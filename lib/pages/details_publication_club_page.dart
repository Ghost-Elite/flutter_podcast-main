import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jiffy/jiffy.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:flutter_podcast/models/export_model.dart';

class DetailsPublicationClubPage extends StatefulWidget {
  var pubUrl,imageUrl,title,date,titrePublic,content,type;
  About? about;
  DetailsPublicationClubPage({Key? key,this.content,this.pubUrl,this.imageUrl,this.title,this.date,this.titrePublic,this.type,this.about}) : super(key: key);

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
        centerTitle: true,
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
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return VoirPlusPage(
                              urldate: widget.pubUrl,
                              titre: widget.titrePublic,
                              image: widget.imageUrl,
                            );
                          }));

                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                                decoration: const BoxDecoration(
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
                        ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 40),
                child: Row(

                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.blue,
                              //blurRadius: 2,
                              offset: Offset(0, 0),
                              spreadRadius: 1.5
                          ),
                        ]
                      ),
                      child: InkWell(
                        onTap: ()=>_launchFacebook,
                        child: Center(
                          child: Icon(Remix.facebook_fill,color: Colors.blue,),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue,
                              //blurRadius: 2,
                              offset: Offset(0, 0),
                              spreadRadius: 1.5
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: ()=>_launchTwitter,
                        child: Center(
                          child: Icon(Remix.twitter_fill,color: Colors.blue,),
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 void _launchTwitter() async =>
     await canLaunch('https://twitter.com/intent/tweet?url=https://www.seytutefes.com/club-lmt/yenne')
         ? await launch('')
         : throw 'Could not launch';
 void _launchFacebook() async =>
     await canLaunch('https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fwww.seytutefes.com%2Fclub-lmt%2Fyenne')
         ? await launch('')
         : throw 'Could not launch';
}
class VoirPlusPage extends StatefulWidget {
  var urldate,titre,image;
  VoirPlusPage({Key? key,this.urldate,this.titre,this.image}) : super(key: key);

  @override
  State<VoirPlusPage> createState() => _VoirPlusPageState();
}

class _VoirPlusPageState extends State<VoirPlusPage> {
  var dataUrlClub;
  Future<void> getPublicationClubs() async {
    try {
      final response = await http.get(Uri.parse(widget.urldate));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataUrlClub=data;
        });
        if (dataUrlClub['data'].length ==0) {
          print('true');
        }  else{
          print("false");
        }
        //print(dataUrlClub['data'][0]['content']);
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
        title: Text("${widget.titre}",style: TextStyle(color: Colors.black),),
      ),
      body: dataUrlClub !=null && dataUrlClub['data'] !=0 ? SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: dataUrlClub['data'].isNotEmpty ||dataUrlClub['data'].length !=0? Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: CachedNetworkImage(
                  imageUrl: widget.image.toString().isEmpty?'': widget.image.toString(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset(
                        "assets/images/logo.png",
                        width:
                        MediaQuery.of(context).size.width ,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        "assets/images/logo.png",
                        width:
                        MediaQuery.of(context).size.width ,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                  width: MediaQuery.of(context).size.width ,
                  height: 200,
                ),
              ),
              SizedBox(height: 15,),
              HtmlWidget(
                dataUrlClub['data'][0]['content'].toString().isEmpty?'':dataUrlClub['data'][0]['content']??"",
                textStyle: TextStyle(fontSize: 15),
                renderMode: RenderMode.column,
              )
            ],


          ):

          Center(child: Text('Pas de publications disponible pour le moment.')),
        ),
      ) :Center(child: CircularProgressIndicator(),),
    );
  }
}
