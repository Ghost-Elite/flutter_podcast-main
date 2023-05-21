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
      //var url ="https://seytutefes.com/api/about";
      String endpoint="publications";
      var url = "${baseUrl+endpoint}";
      final reponse = await http.get(Uri.parse(url));
      if (reponse.statusCode == 200) {
        var data = jsonDecode(reponse.body);
        setState(() {
          dataUrl=data;
        });
        //print(dataUrl);
        navigationPage();
      }
    } on Exception catch (e) {
      print(e.toString());
      internetProblem();
    }
  }
  Object internetProblem() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        title: Column(
          children: const [
            Text(
              'LMT',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            )
          ],
        ),
        content: const Text(
          "Problème d\'accès à Internet, veuillez vérifier votre connexion et réessayez !!!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: grenSecondaryColor),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const SplashScreen()));
                },
                child: Container(
                  width: 120,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: grenSecondaryColor,
                      borderRadius: BorderRadius.circular(35)),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    "Réessayer",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    getApi();
    checkNecessaryPermissions(context);
    if (mounted) {
      setState(() => {});
    }
  }

  startTime() async {
    var duration = const Duration(seconds: 5);

    return Timer(duration,getApi);
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage(),
          ),
              (Route<dynamic> route) => false,
        );
      }



  }
}
