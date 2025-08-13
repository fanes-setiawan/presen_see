import 'dart:io';
import '../repositories/cloudinary_repository.dart';

class UploadImage {
  final CloudinaryRepository repo;

  UploadImage(this.repo);

  Future<String> call(File imageFile) async {
    return await repo.uploadImage(imageFile);
  }
}
