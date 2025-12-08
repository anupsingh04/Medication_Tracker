import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/medication.dart';
import 'package:intl/intl.dart';

class MedicationScheduleItem {
  final Medication medication;
  final String time; // "HH:mm"
  final DateTime dateTime; // Full DateTime for sorting
  final String status; // "Pending", "Taken", "Skipped", "Snoozed"

  MedicationScheduleItem({
    required this.medication,
    required this.time,
    required this.dateTime,
    required this.status,
  });
}

class MedicationService {
  static final MedicationService _instance = MedicationService._internal();

  factory MedicationService() {
    return _instance;
  }

  MedicationService._internal();

  ValueNotifier<List<Medication>> medicationsNotifier = ValueNotifier([]);
  // Notifier to trigger UI updates for schedule changes
  ValueNotifier<DateTime> lastUpdateNotifier = ValueNotifier(DateTime.now());

  Future<void> loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? medsString = prefs.getString('medications');

    if (medsString != null && medsString.isNotEmpty) {
      List<dynamic> jsonList = jsonDecode(medsString);
      List<Medication> loadedMeds = jsonList.map((json) => Medication.fromJson(json)).toList();
      medicationsNotifier.value = loadedMeds;
    } else {
      await _seedDemoData(prefs);
    }
    notifyUpdate();
  }

  Future<void> _seedDemoData(SharedPreferences prefs) async {
    List<Medication> demos = [
      Medication(
        id: 'demo1',
        medName: 'Vitamin C',
        medNickName: 'Immunity Booster',
        medType: 'Pills',
        dosage: '500',
        dosageUnit: 'mg',
        dosageStock: '30',
        imagePath: 'assets/images/pill1.png',
        intakeTimes: ['08:00', '13:00'],
        medProvider: 'Nature Made',
      ),
      Medication(
        id: 'demo2',
        medName: 'Paracetamol',
        medNickName: 'Headache',
        medType: 'Tablets',
        dosage: '500',
        dosageUnit: 'mg',
        dosageStock: '12',
        imagePath: 'assets/images/pill2.png',
        intakeTimes: ['09:00', '21:00'],
        medProvider: 'Panadol',
      ),
      Medication(
        id: 'demo3',
        medName: 'Amoxicillin',
        medNickName: 'Antibiotics',
        medType: 'Capsules',
        dosage: '250',
        dosageUnit: 'mg',
        dosageStock: '4', // Low stock for alert demo
        imagePath: 'assets/images/pill3.png',
        intakeTimes: ['10:00', '18:00', '22:00'],
        medProvider: 'Generic',
      ),
    ];

    medicationsNotifier.value = demos;
    String jsonString = jsonEncode(demos.map((m) => m.toJson()).toList());
    await prefs.setString('medications', jsonString);
  }

  Future<void> addMedication(Medication med) async {
    final prefs = await SharedPreferences.getInstance();
    List<Medication> currentMeds = List.from(medicationsNotifier.value);
    currentMeds.add(med);

    // Update State
    medicationsNotifier.value = currentMeds;

    // Persist
    String jsonString = jsonEncode(currentMeds.map((m) => m.toJson()).toList());
    await prefs.setString('medications', jsonString);
    notifyUpdate();
  }

  Future<void> updateMedication(int index, Medication med) async {
    final prefs = await SharedPreferences.getInstance();
    List<Medication> currentMeds = List.from(medicationsNotifier.value);

    if (index >= 0 && index < currentMeds.length) {
      currentMeds[index] = med;

      // Update State
      medicationsNotifier.value = currentMeds;

      // Persist
      String jsonString = jsonEncode(currentMeds.map((m) => m.toJson()).toList());
      await prefs.setString('medications', jsonString);
      notifyUpdate();
    }
  }

  Future<void> deleteMedication(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<Medication> currentMeds = List.from(medicationsNotifier.value);

    if (index >= 0 && index < currentMeds.length) {
      currentMeds.removeAt(index);

      // Update State
      medicationsNotifier.value = currentMeds;

      // Persist
      String jsonString = jsonEncode(currentMeds.map((m) => m.toJson()).toList());
      await prefs.setString('medications', jsonString);
      notifyUpdate();
    }
  }

  void notifyUpdate() {
    lastUpdateNotifier.value = DateTime.now();
  }

  // --- Scheduling Logic ---

  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<Map<String, String>> _getDailyLog(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'daily_log_${_getDateKey(date)}';
    String? logString = prefs.getString(key);
    if (logString != null) {
      return Map<String, String>.from(jsonDecode(logString));
    }
    return {};
  }

  Future<void> _saveDailyLog(DateTime date, Map<String, String> log) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'daily_log_${_getDateKey(date)}';
    await prefs.setString(key, jsonEncode(log));
    notifyUpdate();
  }

  Future<void> logIntake(String medId, String time, String status, DateTime date) async {
    Map<String, String> log = await _getDailyLog(date);
    String key = '${medId}_$time';
    log[key] = status;
    await _saveDailyLog(date, log);
  }

  Future<double> getDailyProgress(DateTime date) async {
    List<MedicationScheduleItem> items = await getDueMedications(date);
    if (items.isEmpty) return 0.0;

    int takenCount = items.where((i) => i.status == 'Taken').length;
    return takenCount / items.length;
  }

  Future<List<MedicationScheduleItem>> getDueMedications(DateTime date) async {
    List<Medication> meds = medicationsNotifier.value;
    Map<String, String> log = await _getDailyLog(date);
    List<MedicationScheduleItem> schedule = [];

    for (var med in meds) {
      // Assuming Everyday frequency for demo simplicity

      for (var timeStr in med.intakeTimes) {
        String status = log['${med.id}_$timeStr'] ?? 'Pending';

        // Parse time
        try {
          List<String> parts = timeStr.split(':');
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1]);
          DateTime itemDateTime = DateTime(date.year, date.month, date.day, hour, minute);

          schedule.add(MedicationScheduleItem(
            medication: med,
            time: timeStr,
            dateTime: itemDateTime,
            status: status,
          ));
        } catch (e) {
          print('Error parsing time $timeStr for med ${med.medName}');
        }
      }
    }

    // Sort by time
    schedule.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return schedule;
  }
}
