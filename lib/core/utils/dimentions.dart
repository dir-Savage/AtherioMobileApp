import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimensions {
  // Padding and Margin
  static const double paddingSmall = 6.0;
  static const double paddingMedium = 10.0;
  static const double paddingMediumExtra = 12.0;
  static const double paddingLarge = 18.0;

  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;

  // Font Sizes
  static const double fontSmall = 14.0;
  static const double fontMedium = 16.0;
  static const double fontLarge = 20.0;
  static const double fontExtraLarge = 24.0;

  // Button Dimensions
  static const double buttonHeight = 48.0;
  static const double buttonWidth = 343.0;
  static const double buttonBorderRadius = 12.0;

  // Icon Sizes
  static const double iconSmall = 24.0;
  static const double iconMedium = 36.0;
  static const double iconLarge = 54.0;

  // AppBar Dimensions
  static const double appBarHeight = 56.0;

  // Other
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 10.0;
  static const double borderRadiusLarge = 16.0;


  // textfield
  static const double textFieldWidth = 343.0;


  // Spacing Height
  static SizedBox spaceSmall = SizedBox(height: 6.0.h);
  static SizedBox spaceMedium = SizedBox(height: 10.0.h);
  static SizedBox spaceLarge = SizedBox(height: 12.0.h);
  static SizedBox spaceExtraLarge = SizedBox(height: 16.0.h);
  static SizedBox spaceExtraExtraLarge = SizedBox(height: 22.0.h);

  // Spacing Width
  static SizedBox spaceWidthSuperSmall = SizedBox(width: 6.0.w);
  static SizedBox spaceWidthExtraSmall = SizedBox(width: 4.0.w);
  static SizedBox spaceWidthSmall = SizedBox(width: 6.0.w);
  static SizedBox spaceWidthMedium = SizedBox(width: 10.0.w);
  static SizedBox spaceWidthLarge = SizedBox(width: 12.0.w);
  static SizedBox spaceWidthExtraLarge = SizedBox(width: 16.0.w);
  static SizedBox spaceWidthExtraExtraLarge = SizedBox(width: 22.0.w);

  // Screen Dimensions (Dynamic Sizing)
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  // Responsive Dimensions
  static double responsiveFont(BuildContext context, double scale) => screenWidth(context) * scale;
  static double responsivePadding(BuildContext context, double scale) => screenHeight(context) * scale;
}
