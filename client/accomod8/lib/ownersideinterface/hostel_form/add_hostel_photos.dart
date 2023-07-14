

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

import '../../utility/image_uploader/upload_image.dart';

class AddBasicHostelPhotosPage extends StatefulWidget {
  final Function(File?) onDocumentPhotoSelected;
  final Function(List<File?>) onHostelPhotosSelected;

  const AddBasicHostelPhotosPage({
    Key? key,
    required this.onDocumentPhotoSelected,
    required this.onHostelPhotosSelected,
  }) : super(key: key);

  @override
  State<AddBasicHostelPhotosPage> createState() =>
      _AddBasicHostelPhotosPageState();
}

class _AddBasicHostelPhotosPageState extends State<AddBasicHostelPhotosPage> {
  final ImageUploader _imageUploader = ImageUploader();
  File? documentPhoto;
  List<File?> hostelPhotos = List.generate(5, (_) => null);
  File? defaultDocumentPhoto;

  @override
  void initState() {
    super.initState();
    // _loadDefaultDocumentPhoto();
  }

  // Future<void> _loadDefaultDocumentPhoto() async {
  //   final bytes = await _imageUploader.loadDefaultImageBytes('images/xdd.png');
  //   final file = File('${Directory.systemTemp.path}/default_document_photo.png');
  //   await file.writeAsBytes(bytes);
  //   setState(() {
  //     defaultDocumentPhoto = file;
  //   });
  // }

  Future<void> _selectDocumentPhoto() async {
    final source = await _showImageSourceSelectionDialog();
    if (source != null) {
      final image = await _imageUploader.selectImageFromSource(source);
      if (image != null) {
        setState(() {
          documentPhoto = image;
        });
        widget.onDocumentPhotoSelected(documentPhoto);
      }
    }
  }

  void _removeDocumentPhoto() {
    setState(() {
      documentPhoto = null;
    });
    widget.onDocumentPhotoSelected(documentPhoto);
  }

  Future<void> _selectHostelPhoto(int index) async {
    final source = await _showImageSourceSelectionDialog();
    if (source != null) {
      final image = await _imageUploader.selectImageFromSource(source);
      if (image != null) {
        setState(() {
          hostelPhotos[index] = image;
        });
        widget.onHostelPhotosSelected(hostelPhotos);
      }
    }
  }

  void _addHostelPhoto() {
    for (int i = 0; i < hostelPhotos.length; i++) {
      if (hostelPhotos[i] == null) {
        _selectHostelPhoto(i);
        break;
      }
    }
  }

  void _removeHostelPhoto(int index) {
    setState(() {
      hostelPhotos[index] = null;
    });
    widget.onHostelPhotosSelected(hostelPhotos);
  }

  Future<ImageSource?> _showImageSourceSelectionDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> hostelPhotoWidgets = [];
    for (int i = 0; i < hostelPhotos.length; i++) {
      if (hostelPhotos[i] != null) {
        hostelPhotoWidgets.add(
          Stack(
            children: [
              Image.file(
                hostelPhotos[i]!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () => _removeHostelPhoto(i),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _selectDocumentPhoto(),
          child: const Text('Upload photo of document'),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            const Text('Upload photos of hostel (up to 5)'),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _addHostelPhoto(),
                  child: const Text('Add Hostel Photo'),
                ),
                const Text('Hostel Photos:'),
                const SizedBox(height: 8),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    enableInfiniteScroll: false,
                  ),
                  items: hostelPhotoWidgets,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Document Photo:'),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: documentPhoto != null
                  ? Image.file(
                      documentPhoto!,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Text('No document to display'),
                    ),
              // : Image.file(
              //     File('images/xdd.png'),
              //     fit: BoxFit.cover,
              //   ),
            ),
            if (documentPhoto != null)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: _removeDocumentPhoto,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
