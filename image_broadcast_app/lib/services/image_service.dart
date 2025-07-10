import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';
import '../constants.dart'; // 🔥 baseUrl artık buradan geliyor

class ImageService {
  static const String imagePath = "$baseUrl/api/images";

  static Future<List<ImageModel>> getMyImages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("$imagePath/my-images"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => ImageModel.fromJson(e)).toList();
    } else {
      throw Exception("Görseller alınamadı");
    }
  }

  static Future<bool> broadcastImage(int imageId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("$imagePath/broadcast/$imageId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }
}
