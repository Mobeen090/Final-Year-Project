import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final bool shouldTextBold;
  final double buttonTextSize;
  final Color buttonRoundedBorderColor;

  // You can add more parameters as needed

  const RoundedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.buttonColor,
    required this.textColor,
    required this.shouldTextBold,
    required this.buttonTextSize,
    this.buttonRoundedBorderColor=appThemeColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.all( BorderSide(
        color:  buttonRoundedBorderColor,
        width: 1.0,
        style: BorderStyle.solid)),
        backgroundColor: MaterialStateProperty.all<Color>(
          buttonColor, // Your custom color
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // Adjust the value as needed
          ),
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.all(8.r),
        child: Text(
          buttonText,
          style:  TextStyle(fontSize: buttonTextSize > 4 ? buttonTextSize : 16.sp,color: textColor, fontWeight: shouldTextBold ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}