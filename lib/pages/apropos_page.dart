import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_podcast/models/export_model.dart';

class AproposPage extends StatefulWidget {
  About? about;
  bool? isFistLoadRunning = false;
  AproposPage({Key? key,this.about,this.isFistLoadRunning}) : super(key: key);

  @override
  State<AproposPage> createState() => _AproposPageState();
}

class _AproposPageState extends State<AproposPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (this.mounted) {
      setState(() {
        // Your state change code goes here
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
   print(widget.about!.data.email);
    return Scaffold(
      body: SafeArea(
        child: widget.about !=false
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
                      imageUrl: widget.about!.data.image != null && widget.about!.data.image.toString().isNotEmpty?widget.about!.data.image  :"",
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
              InkWell(
                onTap: ()=>_makePhoneCall(),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    title: Text(
                        widget.about!.data.phone != null && widget.about!.data.phone.toString().isNotEmpty ? widget.about!.data.phone : '',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()=>_sendEmail(),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    title: Text(
                      widget.about!.data.email != null && widget.about!.data.email.toString().isNotEmpty ? widget.about!.data.email : '',
                      style: TextStyle(

                          fontSize: 20.0,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ),
              InkWell(

                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: Colors.black,
                    ),
                    title: Text(
                      widget.about!.data.address != null && widget.about!.data.address.toString().isNotEmpty ? widget.about!.data.address : '',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              widget.about!.data.aboutLmt != null?
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    widget.about!.data.aboutLmt != null &&  widget.about!.data.aboutLmt.toString().isNotEmpty ?  widget.about!.data.aboutLmt : '',
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
  void _launchPhone() async =>
      await canLaunch( widget.about!.data.phone != null && widget.about!.data.phone.toString().isNotEmpty ? widget.about!.data.phone : '')
          ? await launch(widget.about!.data.phone != null && widget.about!.data.phone.toString().isNotEmpty ? widget.about!.data.phone : '')
          : throw 'Could not launch ${widget.about!.data.phone != null && widget.about!.data.phone.toString().isNotEmpty ? widget.about!.data.phone : ''}';
  void _launchEmail() async =>
      await canLaunch(widget.about!.data.email != null && widget.about!.data.email.toString().isNotEmpty ? widget.about!.data.email : '')
          ? await launch(widget.about!.data.email != null && widget.about!.data.email.toString().isNotEmpty ? widget.about!.data.email : '')
          : throw 'Could not launch ${widget.about!.data.email != null && widget.about!.data.email.toString().isNotEmpty ? widget.about!.data.email : ''}';

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.about!.data.phone,
    );
    await launchUrl(launchUri);
  }
  void _sendEmail(){
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: widget.about!.data.email,
      queryParameters: {
        'subject': 'CallOut user Profile',
        'body': widget.about!.data.email
      },
    );
    launchUrl(emailLaunchUri);
  }

}
