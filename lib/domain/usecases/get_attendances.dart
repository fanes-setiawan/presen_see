import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAttendances {
  final AttendanceRepository repo;
  GetAttendances(this.repo);

  Future<List<Attendance>> call(String userId) => repo.getAttendances(userId);
}
