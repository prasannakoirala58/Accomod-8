// import 'dart:io';

import 'package:accomod8/config.dart';
import 'package:accomod8/services/hostel/hostel_provider.dart';
import 'package:dio/dio.dart';

import '../cookie/cookie_manager.dart';

class NodeHostelProvider implements HostelProvider {
  @override
  Future<String> registerHostel({
    required String name,
    required String address,
    required bool isFeatured,
    required double latitude,
    required double longitude,
    required String description,
    required String forGender,
    // required List<File> images, // not required
    // required File document, // not required
    required bool isVerified,
    required List<String> amenities,
    required List<Map<String, dynamic>> rooms,
    required List<String> reviews,
    required String ownerId,
  }) async {
    CookieManager cookieManager = CookieManager.instance;
    await cookieManager.initCookie();
    Dio dio = Dio();
    dio.interceptors.add(cookieManager);

    // String documentFileName = document.path.split('/').last;

    // List<MultipartFile> imageFile = [];
    // for (var i = 0; i < images.length; i++) {
    //   String imageFileName = images[i].path.split('/').last;
    //   imageFile.add(
    //     await MultipartFile.fromFile(images[i].path, filename: imageFileName),
    //   );
    // }

    List<Map<String, dynamic>> roomData = rooms.map((room) {
      return {
        'available_seats': room['available_seats'],
        'room_number': room['room_number'],
        'id': room['id'],
        'room_type': room['room_type'],
        'availability': room['availability'],
        'price': room['price'],
        'attached_bathroom': room['attached_bathroom'],
        'direct_sunlight': room['direct_sunlight'],
        'balcony': room['balcony'],
      };
    }).toList();

    FormData formData = FormData.fromMap(
      {
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'for_gender': forGender,
        'amenities': amenities,
        'rooms': roomData,
        // 'images': images,
        // 'document': await MultipartFile.fromFile(
        //   document.path,
        //   filename: documentFileName,
        // ),
      },
    );

    try {
      Response formDataResponse = await dio.post(
        getHostelUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print('Raw Response:$formDataResponse');
    } on Exception catch (e) {
      print('Register Hostel Error: $e');
    }

    return 'cringe';
  }
}
