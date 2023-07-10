import 'package:accomod8/services/payment/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiPayment extends PaymentProvider {
  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<void> performPayment({
    required BuildContext context,
    required int amount,
    required String productId,
    required String productName,
    // required String paymentConfig,
    required ValueChanged<PaymentSuccessModel> onSuccess,
    required ValueChanged<PaymentFailureModel> onFailure,
  }) async {
    try {
      // var response =
      await KhaltiScope.of(context).pay(
        config: PaymentConfig(
          amount: amount,
          productIdentity: productId,
          productName: productName,
        ),
        preferences: [
          PaymentPreference.khalti,
        ],
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
      // print('Raw Response: $response');
    } on Exception catch (e) {
      print("Khalti Error:$e");
    }
  }
}
