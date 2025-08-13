// lib/domain/repositories/attendance_repository.dart
import 'dart:io';
import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<void> addAttendance(Attendance attendance, File photoFile);

  Future<List<Attendance>> getAttendances(String userId);

  Future<void> syncPending();
}
