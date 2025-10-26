import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';

class GalleryFormScreen extends StatefulWidget {
  const GalleryFormScreen({super.key});

  @override
  _GalleryFormScreenState createState() => _GalleryFormScreenState();
}

class _GalleryFormScreenState extends State<GalleryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _sportId, _sportName, _eventName, _galleryTitle;
  String _galleryType = 'Image';
  String _status = 'Pending';

  List<XFile> _images = [];
  List<String> _videoLinks = [];

  final TextEditingController _videoLinkController = TextEditingController();
  final TextEditingController _sportIdController = TextEditingController();
  final TextEditingController _sportNameController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _galleryTitleController = TextEditingController();

  DateTime? _conductedTime;
  final ImagePicker _picker = ImagePicker();

  // Select multiple images
  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images.addAll(selectedImages);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _addVideoLink() {
    if (_videoLinkController.text.isNotEmpty &&
        _isValidYouTubeUrl(_videoLinkController.text)) {
      setState(() {
        _videoLinks.add(_videoLinkController.text);
        _videoLinkController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid YouTube URL'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeVideoLink(int index) {
    setState(() {
      _videoLinks.removeAt(index);
    });
  }

  bool _isValidYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _conductedTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Function to get formatted date-time
  String get formattedDateTime {
    if (_conductedTime == null) return '';
    return DateFormat('dd-MM-yyyy h:mm a').format(_conductedTime!);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Gallery Data:');
      print('Sport ID: $_sportId');
      print('Sport Name: $_sportName');
      print('Event Name: $_eventName');
      print('Gallery Title: $_galleryTitle');
      print('Gallery Type: $_galleryType');
      print('Conducted Time: $_conductedTime');
      print('Status: $_status');
      if (_galleryType == 'Image') {
        print('Images: ${_images.map((e) => e.path).toList()}');
      } else {
        print('Video Links: $_videoLinks');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gallery saved successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        foregroundColor: AppColors.background,
        title: Text('Gallery', style: TextStyle(color: AppColors.background)),
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: IconThemeData(color: AppColors.background),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                // Sport Name
                MyTextFormFieldBox(
                  controller: _sportNameController,
                  labelText: 'Sport Name',
                  validator: (value) =>
                      value!.isEmpty ? 'Sport Name is required' : null,
                  onChanged: (value) => _sportName = value,
                ),
                const SizedBox(height: 16),
                // Event Name
                MyTextFormFieldBox(
                  controller: _eventNameController,
                  labelText: 'Event Name',
                  validator: (value) =>
                      value!.isEmpty ? 'Event Name is required' : null,
                  onChanged: (value) => _eventName = value,
                ),
                const SizedBox(height: 16),
                // Gallery Title
                MyTextFormFieldBox(
                  controller: _galleryTitleController,
                  labelText: 'Gallery Title',
                  validator: (value) =>
                      value!.isEmpty ? 'Gallery Title is required' : null,
                  onChanged: (value) => _galleryTitle = value,
                ),
                const SizedBox(height: 16),

                // Conducted Time
                MyTextFormFieldBox(
                  controller: TextEditingController(text: formattedDateTime),
                  readOnly: true,
                  labelText: 'Conducted Time',
                  onTap: _pickDateTime,
                  validator: (_) => _conductedTime == null
                      ? 'Conducted Time is required'
                      : null,
                ),

                const SizedBox(height: 16),
                // Gallery Type
                DropdownButtonFormField<String>(
                  value: _galleryType,
                  decoration: InputDecoration(
                    labelText: 'Gallery Type',
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(),
                  ),
                  items: ['Image', 'Video']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _galleryType = value!;
                      _images.clear();
                      _videoLinks.clear();
                    });
                  },
                ),

                const SizedBox(height: 16),
                // Status
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(value: 'Blocked', child: Text('Blocked')),
                  ],
                  onChanged: (value) => setState(() => _status = value!),
                ),
                const SizedBox(height: 16),

                // Image/Video Section
                if (_galleryType == 'Image') ...[
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(Icons.image, color: AppColors.iconLightColor),
                    label: Text('Upload Images'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimaryDual,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_images.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _images.asMap().entries.map((entry) {
                        int index = entry.key;
                        XFile image = entry.value;
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.bluePrimaryDual,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: AppColors.iconRed,
                                ),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                ] else ...[
                  MyTextFormFieldBox(
                    controller: _videoLinkController,
                    labelText: 'YouTube Video Link',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add, color: AppColors.iconColor),
                      onPressed: _addVideoLink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._videoLinks.asMap().entries.map((entry) {
                    int index = entry.key;
                    String link = entry.value;
                    return ListTile(
                      title: Text(
                        link,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: AppColors.iconRed,
                        ),
                        onPressed: () => _removeVideoLink(index),
                      ),
                    );
                  }).toList(),
                ],

                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      'Save Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
