import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:accomod8/config.dart';
import 'package:accomod8/services/hostel/hostel_provider.dart';
import 'package:dio/dio.dart';

import '../cookie/dio_instance.dart';

class NodeHostelProvider implements HostelProvider {
  @override
  Future<String> registerHostel({
    required String name,
    required String address,
    // required bool isFeatured,
    required double latitude,
    required double longitude,
    required String description,
    required String forGender,
    List<File?>? images, // make images nullable
    File? document, // make document nullable
    required bool isVerified,
    required List<String> amenities,
    required List<Map<String, dynamic>> rooms,
    required List<String> reviews,
    required String ownerId,
  }) async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;

    String documentFileName = document?.path.split('/').last ?? '';
    print('Doc File Name:$documentFileName');

    print('Raw images: $images');

    List<MultipartFile> imageFiles = [];
    if (images != null) {
      for (var i = 0; i < images.length; i++) {
        if (images[i] != null) {
          String imageFileName = images[i]!.path.split('/').last;
          print('Image File Name: $imageFileName');
          imageFiles.add(
            await MultipartFile.fromFile(
              images[i]!.path,
              filename: imageFileName,
              contentType: MediaType('image', 'png'),
            ),
          );
        }
      }
    }

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
        'images': imageFiles.isNotEmpty ? imageFiles : null,
        'document': document != null
            ? await MultipartFile.fromFile(
                document.path,
                filename: documentFileName,
                contentType: MediaType('image', 'png'),
              )
            : null,
      },
    );

    print('FormData being sent:${formData.fields}');

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
      var responseBody = formDataResponse.data;
      if (responseBody['status'] == 'success') {
        print('Resgister bhayo');
      } else {
        responseBody['status'] = 'failure';
      }
      return responseBody['status'];
    } on Exception catch (e) {
      print('Register Hostel Error: $e');
      return 'failure';
    }
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getAllHostels() async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;

    var response = await dio.get(getAllHostelUrl);
    // print('Raw Response: $response');
    var jsonResponse = response.data;
    List<Map<String, dynamic>> hostels =
        List<Map<String, dynamic>>.from(jsonResponse);
    // print('Hostels:$hostels');
    return hostels;
  }

  @override
  Future<String> featureOrUnfeatureHostel({
    required bool toFeature,
    required String id,
  }) async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;
    print('Id of hostel selected:$id');
    final Response response;
    final String selectedUrl;
    if (toFeature == true) {
      selectedUrl = '$featureHostelUrl/$id';
    } else {
      selectedUrl = '$unFeatureHostelUrl/$id';
    }
    response = await dio.post(selectedUrl);
    print('Raw Response : $response');
    return response.toString();
  }

  @override
  Future<List<Map<String, dynamic>>> getOwnerHostel(
      {required String id}) async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;

    // changing the type to List<Map<String, dynamic>>
    List<Map<String, dynamic>> data = [];

    final String ownerUrl = '$getOwnerHostelUrl/$id';

    try {
      var response = await dio.get(ownerUrl);
      var jsonResponse = response.data;
      Map<String, dynamic> responseData =
          Map<String, dynamic>.from(jsonResponse);

      // mapping each element to Map<String, dynamic>
      data = List<Map<String, dynamic>>.from(responseData['data']);

      return data;
    } catch (e) {
      print('Error: $e');
      return data;
    }
  }

  @override
  Future<String> verifyOrUnverifyHostel({
    required bool toVerify,
    required String id,
  }) async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;
    print('Id of hostel selected:$id');
    final Response response;
    final String selectedUrl;
    if (toVerify == true) {
      selectedUrl = '$verifyHostelUrl/$id';
    } else {
      selectedUrl = '$unVerifyHostelUrl/$id';
    }
    response = await dio.post(selectedUrl);
    print('Raw Response : $response');
    return response.toString();
  }

  @override
  Future<void> updateHostelDetails({
    required String hostelId,
    required String newDescription,
    required String newForGender,
  }) async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;
    final String updateUrl = '$updateHostelUrl/$hostelId';

    Map<String, dynamic> requestBody = {
      'description': newDescription,
      'for_gender': newForGender,
    };

    try {
      var response = await dio.patch(
        updateUrl,
        data: requestBody,
      );

      print('Raw Response: $response');
    } on Exception catch (e) {
      print('Error in update:$e');
    }
  }
}
