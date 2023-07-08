import 'package:flutter/material.dart';

class AddRoomDetailsPage extends StatefulWidget {
  final Function(Map<String, dynamic>) addRoomDetail;
  const AddRoomDetailsPage({
    Key? key,
    required this.addRoomDetail,
  }) : super(key: key);

  @override
  State<AddRoomDetailsPage> createState() => _AddRoomDetailsPageState();
}

class _AddRoomDetailsPageState extends State<AddRoomDetailsPage> {
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    addRoomForm();
  }

  List<Map<String, dynamic>> getRooms() {
    return rooms;
  }

  void addRoomForm() {
    Map<String, dynamic> newRoom = {
      'room_number': '',
      'id': '',
      'room_type': 'one_seater',
      'availability': true,
      'attached_bathroom': false,
      'direct_sunlight': false,
      'balcony': false,
      'available_seats': '',
      'price': '',
    };

    setState(() {
      rooms.add(newRoom);
    });

    widget.addRoomDetail(newRoom);
  }

  void deleteRoomForm(int index) {
    setState(() {
      rooms.removeAt(index);
    });
  }

  Widget buildRoomForm(int index) {
    Map<String, dynamic> roomData = rooms[index];
    bool availability = roomData['availability'];
    bool attachedBathroom = roomData['attached_bathroom'];
    bool directSunlight = roomData['direct_sunlight'];
    bool balcony = roomData['balcony'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Room Number: ${index + 1}'),
          onChanged: (value) {
            setState(() {
              roomData['room_number'] = value;
              roomData['id'] = value;
            });
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Available Seats'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              roomData['available_seats'] = int.tryParse(value) ?? 0;
            });
          },
          initialValue: roomData['available_seats'].toString(),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              roomData['price'] = double.tryParse(value) ?? 0.0;
            });
          },
          initialValue: roomData['price'].toString(),
        ),
        DropdownButtonFormField<String>(
          value: roomData['room_type'],
          items: const [
            DropdownMenuItem<String>(
              value: 'one_seater',
              child: Text('One Seater'),
            ),
            DropdownMenuItem<String>(
              value: 'two_seater',
              child: Text('Two Seater'),
            ),
            DropdownMenuItem<String>(
              value: 'three_seater',
              child: Text('Three Seater'),
            ),
            DropdownMenuItem<String>(
              value: 'four_seater',
              child: Text('Four Seater'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              roomData['room_type'] = value!;
            });
          },
          decoration: InputDecoration(labelText: 'Room Type'),
        ),
        const SizedBox(
          height: 15,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('True'),
            Text('False'),
          ],
        ),
        ListTile(
          title: Text('Availability'),
          dense: true,
          contentPadding: EdgeInsets.all(0),
          leading: Radio(
            value: true,
            activeColor: Colors.green[300],
            groupValue: availability,
            onChanged: (value) {
              setState(() {
                roomData['availability'] = value;
              });
            },
          ),
          trailing: Radio(
            value: false,
            activeColor: Colors.red[300],
            groupValue: availability,
            onChanged: (value) {
              setState(() {
                roomData['availability'] = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Attached Bathroom'),
          dense: true,
          contentPadding: EdgeInsets.all(0),
          leading: Radio(
            value: true,
            activeColor: Colors.green[300],
            groupValue: attachedBathroom,
            onChanged: (value) {
              setState(() {
                roomData['attached_bathroom'] = value;
              });
            },
          ),
          trailing: Radio(
            value: false,
            activeColor: Colors.red[300],
            groupValue: attachedBathroom,
            onChanged: (value) {
              setState(() {
                roomData['attached_bathroom'] = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Direct Sunlight'),
          dense: true,
          contentPadding: EdgeInsets.all(0),
          leading: Radio(
            value: true,
            activeColor: Colors.green[300],
            groupValue: directSunlight,
            onChanged: (value) {
              setState(() {
                roomData['direct_sunlight'] = value;
              });
            },
          ),
          trailing: Radio(
            value: false,
            activeColor: Colors.red[300],
            groupValue: directSunlight,
            onChanged: (value) {
              setState(() {
                roomData['direct_sunlight'] = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Balcony'),
          dense: true,
          contentPadding: EdgeInsets.all(0),
          leading: Radio(
            value: true,
            activeColor: Colors.green[300],
            groupValue: balcony,
            onChanged: (value) {
              setState(() {
                roomData['balcony'] = value;
              });
            },
          ),
          trailing: Radio(
            value: false,
            activeColor: Colors.red[300],
            groupValue: balcony,
            onChanged: (value) {
              setState(() {
                roomData['balcony'] = value;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            deleteRoomForm(index);
          },
          child: const Text('Delete Room'),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              height:
                  MediaQuery.of(context).size.height - kToolbarHeight - 320.0,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ElevatedButton(
                    onPressed: addRoomForm,
                    child: const Text('Add Room'),
                  ),
                  const SizedBox(height: 16.0),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      rooms.length,
                      (index) => buildRoomForm(index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
