import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/medicine_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //==============================================================
  // CURRENT USER
  //==============================================================

  String get _currentUserId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not logged in.");
    }

    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _firestore.collection('users').doc(_currentUserId);

  CollectionReference<Map<String, dynamic>> get _medicineCollection =>
      _userDoc.collection('medicines');

  //==============================================================
  // USER PROFILE
  //==============================================================

  Future<void> createUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) return;

    final doc = await _userDoc.get();

    if (!doc.exists) {
      await _userDoc.set({
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "phone": "",
        "photoUrl": "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() {
    return _userDoc.snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfileOnce() {
    return _userDoc.get();
  }

  Future<void> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _userDoc.set(
      {
        "name": name,
        "phone": phone,
        "email": user.email,
        "updatedAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  //==============================================================
  // MEDICINES
  //==============================================================

  Future<void> addMedicine(MedicineModel medicine) async {
    await _medicineCollection.add(medicine.toMap());
  }

  Stream<List<MedicineModel>> getMedicines() {
    return _medicineCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MedicineModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Future<MedicineModel?> getMedicine(String id) async {
    final doc = await _medicineCollection.doc(id).get();

    if (!doc.exists) return null;

    return MedicineModel.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    await _medicineCollection.doc(medicine.id).update(
          medicine.toMap(),
        );
  }

  Future<void> deleteMedicine(String id) async {
    await _medicineCollection.doc(id).delete();
  }

  Future<void> updateStatus(
    String id,
    String status,
  ) async {
    await _medicineCollection.doc(id).update({
      "status": status,
    });
  }

  Future<void> updateMedicineStatus(
    String id,
    String status,
  ) async {
    await updateStatus(id, status);
  }

  Future<void> updateReminderEnabled(
    String id,
    bool enabled,
  ) async {
    await _medicineCollection.doc(id).update({
      "reminderEnabled": enabled,
    });
  }

  Future<void> updateNotificationId(
    String id,
    int notificationId,
  ) async {
    await _medicineCollection.doc(id).update({
      "notificationId": notificationId,
    });
  }

  Future<void> updateReminderDate(
    String id,
    DateTime reminderDate,
  ) async {
    await _medicineCollection.doc(id).update({
      "reminderDate": reminderDate.toIso8601String(),
    });
  }

  Future<void> updateNotes(
    String id,
    String notes,
  ) async {
    await _medicineCollection.doc(id).update({
      "notes": notes,
    });
  }
}
