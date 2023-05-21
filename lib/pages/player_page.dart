import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:path_provider/path_provider.dart';

import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
import 'package:permission_handler/permission_handler.dart';


class PlayerPage extends StatefulWidget {
  PlayerPage({this.idMusic, this.title, this.image, this.content, Key? key})
      : super(key: key);

  var idMusic, title, image, content;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = true;
  int progress = 0;
  final ReceivePort _port = ReceivePort();
  String mp3='';
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
  Random random =  Random();
  int index = 0;
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
   // Color(0xFF252525),
    Color(0xFFA4C639),
    Color(0xFF005062),
  ];

  //List<Audio> songs = [];
  void changeIndex() {
    setState(() => index = random.nextInt(colors.length));
  }

  @override
  void initState() {
    //print(player);
    //getAudio();
    openPlayer();
    changeIndex();
    //_init();
    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });

    player.onReadyToPlay.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration?.duration ?? Duration.zero;
        });
      }
    });

    player.currentPosition.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
    checkNecessaryPermissions(context);
    setState(() {
      mp3=widget.idMusic.replaceAll("https://dev.acangroup.org/", "");
    });

    //_downloadListener();
    super.initState();
  }

  void openPlayer() async {
    await player.open(
      Audio.network(widget.idMusic,
          metas: Metas(
            title: widget.title,
            artist: '',
            //image:  MetasImage.network(widget.image),
          )),
      showNotification: true,
      autoStart: true,
    );
    //logger.w('bara player ',audios);
  }

  /*void openPlayer(audios) async {
    await player.open(Playlist(audios: audios),
        autoStart: false, showNotification: true, loopMode: LoopMode.playlist);
  }*/
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colors[index],
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
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
                  if (Platform.isAndroid) {
                    String path =
                        await ExternalPath.getExternalStoragePublicDirectory(
                            ExternalPath.DIRECTORY_DOWNLOADS);
                    //String fullPath = tempDir.path + "/boo2.pdf'";
                    String fullPath = "$path/${widget.idMusic.replaceAll("https://dev.acangroup.org/", "")}";
                    print('full path ${fullPath}');

                    download2(dio, widget.idMusic, fullPath);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "le fichier sera telecharger dans le" + fullPath)));
                  } else {
                    final tempDir = await getDownloadsDirectory();
                    final downloadPath = tempDir!.path + '/${widget.idMusic.replaceAll("https://dev.acangroup.org/", "")}';
                    print('full path $downloadPath');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("le fichier sera telecharger dans le" +
                            downloadPath)));

                    await downloadFileTo(
                        dio: dio,
                        url: widget.idMusic,
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
                  }
                },
              ),
            )
          ],
        ),
        //extendBodyBehindAppBar: true,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //setting the music cover
                      const SizedBox(
                        height: 15,
                      ),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(9.0),
                        child: Image.network(
                          widget.image,
                          width: MediaQuery.of(context).size.width * 0.90,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        player.getCurrentAudioTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            letterSpacing: 6),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        player.getCurrentAudioArtist,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            letterSpacing: 6),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),

                      IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*FutureBuilder<PaletteGenerator>(
                        future: getImageColors(player),
                        builder: (context, snapshot) {
                          return Container(
                            width: MediaQuery.of(context).size.width*0.99,
                            child: Slider(
                                activeColor: snapshot.data?.mutedColor?.color,
                                thumbColor: Colors.green,
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                value: position.inSeconds.toDouble(),
                                onChanged: (value) async {
                                  await player.seek(Duration(seconds: value.toInt()));
                                }),
                          );
                        },
                      ),*/
                            Container(
                              width: MediaQuery.of(context).size.width * 0.99,
                              child: Slider(
                                  activeColor: Colors.grey,
                                  thumbColor: Colors.green,
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  value: position.inSeconds.toDouble(),
                                  onChanged: (value) async {
                                    await player.seek(
                                        Duration(seconds: value.toInt()));
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 23.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    durationFormat(position),
                                    style:
                                    const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    durationFormat(duration - position),
                                    style:
                                    const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 28, top: 15),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await player.previous();
                                      },
                                      icon: const Icon(
                                        Icons.skip_previous_rounded,
                                        size: 40,
                                        color: Colors.grey,
                                      )),
                                  InkWell(
                                    onTap: () async {
                                      await player
                                          .seekBy(Duration(seconds: -10));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: 25,
                                        height: 34,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/replay_moin.png'))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await player.playOrPause();
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: isPlaying
                                        ? Icon(
                                      Icons.pause_circle,
                                      size: 70,
                                      color: Colors.green[200],
                                    )
                                        : Icon(
                                      Icons.play_circle,
                                      size: 70,
                                      color: Colors.green[200],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await player
                                          .seekBy(Duration(seconds: 10));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 15),
                                      child: Container(
                                        width: 25,
                                        height: 34,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/replay_plus.png'))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await player.next();
                                      },
                                      icon: const Icon(
                                        Icons.skip_next_rounded,
                                        size: 40,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 40),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white
                                ),
                                child: HtmlWidget(
                                  widget.content,
                                  textStyle: TextStyle(fontSize: 18),
                                  renderMode: RenderMode.column,
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 50,),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            )
          ],
        )
      );
  }
}
/*
Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder<PaletteGenerator>(
            future: getImageColors(widget.player),
            builder: (context, snapshot) {
              return Container(
                color: snapshot.data?.mutedColor?.color,
              );
            },
          ),
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
          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              children: [
                Text(
                  widget.player.getCurrentAudioTitle,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.player.getCurrentAudioArtist,
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),

              ],
            ),
          ),
          */ /*Center(
              child: SleekCircularSlider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            initialValue: position.inSeconds.toDouble(),
            onChange: (value) async {
              await widget.player.seek(Duration(seconds: value.toInt()));
            },
            innerWidget: (percentage) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage(
                      widget.player.getCurrentAudioImage?.path ?? ''),
                ),
              );
            },
            appearance: CircularSliderAppearance(
                size: 330,
                angleRange: 300,
                startAngle: 300,
                customColors: CustomSliderColors(
                    progressBarColor: kPrimaryColor,
                    dotColor: kPrimaryColor,
                    trackColor: Colors.grey.withOpacity(.4)),
                customWidths: CustomSliderWidths(
                    trackWidth: 6, handlerSize: 10, progressBarWidth: 6)),
          )),*/ /*
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.95,
              height: 370,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(widget.player.getCurrentAudioTitle),
                            Text('data')
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            //download(songs[0].path);
                           // _download(songs[0].path);
                          },
                          child: Container(
                            width: 32,
                            height: 22,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/download.png'
                                )
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<PaletteGenerator>(
                          future: getImageColors(widget.player),
                          builder: (context, snapshot) {
                            return Container(
                              width: MediaQuery.of(context).size.width*0.90,
                              child: Slider(
                                  activeColor: snapshot.data?.mutedColor?.color,
                                  thumbColor: Colors.green,
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  value: position.inSeconds.toDouble(),
                                  onChanged: (value) async {
                                    await widget.player.seek(Duration(seconds: value.toInt()));
                                  }),
                            );
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                durationFormat(position),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                durationFormat(duration - position),
                                style: const TextStyle(color: kPrimaryColor),
                              )
                            ],
                          ),
                        )


                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await widget.player.previous();
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 50,
                              color: Colors.grey,
                            )),
                        InkWell(
                          onTap: () async {
                            await widget.player.seekBy(Duration(seconds: -10));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              width: 25,
                              height: 34,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/replay_moin.png')
                                )
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await widget.player.playOrPause();
                          },
                          padding: EdgeInsets.zero,
                          icon: isPlaying
                              ?  Icon(
                            Icons.pause_circle,
                            size: 70,
                            color: Colors.green[200],
                          )
                              :  Icon(
                            Icons.play_circle,
                            size: 70,
                            color: Colors.green[200],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await widget.player.seekBy(Duration(seconds: 10));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,left: 15),
                            child: Container(

                              width: 25,
                              height: 34,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/replay_plus.png')
                                  )
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              await widget.player.next();
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 50,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.3,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () async {
                        await widget.player.previous();
                      },
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 50,
                        color: Colors.white,
                      )),
                  IconButton(
                    onPressed: () async {
                      await widget.player.playOrPause();
                    },
                    padding: EdgeInsets.zero,
                    icon: isPlaying
                        ? const Icon(
                            Icons.pause_circle,
                            size: 70,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.play_circle,
                            size: 70,
                            color: Colors.white,
                          ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await widget.player.next();
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 50,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    )
*/
