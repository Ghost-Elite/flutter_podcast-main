import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/models/publication.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:flutter_podcast/utils/utils_export.dart';

class PlusDePublicationPage extends StatefulWidget {
  const PlusDePublicationPage({Key? key}) : super(key: key);

  @override
  State<PlusDePublicationPage> createState() => _PlusDePublicationPageState();
}

class _PlusDePublicationPageState extends State<PlusDePublicationPage> {
  final _baseUrl = "seytutefes.com";
  int _page = 0;
  final int _limite = 10;
  bool _isFistLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List<Data> _posts = [];
  News? news;
  bool _hasNextpage = true;
  List<Link> lien = [];
  String? isActive;

  //late ScrollController _controller;

  void _firstLoad() async {
    try {
      final url = Uri.https(baseUrls, "/api/publications");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        news = News.fromJson(json.decode(res.body));
        setState(() {
          _posts = news!.data;
          lien = news!.links;
          _isFistLoadRunning = false;
        });
        log("Post 1 $_posts");
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
        news = News.fromJson(json.decode(res.body));
        setState(() {
          _posts = news!.data;
          lien = news!.links;
          _isFistLoadRunning = false;
        });
        log("Post $_posts");
      }
    } catch (err) {
      if (kDebugMode) {
        print("Something went wrong");
      }
      _isFistLoadRunning = false;
    }
  }

  navigation() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              //print(e.active);
               loadPage(news!.firstPageUrl!);
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
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () {
              loadPage(news!.prevPageUrl);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  width: 67,
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
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () {
              loadPage(news!.nextPageUrl);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  width: 67,
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
               loadPage(news!.lastPageUrl);
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
          "Publication",
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
                    itemCount: _posts.length,
                    // controller: _controller,
                    itemBuilder: (context, index) {
                      final news = _posts[index];
                      log('ghost${news.image}');
                      return InkWell(
                        onTap: () {
                          if (news.podcast == null) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              //print(widget.dataUrlPublication['data'][position]['content']);
                              return DetailsPublicationPage(
                                pubUrl: news.content,
                                imageUrl: news.image,
                                title: news.title,
                                date: news.createdAt,
                              );
                            }));
                          } else if (news.typeUrl == 'audio') {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              //print(widget.dataUrlPublication['data'][position]['content']);
                              return PlayerPage(
                                image: news.image,
                                idMusic: news.podcast,
                                title: news.title,
                                content: news.content,
                              );
                            }));
                          } else if (news.typeUrl == 'soundcloud') {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PlayerTypePage(
                                idMusic: news.podcast,
                                content: news.content,
                              );
                            }));
                          }
                        },
                        child: Stack(
                          children: [
                            Card(
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
                                                news.title,
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
                            news.podcast != null
                                ? Positioned(
                                  left: 375,
                                  bottom: 10/1,
                                  child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.green,
                                      ),
                                    ),
                                )
                                : Container()
                          ],
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
                (news != null &&
                        news!.total >  news!.perPage)
                    ? navigation()
                    : const SizedBox.shrink(),
              ],
            ),
    );
  }
}
