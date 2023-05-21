import 'dart:io';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';


const imageUrl = 'https://th.wallhaven.cc/orig/3l/3llgk6.jpg';
const dir = '/storage/emulated/0/Download';
const portName = 'download_port';
const kPrimaryColor = Color(0xFFebbe8b);
const String baseUrl = "https://seytutefes.com/api/";
const String baseUrls = "seytutefes.com";

// playlist songs
List<Audio> songs = [
  Audio(
      'assets/music/nf_Let_You_Down.mp3',
      metas: Metas(
          title: 'Let You Down',
          artist: 'NF',
          image: const MetasImage.asset(
              'assets/images/1b7f41e39f3d6ac58798a500eb4a0e2901f4502dv2_hq.jpeg'))
  ),
  Audio('assets/music/lil_nas_x_industry_baby.mp3',
      metas: Metas(
          title: 'Industry Baby',
          artist: 'Lil Nas X',
          image: const MetasImage.asset('assets/images/81Uj3NtUuhL._SS500_.jpg'))),
  Audio('assets/music/Beautiful.mp3',
      metas: Metas(
          title: 'Beautiful',
          artist: 'Eminem',
          image: const MetasImage.asset('assets/images/916WuJt833L._SS500_.jpg'))),
  Audio('assets/music/bensound-shouldacoulda.mp3',
      metas: Metas(
          title: 'Shoulda Coulda',
          artist: 'C.W.',
          image: const MetasImage.asset('assets/images/cw-X2.webp'))),
  Audio('assets/music/bensound.mp3',
      metas: Metas(
          title: 'Closer To The Sun',
          artist: 'Veace D, featuring piano',
          image: const MetasImage.asset('assets/images/veaced-cinema-X2.webp'))),
  Audio('assets/music/bensound-pastello.mp3',
      metas: Metas(
          title: 'Pastello',
          artist: 'Neptune',
          image: const MetasImage.asset('assets/images/neptune-X2.webp'))),
  Audio('assets/music/unnatural.mp3',
      metas: Metas(
          title: 'Unnatural',
          artist: 'Alexander Vasenin',
          image: const MetasImage.asset('assets/images/alexandervasenin.webp'))),
];

String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
  // for example => 03:09
}

// get song cover image colors
Future<PaletteGenerator> getImageColors(AssetsAudioPlayer player) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
    //AssetImage(player.getCurrentAudioImage?.path ?? ''),
    ResizeImage(
        CachedNetworkImageProvider(
          player.getCurrentAudioImage?.path ?? '',
        ),
        height: 10,
        width: 10),

  );
  return paletteGenerator;
}
Future downloadFileTo(
    {required Dio dio,
      required String url,
      required String savePath,
      Function(int received, int total)? progressFunction}) async {
  try {
    final response = await dio.get(
      url,
      onReceiveProgress: progressFunction,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return (status ?? 0) < 500;
          }),
    );
    print(response.headers);
    final file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print(e);
  }
}
Future<void> checkNecessaryPermissions(BuildContext context) async {
  await Permission.audio.request();
  await Permission.notification.request();
  try {
    await Permission.storage.request();
  } catch (e) {
    showToast(
      'permission + $e',
    );
  }
}
void showToast(String text) {
  Fluttertoast.showToast(
    backgroundColor: Colors.green,
    textColor: Colors.white,
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    fontSize: 14,
  );
}
