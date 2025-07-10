import 'package:dio/dio.dart';

class AuthService {
  // 🔄 Gerçek cihaz veya Windows ortamı için local IP kullan
  static const String baseUrl = 'http://192.168.0.110:5125';
  static final Dio dio = Dio()
    ..options.headers['Content-Type'] = 'application/json';

  // 🔄 REGISTER fonksiyonu artık username parametresi alıyor
  static Future<void> register(String email, String password, String username) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/Auth/register',
        data: {
          "email": email,
          "password": password,
          "username": username,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Kayıt başarılı: ${response.data}');
      } else {
        print('❌ Kayıt başarısız: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        print("❌ Dio hatası: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("❌ Beklenmeyen hata: $e");
      }
    }
  }

  static Future<String?> login(String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/Auth/login',
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        print("✅ Giriş başarılı");
        return response.data;
      } else {
        throw Exception('❌ Giriş başarısız: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        print("❌ Dio hatası: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("❌ Beklenmeyen hata: $e");
      }
      rethrow;
    }
  }
}
