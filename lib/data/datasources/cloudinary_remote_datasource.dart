import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

abstract class CloudinaryRemoteDataSource {
  Future<String> uploadImage(File imageFile);
}

class CloudinaryRemoteDataSourceImpl implements CloudinaryRemoteDataSource {
  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  @override
  Future<String> uploadImage(File imageFile) async {
    print("upload foto di panggil");
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath(
              'file',
              imageFile.path,
              contentType: MediaType.parse(mimeType),
            ),
          );

    final response = await request.send();

    print("FOTO RESPONSE :: ${response.statusCode}");

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final Map<String, dynamic> resJson = json.decode(resStr);
      return resJson['secure_url'];
    } else {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  }
}
