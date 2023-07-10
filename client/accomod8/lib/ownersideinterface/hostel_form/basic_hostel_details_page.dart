import 'package:accomod8/enums/gender_enums.dart';
import 'package:flutter/material.dart';

class AddBasicHostelDetailsPage extends StatefulWidget {
  final GenderTypeEnum? selectedGender;
  final ValueChanged<GenderTypeEnum?> onChanged;
  final TextEditingController? nameController;
  final TextEditingController? addressController;
  final TextEditingController? descriptionController;
  final TextEditingController? amenitiesController;

  const AddBasicHostelDetailsPage({
    Key? key,
    required this.selectedGender,
    required this.onChanged,
    required this.nameController,
    required this.addressController,
    required this.descriptionController,
    required this.amenitiesController,
  }) : super(key: key);

  @override
  State<AddBasicHostelDetailsPage> createState() =>
      _AddBasicHostelDetailsPageState();
}

class _AddBasicHostelDetailsPageState extends State<AddBasicHostelDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Widget buildVerticalSpacing(double height) {
      return SizedBox(height: height);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.home_work_outlined),
          ),
        ),
        buildVerticalSpacing(15),
        TextFormField(
          controller: widget.addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            prefixIcon: Icon(Icons.location_history_outlined),
          ),
        ),
        buildVerticalSpacing(15),
        TextFormField(
          controller: widget.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            prefixIcon: Icon(Icons.description_outlined),
          ),
          maxLines: 3,
        ),
        buildVerticalSpacing(15),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'For gender:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 242, 162, 131),
                ),
              ),
              GestureDetector(
                child: Row(
                  children: [
                    Radio<GenderTypeEnum>(
                      value: GenderTypeEnum.male,
                      groupValue: widget.selectedGender,
                      onChanged: (value) {
                        setState(() {
                          widget.onChanged(value);
                        });
                      },
                      activeColor: const Color.fromARGB(255, 242, 162, 131),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Male",
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 162, 131),
                      ),
                    ),
                    Radio<GenderTypeEnum>(
                      value: GenderTypeEnum.female,
                      groupValue: widget.selectedGender,
                      onChanged: (value) {
                        setState(() {
                          widget.onChanged(GenderTypeEnum.female);
                        });
                      },
                      activeColor: const Color.fromARGB(255, 242, 162, 131),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Female",
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 162, 131),
                      ),
                    ),
                    Radio<GenderTypeEnum>(
                      value: GenderTypeEnum.others,
                      groupValue: widget.selectedGender,
                      onChanged: (value) {
                        setState(() {
                          widget.onChanged(GenderTypeEnum.others);
                        });
                      },
                      activeColor: const Color.fromARGB(255, 242, 162, 131),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Others",
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 162, 131),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        buildVerticalSpacing(15),
        TextFormField(
          controller: widget.amenitiesController,
          decoration: const InputDecoration(
            labelText: 'Amenities(One per line)',
            prefixIcon: Icon(Icons.list),
          ),
          maxLines: null,
        ),
      ],
    );
  }
}
