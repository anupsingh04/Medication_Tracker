class Medication {
  String medName;
  String? medNickName;
  String? medType;
  String? medProvider;
  String? medProviderContact;
  String? dosageStock;
  String? lowSupplyNotif;
  String? startDate;
  String? endDate;
  String? frequencyPerWeek;
  String? frequencyPerDay;
  String? dosage;
  String? dosageUnit;
  String? medicineIntakeNotif;

  // Constructor
  Medication({
    required this.medName,
    this.medNickName,
    this.medType,
    this.medProvider,
    this.medProviderContact,
    this.dosageStock,
    this.lowSupplyNotif,
    this.startDate,
    this.endDate,
    this.frequencyPerWeek,
    this.frequencyPerDay,
    this.dosage,
    this.dosageUnit,
    this.medicineIntakeNotif,
  });

  // Convert a Medication object into a Map
  Map<String, dynamic> toJson() {
    return {
      'MedName': medName,
      'MedNickName': medNickName ?? '',
      'MedType': medType ?? 'Pills',
      'MedProvider': medProvider ?? '',
      'MedProviderContact': medProviderContact ?? '',
      'DosageStock': dosageStock ?? '0',
      'LowSupplyNotif': lowSupplyNotif ?? '5 days',
      'StartDate': startDate ?? '',
      'EndDate': endDate ?? '',
      'FrequencyPerWeek': frequencyPerWeek ?? '',
      'FrequencyPerDay': frequencyPerDay ?? '',
      'Dosage': dosage ?? '',
      'DosageUnit': dosageUnit ?? 'mg',
      'MedicineIntakeNotif': medicineIntakeNotif ?? '',
    };
  }

  // Create a Medication object from a Map
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      medName: json['MedName'],
      medNickName: json['MedNickName'],
      medType: json['MedType'],
      medProvider: json['MedProvider'],
      medProviderContact: json['MedProviderContact'],
      dosageStock: json['DosageStock'],
      lowSupplyNotif: json['LowSupplyNotif'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
      frequencyPerWeek: json['FrequencyPerWeek'],
      frequencyPerDay: json['FrequencyPerDay'],
      dosage: json['Dosage'],
      dosageUnit: json['DosageUnit'],
      medicineIntakeNotif: json['MedicineIntakeNotif'],
    );
  }
}
