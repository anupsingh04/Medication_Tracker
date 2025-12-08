import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/medication.dart';

class MedicationService {
  static final MedicationService _instance = MedicationService._internal();

  factory MedicationService() {
    return _instance;
  }

  MedicationService._internal();

  ValueNotifier<List<Medication>> medicationsNotifier = ValueNotifier([]);

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
    }
  }
}
