import 'package:atherio/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';


class CustomDropdownButton<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color dropdownColor;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;

  const CustomDropdownButton({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = C.primaryColor,
    this.dropdownColor = Colors.white,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem<T>(
        value: item,
        child: CustomText(
          text : item.toString(), color: C.blackText
        ),
      ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 1.5,
          ),
        ),
      ),
      dropdownColor: dropdownColor,
      hint: CustomText(
        text : hintText, color: C.greyTextTwo, fontSize: 12.sp,
      ),
    );
  }
}
