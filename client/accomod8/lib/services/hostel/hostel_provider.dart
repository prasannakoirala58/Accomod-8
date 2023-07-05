// import 'dart:io';

abstract class HostelProvider {
  Future<String> registerHostel({
    required String name,
    required String address,
    // required bool isFeatured,
    required double latitude,
    required double longitude,
    required String description,
    required String forGender,
    // required List<File> images,
    // required File document,
    required bool isVerified,
    required List<String> amenities,
    required List<Map<String, dynamic>> rooms,
    required List<String> reviews,
    required String ownerId,
  });

  Future<void> initialize();
}
