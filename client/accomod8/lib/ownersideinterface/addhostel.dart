import 'package:accomod8/services/hostel/node_hostel_provider.dart';
import 'package:flutter/material.dart';

import '../utility/string_formatter/user_data_formatter.dart';

class AddHostel extends StatefulWidget {
  final String token;
  const AddHostel({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<AddHostel> createState() => _AddHostelState();
}

class _AddHostelState extends State<AddHostel> {
  String? token;
  late String id;
  @override
  void initState() {
    token = widget.token;

    try {
      Map<String, dynamic> extractedData =
          UserDataFormatter.extractValues(widget.token);

      setState(
        () {
          id = extractedData['id'];
        },
      );
    } on Exception catch (e) {
      print('Exception: $e');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("This is add hostel page"),
              TextButton(
                onPressed: () async {
                  // print('token in add:$token');
                  // print('id in add:$id');
                  try {
                    await NodeHostelProvider().registerHostel(
                      name: 'OtestHostel',
                      address: 'Ostest Road',
                      isFeatured: false,
                      latitude: 27.75292,
                      longitude: 85.32524,
                      description: 'Yo Otest user ko hostel ho',
                      forGender: 'M',
                      // images: '',
                      // document: document,
                      isVerified: false,
                      amenities: [
                        'Wifi',
                        'Kitchen',
                      ],
                      rooms: [
                        {
                          'available_seats': 2,
                          'room_number': '101',
                          'id': '101',
                          'room_type': 'two_seater',
                          'availability': true,
                          'price': 100,
                          'attached_bathroom': true,
                          'direct_sunlight': false,
                          'balcony': true,
                        },
                        {
                          'available_seats': 4,
                          'room_number': '201',
                          'id': '101',
                          'room_type': 'four_seater',
                          'availability': true,
                          'price': 200,
                          'attached_bathroom': true,
                          'direct_sunlight': true,
                          'balcony': false,
                        },
                      ],
                      reviews: [],
                      ownerId: id,
                    );
                  } on Exception catch (e) {
                    print('Add hostel error:$e');
                  }
                },
                child: const Text('Add hostel'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
