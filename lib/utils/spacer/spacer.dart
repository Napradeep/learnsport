import 'package:flutter/material.dart';

class Space {
  static SizedBox height(BuildContext context, double value) {
    double screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight >= 1000) {
      return SizedBox(height: value + 6); 
    } else {
      return SizedBox(height: value); 
    }
  }

  static SizedBox width(BuildContext context, double value) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1000) {
      return SizedBox(width: value + 6); 
    } else {
      return SizedBox(width: value); 
    }
  }

  static SizedBox h5(BuildContext context) => height(context, 5);
  static SizedBox h10(BuildContext context) => height(context, 10);
  static SizedBox h15(BuildContext context) => height(context, 15);
  static SizedBox h20(BuildContext context) => height(context, 20);
  static SizedBox h25(BuildContext context) => height(context, 25);
  static SizedBox h30(BuildContext context) => height(context, 30);
  static SizedBox h40(BuildContext context) => height(context, 40);
  static SizedBox h50(BuildContext context) => height(context, 50);
  static SizedBox h60(BuildContext context) => height(context, 60);
  static SizedBox h70(BuildContext context) => height(context, 70);
  static SizedBox h80(BuildContext context) => height(context, 80);
  static SizedBox h90(BuildContext context) => height(context, 90);
  static SizedBox h120(BuildContext context) => height(context, 120);




  static SizedBox w5(BuildContext context) => width(context, 5);
  static SizedBox w10(BuildContext context) => width(context, 10);
  static SizedBox w15(BuildContext context) => width(context, 15);
  static SizedBox w20(BuildContext context) => width(context, 20);
  static SizedBox w25(BuildContext context) => width(context, 25);
  static SizedBox w30(BuildContext context) => width(context, 30);
}
