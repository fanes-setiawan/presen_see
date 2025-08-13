import 'dart:io';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';

class AddAttendance {
  final AttendanceRepository repo;
  AddAttendance(this.repo);

  Future<void> call(Attendance attendance, File photoFile) =>
      repo.addAttendance(attendance, photoFile);
}
