// lib/utils/widget/common_dropdown.dart
import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

/// Reusable dropdown with:
/// • Loading / error / empty states
/// • "General" always first & default
/// • Same styling as your ContactScreen
class CommonDropdown extends StatelessWidget {
  /// List of items from API (e.g. sports)
  final List<Map<String, dynamic>> items;

  /// Current selected value
  final String? selectedValue;

  /// Called when user selects an item
  final ValueChanged<String?> onChanged;

  /// Loading flag
  final bool isLoading;

  /// Optional error message
  final String? error;

  /// Optional label (default: "Contact Type")
  final String label;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.isLoading = false,
    this.error,
    this.label = 'Contact Type',
  });

  @override
  Widget build(BuildContext context) {
    // 1. Loading
    if (isLoading) {
      return _buildDropdown(
        items: const [
          DropdownMenuItem(value: 'General', child: Text('General')),
        ],
        value: selectedValue,
        hint: const Text('Loading...'),
        enabled: false,
      );
    }

    // 2. Error
    if (error != null) {
      return _buildDropdown(
        items: const [
          DropdownMenuItem(value: 'General', child: Text('General')),
        ],
        value: selectedValue,
        hint: const Text('Error loading'),
        enabled: false,
        errorText: error,
      );
    }

    // 3. Build final list: General + API items
    final List<DropdownMenuItem<String>> dropdownItems = [
      const DropdownMenuItem(value: 'General', child: Text('General')),
      ...items.map((item) {
        final name = item['name']?.toString() ?? 'Unknown';
        return DropdownMenuItem(value: name, child: Text(name));
      }).toList(),
    ];

    return _buildDropdown(
      items: dropdownItems,
      value: selectedValue,
      onChanged: onChanged,
      validator: (v) => v == null ? 'Please select an option' : null,
    );
  }

  // ── Same styling as your original dropdown ─────────────────────
  Widget _buildDropdown({
    required List<DropdownMenuItem<String>> items,
    String? value,
    Widget? hint,
    bool enabled = true,
    String? errorText,
    ValueChanged<String?>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      hint: hint,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select $label',
        prefixIcon: Icon(
          Icons.category_outlined,
          color: AppColors.iconLightColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 210, 65, 51),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 210, 65, 51),
            width: 1,
          ),
        ),
        errorText: errorText,
      ),
    );
  }
}
