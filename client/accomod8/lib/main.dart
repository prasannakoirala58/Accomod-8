import 'package:accomod8/pages/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogInScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});

//   Future<void> fetchData() async {
//     try {
//       final response = await http.get(Uri.parse('http://100.69.184.245:5000/'));
//       if (response.statusCode == 200) {
//         // Handle the successful response here
//         print('Server response: ${response.body}');
//       } else {
//         // Handle any errors or non-200 status codes
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle any exceptions or connection errors
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Make the server request when the app starts
//     fetchData();

//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello, World!'),
//         ),
//       ),
//     );
//   }
// }
