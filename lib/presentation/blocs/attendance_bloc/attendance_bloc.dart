import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:presen_see/domain/usecases/upload_image.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';
import '../../../domain/usecases/add_attendance.dart';
import '../../../domain/usecases/get_attendances.dart';
import '../../../domain/usecases/sync_attendances.dart';
import '../../../domain/entities/attendance.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AddAttendance addAttendance;
  final GetAttendances getAttendances;
  final SyncAttendances syncAttendances;
   final UploadImage uploadImage; 

  AttendanceBloc({
    required this.addAttendance,
    required this.getAttendances,
    required this.syncAttendances,
    required this.uploadImage,
  }) : super(AttendanceInitial()) {
    on<LoadAttendances>((e, emit) async {
      emit(AttendanceLoading());
      try {
        final list = await getAttendances.call(e.userId);
        emit(AttendanceLoaded(list));
      } catch (err) {
        emit(AttendanceError(err.toString()));
      }
    });

    on<AddAttendanceEvent>((e, emit) async {
      emit(AttendanceLoading());
      try {
         final photoUrl = await uploadImage.call(e.photoFile);
        final attendance = Attendance(
          id: e.id,
          userId: e.userId,
          name: e.name,
          date: e.date,
          time: e.time,
          latitude: e.latitude,
          longitude: e.longitude,
          locationStatus: e.locationStatus,
          photoUrl: photoUrl,
          synced: false,
        );
        await addAttendance.call(attendance, e.photoFile);
        // attempt sync pending
        await syncAttendances.call();
        emit(AttendanceAdded());
      } catch (err) {
        emit(AttendanceError(err.toString()));
      }
    });
  }
}
