import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../services/upload_image.dart';
import '../services/image_service.dart';
import '../models/image_model.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  String? email;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Token bulunamadı ❌")),
          );
        }
        return;
      }

      final imageFile = File(pickedFile.path);

      setState(() {
        selectedImage = imageFile;
      });

      final uploadSuccess = await uploadImageToServer(imageFile, token);

      if (uploadSuccess) {
        final allImages = await ImageService.getMyImages();
        final lastImage = allImages.isNotEmpty ? allImages.last : null;

        if (lastImage != null) {
          final broadcastSuccess = await ImageService.broadcastImage(lastImage.id);

          if (broadcastSuccess) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Görsel yüklendi ve yayına alındı ✅")),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pushNamed(context, "/select-broadcast");
              });
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Görsel yüklendi ama yayına alınamadı ❌")),
              );
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Yükleme başarısız ❌")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa", style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              email != null ? "Hoş geldin, $email" : "Hoş geldin!",
              style: GoogleFonts.poppins(fontSize: 20),
            ),
            const SizedBox(height: 24),
            selectedImage != null
                ? Image.file(selectedImage!, width: 200)
                : const Text("Henüz görsel seçilmedi"),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Galeriden Görsel Seç"),
            ),
          ],
        ),
      ),
    );
  }
}
