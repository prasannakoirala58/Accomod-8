import 'dart:io';

import 'package:accomod8/ownersideinterface/hostel_form/add_hostel_photos.dart';
import 'package:accomod8/ownersideinterface/hostel_form/basic_hostel_details_page.dart';
import 'package:accomod8/ownersideinterface/hostel_form/room_details_page.dart';
import 'package:accomod8/services/hostel/node_hostel_provider.dart';
import 'package:accomod8/utility/snackbar/error_snackbar.dart';
import 'package:accomod8/utility/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';
import '../../enums/gender_enums.dart';
import '../../utility/string_formatter/user_data_formatter.dart';
import '../ownernavbar.dart';

class AddHostelFormScreen extends StatefulWidget {
  final String token;

  const AddHostelFormScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<AddHostelFormScreen> createState() => _AddHostelFormScreenState();
}

class _AddHostelFormScreenState extends State<AddHostelFormScreen> {
  String? token;
  late String id;

  @override
  void initState() {
    token = widget.token;

    try {
      Map<String, dynamic> extractedData =
          UserDataFormatter.extractValues(widget.token);

      setState(
        () {
          id = extractedData['id'];
        },
      );
    } on Exception catch (e) {
      print('Exception: $e');
    }
    super.initState();
  }

  File? document;
  List<File?> hostelPhotos = List.generate(5, (_) => null);

  void handleDocumentPhotoSelected(File? photo) {
    setState(() {
      document = photo;
    });
  }

  void handleHostelPhotosSelected(List<File?> photos) {
    setState(() {
      hostelPhotos = photos;
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amenitiesController = TextEditingController();
  List<Map<String, dynamic>> basicDetails = [];
  List<Map<String, dynamic>> roomDetails = [];

  GenderTypeEnum? _selectedGender;
  final ValueNotifier<GenderTypeEnum?> _genderNotifier =
      ValueNotifier<GenderTypeEnum?>(null);

  void _onGenderChanged(GenderTypeEnum? value) {
    setState(() {
      _selectedGender = value;
    });
  }

  void addRoomDetail(Map<String, dynamic> roomData) {
    roomDetails.add(roomData);
  }

  int _activeStepIndex = 0;

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(
            'Basic Hostel Details',
            style: TextStyle(
              color: Color.fromARGB(255, 242, 162, 131),
            ),
          ),
          content: AddBasicHostelDetailsPage(
            nameController: nameController,
            addressController: addressController,
            descriptionController: descriptionController,
            amenitiesController: amenitiesController,
            onChanged: _onGenderChanged,
            selectedGender: _selectedGender,
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text(
            'Room Details',
            style: TextStyle(
              color: Color.fromARGB(255, 242, 162, 131),
            ),
          ),
          content: AddRoomDetailsPage(
            addRoomDetail: addRoomDetail,
          ),
        ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text(
            'Photos',
            style: TextStyle(
              color: Color.fromARGB(255, 242, 162, 131),
            ),
          ),
          content: AddBasicHostelPhotosPage(
            onDocumentPhotoSelected: handleDocumentPhotoSelected,
            onHostelPhotosSelected: handleHostelPhotosSelected,
          ),
        ),
        Step(
          state: _activeStepIndex <= 3 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text(
            'Submit',
            style: TextStyle(
              color: Color.fromARGB(255, 242, 162, 131),
            ),
          ),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text;
                  final address = addressController.text;
                  final description = descriptionController.text;
                  final forGender = _selectedGender.toString().split('.').last;
                  // final amenities = amenitiesController.text;
                  final amenitiesList =
                      amenitiesController.text.split('\n').toList();
                  print('Name:$name');
                  print('Address:$address');
                  print('Desc:$description');
                  print('For Gender:$forGender');
                  // print('Amenities:$amenities');
                  // print('Room Detail:$roomDetails');
                  print('Amenities List:$amenitiesList');
                  // print('ID:$id');
                  // extract room numbers only
                  // final roomNumbers =
                  //     roomDetails.map((room) => room['room_number']).toList();
                  // print('Room Numbers: $roomNumbers');

                  final List<Map<String, dynamic>> rooms =
                      roomDetails.map((roomData) {
                    return {
                      'available_seats': roomData['available_seats'],
                      'room_number': roomData['room_number'],
                      'id': roomData['id'],
                      'price': roomData['price'],
                      'room_type': roomData['room_type'],
                      'availability': roomData['availability'],
                      'attached_bathroom': roomData['attached_bathroom'],
                      'direct_sunlight': roomData['direct_sunlight'],
                      'balcony': roomData['balcony'],
                    };
                  }).toList();

                  print('rooms:$rooms');
                  print('hostel photos:$hostelPhotos');

                  try {
                    var response = await NodeHostelProvider().registerHostel(
                      name: name,
                      address: address,
                      latitude: 27.75292,
                      longitude: 85.32524,
                      description: description,
                      forGender: forGender,
                      isVerified: false,
                      amenities: amenitiesList,
                      rooms: rooms,
                      reviews: [''],
                      ownerId: id,
                      images: hostelPhotos,
                      document: document,
                    );
                    print('Frontend Response: $response');
                    if (response == 'success') {
                      setState(
                        () {
                          SuccessSnackBar.showSnackBar(
                            context,
                            'Hostel Registered Successfully',
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OwnerNavBar(
                                token: widget.token,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      setState(() {
                        ErrorSnackBar.showSnackBar(
                          context,
                          'Error registering hostel',
                        );
                      });
                    }
                  } on Exception catch (e) {
                    print('Error:$e');
                    setState(
                      () {
                        ErrorSnackBar.showSnackBar(
                            context, 'Error Registering Hostel');
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          child: Scaffold(
            body: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color.fromARGB(255, 242, 162, 131),
                ),
              ),
              child: ValueListenableBuilder<GenderTypeEnum?>(
                valueListenable: _genderNotifier,
                builder: (context, selectedGender, _) {
                  return Stepper(
                    type: StepperType.vertical,
                    currentStep: _activeStepIndex,
                    steps: stepList(),
                    onStepContinue: () {
                      // Color.fromARGB(255, 242, 162, 131);
                      if (_activeStepIndex < (stepList().length - 1)) {
                        _activeStepIndex += 1;
                      }
                      setState(() {});
                    },
                    onStepCancel: () {
                      if (_activeStepIndex == 0) {
                        return;
                      }
                      _activeStepIndex -= 1;
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
