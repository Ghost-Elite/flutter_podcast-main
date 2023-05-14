import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController? controller;
  final IconData? data;
  final IconData? suffixIcon;
  final String? hintText;
  bool? isObsecre = true;
  Color? colors;
  bool? enabled = true;
  bool? passwordVisible = false;
  bool? valide = false;
  final bool isEmail;
  final Function()? onPressed;
  String? Function(String?)? value;
  String? error;
  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled,
    this.passwordVisible,
    this.suffixIcon,
    this.colors,
    this.onPressed,
    this.valide,
    this.value,
    this.error,
    this.isEmail = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre!,
        validator: value,
        cursorColor: Colors.grey,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          border:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
          ),
            prefixIcon: Icon(
              data,
              color: Colors.grey,
              size: 20,

            ),
            suffixIcon: IconButton(
              icon: Icon(
                suffixIcon,
                color: colors,
                size: 20,
              ),
              color: Theme.of(context).primaryColorDark,
              onPressed: onPressed,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText,
          errorText: error,
          fillColor: Colors.white,
          filled: true,

        ),
      ),
    );
  }
}


