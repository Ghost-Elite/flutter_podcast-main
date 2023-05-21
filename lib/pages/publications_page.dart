import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:flutter_podcast/utils/colors.dart';
import 'package:flutter_podcast/models/export_model.dart';
import '../utils/utils_export.dart';

class PublicationsPage extends StatefulWidget {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  bool? isPlaying = true;
  News? news;
  List<Data> posts = [];
  bool? isFistLoadRunning = false;
  Club? club;
  List<DataClub> clubdata = [];
  PublicationsPage({Key? key,required this.player,this.isPlaying,this.news,this.isFistLoadRunning,required this.posts,required this.clubdata,this.club}) : super(key: key);

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage> {
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [

            SliverToBoxAdapter(
              child: SearchBar(
                onTap: ()=>Navigator.push(context, CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context){
                      return RecherchePage(

                      );
                    })),
              ),
            ),
            SliverToBoxAdapter(
              child: TitrePage(
                title: 'Publications',
                color: titreColor,
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const PlusDePublicationPage();
                  }));
                },
              ),
            ),
            SliverToBoxAdapter(
              child: widget.isFistLoadRunning !=null
                  ?cardPodcast()
                  :const Center(child: CircularProgressIndicator()),
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
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.posts ==null || widget.posts ==0 ?0: widget.posts.length,
          itemBuilder: (context,position){
        return CardAlaunePodcasts(
          onTap: (){
            if (widget.posts[position].podcast ==null) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    //print(widget.dataUrlPublication['data'][position]['content']);
                    return DetailsPublicationPage(
                      pubUrl: widget.posts[position].content,
                      imageUrl: widget.posts[position].image,
                      title: widget.posts[position].title,
                      date: widget.posts[position].createdAt,
                    );
                  }));
            }else if(widget.posts[position].typeUrl =='audio'){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    print(widget.posts[position].content);
                    return PlayerPage(
                      image: widget.posts[position].image,
                      idMusic: widget.posts[position].podcast,
                      title: widget.posts[position].title,
                      content: widget.posts[position].content,

                    );
                  }));
            }else if(widget.posts[position].typeUrl =='soundcloud'){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return PlayerTypePage(
                  idMusic: widget.posts[position].podcast,
                  content: widget.posts[position].content,

                );
              }));
            }

          },
          title: widget.posts[position].title,
          date: '',
          imageUrl:  widget.posts[position].image,
          isActive: widget.posts[position].podcast,
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
          itemCount: widget.clubdata==null ||widget.clubdata==0?0: widget.clubdata.length,
          itemBuilder: (BuildContext ctx, index) {
         // print( widget.dataUrlClub['data'].length);
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
