import 'dart:math' as math;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/pages/export_page.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';

import '../utils/colors.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage>
    with SingleTickerProviderStateMixin {
  final player = AssetsAudioPlayer();
  bool isPlaying = true;
  TextEditingController searchController = TextEditingController();

  // define an animation controller for rotate the song cover image
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 3));

  @override
  void initState() {
    openPlayer();

    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });
    super.initState();
  }

  // define a playlist for player
  void openPlayer() async {
    await player.open(Playlist(audios: songs),
        autoStart: false, showNotification: true, loopMode: LoopMode.playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
              child: Column(
            children: [
              Form(
                child: CustomTextField(
                  controller: searchController,
                  data: Icons.search,
                  suffixIcon: Icons.filter_list,
                  isObsecre: false,
                  isEmail: true,
                  hintText: 'Recherche',
                ),
              ),
              TitrePage(
                title: 'Podcasts à la une',
                color: titreColor,
              ),
              cardPodcast(),
              TitrePage(
                title: 'Mes podcasts',
                color: titreColor,
              ),
              Container(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        await player.playlistPlayAtIndex(index);
                        setState(() {
                          player.getCurrentAudioImage;
                          player.getCurrentAudioTitle;
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
              )
            ],
          )),
          player.getCurrentAudioImage == null
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
                        /*onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => PlayerPage(
                                      player: player,
                                    ))),*/
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
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.pause();
    super.dispose();
  }

  Widget cardPodcast() {
    return Container(
      height: 280,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, position) {
            return CardAlaunePodcasts(
              title:
                  'Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant',
              date: '3 décembre 2020',
            );
          }
          ),
    );
  }
}
