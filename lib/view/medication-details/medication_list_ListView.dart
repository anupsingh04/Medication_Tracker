import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'nearby_pharmacy.dart';
import 'add_medication_1.dart';
import '../../controller/medication_service.dart';
import '../../model/medication.dart';
import 'dart:io';

class MedicationListView extends StatefulWidget {
  const MedicationListView({Key? key}) : super(key: key);

  @override
  _MedicationListViewState createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    MedicationService().loadMedications();
  }

  Widget _buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset('assets/images/medicine.png', width: 100, height: 100, fit: BoxFit.cover);
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover);
    }
    return Image.file(
      File(imagePath),
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/images/medicine.png', width: 100, height: 100, fit: BoxFit.cover);
      },
    );
  }

  Color _getStockColor(int stock) {
    if (stock <= 5) return Colors.red;
    if (stock <= 10) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Medication>>(
      valueListenable: MedicationService().medicationsNotifier,
      builder: (context, medications, child) {
        if (medications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No medications added yet.",
                    style: GoogleFonts.signikaNegative(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Click the + button below to add one.",
                    style: GoogleFonts.signikaNegative(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: medications.length,
          itemBuilder: (context, index) {
            Medication med = medications[index];
            int stock = int.tryParse(med.dosageStock ?? '0') ?? 0;
            double stockPercent = (stock > 50) ? 1.0 : (stock / 50.0); // Arbitrary max stock for visualization

            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color(0x2E000000),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFC8C8C8),
                    width: 1,
                  ),
                ),
                child: ExpandableNotifier(
                  initialExpanded: false,
                  child: ExpandablePanel(
                    header: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(0),
                              ),
                              child: _buildImage(med.imagePath),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                    child: Text(
                                      med.medName,
                                      style: GoogleFonts.signikaNegative(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 0, 0),
                                    child: Text(
                                      med.medNickName ?? '',
                                      style: GoogleFonts.signikaNegative(
                                        color: const Color(0xFF57636C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Stock',
                                          style: GoogleFonts.signikaNegative(
                                            color: const Color(0xFF57636C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                          child: LinearPercentIndicator(
                                            percent: stockPercent,
                                            width: 80,
                                            lineHeight: 8,
                                            animation: true,
                                            progressColor: _getStockColor(stock),
                                            backgroundColor: const Color(0xFFE0E3E7),
                                            barRadius: const Radius.circular(8),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                          child: Text(
                                            stock.toString(),
                                            style: GoogleFonts.signikaNegative(
                                              color: const Color(0xFF14181B),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    collapsed: Container(),
                    expanded: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFC8C8C8),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Medication Details:',
                                style: GoogleFonts.signikaNegative(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Type: ${med.medType}'),
                              Text('Provider: ${med.medProvider}'),
                              Text('Dosage: ${med.dosage} ${med.dosageUnit}'),
                              // Text('Frequency: ${med.frequencyPerDay}'), // Replaced by Intake Times
                              Text('Times: ${med.intakeTimes.join(', ')}'),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const NearbyPharmacyWidget()));
                                    },
                                    child: const Text("Restock"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddMedication1(medication: med, editIndex: index)));
                                    },
                                    child: const Text("Edit"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                       MedicationService().deleteMedication(index);
                                    },
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    theme: const ExpandableThemeData(
                      tapHeaderToExpand: true,
                      tapBodyToExpand: false,
                      tapBodyToCollapse: false,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      hasIcon: true,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
