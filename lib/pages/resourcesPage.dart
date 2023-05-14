import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:remixicon/remixicon.dart';

class ResourcePage extends StatefulWidget {
  ResourcePage({Key? key}) : super(key: key);

  @override
  State<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  TextEditingController searchController = TextEditingController();
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
  var dataUrlResouces;

  Future<void> getResources() async {
    try {
      String endpoint = "resources";
      var url = "${baseUrl + endpoint}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataUrlResouces = data;
        });
        // print(dataMocs['data'][0]['image']);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResources();
    if (mounted) {
      setState(() {
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
    //print(urlAudio[0]['feed_url']);
    return Scaffold(
      body: dataUrlResouces != null
          ? CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SearchBar(
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) {
                              return ListeSearchCategories();
                            })),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TitrePage(
                    title: 'Les resources',
                    color: titreColor,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int position) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            print(dataUrlResouces['data'][position]['image']);
                            return ViewResourcePage(
                              images: dataUrlResouces['data'][position]['image'],
                              content: dataUrlResouces['data'][position]['description'],
                              urlPdf: dataUrlResouces['data'][position]['file'],
                            );
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 104,
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  //blurRadius: 2,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0.1),
                            ]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 80,
                                    child: CachedNetworkImage(
                                      imageUrl: dataUrlResouces == null ||
                                              dataUrlResouces == 0
                                          ? 0
                                          : dataUrlResouces['data'][position]
                                                  ['image'] ??
                                              "",
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
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: Text(
                                            dataUrlResouces['data'][position]
                                                ['name'],
                                            style: TextStyle(fontSize: 10),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${dataUrlResouces['data'][position]['author'] == null ? '' : 'Auteur'}  :${dataUrlResouces['data'][position]['author'] != null ? dataUrlResouces['data'][position]['author'] : ''}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600]),
                                              maxLines: 1,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: dataUrlResouces == null || dataUrlResouces == 0
                        ? 0
                        : dataUrlResouces['data'].length,
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ViewResourcePage extends StatefulWidget {
  var images, content, urlPdf, filleExite,dataUrlResouces;

  ViewResourcePage(
      {Key? key, this.content, this.images, this.urlPdf, this.filleExite,this.dataUrlResouces})
      : super(key: key);

  @override
  State<ViewResourcePage> createState() => _ViewResourcePageState();
}

class _ViewResourcePageState extends State<ViewResourcePage> {
  int progress = 0;
  final ReceivePort _port = ReceivePort();
  final mp3 = "https://seytutefes.com/uploads/resource_file__1683722151.pdf";
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pdfString= widget.urlPdf.substring(widget.urlPdf.length-3);
    });
  }

  @override
  Widget build(BuildContext context) {

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
          "",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: widget.dataUrlResouces==null? SingleChildScrollView(
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
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
