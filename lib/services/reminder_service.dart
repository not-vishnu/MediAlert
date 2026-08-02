import 'package:flutter/material.dart';

import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';

class ReminderService {
  ReminderService._();

  static final ReminderService instance = ReminderService._();

  TimeOfDay parseTime(String time) {
    try {
      final parts = time.split(" ");

      final hm = parts[0].split(":");

      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);

      if (parts.length > 1) {
        if (parts[1] == "PM" && hour != 12) {
          hour += 12;
        }

        if (parts[1] == "AM" && hour == 12) {
          hour = 0;
        }
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  bool shouldMarkMissed(String reminderTime, DateTime now) {
    final reminder = parseTime(reminderTime);

    final reminderMinutes = reminder.hour * 60 + reminder.minute;
    final currentMinutes = now.hour * 60 + now.minute;

    // Medicine becomes missed after 30 minutes
    return currentMinutes >= reminderMinutes + 30;
  }

  Future<void> checkMissedMedicines(
    List<MedicineModel> medicines,
    MedicineProvider provider,
  ) async {
    final now = DateTime.now();

    for (final medicine in medicines) {
      if (medicine.status != "Pending") continue;

      if (shouldMarkMissed(medicine.time, now)) {
        await provider.markAsMissed(medicine.id);
      }
    }
  }
}
