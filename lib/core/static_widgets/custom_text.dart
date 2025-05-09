import 'package:atherio/core/const/colors.dart';
import 'package:flutter/material.dart';
import '../utils/dimentions.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final bool isBold;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = Dimensions.fontMedium,
    this.fontFamily = "Poppins",
    this.fontWeight = FontWeight.normal,
    this.isBold = false,
    this.color = C.blackText,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: isBold ? FontWeight.bold : fontWeight,
        color: color,
      ),
    );
  }
}
