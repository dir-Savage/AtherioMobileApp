import 'package:atherio/core/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/dimentions.dart';
import 'custom_button.dart';

class CustomStaticTwoButton extends StatelessWidget {
  const CustomStaticTwoButton({
    super.key,
    required this.textOne,
    required this.textTwo,
    required this.onTapMain,
    required this.onTapSec,
    this.textColorPrim,
    this.textColorSec,
    this.secButtonColor,
    this.firstButtonColor,
  });

  final String? textOne , textTwo;
  final Function onTapMain , onTapSec;
  final Color? textColorPrim , textColorSec , secButtonColor , firstButtonColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: C.silver,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.borderRadiusLarge),
            topRight: Radius.circular(Dimensions.borderRadiusLarge),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            bottom: 20.h,
            top: 6.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                width: 190.w,
                text: textOne ?? 'Next',
                textColor: textColorPrim ?? C.primaryColor,
                color: firstButtonColor ?? C.primaryColor,
                buttonFontSize: 13.sp,
                onTap: () => onTapMain(),
              ),
              CustomButton(
                width: 110.w,
                text: textTwo ?? 'Back',
                textColor: textColorSec ?? C.primaryColor,
                buttonFontSize: 13.sp,
                color: secButtonColor ?? C.primaryColor,
                onTap: () => onTapSec(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
