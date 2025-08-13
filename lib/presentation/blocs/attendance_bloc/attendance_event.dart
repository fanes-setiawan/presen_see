import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAttendances extends AttendanceEvent {
  final String userId;
  LoadAttendances(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AddAttendanceEvent extends AttendanceEvent {
  final String id;
  final String userId;
  final String name;
  final String date;
  final String time;
  final double latitude;
  final double longitude;
  final String locationStatus;
  final File photoFile;
  AddAttendanceEvent({
    required this.id,
    required this.userId,
    required this.name,
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.locationStatus,
    required this.photoFile,
  });
  @override
  List<Object?> get props => [id];
}
