import '../repositories/attendance_repository.dart';

class SyncAttendances {
  final AttendanceRepository repo;
  SyncAttendances(this.repo);

  Future<void> call() => repo.syncPending();
}
