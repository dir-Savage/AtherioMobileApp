import 'package:atherio/core/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/dimentions.dart';
import 'custom_button.dart';

class CustomStaticOneButton extends StatelessWidget {
  const CustomStaticOneButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
  });

  final String? text;
  final Color? textColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: width,
        decoration: const BoxDecoration(
          color: C.silver,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.borderRadiusLarge + 10),
            topRight: Radius.circular(Dimensions.borderRadiusLarge + 10),
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 30.w, right: 30.h, bottom: 20.h, top: 6.h),
          child: CustomButton(
            textColor: textColor,
            text: text ?? 'Back',
            buttonFontSize: 14.sp,
            onTap: () => onTap(),
          ),
        ),
      ),
    );
  }
}
