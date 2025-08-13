import 'dart:io';

import '../../domain/repositories/cloudinary_repository.dart';
import '../datasources/cloudinary_remote_datasource.dart';

class CloudinaryRepositoryImpl implements CloudinaryRepository {
  final CloudinaryRemoteDataSource remote;

  CloudinaryRepositoryImpl({required this.remote});

  @override
  Future<String> uploadImage(File imageFile) {
    return remote.uploadImage(imageFile);
  }
}
