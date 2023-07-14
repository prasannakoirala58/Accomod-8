// import 'dart:io';

import 'dart:io';

abstract class HostelProvider {
  Future<String> registerHostel({
    required String name,
    required String address,
    // required bool isFeatured,
    required double latitude,
    required double longitude,
    required String description,
    required String forGender,
    List<File?>? images,
    required File? document,
    required bool isVerified,
    required List<String> amenities,
    required List<Map<String, dynamic>> rooms,
    required List<String> reviews,
    required String ownerId,
  });

  Future<List<Map<String, dynamic>>> getAllHostels();

  Future<String> featureOrUnfeatureHostel({
    required bool toFeature,
    required String id,
  });

  Future<void> initialize();

  Future<List<Map<String, dynamic>>> getOwnerHostel({required String id});

  Future<String> verifyOrUnverifyHostel({
    required bool toVerify,
    required String id,
  });

  Future<void> updateHostelDetails({
    required String hostelId,
    required String newDescription,
    required String newForGender,
  });
}
