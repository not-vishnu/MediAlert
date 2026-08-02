class MedicineModel {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final String status;

  final bool reminderEnabled;
  final int notificationId;
  final DateTime? reminderDate;

  // NEW
  final String notes;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.status,
    required this.reminderEnabled,
    required this.notificationId,
    required this.reminderDate,
    this.notes = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "dosage": dosage,
      "time": time,
      "status": status,
      "reminderEnabled": reminderEnabled,
      "notificationId": notificationId,
      "reminderDate": reminderDate?.toIso8601String(),
      "notes": notes,
    };
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map, String id) {
    return MedicineModel(
      id: id,
      name: map["name"] ?? "",
      dosage: map["dosage"] ?? "",
      time: map["time"] ?? "",
      status: map["status"] ?? "Pending",
      reminderEnabled: map["reminderEnabled"] ?? true,
      notificationId: map["notificationId"] ?? 0,
      reminderDate: map["reminderDate"] != null
          ? DateTime.parse(map["reminderDate"])
          : null,
      notes: map["notes"] ?? "",
    );
  }

  MedicineModel copyWith({
    String? id,
    String? name,
    String? dosage,
    String? time,
    String? status,
    bool? reminderEnabled,
    int? notificationId,
    DateTime? reminderDate,
    String? notes,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      status: status ?? this.status,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      notificationId: notificationId ?? this.notificationId,
      reminderDate: reminderDate ?? this.reminderDate,
      notes: notes ?? this.notes,
    );
  }
}
