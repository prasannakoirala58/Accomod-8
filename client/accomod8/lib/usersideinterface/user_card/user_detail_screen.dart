import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../services/payment/khalti_payment.dart';
import '../../utility/snackbar/success_snackbar.dart';

class UserDetailScreen extends StatefulWidget {
  final Map<String, dynamic> hostel;

  const UserDetailScreen({
    Key? key,
    required this.hostel,
  }) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool paymentSuccessful = false;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Details'),
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
            title: Text('Name: ${widget.hostel['name']}'),
            subtitle: Text('Address: ${widget.hostel['address']}'),
          ),
          ListTile(
            title: Text('Description: ${widget.hostel['description']}'),
          ),
          ListTile(
            title: Text('For Gender: ${widget.hostel['for_gender']}'),
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
                      blurRadius: 5,
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
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRoomBooked ? Colors.red : Colors.green,
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
                                  onSuccess: (success) {
                                    setState(() {
                                      paymentSuccessful = true;
                                    });
                                    SuccessSnackBar.showSnackBar(
                                        context, 'Payment Successful');
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
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
