import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jiffy/jiffy.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter_podcast/pages/export_page.dart';

class DetailsPublicationPage extends StatefulWidget {
  var pubUrl,imageUrl,title,date;
  DetailsPublicationPage({Key? key,this.pubUrl,this.imageUrl,this.title,this.date}) : super(key: key);

  @override
  State<DetailsPublicationPage> createState() => _DetailsPublicationPageState();
}

class _DetailsPublicationPageState extends State<DetailsPublicationPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Publication",style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            children: [
              Container(
                height: 80,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                  fontWeight: FontWeight.w800,

                ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover
                  )
                ),
              ),
              SizedBox(height: 10,),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: (){


                  }, icon: Icon(Icons.date_range_sharp,color: Colors.green,)),
                  Text(Jiffy.parse(widget.date, pattern: "yyyy-MM-ddTHH").format(pattern: "dd-MM-yyyy"))
                ],
              ),*/
              SizedBox(height: 20,),
              HtmlWidget(
                widget.pubUrl,
                textStyle: TextStyle(fontSize: 15),
                renderMode: RenderMode.column,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
