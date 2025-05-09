import 'package:atherio/core/const/colors.dart';
import 'package:atherio/core/utils/dimentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final Icon? prefixIcon;
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool showError;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    this.prefixIcon,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.showError = false,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      cursorColor: C.primaryColor,
      controller: widget.controller,
      cursorErrorColor: Colors.deepOrange,
      obscureText: widget.isPassword ? _isObscured : false,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
      ),
      onChanged: (value) {
        if (widget.validator != null) {
          setState(() {
            _errorText = widget.validator!(value);
          });
        }
        widget.onChanged?.call(value);
      },
      validator: widget.validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: C.secondaryColor,
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: C.greyTextTwo,
          fontSize: 14.sp,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: C.primaryColor,
            size: 20.sp,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        )
            : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 12.w,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(Dimensions.borderRadiusMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(Dimensions.borderRadiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: C.primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(Dimensions.borderRadiusMedium),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(Dimensions.borderRadiusMedium),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(Dimensions.borderRadiusMedium),
        ),
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }
}