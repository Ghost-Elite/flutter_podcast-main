import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jiffy/jiffy.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter_podcast/pages/export_page.dart';

class DetailsPublicationClubPage extends StatefulWidget {
  var pubUrl,imageUrl,title,date,titrePublic,content;
  DetailsPublicationClubPage({Key? key,this.content,this.pubUrl,this.imageUrl,this.title,this.date,this.titrePublic}) : super(key: key);

  @override
  State<DetailsPublicationClubPage> createState() => _DetailsPublicationClubPageState();
}

class _DetailsPublicationClubPageState extends State<DetailsPublicationClubPage> {
 var dataUrlClub;
  Future<void> getPublicationClubs() async {
    try {
      final response = await http.get(Uri.parse(widget.pubUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataUrlClub=data;
        });
        print(dataUrlClub);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPublicationClubs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("${widget.titrePublic}",style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text("${widget.titrePublic}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.blue),)),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0,0),
                                    color: Colors.white54
                                  )
                                ]
                              ),
                              child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(Icons.add_link_sharp,color: Colors.blue,size: 30,),
                              ),
                          ),
                          SizedBox(width: 10,),
                          Container(child: Text("Voir les publications",style: TextStyle(color: Colors.green,fontSize: 16),))
                        ],
                      )
                    ],
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
              SizedBox(height: 15,),
              HtmlWidget(
                widget.content,
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
class VoirPlusPage extends StatefulWidget {
  var titrePublic,imageUrl,content;
  VoirPlusPage({Key? key,this.titrePublic}) : super(key: key);

  @override
  State<VoirPlusPage> createState() => _VoirPlusPageState();
}

class _VoirPlusPageState extends State<VoirPlusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("${widget.titrePublic}",style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            children: [

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
              SizedBox(height: 15,),
              HtmlWidget(
                widget.content,
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
