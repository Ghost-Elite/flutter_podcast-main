import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remixicon/remixicon.dart';

import '../utils/constants.dart';
class VideoplayerPage extends StatefulWidget {
  var videoId,content,filleExite;
  VideoplayerPage({Key? key,this.videoId,this.content,this.filleExite}) : super(key: key);

  @override
  State<VideoplayerPage> createState() => _VideoplayerPageState();
}

class _VideoplayerPageState extends State<VideoplayerPage> {
  YoutubePlayerController? _controller = YoutubePlayerController(initialVideoId: '');
  int progress = 0;

  var dio = Dio();
  String? downloadedFilePath;
  String? downloadingProgress;

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
  var pdfString ;

  bool _isPlayerReady = false;
  youtubePayer() {
    //videoID = widget.videoId;
    //title = widget.title;
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }
  void TestString(){
    if (widget.filleExite == null) {

    } else{
      setState(() {
        pdfString= widget.filleExite.substring(widget.filleExite.length-3);
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    youtubePayer();
    TestString();

  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
      });
    }
  }
  /*Future<void> saveFile(String fileName) async {
    var file = File('');

    // Platform.isIOS comes from dart:io
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/$fileName');
      print('${dir.path}/$fileName');
    }
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        const downloadsFolderPath = '/storage/emulated/0/Download/ltm';
        Directory dir = Directory(downloadsFolderPath);
        file = File('${dir.path}/$fileName');
        print('${dir.path}/$fileName');
      }
    }
  }*/
  @override
  Widget build(BuildContext context) {
    if (downloadingProgress ==100) {
      print(widget.filleExite.replaceAll("https://seytutefes.com/uploads/", ""));
    }
    print(widget.videoId);
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("",style: TextStyle(color: Colors.black),),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: Text("DOCUMENT À TÉLÉCHARGER:",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),)),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            widget.filleExite == null
                                ? Container(
                                height: 40,
                                color: Colors.blue,
                                alignment: Alignment.center,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "PAS DE DOCUMENT DISPONIBLE",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ))
                                : InkWell(
                              onTap: () async {
                                if (Platform.isAndroid) {
                                  String path = await ExternalPath
                                      .getExternalStoragePublicDirectory(
                                      ExternalPath.DIRECTORY_DOWNLOADS);
                                  //String fullPath = tempDir.path + "/boo2.pdf'";
                                  String fullPath =
                                      "$path/${widget.filleExite.replaceAll("https://seytutefes.com/uploads/", "")}";
                                  print('full path ${fullPath}');

                                  download2(dio, widget.filleExite, fullPath);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                          "le fichier sera telecharger dans le" +
                                              fullPath)));
                                } else {
                                  final tempDir =
                                  await getTemporaryDirectory();
                                  final downloadPath = '${tempDir.path}/${widget.filleExite.replaceAll("https://seytutefes.com/uploads/", "")}';
                                  print('full path $downloadPath');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "le fichier sera telecharger dans le" +
                                            downloadPath),

                                  ));

                                  await downloadFileTo(
                                      dio: dio,
                                      url: widget.filleExite,
                                      savePath: downloadPath,
                                      progressFunction: (received, total) {
                                        if (total != -1) {
                                          setState(() {
                                            downloadingProgress =
                                                (received / total * 100)
                                                    .toStringAsFixed(
                                                    0) +
                                                    '%';
                                          });
                                        }
                                      });
                                  setState(() {
                                    downloadingProgress = null;
                                    downloadedFilePath = downloadPath;
                                  });
                                }
                              },
                              child: Container(
                                  height: 40,
                                  color: Colors.blue,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:  [
                                      Icon(Icons.picture_as_pdf_sharp,color: Colors.white,),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("DOWNLOAD ${pdfString =="pdf"?'.PDF':'.DOCX '}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Icon(
                                        Remix.download_2_fill,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Container(
                  width: double.infinity,
                  height: 260,
                  color: Colors.black,
                  child: _controller != null ? player : Container(),
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
      ),
    )
    ;
  }
}

