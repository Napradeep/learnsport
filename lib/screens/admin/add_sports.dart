import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/admin/sport_provider/sports_provider.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/widget/custom_confirmation_dialog.dart';

class AddEditSportScreen extends StatefulWidget {
  final Map<String, dynamic>? sport;
  const AddEditSportScreen({super.key, this.sport});

  @override
  State<AddEditSportScreen> createState() => _AddEditSportScreenState();
}

class _AddEditSportScreenState extends State<AddEditSportScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _groundNameController;
  late final TextEditingController _actualPriceController;
  late final TextEditingController _finalPriceController;
  late final TextEditingController _aboutController;
  late final TextEditingController _halfLightController;
  late final TextEditingController _fullLightController;

  String? _oldSportImageUrl;
  String? _oldBannerImageUrl;
  String? _oldWebImageUrl;

  File? _sportImage;
  File? _bannerImage;
  File? _webImage;
  String _status = 'AVAILABLE';

  bool _isCompressing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sport?['name'] ?? '');
    _groundNameController = TextEditingController(
      text: widget.sport?['ground_name'] ?? '',
    );
    _actualPriceController = TextEditingController(
      text: widget.sport?['actual_price_per_slot']?.toString() ?? '',
    );
    _finalPriceController = TextEditingController(
      text: widget.sport?['final_price_per_slot']?.toString() ?? '',
    );
    _aboutController = TextEditingController(
      text: widget.sport?['about'] ?? '',
    );
    _halfLightController = TextEditingController(
      text: widget.sport?['sport_lighting_price_half']?.toString() ?? '',
    );
    _fullLightController = TextEditingController(
      text: widget.sport?['sport_lighting_price_full']?.toString() ?? '',
    );

    final apiStatus = (widget.sport?['status'] ?? 'AVAILABLE')
        .toString()
        .toUpperCase();
    _status = apiStatus == 'AVAILABLE' ? 'AVAILABLE' : 'NOT_AVAILABLE';

    _oldSportImageUrl = widget.sport?['image'];
    _oldBannerImageUrl = widget.sport?['banner'];
    _oldWebImageUrl = widget.sport?['web_banner'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groundNameController.dispose();
    _actualPriceController.dispose();
    _finalPriceController.dispose();
    _aboutController.dispose();
    _halfLightController.dispose();
    _fullLightController.dispose();
    super.dispose();
  }

  // IMAGE PICKER WITH COMPRESSION
  Future<void> _pickImage({
    required bool isSport,
    required bool isBanner,
    required bool isWeb,
  }) async {
    if (_isCompressing) {
      Messenger.alert(msg: "Please wait, compressing previous image...");
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1400,
      maxHeight: 1400,
      imageQuality: 85,
    );

    if (picked == null) return;

    setState(() => _isCompressing = true);

    try {
      final compressedFile = await _compressImage(File(picked.path));
      if (compressedFile == null) {
        Messenger.alertError("Failed to compress image");
        return;
      }

      final fileSizeMB = (await compressedFile.length()) / (1024 * 1024);
      if (fileSizeMB > 1.8) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Large Image Detected"),
            content: Text(
              "Image size: ${fileSizeMB.toStringAsFixed(2)} MB\n\n"
              "Recommended: < 1.5 MB\n\n"
              "Continue anyway?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "Upload Anyway",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        );
        if (proceed != true) return;
      }

      setState(() {
        if (isWeb) {
          _webImage = compressedFile;
        } else if (isBanner) {
          _bannerImage = compressedFile;
        } else if (isSport) {
          _sportImage = compressedFile;
        }
      });
    } finally {
      setState(() => _isCompressing = false);
    }
  }

  Future<File?> _compressImage(File file) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final targetPath =
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 72,
      minWidth: 800,
      minHeight: 800,
      format: CompressFormat.jpeg,
    );

    return compressed != null ? File(compressed.path) : null;
  }

  void _saveSport() async {
    if (!_formKey.currentState!.validate()) return;

    final actual = double.tryParse(_actualPriceController.text) ?? 0;
    final finalP = double.tryParse(_finalPriceController.text) ?? 0;
    if (finalP > actual) {
      Messenger.alertError('Final price cannot exceed actual price');
      return;
    }

    final data = {
      'name': _nameController.text.trim(),
      'ground_name': _groundNameController.text.trim(),
      'actual_price_per_slot': actual.toString(),
      'final_price_per_slot': finalP.toString(),
      'about': _aboutController.text.trim(),
      'sport_lighting_price_half': _halfLightController.text.trim().isEmpty
          ? '0'
          : _halfLightController.text.trim(),
      'sport_lighting_price_full': _fullLightController.text.trim().isEmpty
          ? '0'
          : _fullLightController.text.trim(),
      'status': _status,
    };

    CustomConfirmationDialog.show(
      context: context,
      title: widget.sport != null ? 'Update Sport' : 'Add Sport',
      message: widget.sport != null ? 'Update this sport?' : 'Add this sport?',
      icon: widget.sport != null ? Icons.edit : Icons.add,
      iconColor: widget.sport != null ? Colors.orange : Colors.green,
      confirmColor: AppColors.bluePrimaryDual,
      onConfirm: () async {
        final provider = context.read<AddSportsProvider>();
        try {
          if (widget.sport == null) {
            await provider.addSport(
              name: data['name'].toString(),
              about: data['about'].toString(),
              actualPrice: data['actual_price_per_slot'].toString(),
              finalPrice: data['final_price_per_slot'].toString(),
              groundName: data['ground_name'].toString(),
              lightingHalf: data['sport_lighting_price_half'].toString(),
              lightingFull: data['sport_lighting_price_full'].toString(),
              status: data['status'].toString(),
              image: _sportImage!,
              banner: _bannerImage!,
              webBanner: _webImage!,
            );
            Messenger.alertSuccess("Sport added successfully!");
          } else {
            await provider.updateSport(
              id: widget.sport!['_id'].toString(),
              name: data['name'].toString(),
              about: data['about'].toString(),
              actualPrice: data['actual_price_per_slot'].toString(),
              finalPrice: data['final_price_per_slot'].toString(),
              groundName: data['ground_name'].toString(),
              lightingHalf: data['sport_lighting_price_half'].toString(),
              lightingFull: data['sport_lighting_price_full'].toString(),
              status: data['status'].toString(),
              // image: _sportImage,
              // banner: _bannerImage,
              // webBanner: _webImage,
            );
            Messenger.alertSuccess("Sport updated successfully!");
          }

          // THIS IS THE KEY FIX
          if (mounted) Navigator.pop(context, true); // Tell parent to refresh
        } catch (e) {
          Messenger.alertError("Operation failed!");
        }
      },
    );
  }

  // IMAGE PICKER UI
  Widget _buildImagePicker({
    required String label,
    required File? image,
    required String? networkImage,
    required bool isSport,
    required bool isBanner,
    required bool isWeb,
  }) {
    return GestureDetector(
      onTap: () =>
          _pickImage(isSport: isSport, isBanner: isBanner, isWeb: isWeb),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child:
            _isCompressing &&
                ((isWeb && _webImage == null) ||
                    (isBanner && _bannerImage == null) ||
                    (isSport && _sportImage == null))
            ? const Center(child: CircularProgressIndicator())
            : image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image, fit: BoxFit.cover),
              )
            : networkImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(networkImage, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 40, color: Colors.grey.shade500),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  const Text(
                    "Required",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }
        return validator?.call(value);
      },
    );
  }

  Widget _buildBigTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 7,
      minLines: 4,
      maxLength: 300,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        counterText: "",
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }
        if (value != null && value.length > 300) {
          return 'Maximum 300 characters allowed';
        }
        return validator?.call(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.sport != null ? 'Edit Sport' : 'Add Sport'),
        backgroundColor: AppColors.bluePrimaryDual,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  // Form Fields
                  _buildTextField(
                    label: 'Sport Name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Ground Name',
                    controller: _groundNameController,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Actual Price',
                    controller: _actualPriceController,
                    keyboardType: TextInputType.number,
                    validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                        ? 'Enter valid price'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Final Price',
                    controller: _finalPriceController,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final f = double.tryParse(v ?? '') ?? 0;
                      final a =
                          double.tryParse(_actualPriceController.text) ?? 0;
                      return f > a ? 'Cannot exceed actual price' : null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Lighting Prices
                  Row(
                    children: [
                      const Text(
                        'Lighting Price:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Half Ground',
                          controller: _halfLightController,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          label: 'Full Ground',
                          controller: _fullLightController,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status Toggle
                  Row(
                    children: [
                      const Text('Status:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ToggleButtons(
                          isSelected: [
                            _status == 'AVAILABLE',
                            _status == 'NOT_AVAILABLE',
                          ],
                          onPressed: (i) => setState(
                            () => _status = i == 0
                                ? 'AVAILABLE'
                                : 'NOT_AVAILABLE',
                          ),
                          borderRadius: BorderRadius.circular(12),
                          selectedColor: Colors.white,
                          fillColor: AppColors.bluePrimaryDual,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Available'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Not Available'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // IMAGE PICKERS - ALL MANDATORY
                  Row(
                    children: [
                      Expanded(
                        child: _buildImagePicker(
                          label: 'Sport Image ',
                          image: _sportImage,
                          networkImage: _oldSportImageUrl,
                          isSport: true,
                          isBanner: false,
                          isWeb: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildImagePicker(
                          label: 'Banner Image',
                          image: _bannerImage,
                          networkImage: _oldBannerImageUrl,
                          isSport: false,
                          isBanner: true,
                          isWeb: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildImagePicker(
                    label: 'Web Banner Image',
                    image: _webImage,
                    networkImage: _oldWebImageUrl,
                    isSport: false,
                    isBanner: false,
                    isWeb: true,
                  ),
                  const SizedBox(height: 25),
                  _buildBigTextField(
                    label: ' About Sport ',
                    controller: _aboutController,
                    validator: (v) =>
                        (v?.length ?? 0) < 10 ? 'Min 10 characters' : null,
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _isCompressing ? null : _saveSport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimaryDual,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isCompressing
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                "Processing Image...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            widget.sport != null ? 'Update Sport' : 'Add Sport',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
