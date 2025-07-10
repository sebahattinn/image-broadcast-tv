import 'package:flutter/material.dart';
import 'package:image_broadcast_app/services/image_service.dart';
import 'package:image_broadcast_app/models/image_model.dart';
import 'package:image_broadcast_app/constants.dart'; // 🔥 baseUrl import edildi

class SelectAndBroadcastScreen extends StatefulWidget {
  const SelectAndBroadcastScreen({super.key});

  @override
  State<SelectAndBroadcastScreen> createState() => _SelectAndBroadcastScreenState();
}

class _SelectAndBroadcastScreenState extends State<SelectAndBroadcastScreen> {
  List<ImageModel> images = [];
  bool isLoading = true;
  int? selectedImageId;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final fetchedImages = await ImageService.getMyImages();
    setState(() {
      images = fetchedImages;
      isLoading = false;
    });
  }

  Future<void> broadcast() async {
    if (selectedImageId == null) return;
    final success = await ImageService.broadcastImage(selectedImageId!);
    if (success) {
      await fetchImages();
      setState(() {
        selectedImageId = null;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Görsel yayına alındı ✅")),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bir hata oluştu ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yayın Seç")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : images.isEmpty
              ? const Center(child: Text("Henüz görsel yüklenmedi"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final image = images[index];
                          final isSelected = selectedImageId == image.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImageId = image.id;
                              });
                            },
                            child: Card(
                              color: isSelected ? Colors.blue[50] : null,
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    '$baseUrl${image.filePath}', // 🔥 baseUrl ile birleştirildi
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(image.fileName),
                                subtitle: image.isBroadcasted
                                    ? const Text("🟢 Şu anda yayında", style: TextStyle(color: Colors.green))
                                    : const Text("🔘 Yayında değil"),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: Colors.blue)
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (selectedImageId != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: broadcast,
                            icon: const Icon(Icons.campaign),
                            label: const Text("Yayına Al"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
    );
  }
}
