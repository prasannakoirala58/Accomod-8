import 'package:accomod8/services/payment/bookings_provider.dart';
import 'package:dio/dio.dart';

import '../../config.dart';
import '../cookie/dio_instance.dart';

class NodeBookingProvdier extends BookingsProvider {
  @override
  Future<void> createBooking({
    required String userId,
    required String hostelId,
  }) async {
    DioInstance dioInstance = DioInstance();
    Dio dio = dioInstance.dio;
    final bookingUrl = '$createBookingUrl/$userId/$hostelId';
    try {
      var response = await dio.get(bookingUrl);
      var jsonResponse = response.data;
      print('Json Response:$jsonResponse');
    } on Exception catch (e) {
      print('Error: $e');
    }
  }
}
