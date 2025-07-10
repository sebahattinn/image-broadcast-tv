class ImageModel {
  final int id;
  final String fileName;
  final String filePath;
  final bool isBroadcasted;

  ImageModel({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.isBroadcasted,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      isBroadcasted: json['isBroadcasted'] ?? false,
    );
  }
}
