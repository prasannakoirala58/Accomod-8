import 'package:accomod8/services/hostel/node_hostel_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../pages/hostel_details_screen.dart';
import '../../utility/string_formatter/user_data_formatter.dart';

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

  String searchQuery = '';
  List<Map<String, dynamic>> filteredHostels = [];
  List<Map<String, dynamic>> hostels = [];

  bool isSearching = false;

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      searchQuery = '';
      filteredHostels.clear();
    });
  }

  void filterHostels() {
    setState(() {
      filteredHostels = hostels.where((hostel) {
        final address = hostel['address']?.toLowerCase() ?? '';
        return address.contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> extractedData =
        UserDataFormatter.extractValues(widget.token);
    final profilePicture = extractedData['profile_picture'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 242, 162, 131),
        title: isSearching
            ? TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    filterHostels();
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by hostel address',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hostel List'),
                  CircleAvatar(
                    radius: 20,
                    child: profilePicture != null && profilePicture.isNotEmpty
                        ? Image.network(profilePicture)
                        : Image.asset('images/acclog.png'),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  stopSearch();
                } else {
                  startSearch();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getHostels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  hostels = snapshot.data ?? [];
                  final List<Map<String, dynamic>> featured = hostels
                      .where((hostel) => hostel['featured'] == true)
                      .toList();
                  final List<Map<String, dynamic>> remainingHostels = hostels
                      .where((hostel) => hostel['featured'] != true)
                      .toList();

                  final filteredList = searchQuery.isNotEmpty
                      ? filteredHostels
                      : remainingHostels;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: CarouselSlider(
                          items: featured.map<Widget>((hostel) {
                            return GestureDetector(
                              onTap: () {
                                Map<String, dynamic> extractedData =
                                    UserDataFormatter.extractValues(
                                        widget.token);
                                final id = extractedData['id'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HostelDetailsScreen(
                                      hostel: hostel,
                                      showVerifyButton: false,
                                      id: id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
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
                                        color:
                                            Color.fromARGB(255, 242, 162, 131),
                                      ),
                                    ),
                                    Text(
                                      '${hostel['address']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 242, 162, 131),
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
                      SizedBox(
                        height: 20,
                      ),
                      //yaha bata chai grid view builder suru va cha
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 5,
                          ),
                          itemCount: searchQuery.isNotEmpty
                              ? filteredList.length
                              : remainingHostels.length,
                          itemBuilder: (context, index) {
                            final hostel = searchQuery.isNotEmpty
                                ? filteredList[index]
                                : remainingHostels[index];
                            return GestureDetector(
                              onTap: () {
                                Map<String, dynamic> extractedData =
                                    UserDataFormatter.extractValues(
                                        widget.token);
                                final id = extractedData['id'];
                                print('Hostel:$hostel');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HostelDetailsScreen(
                                      hostel: hostel,
                                      showVerifyButton: false,
                                      id: id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: hostel['images'] != null &&
                                                  hostel['images'].isNotEmpty
                                              ? Image.network(
                                                      hostel['images'][0])
                                                  .image // Use Image.network constructor
                                              : Image.asset('images/acclog.png')
                                                  .image, // Replace with your fallback image path
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          Text(
                                            '${hostel['name']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 242, 162, 131),
                                            ),
                                          ),
                                          Text(
                                            '${hostel['address']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  255, 242, 162, 131),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // CircleAvatar(
                                    //   radius: 30,
                                    //   child: hostel['images'] != null &&
                                    //           hostel['images'].isNotEmpty
                                    //       ? Image.network(hostel['images'][0])
                                    //       : Image.asset('images/acclog.png'),
                                    // ),
                                    // SizedBox(height: 8),
                                    // Text(
                                    //   '${hostel['name']}',
                                    //   style: const TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.bold,
                                    //     color:
                                    //         Color.fromARGB(255, 242, 162, 131),
                                    //   ),
                                    // ),
                                    // Text(
                                    //   '${hostel['address']}',
                                    //   style: const TextStyle(
                                    //     fontSize: 16,
                                    //     fontWeight: FontWeight.bold,
                                    //     color:
                                    //         Color.fromARGB(255, 242, 162, 131),
                                    //   ),
                                    // ),
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
          ),
        ],
      ),
    );
  }
}
