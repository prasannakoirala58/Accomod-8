import 'package:accomod8/pages/hostel_details_screen.dart';
import 'package:accomod8/services/hostel/node_hostel_provider.dart';
import 'package:flutter/material.dart';

import '../services/hostel/hostel_exception.dart';
import '../utility/string_formatter/user_data_formatter.dart';

class ManageHostel extends StatefulWidget {
  final String token;
  const ManageHostel({
    super.key,
    required this.token,
  });

  @override
  State<ManageHostel> createState() => _ManageHostelState();
}

class _ManageHostelState extends State<ManageHostel> {
  String? token;
  String? id;

  @override
  void initState() {
    token = widget.token;
    Map<String, dynamic> extractedData =
        UserDataFormatter.extractValues(widget.token);
    id = extractedData['id'];
    super.initState();
  }

  late List<Map<String, dynamic>> hostels;

  Future<List<Map<String, dynamic>>> getHostels() async {
    try {
      var hostels = await NodeHostelProvider().getOwnerHostel(id: id!);
      // print(hostels);
      return hostels;
    } on Exception catch (e) {
      print('Owner Hostel Error:$e');
      throw UnableToRetrieveHostelException;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 242, 162, 131),
        title: const Text(
          'Manage Hostel',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Your Hostels',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getHostels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<Map<String, dynamic>> hostels =
                      snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: hostels.length,
                    itemBuilder: (context, index) {
                      final hostel = hostels[index];

                      const Color containerColor =
                          Color.fromARGB(255, 242, 162, 131);
                      final bool isFeatured = hostel['featured'] ?? false;
                      final Color starColor =
                          isFeatured ? Colors.yellow : Colors.grey;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HostelDetailsScreen(
                                  hostel: hostel,
                                  showBookNowButton: false,
                                  showVerifyButton: false,
                                  showDocument: true,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    hostel['name'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                hostel['address'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Icon(
                                Icons.star,
                                color: starColor,
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
          ),
        ],
      ),
    );
  }
}
