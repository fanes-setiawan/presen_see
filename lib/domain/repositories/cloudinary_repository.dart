import 'dart:io';

abstract class CloudinaryRepository {
  Future<String> uploadImage(File imageFile);
}
