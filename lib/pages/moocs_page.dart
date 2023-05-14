import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:flutter_podcast/utils/colors.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
class MoocsPage extends StatefulWidget {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  bool? isPlaying = true;
  var dataUrlPublication,dataUrlClub,dataMocs;
  MoocsPage({Key? key,required this.player,this.isPlaying,this.dataUrlClub,this.dataUrlPublication,this.dataMocs}) : super(key: key);

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
  var dataMocs;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMocs();
  }
  @override
  Widget build(BuildContext context) {
    //print(widget.dataMocs['data'][0]['image']);
    return Scaffold(
      body: dataMocs !=null? NestedScrollView(
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
                      return ListeSearchCategories();
                    })),
              ),
            ),
            SliverToBoxAdapter(
              child: TitrePage(
                title: 'Mocs',
                color: titreColor,
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
                title: 'Albums',
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
          itemCount: dataMocs ==null || dataMocs ==0 ?0: dataMocs['data'].length,
          itemBuilder: (context,position){
            return InkWell(
              onTap: (){
                if (dataMocs['data'][position]['type'] ==null) {
                  print('text');
                  
                }  else if (dataMocs['data'][position]['type'] == "audio") {
                  print('audio');
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        print(dataMocs['data'][position]['content']);
                        return PlayerPage(
                          image: dataMocs['data'][position]['image'],
                          idMusic: dataMocs['data'][position]['type_url'],
                          title: dataMocs['data'][position]['name'],
                          content: dataMocs['data'][position]['description'],

                        );
                      }));
                }else if(dataMocs['data'][position]['type'] == "soundcloud"){
                  print('soundcloud');
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return PlayerTypePage(
                      idMusic: widget.dataUrlPublication['data'][position]['podcast'],
                    );
                  }));
                }else if(dataMocs['data'][position]['type'] == "youtube"){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return VideoplayerPage(
                      videoId: dataMocs['data'][position]['type_url'],
                      content: dataMocs['data'][position]['description'],
                      filleExite: dataMocs['data'][position]['file'],
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
                          imageUrl: dataMocs==null|| dataMocs==0?0: dataMocs['data'][position]['image'] ??"",
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
                          dataMocs['data'][position]['name'],
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
          itemCount: widget.dataUrlClub['data'] ==null ||widget.dataUrlClub['data']==0?0: widget.dataUrlClub['data'].length,
          itemBuilder: (BuildContext ctx, index) {
            //print( widget.dataUrlClub['data'].length);
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return DetailsPublicationClubPage(
                    titrePublic: widget.dataUrlClub['data'][index]['name'],
                    pubUrl: widget.dataUrlClub['data'][index]['publication_url'],
                    imageUrl: widget.dataUrlClub['data'][index]['image'].toString().trim(),
                    content: widget.dataUrlClub['data'][index]['description'],
                  );
                }));
              },
              child: CategoryCard(
                imageUrl: widget.dataUrlClub['data'][index]['image'].toString().trim(),
                //color: Colors.white,
                title: widget.dataUrlClub['data'][index]['name'],
              ),
            );
          })

      ,
    );
  }
}
