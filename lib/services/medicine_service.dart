import '../models/medicine_model.dart';
import 'firestore_service.dart';

class MedicineService {
  final FirestoreService _firestore = FirestoreService();

  /// Get all medicines
  Stream<List<MedicineModel>> getMedicines() {
    return _firestore.getMedicines();
  }

  /// Add a new medicine
  Future<void> addMedicine(MedicineModel medicine) async {
    await _firestore.addMedicine(medicine);
  }

  /// Delete medicine
  Future<void> deleteMedicine(String id) async {
    await _firestore.deleteMedicine(id);
  }

  /// Update medicine status (Taken/Missed)
  Future<void> updateStatus(String id, String status) async {
    await _firestore.updateStatus(id, status);
  }

  /// Smart Reminder status update
  Future<void> updateMedicineStatus(String id, String status) async {
    await _firestore.updateMedicineStatus(id, status);
  }

  /// Enable / Disable Reminder
  Future<void> updateReminderEnabled(String id, bool enabled) async {
    await _firestore.updateReminderEnabled(id, enabled);
  }

  /// Update Notification ID
  Future<void> updateNotificationId(String id, int notificationId) async {
    await _firestore.updateNotificationId(id, notificationId);
  }

  /// Update Reminder Date
  Future<void> updateReminderDate(String id, DateTime reminderDate) async {
    await _firestore.updateReminderDate(id, reminderDate);
  }

  /// Update medicine details
  Future<void> updateMedicine(MedicineModel medicine) async {
    await _firestore.updateMedicine(medicine);
  }
}
