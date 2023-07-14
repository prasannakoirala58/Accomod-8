import 'package:accomod8/services/hostel/node_hostel_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../services/payment/khalti_payment.dart';
import '../../utility/snackbar/success_snackbar.dart';
import '../services/payment/node_bookings_provider.dart';

class HostelDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> hostel;
  final bool showBookNowButton;
  final bool showVerifyButton;
  final bool showDocument;
  final String id;

  const HostelDetailsScreen({
    Key? key,
    required this.hostel,
    this.showBookNowButton = true,
    this.showVerifyButton = true,
    this.showDocument = false,
    this.id = '',
  }) : super(key: key);

  @override
  _HostelDetailsScreenState createState() => _HostelDetailsScreenState();
}

class _HostelDetailsScreenState extends State<HostelDetailsScreen> {
  bool paymentSuccessful = false;
  bool isHostelVerified = false;

  @override
  void initState() {
    super.initState();
    isHostelVerified = widget.hostel['verified'];
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images =
        widget.hostel['images'] != null && widget.hostel['images'].isNotEmpty
            ? List<String>.from(widget.hostel['images'])
            : ['images/xdd.png'];

    final List<String> amenities = widget.hostel['amenities'] != null &&
            widget.hostel['amenities'].isNotEmpty
        ? List<String>.from(widget.hostel['amenities'])
        : [];

    final String? document = widget.hostel['document'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 213, 127, 93),
        title: const Text(
          'Hostel Details',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            child: CarouselSlider(
              items: images.map<Widget>((image) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: image.startsWith('http')
                          ? NetworkImage(image)
                          : AssetImage(image) as ImageProvider<Object>,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              'Name: ${widget.hostel['name']}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
            subtitle: Text(
              'Address: ${widget.hostel['address']}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ),
          ListTile(
            title: Text(
              'Description: ${widget.hostel['description']}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ),
          ListTile(
            title: Text(
              'For Gender: ${widget.hostel['for_gender']}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
          ),
          const Text(
            'Amenities:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: amenities.map<Widget>((amenity) {
              return Chip(
                label: Text(amenity),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Available Rooms:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children:
                (widget.hostel['rooms'] as List<dynamic>).map<Widget>((room) {
              final Color colorOfAvailable;
              if (room['available_seats'] > 0) {
                colorOfAvailable = Colors.green.shade600;
              } else {
                colorOfAvailable = Colors.red.shade600;
              }
              final bool isRoomBooked =
                  paymentSuccessful || (room['available_seats'] == 0);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 242, 162, 131),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text('Room Number: ${room['room_number']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Room Type: ${room['room_type']}'),
                      Text(
                        'Available Seats: ${room['available_seats']}',
                        style: TextStyle(
                          color: colorOfAvailable,
                        ),
                      ),
                      Text('Price: ${room['price']}'),
                      Text('Attached Bathroom: ${room['attached_bathroom']}'),
                      Text('Direct Sunlight: ${room['direct_sunlight']}'),
                      Text('Balcony: ${room['balcony']}'),
                    ],
                  ),
                  trailing: widget.showBookNowButton
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isRoomBooked ? Colors.red : Colors.green,
                          ),
                          onPressed: isRoomBooked
                              ? null
                              : () {
                                  if (!paymentSuccessful) {
                                    try {
                                      KhaltiPayment().performPayment(
                                        context: context,
                                        amount: room['price'] * 100,
                                        productId: room['room_number'],
                                        productName:
                                            'Room Number: ${room['room_number']}',
                                        onSuccess: (success) async {
                                          final paymentStatus =
                                              await NodeBookingProvdier()
                                                  .createBooking(
                                            userId: widget.id,
                                            hostelId: widget.hostel['id'],
                                            price: room['price'],
                                          );
                                          if (paymentStatus == 'success') {
                                            setState(
                                              () {
                                                paymentSuccessful = true;
                                                SuccessSnackBar.showSnackBar(
                                                  context,
                                                  'Payment Successful',
                                                );
                                              },
                                            );
                                          }
                                        },
                                        onFailure: (failure) {
                                          print(
                                              'Payment Failed: ${failure.toString()}');
                                        },
                                      );
                                    } on Exception catch (e) {
                                      print('Error in client: $e');
                                    }
                                  }
                                },
                          child: Text(isRoomBooked ? 'Booked' : 'Book Now'),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (widget.showDocument && document != null)
            Column(
              children: [
                const Text('Document:'),
                Container(
                  alignment: Alignment.center,
                  child: Image.network(document),
                ),
              ],
            )
          else if (widget.showDocument)
            const Text('No document submitted'),
          const SizedBox(height: 16),
          if (!isHostelVerified && widget.showVerifyButton)
            ElevatedButton(
              onPressed: () async {
                print('Verify Pressed');
                try {
                  await NodeHostelProvider().verifyOrUnverifyHostel(
                    toVerify: true,
                    id: widget.hostel['id'],
                  );
                  setState(() {
                    isHostelVerified = true;
                    SuccessSnackBar.showSnackBar(
                      context,
                      'Hostel Verified Successfully',
                    );
                  });
                } on Exception catch (e) {
                  print('Error:$e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isHostelVerified ? Colors.grey : null,
              ),
              child: const Text('Verify Hostel'),
            )
          else if (isHostelVerified && widget.showVerifyButton)
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Hostel Verified'),
            ),
        ],
      ),
    );
  }
}
