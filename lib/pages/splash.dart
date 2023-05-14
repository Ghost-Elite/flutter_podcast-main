import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'export_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_podcast/utils/utils_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var dataUrl;
  Future<void> getApi() async {
    try {
      var url ="https://seytutefes.com/api/about";
      final reponse = await http.get(Uri.parse(url));
      if (reponse.statusCode == 200) {
        var data = jsonDecode(reponse.body);
        setState(() {
          dataUrl=data;
        });
        //print(dataUrl);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    getApi();
    checkNecessaryPermissions(context);
  }
  startTime() async {
    var _duration = const Duration(seconds: 5);

    return Timer(_duration, navigationPage);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var bg = Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/splashScreen.png"),
                fit: BoxFit.fill
            ),
          ),
        ),

      ],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          bg,
          Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Platform.isIOS?200:300,),

                ],
              )
          ),
        ],
        ),
      ),
    );
  }
  Future<void> navigationPage()async {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(),
        ),
            (Route<dynamic> route) => false,
      );



  }
}
