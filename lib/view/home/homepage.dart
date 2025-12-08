import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:io';

import '../../controller/medication_service.dart';
import '../../model/medication.dart';
import '../medication-details/nearby_pharmacy.dart';
import '../medication-details/add_medication_1.dart';
import '../medication-details/journal_history.dart';
import '../profile/Profile.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    MedicationService().loadMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ValueListenableBuilder<DateTime>(
          valueListenable: MedicationService().lastUpdateNotifier,
          builder: (context, _, __) {
            return FutureBuilder<List<dynamic>>(
              future: Future.wait([
                MedicationService().getDueMedications(DateTime.now()),
                MedicationService().getDailyProgress(DateTime.now()),
                Future.value(MedicationService().medicationsNotifier.value) // Just to access full list for alerts
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<MedicationScheduleItem> schedule = snapshot.data![0] as List<MedicationScheduleItem>;
                double progress = snapshot.data![1] as double;
                List<Medication> allMeds = snapshot.data![2] as List<Medication>;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(progress),
                      _buildAlerts(allMeds),
                      _buildNowSection(schedule),
                      _buildUpcomingSection(schedule),
                      _buildBottomActions(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    String formattedDate = DateFormat('EEEE, MMM d').format(DateTime.now());
    int percentage = (progress * 100).toInt();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, color: Colors.black),
              Text(
                formattedDate,
                style: GoogleFonts.signikaNegative(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const Icon(Icons.settings, color: Colors.black),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning,',
                    style: GoogleFonts.signikaNegative(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'User',
                    style: GoogleFonts.fredoka(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 8.0,
                percent: progress,
                center: Text(
                  "$percentage%",
                  style: GoogleFonts.signikaNegative(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: const Color(0xFF809BCE),
                backgroundColor: const Color(0xFFE0E0E0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlerts(List<Medication> medications) {
    Medication? lowStockMed;
    for (var med in medications) {
      int? stock = int.tryParse(med.dosageStock ?? '');
      if (stock != null && stock < 5) {
        lowStockMed = med;
        break;
      }
    }

    if (lowStockMed == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3CD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFECB5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "!!! ALERTS",
              style: GoogleFonts.signikaNegative(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF856404),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFF856404)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${lowStockMed.medName}: Low Stock. Visit Pharmacy.",
                    style: GoogleFonts.signikaNegative(
                      color: const Color(0xFF856404),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NearbyPharmacyWidget()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF809BCE),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Locate Pharmacy"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowSection(List<MedicationScheduleItem> schedule) {
    // Find first item that is not 'Taken' or 'Skipped'
    // Actually we might want to show snoozed ones too.
    // Let's filter for 'Pending' or 'Snoozed'.

    // Sort logic already puts them in time order.

    // Check if there are any items for today at all
    if (schedule.isEmpty) {
       return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            "No medications scheduled for today.",
            style: GoogleFonts.signikaNegative(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    MedicationScheduleItem? nextItem;
    try {
      nextItem = schedule.firstWhere((item) => item.status == 'Pending' || item.status == 'Snoozed');
    } catch (e) {
      // All done
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline, size: 60, color: Color(0xFF809BCE)),
              const SizedBox(height: 10),
              Text(
                "All caught up for today!",
                style: GoogleFonts.signikaNegative(fontSize: 18, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      );
    }

    Medication med = nextItem.medication;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "## NOW (Due: ${nextItem.time})",
            style: GoogleFonts.signikaNegative(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Image
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[100],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (med.imagePath != null && med.imagePath!.isNotEmpty)
                      ? Image.file(
                          File(med.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/medicine.png'),
                        )
                      : Image.asset(
                          'assets/images/medicine.png',
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 15),
                Text(
                  "${med.medName} - ${med.dosage ?? '? '}${med.dosageUnit ?? ''}",
                  style: GoogleFonts.signikaNegative(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (med.medType != null)
                Text(
                  med.medType!,
                  style: GoogleFonts.signikaNegative(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton("TAKEN", const Color(0xFF4CAF50), Colors.white, () {
                        MedicationService().logIntake(med.id, nextItem!.time, 'Taken', DateTime.now());
                      }),
                      _actionButton("SNOOZE", const Color(0xFFFFC107), Colors.black, () {
                         MedicationService().logIntake(med.id, nextItem!.time, 'Snoozed', DateTime.now());
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _actionButton("SKIP", const Color(0xFFEF5350), Colors.white, () {
                    MedicationService().logIntake(med.id, nextItem!.time, 'Skipped', DateTime.now());
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color bg, Color text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: text,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(
        label,
        style: GoogleFonts.signikaNegative(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUpcomingSection(List<MedicationScheduleItem> schedule) {
    // Filter for pending items that are NOT the "Now" item
    // Actually, just list everything and mark status
    // OR list subsequent pending items.

    // Let's list everything for today to give a full view, or just upcoming?
    // User asked for "Upcoming".

    // Let's filter items that are AFTER the current time, or just all items not "Taken"?
    // A clean approach is to list all items, but highlight status.
    // Or strictly "Upcoming" = Pending items excluding the one in "Now".

    var pendingItems = schedule.where((i) => i.status == 'Pending' || i.status == 'Snoozed').toList();
    if (pendingItems.isEmpty || pendingItems.length == 1) return const SizedBox.shrink(); // Only 0 or 1 (which is in Now)

    List<MedicationScheduleItem> upcoming = pendingItems.sublist(1);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "## UPCOMING",
            style: GoogleFonts.signikaNegative(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: upcoming.asMap().entries.map((entry) {
                int idx = entry.key;
                MedicationScheduleItem item = entry.value;
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        item.time,
                        style: GoogleFonts.signikaNegative(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        "${item.medication.medName} (${item.medication.dosage ?? '1'} ${item.medication.dosageUnit ?? ''})",
                        style: GoogleFonts.signikaNegative(),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.circle_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            item.status,
                            style: GoogleFonts.signikaNegative(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (idx < upcoming.length - 1) const Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _bottomButton(context, Icons.add, "Add Med", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMedication1()),
            );
          }),
          _bottomButton(context, Icons.history, "History", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JournalHistoryWidget()),
            );
          }),
          _bottomButton(context, Icons.person, "Caretaker", () {
            // Placeholder
          }),
        ],
      ),
    );
  }

  Widget _bottomButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF809BCE)),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.signikaNegative(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
