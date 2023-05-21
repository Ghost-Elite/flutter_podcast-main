import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TitrePage extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  Color? color ;
  double? size;
  TitrePage({Key? key,this.onTap,this.title,this.color,this.size=18}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title!,style: TextStyle(color: color,fontSize: size!,fontWeight: FontWeight.w500),),
            const SizedBox(width: 20,),
            Icon(Icons.arrow_forward_ios_sharp,color: color,size: 18,)
          ],
        ),
      ),
    );
  }
}
