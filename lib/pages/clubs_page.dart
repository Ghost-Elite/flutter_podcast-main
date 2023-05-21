import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
import 'package:logger/logger.dart';
import 'package:flutter_podcast/models/export_model.dart';
class ClubsPage extends StatefulWidget {
  final AssetsAudioPlayer player;
  Club? club;
  List<DataClub> clubdata = [];
  bool isLoading;
  About? about;
  ClubsPage({Key? key,required this.player,this.club,required this.clubdata,required this.isLoading,this.about}) : super(key: key);

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  //TextEditingController searchController = TextEditingController();
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

  List titre=[
    'Nouveaux podcasts',
    'Actualités',
    'Nouveaux podcasts',
    'Actualités',
    'Nouveaux podcasts',
    'Actualités',
    'Actualités',
    'Music',
    'Radios',
    'Track',
    'Actualités',
    'podcasts'

  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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
    print(widget.clubdata[0].image);
    return Scaffold(
      body: widget.clubdata !=null
          ? NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            /*SliverToBoxAdapter(
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
      )
          : Center(child: CircularProgressIndicator(),),
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
                    about: widget.about,
                    //type: widget.dataUrlClub['data'][index]['description'],
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
