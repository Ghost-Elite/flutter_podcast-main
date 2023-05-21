import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/models/export_model.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;
class PlusDeMoocsPage extends StatefulWidget {
  List<Data> posts = [];
  PlusDeMoocsPage({Key? key,required this.posts}) : super(key: key);

  @override
  State<PlusDeMoocsPage> createState() => _PlusDeMoocsPageState();
}

class _PlusDeMoocsPageState extends State<PlusDeMoocsPage> {
  final _baseUrl = "seytutefes.com";
  bool _isFistLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<DataMocs> _datamocs = [];
  Mocs? mocs;
  List<Linkis> lien = [];
  String? isActive;

  //late ScrollController _controller;

  void _firstLoad() async {
    try {
      final url = Uri.https(_baseUrl, "/api/moocs");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        mocs = Mocs.fromJson(json.decode(res.body));
        setState(() {
          _datamocs = mocs!.data;
          lien = mocs!.linkis;
          _isFistLoadRunning = false;
        });
        log("Post 1 $_datamocs");
      }
    } catch (err) {
      log("message $err");
      if (kDebugMode) {
        print("Something went wrong");
      }
      _isFistLoadRunning = false;
    }
  }

  void loadPage(String url) async {
    try {
      final uri = Uri.parse(url);
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        mocs = Mocs.fromJson(json.decode(res.body));
        setState(() {
          _datamocs = mocs!.data;
          lien = mocs!.linkis;
          _isFistLoadRunning = true;
        });
        log("Post $mocs");
      }
    } catch (err) {
      if (kDebugMode) {
        print("Something went wrong");
      }
      _isFistLoadRunning = false;
    }
  }

  /*navigation(List<Linkis> lien) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: lien
          .map((e) => Padding(
        padding: const EdgeInsets.all(18.0),
        child: InkWell(
          onTap: () {
            print(e.url);
            e.active ? loadPage(e.url!) : null;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 90,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, offset: Offset(2, 1))
                    ]),
                child: Center(child: HtmlWidget(e.label))),
          ),
        ),
      ))
          .toList(),
    );
  }*/
  navigation() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              //print(e.active);
              loadPage(mocs!.firstPageUrl!);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, offset: Offset(2, 1))
                    ]),
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
            onTap: () {
              loadPage(mocs!.prevPageUrl);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12, offset: Offset(2, 1))
                      ]),
                  child: const Icon(Icons.keyboard_double_arrow_left_sharp)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
            onTap: () {
              loadPage(mocs!.nextPageUrl);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12, offset: Offset(2, 1))
                      ]),
                  child: const Icon(Icons.keyboard_double_arrow_right_sharp)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              loadPage(mocs!.lastPageUrl);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, offset: Offset(2, 1))
                    ]),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ),
      ],
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstLoad();
    // _controller = ScrollController()..addListener(_loadMore);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Moocs",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _isFistLoadRunning
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _datamocs.length,
              // controller: _controller,
              itemBuilder: (context, index) {
                final news = _datamocs[index];
                log('ghost${news.image}');
                return InkWell(
                  onTap: (){
                    if (_datamocs[index].type ==null) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            //print(widget.dataUrlPublication['data'][position]['content']);
                            return ViewMocsPage(
                              images: _datamocs[index].image,
                              content: _datamocs[index].description,
                              urlPdf: _datamocs[index].file,
                              name: _datamocs[index].name,
                              dataUrlResouces: _datamocs,

                            );
                          }));

                    }  else if (_datamocs[index].type == "audio") {
                      //print('audio');
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            //print(dataMocs['data'][position]['content']);
                            return PlayerPage(
                              image: _datamocs[index].image,
                              idMusic: _datamocs[index].typeUrl,
                              title: _datamocs[index].name,
                              content: _datamocs[index].description,

                            );
                          }));
                    }else if(_datamocs[index].type == "soundcloud"){
                      //print('soundcloud');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return PlayerTypePage(
                          idMusic: widget.posts[index].podcast,
                          content: widget.posts[index].content,
                        );
                      }));
                    }else if(_datamocs[index].type == "youtube"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return VideoplayerPage(
                          videoId: _datamocs[index].typeUrl,
                          content: _datamocs[index].description,
                          filleExite: _datamocs[index].file,
                        );
                      }));
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: CachedNetworkImage(
                              imageUrl:
                              news == null ? '' : news.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    "assets/images/logo.png",
                                    width:
                                    MediaQuery.of(context).size.width,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/logo.png",
                                    width:
                                    MediaQuery.of(context).size.width,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                              width:
                              MediaQuery.of(context).size.width,
                              height: 200,
                            ),
                          ),
                          Container(
                            height: 100,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    child: HtmlWidget(
                                      news.name,
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          overflow:
                                          TextOverflow.visible,
                                          fontWeight:
                                          FontWeight.w700),
                                      buildAsync: true,
                                      renderMode: RenderMode.column,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoadMoreRunning == true)
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),

          //(news != null && news!.total > news!.currentPage*news!.perPage)?
          //navigation(news!.links), //:const SizedBox.shrink(),
          /*(mocs != null &&
              mocs!.total > mocs!.currentPage * mocs!.perPage)
              ? navigation(mocs!.linkis)
              : const SizedBox.shrink(),*/
          (mocs != null &&
              mocs!.total >  mocs!.perPage)
              ? navigation()
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
