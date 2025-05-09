import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const/colors.dart';
import '../utils/dimentions.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color color;
  final double borderRadius;
  final double height;
  final double width;
  final bool isEnabled;
  final double? buttonFontSize;
  final Color? textColor;
  final bool isLoading;
  final double loaderSize;
  final Color loaderColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.color = C.primaryColor,
    this.borderRadius = Dimensions.buttonBorderRadius,
    this.height = Dimensions.buttonHeight,
    this.width = double.infinity,
    this.isEnabled = true,
    this.buttonFontSize,
    this.textColor,
    this.isLoading = false,
    this.loaderSize = 20,
    this.loaderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isEnabled && !isLoading) ? onTap : null,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: _getButtonColor(),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: _buildContent(),
        ),
      ),
    );
  }

  Color _getButtonColor() {
    if (isLoading) return color.withOpacity(0.7);
    if (!isEnabled) return C.secondaryColor;
    return color;
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        width: loaderSize,
        height: loaderSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
        ),
      );
    }
    return CustomText(
      text: text,
      color: _getTextColor(),
      fontSize: buttonFontSize ?? 14.sp,
    );
  }

  Color _getTextColor() {
    if (isLoading) return Colors.transparent;
    if (!isEnabled) return C.greyText;
    return textColor ?? Colors.white;
  }
}