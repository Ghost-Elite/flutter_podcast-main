import 'dart:convert';
import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:remixicon/remixicon.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'export_page.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
import 'package:flutter_podcast/models/export_model.dart';

class HomePage extends StatefulWidget {
  static int idpage = 0;

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomePage> {
  final player = AssetsAudioPlayer();
  bool isPlaying = true;
  int _page = 0;
  String title = "Podcasts";
  TextEditingController searchController = TextEditingController();
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 3));

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  About? about;
  bool _isFistLoadRunning = false;
  bool _LoadRunning = false;
  final _baseUrl = "seytutefes.com";
  List<Data> _posts = [];
  List<DataClub> _clubdata = [];
  List<DataMocs> _datamocs = [];
  Mocs? mocs;
  News? news;
  Club? club;
  List<Link> lien = [];
  late bool _isLoading;

  /*Future<void> getClubs() async {
    try {
      String endpoint="clubs";
      var url = "${baseUrls+endpoint}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataUrlClub=data;
        });
        //print(dataUrlClub['data'].length);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  Future<void> getPublication() async {
    try {
      String endpoint="publications";
      var url = "${baseUrls+endpoint}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataUrlPublication=data;
        });
        //print(dataUrl['data'][0]['id']);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  Future<void> getPApropos() async {
    try {
      String endpoint="about";
      var url = "${baseUrls+endpoint}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          dataUrlAbout=data;
        });
        //print(dataMocs['data']['name']);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  Future<void> getMocs() async {
    try {
      String endpoint="moocs";
      var url = "${baseUrls+endpoint}";
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
  void _aboutLoad() async {
    try {
      final url = Uri.https(baseUrls, "api/about");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        about = About.fromJson(json.decode(res.body));
        setState(() {
          _LoadRunning = false;
        });
        //log("Post 1 ${about!.data.name}");
      }
    } catch (err) {
      log("message $err");
      if (kDebugMode) {
        print("Something went wrong");
      }
      _LoadRunning = true;
    }
  }

  void _publicationLoad() async {
    try {
      final url = Uri.https(baseUrls, "api/publications");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        news = News.fromJson(json.decode(res.body));
        setState(() {
          _posts = news!.data;
          lien = news!.links;
          _isFistLoadRunning = false;
        });
        //log("Post 1 ${_posts}");
      }
    } catch (err) {
      log("message $err");
      if (kDebugMode) {
        print("Something went wrong");
      }
      _isFistLoadRunning = false;
    }
  }

  void _clubLoad() async {
    try {
      final url = Uri.https(baseUrls, "api/clubs");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        club = Club.fromJson(json.decode(res.body));
        setState(() {
          _clubdata = club!.data;
          //lien = news!.links;
          _isFistLoadRunning = false;
        });
        //log("Post 1 ${_clubdata[0].name}");
      }
    } catch (err) {
      log("message $err");
      if (kDebugMode) {
        print("Something went wrong");
      }
      _isFistLoadRunning = false;
    }
  }

  void _mocsLoad() async {
    try {
      final url = Uri.https(baseUrls, "api/moocs");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        mocs = Mocs.fromJson(json.decode(res.body));
        setState(() {
          _datamocs = mocs!.data;
          //lien = news!.links;
          _isFistLoadRunning = false;
        });
        //log("Post 1 ${_datamocs[1].name}");
      }
    } catch (err) {
      log("message $err");
      if (kDebugMode) {
        print("Something went wrong");
      }
      _isFistLoadRunning = false;
    }
  }

  /*Future<void> getResources() async {
    try {
      String endpoint="resources";
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
    //openPlayer();

    _isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    //getPApropos();
    //getMocs();
    _aboutLoad();
    _publicationLoad();
    _clubLoad();
    _mocsLoad();
  }

  void pageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
        HomePage.idpage = index;
        if (index == 0) {
          title = "Publications";
        }
        if (index == 1) {
          title = " Clubs";
        }
        if (index == 2) {
          title = "Moocs ";
        }
        if (index == 3) {
          title = " Resources";
        }
        if (index == 4) {
          title = " A propos";
        }
      },
      children: <Widget>[
        PublicationsPage(
          player: player,
          news: news,
          posts: _posts,
          isFistLoadRunning: _isFistLoadRunning,
          clubdata: _clubdata,
          club: club,
        ),
        ClubsPage(
          player: player,
          clubdata: _clubdata,
          club: club,
          isLoading: _isLoading,
          about: about,
        ),
        MoocsPage(
          player: player,
          mocs: mocs,
          datamocs: _datamocs,
          clubdata: _clubdata,
          posts: _posts,
        ),
        ResourcePage(),
        AproposPage(
          about: about,
          isFistLoadRunning: _isFistLoadRunning,
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //log("Post 1 ${about!.data.name}");
    return DefaultTabController(
      length: 4,
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(alignment: Alignment.bottomLeft, children: [
          _isLoading
              ? const Center(
                  child: SpinKitWanderingCubes(
                    color: Colors.green,
                    size: 50.0,
                  ),
                )
              : buildPageView(),
        ]),
        bottomNavigationBar: salomonBottomNavigation(),
      ),
    );
  }

  Widget salomonBottomNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SalomonBottomBar(
        currentIndex: _page,
        curve: Curves.ease,
        onTap: (i) => setState(() {
          _page = i;
          pageController.animateToPage(i,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }),
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_sharp, size: 30),
            title: const Text(
              "Publications",
              style: TextStyle(fontSize: 14),
            ),
            selectedColor: Colors.green,
            //unselectedColor: Colors.red
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.grid_view, size: 30),
            title: const Text("Clubs", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(
              Remix.book_fill,
              size: 30,
            ),
            title: const Text("Moocs", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Remix.database_fill, size: 30),
            title: const Text("Resources", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.info, size: 30),
            title: const Text("A propos", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.green,
          ),
        ],
      ),
    );
  }

  void gotoScreen(int index) {
    toggleDrawer();
    _page = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
