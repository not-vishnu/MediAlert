import 'package:flutter/material.dart';

import '../models/medicine_model.dart';
import '../services/medicine_service.dart';

class MedicineProvider extends ChangeNotifier {
  final MedicineService _service = MedicineService();

  /// Stream of medicines from Firestore
  Stream<List<MedicineModel>> get medicines => _service.getMedicines();

  /// Add Medicine
  Future<void> addMedicine(MedicineModel medicine) async {
    await _service.addMedicine(medicine);
    notifyListeners();
  }

  /// Delete Medicine
  Future<void> deleteMedicine(String id) async {
    await _service.deleteMedicine(id);
    notifyListeners();
  }

  /// Mark as Taken
  Future<void> markAsTaken(String id) async {
    await _service.updateStatus(id, "Taken");
    notifyListeners();
  }

  /// Mark as Missed
  Future<void> markAsMissed(String id) async {
    await _service.updateStatus(id, "Missed");
    notifyListeners();
  }

  /// Update Medicine
  Future<void> updateMedicine(MedicineModel medicine) async {
    await _service.updateMedicine(medicine);
    notifyListeners();
  }
}
