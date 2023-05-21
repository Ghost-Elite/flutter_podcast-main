import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class PlayerTypePage extends StatefulWidget {
  var idMusic,content;
  PlayerTypePage({Key? key,this.idMusic,this.content}) : super(key: key);

  @override
  State<PlayerTypePage> createState() => _PlayerTypePageState();
}

class _PlayerTypePageState extends State<PlayerTypePage> {
  WebViewPlusController? _controller;
  var url;
  Random random =  Random();
  int index = 0;
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

  List colors = [
    Color(0xFF303D00),
    Color(0xFF2C92F0),
    Color(0xFFED3D05),
    Color(0xFFFA7B06),
    Color(0xFF16A925),
    Color(0xFF3AAD7D),
    Color(0xFF301D58),
    Color(0xFFDF17CB),
    Color(0xFF6D3986),
    Color(0xFF252525),
    Color(0xFFA4C639),
    Color(0xFF005062),
  ];

  //List<Audio> songs = [];
  void changeIndex() {
    setState(() => index = random.nextInt(colors.length));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeIndex();

  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _controller?.webViewController.goBack();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.webViewController.goBack();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.content);
    return Scaffold(
      backgroundColor: colors[index],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 34,
                color: Colors.white,
              )),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              enableFeedback: false,
              icon: const Icon(
                Icons.cloud_download_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () async {
                /*if (Platform.isAndroid) {
                    String path =
                        await ExtStorage.getExternalStoragePublicDirectory(
                            ExtStorage.DIRECTORY_DOWNLOADS);
                    //String fullPath = tempDir.path + "/boo2.pdf'";
                    String fullPath = "$path/1_Alamane.mp3";
                    print('full path ${fullPath}');

                    download2(dio, mp3, fullPath);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "le fichier sera telecharger dans le" + fullPath)));
                  } else {
                    final tempDir = await getTemporaryDirectory();
                    final downloadPath = tempDir.path + '/downloaded.mp3';
                    print('full path $downloadPath');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("le fichier sera telecharger dans le" +
                            downloadPath)));

                    await downloadFileTo(
                        dio: dio,
                        url: mp3,
                        savePath: downloadPath,
                        progressFunction: (received, total) {
                          if (total != -1) {
                            setState(() {
                              downloadingProgress =
                                  (received / total * 100).toStringAsFixed(0) +
                                      '%';
                            });
                          }
                        });
                    setState(() {
                      downloadingProgress = null;
                      downloadedFilePath = downloadPath;
                    });
                  }*/
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(.7)
                          ])),
                ),
              ),

            ],
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 180,

                  color: Colors.transparent,
                  child: WebViewPlus(
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller) {
                      controller.loadString('''${r'''
           <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <script src="https://w.soundcloud.com/player/api.js"></script>
          <script>
          document.getElementById('closePlayer').addEventListener('click', function() {
                $(this).parent().fadeOut(400, function() {
                    $(this).remove();
                });
            });
          </script>
        </head>
        <body >
        <div style="left: 0; width: 100%; height: 166px; position: relative;">
        <span id="closePlayer" class="glyphicon glyphicon-remove"></span>
          <iframe
         
            id="sound-cloud-iframe"
            src='''+widget.idMusic}    scrolling="no" 
            style="top: 0; left: 0; width: 100%; height: 100%; position: absolute; border: 0;" allowfullscreen"
          >
          </iframe>
         
        </body>
      </html>
            
      ''');
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 40),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                      child: HtmlWidget(
                        widget.content,

                        textStyle: TextStyle(fontSize: 16),

                        renderMode: RenderMode.column,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}
//271188615
//<div class="mainWidget "><iframe id="sc-widget" width="100%" height="100%" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https://soundcloud.com/alamincmt7418/birds-squawk&amp;color=%23f50&amp;auto_play=true&amp;buying=true&amp;sharing=true&amp;download=true&amp;show_artwork=true&amp;show_playcount=true&amp;show_user=true&amp;single_active=true&amp;show_comments=true&amp;visual=false&amp;show_teaser=false&amp;hide_related=true&amp;start_track=0"></iframe></div>