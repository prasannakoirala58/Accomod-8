import 'package:accomod8/services/payment/khalti_payment.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  void onSuccess(PaymentSuccessModel success) {
    print('Payment bhayo:${success.toString}');
  }

  void onFailure(PaymentFailureModel failure) {
    print('Payment bhayena:${failure.toString}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("This is favourite page",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w500))
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  KhaltiPayment().performPayment(
                    context: context,
                    amount: 10 * 100,
                    productId: 'productId',
                    productName: 'productName',
                    onSuccess: onSuccess,
                    onFailure: onFailure,
                  );
                } on Exception catch (e) {
                  print('Error in client: $e');
                }
              },
              child: const Text(
                'Pay with khalti',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
