// lib/utils/widget/common_dropdown.dart
import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class CommonDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool isLoading;
  final String? error;
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
          DropdownMenuItem(
            value: 'General',
            child: Text(
              'General',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        value: selectedValue,
        hint: const Text(
          'Loading...',
          overflow: TextOverflow.ellipsis,
        ),
        enabled: false,
      );
    }

    // 2. Error
    if (error != null) {
      return _buildDropdown(
        items: const [
          DropdownMenuItem(
            value: 'General',
            child: Text(
              'General',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        value: selectedValue,
        hint: const Text(
          'Error loading',
          overflow: TextOverflow.ellipsis,
        ),
        enabled: false,
        errorText: error,
      );
    }

    // 3. Build list
    final List<DropdownMenuItem<String>> dropdownItems = [
      const DropdownMenuItem(
        value: 'General',
        child: Text(
          'General',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ...items.map((item) {
        final name = item['name']?.toString() ?? 'Unknown';
        return DropdownMenuItem(
          value: name,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    ];

    return _buildDropdown(
      items: dropdownItems,
      value: selectedValue,
      onChanged: onChanged,
      validator: (v) => v == null ? 'Please select an option' : null,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Dropdown builder with ellipsis applied everywhere
  // ─────────────────────────────────────────────────────────────
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

      // ⬅ Force ellipsis for the *selected* displayed text
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.value.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList();
      },

      items: items,
      hint: hint != null
          ? DefaultTextStyle(
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
              child: hint!,
            )
          : null,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
        hintText: 'Select $label',
        hintStyle: const TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
        errorText: errorText,
        errorMaxLines: 1,

        prefixIcon: const Icon(
          Icons.category_outlined,
          color: AppColors.iconLightColor,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2),
        ),
      ),
    );
  }
}
