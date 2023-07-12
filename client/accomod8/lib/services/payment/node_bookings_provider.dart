import 'package:accomod8/services/payment/bookings_provider.dart';
import 'package:dio/dio.dart';

import '../../config.dart';
import '../cookie/dio_instance.dart';

class NodeBookingProvdier extends BookingsProvider {
  @override
  Future<String> createBooking({
    required String userId,
    required String hostelId,
    required int price,
  }) async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;
    final bookingUrl = '$createBookingUrl/$userId/$hostelId/$price';
    print('Sent Url:$bookingUrl');
    var status;
    //hostel _id ->user _id ->  price
    try {
      var response = await dio.get(bookingUrl);
      var jsonResponse = response.data;
      print('Json Response:$jsonResponse');
      print('Status: ${jsonResponse['status']}');
      status = jsonResponse['status'];
    } on Exception catch (e) {
      print('Error: $e');
      status = 'failure';
    }
    return status;
  }
}
