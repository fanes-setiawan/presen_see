import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<void> uploadAttendance(AttendanceModel attendance, File photoFile);
  Future<List<AttendanceModel>> fetchAttendances(String userId);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  AttendanceRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<void> uploadAttendance(
    AttendanceModel attendance,
    File photoFile,
  ) async {
    try {
      await firestore.collection('attendances').doc(attendance.id).set({
        ...attendance.toMap(),
      });
    } catch (e) {
      print('Gagal upload attendance: $e');
      rethrow;
    }
  }

  @override
  Future<List<AttendanceModel>> fetchAttendances(String userId) async {
    final snapshot =
        await firestore
            .collection('attendances')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
  }
}
