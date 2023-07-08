// import 'package:flutter/material.dart';

// import 'package:carousel_slider/carousel_slider.dart';

// class UserDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> hostel;

//   const UserDetailScreen({
//     Key? key,
//     required this.hostel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<String> images =
//         hostel['images'] != null && hostel['images'].isNotEmpty
//             ? List<String>.from(hostel['images'])
//             : ['images/acclog.png'];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hostel Details'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Container(
//             height: 200,
//             child: CarouselSlider(
//               items: images.map<Widget>((image) {
//                 return Container(
//                   margin: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     image: DecorationImage(
//                       image: NetworkImage(image),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 height: 200,
//                 enlargeCenterPage: true,
//                 enableInfiniteScroll: true,
//                 autoPlay: true,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           ListTile(
//             title: Text('Name: ${hostel['name']}'),
//             subtitle: Text('Address: ${hostel['address']}'),
//           ),
//           ListTile(
//             title: Text('Description: ${hostel['description']}'),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Available Rooms:',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Column(
//             children: (hostel['available_rooms'] as Map<String, dynamic>)
//                 .entries
//                 .map<Widget>((entry) {
//               final roomType = entry.key;
//               // final roomCount = entry.value['count'];
//               // final roomPrice = entry.value['price'];

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 8),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 242, 162, 131),
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ListTile(
//                   title: Text('Room Type: $roomType'),
//                   subtitle: const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Text('Room Count: $roomCount'),
//                       // Text('Price: $roomPrice'), // Add price information
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           //  additional hostel details can be added
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hostel;

  const UserDetailScreen({
    Key? key,
    required this.hostel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> images =
        hostel['images'] != null && hostel['images'].isNotEmpty
            ? List<String>.from(hostel['images'])
            : ['images/logo.png'];

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
            title: Text('Name: ${hostel['name']}'),
            subtitle: Text('Address: ${hostel['address']}'),
          ),
          ListTile(
            title: Text('Description: ${hostel['description']}'),
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
            children: (hostel['available_rooms'] as Map<String, dynamic>)
                .entries
                .map<Widget>((entry) {
              final roomType = entry.key;
              // final roomCount = entry.value['count'];
              // final roomPrice = entry.value['price'];

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
                  title: Text('Room Type: $roomType'),
                  subtitle: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Room Count: $roomCount'),
                      // Text('Price: $roomPrice'), // Add price information
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          //  additional hostel details can be added
        ],
      ),
    );
  }
}
