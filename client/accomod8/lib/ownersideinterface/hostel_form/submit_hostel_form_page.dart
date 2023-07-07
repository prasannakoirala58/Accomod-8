import 'package:flutter/material.dart';

class AddSubmitFormPage extends StatelessWidget {
  final List<Map<String, dynamic>> basicDetails;
  final List<Map<String, dynamic>> roomDetails;

  const AddSubmitFormPage({
    Key? key,
    required this.basicDetails,
    required this.roomDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Basic Hostel Details:'),
        for (final detail in basicDetails)
          Text('Field: ${detail['fieldName']}, Value: ${detail['fieldValue']}'),
        SizedBox(height: 16.0),
        Text('Room Details:'),
        for (final room in roomDetails)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room Number: ${room['room_number']}'),
              Text('Room Type: ${room['room_type']}'),
              Text('Availability: ${room['availability']}'),
              Text('Attached Bathroom: ${room['attached_bathroom']}'),
              Text('Direct Sunlight: ${room['direct_sunlight']}'),
              Text('Balcony: ${room['balcony']}'),
              Divider(),
            ],
          ),
        ElevatedButton(
          onPressed: () {
            // Perform any actions on submit button click
            // For example, submit the form data to an API
            // You can access the basic and room details using the respective variables
            print('Basic Details: $basicDetails');
            print('Room Details: $roomDetails');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
