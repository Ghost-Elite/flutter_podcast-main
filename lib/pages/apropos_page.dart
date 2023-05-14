import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
import 'package:http/http.dart' as http;

class AproposPage extends StatefulWidget {
  var dataUrlAbout,nameAbout,email,tel,image,about_lmt;
  AproposPage({Key? key}) : super(key: key);

  @override
  State<AproposPage> createState() => _AproposPageState();
}

class _AproposPageState extends State<AproposPage> {
  var dataUrlAbout;
  Future<void> getPApropos() async {
    try {
      String endpoint="about";
      var url = "${baseUrl+endpoint}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataUrlAbout=data;
        });
        //print(dataMocs['data']['name']);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPApropos();
  }
  @override
  Widget build(BuildContext context) {
   // print(widget.nameAbout['data']);
    return Scaffold(
      body: SafeArea(
        child: dataUrlAbout !=null
            ? SingleChildScrollView(
          child: Column(

            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl: dataUrlAbout['data']['image'] != null && dataUrlAbout['data']['image'].toString().isNotEmpty?dataUrlAbout['data']['image'] :"",
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Image.asset(
                            "assets/images/logo.png",
                            width: 130,height: 80,fit: BoxFit.cover,
                          ),
                      errorWidget: (context, url, error) =>
                          Image.asset(
                            "assets/images/logo.png",width: 130,height: 80,fit: BoxFit.cover,
                          ),
                      width: 130,
                      height: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'LMT',
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10,),
              Text(
                'Les Micros de la Transition',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5),
              ),
              SizedBox(
                width: 150.0,
                height: 20.0,
                child: Divider(
                  color: Colors.teal.shade100,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  title: Text(
                    dataUrlAbout['data']['phone'] != null && dataUrlAbout['data']['phone'].toString().isNotEmpty ? dataUrlAbout['data']['phone'] : '',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black54),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  title: Text(
                    dataUrlAbout['data']['email'] != null && dataUrlAbout['data']['email'].toString().isNotEmpty ? dataUrlAbout['data']['email'] : '',
                    style: TextStyle(

                        fontSize: 20.0,
                        color: Colors.black54),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home_filled,
                    color: Colors.black,
                  ),
                  title: Text(
                    dataUrlAbout['data']['address'] != null && dataUrlAbout['data']['address'].toString().isNotEmpty ? dataUrlAbout['data']['address'] : '',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              dataUrlAbout['data']['privacy'] != null?
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    dataUrlAbout['data']['privacy'] != null && dataUrlAbout['data']['privacy'].toString().isNotEmpty ? dataUrlAbout['data']['privacy'] : '',
                    textStyle: TextStyle(fontSize: 15,letterSpacing: 2.0),

                    renderMode: RenderMode.column,
                  ),
                ),
              ):Container(),

            ],
          ),
        )
            : Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
