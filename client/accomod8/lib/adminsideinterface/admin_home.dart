import 'package:flutter/material.dart';
import 'package:accomod8/services/hostel/node_hostel_provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Future<List<Map<String, dynamic>>> getHostels() async {
    var hostels = await NodeHostelProvider().getAllHostels();
    return hostels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home Page'),
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
            return ListView.builder(
              itemCount: hostels.length,
              itemBuilder: (context, index) {
                final hostel = hostels[index];
                final bool isFeatured = hostel['featured'] ?? false;
                final bool isVerified = hostel['verified'] ?? false;
                final Color containerColor =
                    const Color.fromARGB(255, 242, 162, 131);
                final Color starColor =
                    isFeatured ? Colors.yellow : Colors.grey;
                final Color verifiedIconColor =
                    isVerified ? Colors.green : Colors.red;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => UserDetailScreen(hostel: hostel),
                      //   ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hostel['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: starColor,
                                ),
                                Icon(
                                  Icons.verified,
                                  color: verifiedIconColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text(
                          hostel['address'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
