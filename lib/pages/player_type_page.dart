import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class PlayerTypePage extends StatefulWidget {
  var idMusic;
  PlayerTypePage({Key? key,this.idMusic}) : super(key: key);

  @override
  State<PlayerTypePage> createState() => _PlayerTypePageState();
}

class _PlayerTypePageState extends State<PlayerTypePage> {
  WebViewPlusController? _controller;
  String viewport =
      '<head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>';

  Future<void> loadHtmlFromAssets(controller, url) async {
    String fileText = ""; /*await rootBundle.loadString(filename);*/
    String txt =
        "<iframe style=\"position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0;scrolling:no; frameborder:no; allow:autoplay padding:0; overflow:hidden; z-index:999999;\" src=\"$url\"></iframe>";

    if (Platform.isIOS) {
      fileText = viewport + txt;
    } else {
      fileText = txt;
    }
    controller.loadUrl(Uri.dataFromString(fileText,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
  var url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    print(widget.idMusic);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.yellowAccent,
        child: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller.loadString('''${r'''
           <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <script src="https://w.soundcloud.com/player/api.js"></script>
        </head>
        <body>
          <iframe
            id="sound-cloud-iframe"
            src='''+widget.idMusic}            scrolling="no"
            style="width: 100%; height: 100%;"
          >
          </iframe>
        </body>
      </html>
            
      ''');
          },
        ),
      )
    );
  }
}
//271188615
//<div class="mainWidget "><iframe id="sc-widget" width="100%" height="100%" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https://soundcloud.com/alamincmt7418/birds-squawk&amp;color=%23f50&amp;auto_play=true&amp;buying=true&amp;sharing=true&amp;download=true&amp;show_artwork=true&amp;show_playcount=true&amp;show_user=true&amp;single_active=true&amp;show_comments=true&amp;visual=false&amp;show_teaser=false&amp;hide_related=true&amp;start_track=0"></iframe></div>