import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'data/datasources/attendance_local_datasource.dart';
import 'data/datasources/attendance_remote_datasource.dart';
import 'data/datasources/cloudinary_remote_datasource.dart';
import 'data/repositories/attendance_repository_impl.dart';
import 'data/repositories/cloudinary_repository_impl.dart';
import 'domain/usecases/add_attendance.dart';
import 'domain/usecases/get_attendances.dart';
import 'domain/usecases/sync_attendances.dart';
import 'domain/usecases/upload_image.dart';
import 'data/models/attendance_model.dart';

class InjectionContainer {
  static Future<InjectionContainer> init() async {
    await Firebase.initializeApp();

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );

    await Hive.initFlutter();
    Hive.registerAdapter(AttendanceModelAdapter());
    await Hive.openBox<AttendanceModel>('attendances');

    final localBox = Hive.box<AttendanceModel>('attendances');
    final localDS = AttendanceLocalDataSourceImpl(localBox);
    final cloudinaryRemoteDS = CloudinaryRemoteDataSourceImpl();

    final remoteDS = AttendanceRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
    );

    final repo = AttendanceRepositoryImpl(local: localDS, remote: remoteDS);
    final repoCl = CloudinaryRepositoryImpl(remote: cloudinaryRemoteDS);

    final addUsecase = AddAttendance(repo);
    final uploadImageUsecase = UploadImage(repoCl);
    final getUsecase = GetAttendances(repo);
    final syncUsecase = SyncAttendances(repo);

    return InjectionContainer._(
      addUsecase: addUsecase,
      uploadImageUsecase: uploadImageUsecase,
      getUsecase: getUsecase,
      syncUsecase: syncUsecase,
    );
  }

  final AddAttendance addUsecase;
  final UploadImage uploadImageUsecase;
  final GetAttendances getUsecase;
  final SyncAttendances syncUsecase;

  InjectionContainer._({
    required this.addUsecase,
    required this.uploadImageUsecase,
    required this.getUsecase,
    required this.syncUsecase,
  });
}
