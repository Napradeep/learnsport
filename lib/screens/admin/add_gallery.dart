
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/common_provider/gallery_service.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/widget/custom_text_field.dart';
import 'package:sportspark/screens/sportslist/sports_provider.dart';

class GalleryFormScreen extends StatefulWidget {
  const GalleryFormScreen({super.key});

  @override
  State<GalleryFormScreen> createState() => _GalleryFormScreenState();
}

class _GalleryFormScreenState extends State<GalleryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSportId;
  String? _eventName;
  String? _galleryTitle;
  String _galleryType = 'Image';
  String _status = 'Pending';

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  List<String> _videoLinks = [];

  final TextEditingController _videoLinkController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _galleryTitleController = TextEditingController();

  DateTime? _conductedTime;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // ensure sports are loaded (SportsProvider should already be used in app)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<SportsProvider>();
      if (sp.sports.isEmpty) sp.loadSports();
    });
  }

  @override
  void dispose() {
    _videoLinkController.dispose();
    _eventNameController.dispose();
    _galleryTitleController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked != null && picked.isNotEmpty) {
      setState(() => _images.addAll(picked));
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void _addVideoLink() {
    final text = _videoLinkController.text.trim();
    if (text.isEmpty) {
      _showSnack('Enter a YouTube URL', isError: true);
      return;
    }
    if (!_isValidYouTubeUrl(text)) {
      _showSnack('Enter a valid YouTube URL', isError: true);
      return;
    }
    setState(() {
      _videoLinks.add(text);
      _videoLinkController.clear();
    });
  }

  bool _isValidYouTubeUrl(String url) {
    final l = url.toLowerCase();
    return l.contains('youtube.com') || l.contains('youtu.be');
  }

  Future<void> _pickDateTime() async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: _conductedTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    final TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_conductedTime ?? DateTime.now()),
    );
    if (t == null) return;
    setState(() {
      _conductedTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  String get formattedConductedTime {
    if (_conductedTime == null) return '';
    return DateFormat('dd-MM-yyyy h:mm a').format(_conductedTime!);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showSnack('Please fix the errors', isError: true);
      return;
    }

    if (_selectedSportId == null || _selectedSportId!.isEmpty) {
      _showSnack('Please select a sport', isError: true);
      return;
    }

    if (_galleryType == 'Image' && _images.isEmpty) {
      _showSnack('Please add at least one image', isError: true);
      return;
    }

    if (_galleryType == 'Video' && _videoLinks.isEmpty) {
      _showSnack('Please add at least one YouTube link', isError: true);
      return;
    }

    setState(() => _submitting = true);

    try {
      final files = _images.map((x) => File(x.path)).toList();
      final conductedIso = _conductedTime?.toIso8601String();
      // Convert images to File list

      // 🟦 Debug Check — PRINT ALL DATA BEFORE API CALL
      print("-------- GALLERY SUBMIT DEBUG --------");
      print("SPORT ID       : $_selectedSportId");
      print("EVENT NAME     : ${_eventName?.trim()}");
      print("GALLERY TITLE  : ${_galleryTitle?.trim()}");
      print("GALLERY TYPE   : $_galleryType");
      print("CONDUCTED UTC  : $conductedIso");
      print("YOUTUBE LINKS  : $_videoLinks");
      print("IMAGE COUNT    : ${files.length}");

      for (var f in files) {
        print("FILE PATH      : ${f.path}");
      }
      print("--------------------------------------");

      final success = await GalleryService().addGallery(
        sportId: _selectedSportId!,
        eventName: _eventName!.trim(),
        title: _galleryTitle!.trim(),
        conductedTime: conductedIso.toString(),
        youtubeLinks: _galleryType == 'Video' ? _videoLinks : [],
        files: files,
      );

      if (success) {
        _showSnack('Gallery uploaded', isError: false);
        // optionally navigate back
        Navigator.of(context).pop(true);
      } else {
        _showSnack('Upload failed', isError: true);
      }
    } catch (e) {
      _showSnack('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sportsProvider = context.watch<SportsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
         centerTitle: false,
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: IconThemeData(color: AppColors.background),
        title: Text(
          'Add Gallery',
          style: TextStyle(color: AppColors.background),
        ),
      ),
      body: AbsorbPointer(
        absorbing: _submitting,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Sport dropdown
                DropdownButtonFormField<String>(
                  value: _selectedSportId,
                  decoration: InputDecoration(
                    labelText: 'Sport',
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: const OutlineInputBorder(),
                  ),
                  items: sportsProvider.sports.map<DropdownMenuItem<String>>((
                    s,
                  ) {
                    final id = s['_id'] ?? '';
                    final name = s['name'] ?? 'Sport';
                    return DropdownMenuItem(value: id, child: Text(name));
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedSportId = v),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Select sport' : null,
                ),
                const SizedBox(height: 12),

                // Event name
                MyTextFormFieldBox(
                  controller: _eventNameController,
                  labelText: 'Event Name',
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                  onChanged: (v) => _eventName = v,
                ),
                const SizedBox(height: 12),

                // Gallery title
                MyTextFormFieldBox(
                  controller: _galleryTitleController,
                  labelText: 'Gallery Title',
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Required' : null,
                  onChanged: (v) => _galleryTitle = v,
                ),
                const SizedBox(height: 12),

                // Conducted time
                TextFormField(
                  readOnly: true,
                  onTap: _pickDateTime,
                  controller: TextEditingController(
                    text: formattedConductedTime,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Conducted Time',
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: const OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  validator: (_) => _conductedTime == null ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // Gallery type
                DropdownButtonFormField<String>(
                  value: _galleryType,
                  decoration: InputDecoration(
                    labelText: 'Gallery Type',
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: const OutlineInputBorder(),
                  ),
                  items: ['Image', 'Video']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _galleryType = v ?? 'Image';
                    if (_galleryType == 'Image') _videoLinks.clear();
                    if (_galleryType == 'Video') _images.clear();
                  }),
                ),
                const SizedBox(height: 12),

                // Status
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: const OutlineInputBorder(),
                  ),
                  items: ['Pending', 'Active', 'Blocked']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v ?? 'Pending'),
                ),
                const SizedBox(height: 16),

                // Image picker or video links
                if (_galleryType == 'Image') ...[
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(Icons.image, color: AppColors.iconLightColor),
                    label: const Text(
                      'Pick Images',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimaryDual,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_images.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _images.asMap().entries.map((e) {
                        final idx = e.key;
                        final file = e.value;
                        return Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.bluePrimaryDual,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(file.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -8,
                              top: -8,
                              child: IconButton(
                                icon: const Icon(Icons.cancel, size: 20),
                                color: AppColors.iconRed,
                                onPressed: () => _removeImage(idx),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                ] else ...[
                  MyTextFormFieldBox(
                    controller: _videoLinkController,
                    labelText: 'YouTube link',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add, color: AppColors.iconColor),
                      onPressed: _addVideoLink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._videoLinks.map(
                    (l) => ListTile(
                      title: Text(l, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: AppColors.iconRed),
                        onPressed: () => setState(() => _videoLinks.remove(l)),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _submitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Uploading...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : const Text(
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
