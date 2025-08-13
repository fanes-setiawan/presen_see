import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}
class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendances;
  AttendanceLoaded(this.attendances);
  @override
  List<Object?> get props => [attendances];
}
class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);
  @override
  List<Object?> get props => [message];
}
class AttendanceAdded extends AttendanceState {}
