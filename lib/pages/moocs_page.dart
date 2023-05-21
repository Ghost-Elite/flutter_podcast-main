import 'dart:convert';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:flutter_podcast/utils/colors.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remixicon/remixicon.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_podcast/models/export_model.dart';
class MoocsPage extends StatefulWidget {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  bool? isPlaying = true;
  List<DataMocs> datamocs = [];
  List<DataClub> clubdata = [];
  List<Data> posts = [];
  Mocs? mocs;

  MoocsPage({Key? key,required this.player,this.isPlaying,this.mocs,required this.datamocs,required this.clubdata,required this.posts}) : super(key: key);

  @override
  State<MoocsPage> createState() => _MoocsPageState();
}

class _MoocsPageState extends State<MoocsPage> {
  TextEditingController searchController = TextEditingController();
  List colors=[
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
  /*var dataMocs;
  Future<void> getMocs() async {
    try {
      String endpoint="moocs";
      var url = "${baseUrl+endpoint}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataMocs=data;
        });
        // print(dataMocs['data'][0]['image']);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getMocs();
    if (mounted) {
      setState(() {});
    }
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    //print(widget.dataMocs['data'][0]['image']);
    return Scaffold(
      body: widget.datamocs !=null? NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            /*
            SliverToBoxAdapter(
              child: Form(
                child: CustomTextField(
                  controller: searchController,
                  data: Icons.search,
                  suffixIcon: Icons.filter_list,
                  isObsecre: false,
                  isEmail: true,
                  hintText: 'Recherche',
                ),
              ),
            ),*/
            SliverToBoxAdapter(
              child: SearchBar(
                onTap: ()=>Navigator.push(context, CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context){
                      return RecherchePage();
                    })),
              ),
            ),
            SliverToBoxAdapter(
              child: TitrePage(
                title: 'Moocs',
                color: titreColor,
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return PlusDeMoocsPage(
                      posts: widget.posts,
                    );
                  }));
                },
              ),
            ),
            SliverToBoxAdapter(
              child: cardPodcast(),
            ),
            /*SliverToBoxAdapter(
              child: TitrePage(
                title: 'Mes musique',
                color: titreColor,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        await widget.player.playlistPlayAtIndex(index);
                        setState(() {
                          widget.player.getCurrentAudioImage;
                          widget.player.getCurrentAudioTitle;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Container(
                          width: 120,
                          height: 130,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                              Image.asset(songs[index].metas.image!.path)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),*/
            SliverToBoxAdapter(
              child: TitrePage(
                title: 'Clubs',
                color: titreColor,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10,),
            )

          ];
        },
        body: Column(
          children: [

            Expanded(child: gridviewCategories())

          ],
        ),
      ) :Center(child: CircularProgressIndicator(),),
    );
  }
  Widget cardPodcast(){
    return Container(
      height: 240,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.datamocs ==null || widget.datamocs ==0 ?0: widget.datamocs.length,
          itemBuilder: (context,position){
            return InkWell(
              onTap: (){
                if (widget.datamocs[position].type ==null) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        //print(widget.dataUrlPublication['data'][position]['content']);
                        return ViewMocsPage(
                          images: widget.datamocs[position].image,
                          content: widget.datamocs[position].description,
                          urlPdf: widget.datamocs[position].file,
                          name: widget.datamocs[position].name,
                          dataUrlResouces: widget.datamocs,

                        );
                      }));
                  
                }  else if (widget.datamocs[position].type == "audio") {
                  //print('audio');
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        //print(dataMocs['data'][position]['content']);
                        return PlayerPage(
                          image: widget.datamocs[position].image,
                          idMusic: widget.datamocs[position].typeUrl,
                          title: widget.datamocs[position].name,
                          content: widget.datamocs[position].description,

                        );
                      }));
                }else if(widget.datamocs[position].type == "soundcloud"){
                  print('soundcloud');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return PlayerTypePage(
                      idMusic: widget.posts[position].podcast,
                      content: widget.posts[position].content,
                    );
                  }));
                }else if(widget.datamocs[position].type == "youtube"){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return VideoplayerPage(
                      videoId: widget.datamocs[position].typeUrl,
                      content: widget.datamocs[position].description,
                      filleExite: widget.datamocs[position].file,
                    );
                  }));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.60,
                  height: 200,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        child: CachedNetworkImage(
                          imageUrl:  widget.datamocs[position].image ??"",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset(
                                "assets/images/logo.png",
                                width: MediaQuery.of(context).size.width,height: 150,fit: BoxFit.cover,
                              ),
                          errorWidget: (context, url, error) =>
                              Image.asset(
                                "assets/images/logo.png",width: MediaQuery.of(context).size.width,height: 150,fit: BoxFit.cover,
                              ),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          widget.datamocs[position].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget gridviewCategories(){
    return SizedBox(
      height: 300,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20
          ),
          itemCount: widget.clubdata ==null ||widget.clubdata==0?0: widget.clubdata.length,
          itemBuilder: (BuildContext ctx, index) {
            //print( widget.dataUrlClub['data'].length);
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return DetailsPublicationClubPage(
                    titrePublic: widget.clubdata[index].name,
                    pubUrl: widget.clubdata[index].publicationUrl,
                    imageUrl: widget.clubdata[index].image.toString().trim(),
                    content: widget.clubdata[index].description,
                  );
                }));
              },
              child: CategoryCard(
                imageUrl: widget.clubdata[index].image.toString().trim(),
                //color: Colors.white,
                title: widget.clubdata[index].name,
              ),
            );
          })

      ,
    );
  }
}
class ViewMocsPage extends StatefulWidget {
  var images, content, urlPdf, filleExite,dataUrlResouces,name;

  ViewMocsPage(
      {Key? key, this.content, this.images, this.urlPdf, this.filleExite,this.dataUrlResouces,this.name})
      : super(key: key);

  @override
  State<ViewMocsPage> createState() => _ViewMocsPageState();
}

class _ViewMocsPageState extends State<ViewMocsPage> {
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
  void TestString(){
    if (widget.urlPdf == null) {

    } else{
      setState(() {
        pdfString= widget.urlPdf.substring(widget.urlPdf.length-3);
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    //print(widget);

    if (pdfString =="pdf") {
      print("pdf");
    }  else{
      print("no");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            child: Text(
                              "DOCUMENT À TÉLÉCHARGER:",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          widget.urlPdf == null
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
                                    "$path/${widget.urlPdf.replaceAll("https://seytutefes.com/uploads/", "")}";
                                print('full path ${fullPath}');

                                download2(dio, widget.urlPdf, fullPath);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(
                                        "le fichier sera telecharger dans le" +
                                            fullPath)));
                              } else {
                                final tempDir =
                                await getTemporaryDirectory();
                                final downloadPath = '${tempDir.path}/${widget.urlPdf.replaceAll("https://seytutefes.com/uploads/", "")}';
                                print('full path $downloadPath');
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "le fichier sera telecharger dans le" +
                                          downloadPath),

                                ));

                                await downloadFileTo(
                                    dio: dio,
                                    url: widget.urlPdf,
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
              const SizedBox(
                height: 40,
              ),
              Container(
                width: double.infinity,
                height: 260,
                child: CachedNetworkImage(
                  imageUrl: widget.images.toString().isEmpty?'': widget.images.toString(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset(
                        "assets/images/logo.png",
                        width:
                        MediaQuery.of(context).size.width *
                            0.3,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        "assets/images/logo.png",
                        width:
                        MediaQuery.of(context).size.width *
                            0.3,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                  width: MediaQuery.of(context).size.width *
                      0.3,
                  height: 80,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              HtmlWidget(
                widget.content.toString().isEmpty?'':widget.content??"",
                textStyle: const TextStyle(fontSize: 15),
                renderMode: RenderMode.column,
              ),
            ],
          ),
        ),
      ),
    );
  }
}