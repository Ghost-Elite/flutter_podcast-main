// ignore_for_file: file_names

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final Function()? onPressed;
  const SearchBar({super.key,this.onTap,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: TextField(
        onTap: onTap,
        cursorColor: Colors.white,
        keyboardType: TextInputType.none,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15)
            ),
            prefixIcon: const Icon(
              FluentIcons.search_28_regular,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.filter_list,color: Colors.grey,),
              onPressed: onPressed,
            ),
            hintText: 'Que souhaitez-vous écouter ?',
            hintStyle: TextStyle(color: Colors.black,fontSize: 14),
            prefixIconColor: Colors.black),
      ),
    );
  }
}
