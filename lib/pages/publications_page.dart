import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:flutter_podcast/utils/colors.dart';
import 'package:http/http.dart' as http;

import '../utils/utils_export.dart';
class PublicationsPage extends StatefulWidget {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  bool? isPlaying = true;
  var dataUrlPublication,dataUrlClub;
  PublicationsPage({Key? key,required this.player,this.isPlaying,this.dataUrlPublication,this.dataUrlClub}) : super(key: key);

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  TextEditingController searchController = TextEditingController();
  List colors=[
    Color(0xFF303D00),
    Color(0xFF2C92F0),
    Color(0xFFED3D05),
    Color(0xFFFA7B06),
    /*Color(0xFF16A925),
    Color(0xFF3AAD7D),
    Color(0xFF301D58),
    Color(0xFFDF17CB),
    Color(0xFF6D3986),
    Color(0xFF252525),
    Color(0xFFA4C639),
    Color(0xFF005062),*/
  ];
  List titre=[
    'Nouveaux podcasts',
    'Actualités',
    'Nouveaux podcasts',
    'Actualités',
    /*'Nouveaux podcasts',
    'Actualités',
    'Actualités',
    'Music',
    'Radios',
    'Track',
    'Actualités',
    'podcasts'*/

  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [

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
                title: 'Publications',
                color: titreColor,
              ),
            ),
            SliverToBoxAdapter(
              child: widget.dataUrlPublication !=null|| widget.dataUrlPublication!=0
                  ?cardPodcast()
                  :Center(child: CircularProgressIndicator()),
            ),
            SliverToBoxAdapter(
              child: TitrePage(
                title: 'Mes podcasts',
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
            ),
            SliverToBoxAdapter(
              child: TitrePage(
                title: 'Clubs',
                color: titreColor,
              ),
            ),


          ];
        },
        body: Column(
          children: [

            Expanded(child: gridviewCategories())

          ],
        ),
      ),
    );



  }
  Widget cardPodcast(){
    return Container(
      height: 280,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.dataUrlPublication ==null || widget.dataUrlPublication ==0 ?0: widget.dataUrlPublication['data'].length,
          itemBuilder: (context,position){
        return CardAlaunePodcasts(
          onTap: (){
            if (widget.dataUrlPublication['data'][position]['podcast'] ==null) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    //print(widget.dataUrlPublication['data'][position]['content']);
                    return DetailsPublicationPage(
                      pubUrl: widget.dataUrlPublication['data'][position]['content'],
                      imageUrl: widget.dataUrlPublication['data'][position]['image'],
                      title: widget.dataUrlPublication['data'][position]['title'],
                      date: widget.dataUrlPublication['data'][position]['created_at'],
                    );
                  }));
            }else if(widget.dataUrlPublication['data'][position]['type_url'] =='audio'){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    print(widget.dataUrlPublication['data'][position]['content']);
                    return PlayerPage(
                      image: widget.dataUrlPublication['data'][position]['image'],
                      idMusic: widget.dataUrlPublication['data'][position]['podcast'],
                      title: widget.dataUrlPublication['data'][position]['title'],
                      content: widget.dataUrlPublication['data'][position]['content'],

                    );
                  }));
            }else if(widget.dataUrlPublication['data'][position]['type_url'] =='soundcloud'){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return PlayerTypePage(
                  idMusic: widget.dataUrlPublication['data'][position]['podcast'],
                );
              }));
            }

          },
          title: widget.dataUrlPublication['data'][position]['title'],
          date: widget.dataUrlPublication['data'][position]['created_at'],
          imageUrl:  widget.dataUrlPublication['data'][position]['image'],
          isActive: widget.dataUrlPublication['data'][position]['podcast'],
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
          itemCount: widget.dataUrlClub ==null ||widget.dataUrlClub==0?0: widget.dataUrlClub['data'].length,
          itemBuilder: (BuildContext ctx, index) {
         // print( widget.dataUrlClub['data'].length);
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
