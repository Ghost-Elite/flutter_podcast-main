import 'dart:convert';
import 'dart:math' as math;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'export_page.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
class HomePage extends StatefulWidget {
  static int idpage = 0;
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin<HomePage>{
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

  var dataUrlClub;
  var dataUrlPublication;
  var dataMocs;
  var dataUrlAbout;
  var dataUrlResouces;

  Future<void> getClubs() async {
    try {
      String endpoint="clubs";
      var url = "${baseUrl+endpoint}";
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
      var url = "${baseUrl+endpoint}";
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
      var url = "${baseUrl+endpoint}";
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
    getPublication();
    getClubs();
    getPApropos();
    getMocs();

    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });
  }
  // define a playlist for player
  void openPlayer() async {
    await player.open(
      Audio.network(
          dataUrlPublication['data'][0]['podcast'],
          metas: Metas(
            title: dataUrlPublication['data'][0]['podcast'],
            artist: 'NF',
            //image:  MetasImage.network(widget.image),
          )

      ),
      showNotification: true,
      autoStart: true,
    );
    //logger.w('bara player ',audios);
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
        /*if (index == 0) {
          title = "Accueil";
        } else*/
        /*if (index == 0) {
          title = "Télévision";
        } else if (index == 1) {
          title = "Actualités";
        } else if (index == 2) {
          title = "YouTube";
        } else if (index == 3) {
          title = "Radio";
        }*/
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
          dataUrlPublication: dataUrlPublication,
          dataUrlClub:dataUrlClub,

        ),
        ClubsPage(
          player: player,
          dataUrlClub: dataUrlClub,
        ),
        MoocsPage(
          player: player,
          dataUrlPublication: dataUrlPublication,
          dataUrlClub:dataUrlClub,
          dataMocs: dataMocs,
        ),
        ResourcePage(),
        AproposPage(
          /*nameAbout: dataMocs,
          image: dataUrlAbout['data']['image'],
          about_lmt: dataUrlAbout['data']['about_lmt'],
          tel: dataUrlAbout['data']['phone'],
          email: dataUrlAbout['data']['email'],*/
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      key: _scaffoldKey,
      child: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(title,style: TextStyle(color: Colors.black),),
          /*actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(

                width: 25,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/alarme.png')
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                width: 25,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/parametre.png')
                  )
                ),
              ),
            ),

          ],*/
        ),
        body: Stack(
          alignment: Alignment.bottomLeft,
            children: [
              dataMocs !=null || dataMocs !=null? buildPageView():Center(child: CircularProgressIndicator(),),
              /*player.getCurrentAudioImage == null
                  ? const SizedBox.shrink()
                  : FutureBuilder<PaletteGenerator>(
                future: getImageColors(player),
                builder: (context, snapshot) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    height: 70,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: const Alignment(0, 5),
                            colors: [
                              snapshot.data?.lightMutedColor?.color ??
                                  Colors.grey,
                              snapshot.data?.mutedColor?.color ?? Colors.grey,
                            ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: AnimatedBuilder(
                        // rotate the song cover image
                        animation: _animationController,
                        builder: (_, child) {
                          // if song is not playing
                          if (!isPlaying) {
                            _animationController.stop();
                          } else {
                            _animationController.forward();
                            _animationController.repeat();
                          }
                          return Transform.rotate(
                              angle: _animationController.value * 2 * math.pi,
                              child: child);
                        },
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage(
                                player.getCurrentAudioImage?.path ?? '')),
                      ),
                      onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => PlayerPage(
                                      player: player,
                                    ))),
                      title: Text(player.getCurrentAudioTitle),
                      subtitle: Text(player.getCurrentAudioArtist),
                      trailing: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await player.playOrPause();
                        },
                        icon: isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                      ),
                    ),
                  );
                },
              ),*/
          ]
        ),
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
        onTap: (i) => setState((){
          _page= i;
          pageController.animateToPage(i,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.podcasts,size: 30),
            title: const Text("Publications",style: TextStyle(fontSize: 14),),
            selectedColor: Colors.green,
            //unselectedColor: Colors.red
          ),

          SalomonBottomBarItem(
            icon: const Icon(Icons.grid_view,size: 30),
            title: const Text("Clubs",style: TextStyle(fontSize: 14)),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.music_note,size: 30,),
            title: const Text("Moocs",style: TextStyle(fontSize: 14)),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.info,size: 30),
            title: const Text("Resources",style: TextStyle(fontSize: 14)),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.info,size: 30),
            title: const Text("A propos",style: TextStyle(fontSize: 14)),
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
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }


}
