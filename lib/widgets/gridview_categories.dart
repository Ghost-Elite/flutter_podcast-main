import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GridViewCategories extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  Color? color;
  GridViewCategories({Key? key,this.title,this.color,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(

          alignment: Alignment.center,

          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15)),
          child: Text(title!,style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
