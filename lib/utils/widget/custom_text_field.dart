import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportspark/utils/const/const.dart';

class MyTextFormFieldBox extends StatefulWidget {
  final TextEditingController controller;
  final Color? color;
  final Decoration? decoration;
  final int? length;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hinttext;
  final Icon? icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final bool readOnly;
  final Function()? onTap;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const MyTextFormFieldBox({
    super.key,
    required this.controller,
    this.color,
    this.decoration,
    this.keyboardType,
    this.icon,
    this.hinttext,
    this.suffixIcon,
    this.obscureText = false,
    this.labelText,
    this.floatingLabelBehavior,
    this.length,
    this.maxLines = 1,
    this.enable,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<MyTextFormFieldBox> createState() => _MyTextFormFieldBoxState();
}

class _MyTextFormFieldBoxState extends State<MyTextFormFieldBox> {
  late FocusNode _focusNode;
  Color _currentBorderColor = const Color(0xFFD1D1DB);

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _currentBorderColor = _focusNode.hasFocus
            ? AppColors.bluePrimaryDual
            : Colors.grey.shade300;
      });
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      maxLength: widget.length,
      maxLines: widget.maxLines,
      enabled: widget.enable ?? true,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        prefixIcon: widget.icon,
        suffixIcon: widget.suffixIcon,
        hintText: widget.hinttext,
        labelText: widget.labelText,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        fillColor: Colors.white,
        filled: true,
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1.5, color: _currentBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: _currentBorderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _currentBorderColor),
        ),
      ),
    );
  }
}
