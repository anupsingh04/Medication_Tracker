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

    if (medsString != null) {
      List<dynamic> jsonList = jsonDecode(medsString);
      List<Medication> loadedMeds = jsonList.map((json) => Medication.fromJson(json)).toList();
      medicationsNotifier.value = loadedMeds;
    } else {
      medicationsNotifier.value = [];
    }
    notifyUpdate();
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
    // Skipped items generally count as completed interaction in some apps, but strictly progress usually means taken.
    // Let's assume progress is (Taken) / (Total).
    return takenCount / items.length;
  }

  Future<List<MedicationScheduleItem>> getDueMedications(DateTime date) async {
    List<Medication> meds = medicationsNotifier.value;
    Map<String, String> log = await _getDailyLog(date);
    List<MedicationScheduleItem> schedule = [];

    for (var med in meds) {
      // Basic frequency check (can be improved with start/end dates and specific days)
      // For now, assume everyday or check frequencyPerWeek/Day logic if implemented properly.
      // Currently frequency is stored as string like "Everyday", "Monday", etc.
      // We will assume "Everyday" or valid for now since complex parsing wasn't requested/implemented fully yet.

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
