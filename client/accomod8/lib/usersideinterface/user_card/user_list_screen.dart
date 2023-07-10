import 'package:accomod8/services/hostel/node_hostel_provider.dart';
import 'package:accomod8/usersideinterface/user_card/user_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// class UserListScreen extends StatefulWidget {
//   final String token;

//   const UserListScreen({
//     Key? key,
//     required this.token,
//   }) : super(key: key);

//   @override
//   State<UserListScreen> createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   Future<List<dynamic>> getHostels() async {
//     var hostels = await NodeHostelProvider().getAllHostels();
//     return hostels;
//     // return hostels.cast<dynamic>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hostel List'),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: getHostels(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final List<dynamic> hostels = snapshot.data ?? [];
//             final List<dynamic> featured =
//                 hostels.where((hostel) => hostel['featured'] == true).toList();
//             final List<dynamic> remainingUsers =
//                 hostels.where((hostel) => hostel['featured'] != true).toList();

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 20),
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   child: CarouselSlider(
//                     items: featured.map<Widget>((hostel) {
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => UserDetailScreen(
//                                 // name: hostel['name'],
//                                 // address: hostel['address'],
//                                 hostel: hostel,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           margin: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 radius: 40,
//                                 child: hostel['images'] != null &&
//                                         hostel['images'].isNotEmpty
//                                     ? Image.network(hostel['images'][0])
//                                     : Image.asset('images/xdd.png'),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 '${hostel['name']}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color.fromARGB(255, 242, 162, 131),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     options: CarouselOptions(
//                       height: 200.0,
//                       enlargeCenterPage: true,
//                       enableInfiniteScroll: true,
//                       autoPlay: true,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 2.5,
//                     ),
//                     itemCount: remainingUsers.length,
//                     itemBuilder: (context, index) {
//                       final hostel = remainingUsers[index];
//                       return GestureDetector(
//                         onTap: () {
//                           print('Hostel:$hostel');
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => UserDetailScreen(
//                                 // name: hostel['name'],
//                                 // address: hostel['address'],
//                                 hostel: hostel,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           margin: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                                 offset: Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 radius: 40,
//                                 child: hostel['images'] != null &&
//                                         hostel['images'].isNotEmpty
//                                     ? Image.network(hostel['images'][0])
//                                     : Image.asset('images/acclog.png'),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 '${hostel['name']}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color.fromARGB(255, 242, 162, 131),
//                                 ),
//                               ),
//                               Text(
//                                 '${hostel['address']}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color.fromARGB(255, 242, 162, 131),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class UserListScreen extends StatefulWidget {
  final String token;

  const UserListScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Future<List<Map<String, dynamic>>> getHostels() async {
    var hostels = await NodeHostelProvider().getAllHostels();
    return hostels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getHostels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> hostels = snapshot.data ?? [];
            final List<Map<String, dynamic>> featured =
                hostels.where((hostel) => hostel['featured'] == true).toList();
            final List<Map<String, dynamic>> remainingUsers =
                hostels.where((hostel) => hostel['featured'] != true).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CarouselSlider(
                    items: featured.map<Widget>((hostel) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(
                                hostel: hostel,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: hostel['images'] != null &&
                                        hostel['images'].isNotEmpty
                                    ? Image.network(hostel['images'][0])
                                    : Image.asset('images/acclog.png'),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${hostel['name']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 162, 131),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: remainingUsers.length,
                    itemBuilder: (context, index) {
                      final hostel = remainingUsers[index];
                      return GestureDetector(
                        onTap: () {
                          print('Hostel:$hostel');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(
                                hostel: hostel,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                child: hostel['images'] != null &&
                                        hostel['images'].isNotEmpty
                                    ? Image.network(hostel['images'][0])
                                    : Image.asset('images/acclog.png'),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${hostel['name']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 162, 131),
                                ),
                              ),
                              Text(
                                '${hostel['address']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 242, 162, 131),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
