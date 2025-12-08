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
import '../profile/Profile.dart'; // For settings/profile navigation if needed

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
        child: ValueListenableBuilder<List<Medication>>(
          valueListenable: MedicationService().medicationsNotifier,
          builder: (context, medications, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildAlerts(medications),
                  _buildNowSection(medications),
                  _buildUpcomingSection(medications),
                  _buildBottomActions(context),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String formattedDate = DateFormat('EEEE, MMM d').format(DateTime.now());
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
                percent: 0.25, // Mock progress
                center: Text(
                  "1 of 4",
                  style: GoogleFonts.signikaNegative(
                    fontSize: 12,
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
    // Logic: Find meds with low stock (e.g. < 5)
    // Since dosageStock is String, we try to parse it.
    // This is a simple implementation for the UI requirement.
    Medication? lowStockMed;
    for (var med in medications) {
      int? stock = int.tryParse(med.dosageStock ?? '');
      if (stock != null && stock < 5) {
        lowStockMed = med;
        break; // Just show one alert for now
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

  Widget _buildNowSection(List<Medication> medications) {
    if (medications.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            "No active medications.",
            style: GoogleFonts.signikaNegative(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Pick the first one as "NOW"
    Medication currentMed = medications.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "## NOW (Due: 9:00 AM)", // Hardcoded time as per requirement mock
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
                  child: (currentMed.imagePath != null && currentMed.imagePath!.isNotEmpty)
                      ? Image.file(
                          File(currentMed.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/medicine.png',
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 15),
                Text(
                  "${currentMed.medName} - ${currentMed.dosage ?? '? '}${currentMed.dosageUnit ?? ''}",
                  style: GoogleFonts.signikaNegative(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Take after breakfast",
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
                      _actionButton("TAKEN", const Color(0xFF4CAF50), Colors.white),
                      _actionButton("SNOOZE", const Color(0xFFFFC107), Colors.black),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _actionButton("SKIP", const Color(0xFFEF5350), Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color bg, Color text) {
    return ElevatedButton(
      onPressed: () {
        // Todo: Implement action logic
      },
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

  Widget _buildUpcomingSection(List<Medication> medications) {
    if (medications.length < 2) return const SizedBox.shrink();

    // Show remaining meds
    List<Medication> upcoming = medications.sublist(1);

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
                Medication med = entry.value;
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        idx == 0 ? "1:00 PM" : "9:00 PM", // Mock times
                        style: GoogleFonts.signikaNegative(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        "${med.medName} (${med.dosage ?? '1'} Tablet)",
                        style: GoogleFonts.signikaNegative(),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.circle_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            "Pending",
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
