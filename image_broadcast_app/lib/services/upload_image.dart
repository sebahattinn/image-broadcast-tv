import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

Future<bool> uploadImageToServer(File imageFile, String token) async {
  try {
    final dio = Dio();

    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        imageFile.path,
        filename: path.basename(imageFile.path),
      ),
    });

    final response = await dio.post(
      'http://192.168.0.110:5125/api/images/upload', // ⚠️ IP adresini kendi ağ IP’ne göre güncelle
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.statusCode == 200;
  } catch (e) {
    print("Görsel yükleme hatası: $e");
    return false;
  }
}
