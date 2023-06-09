import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);
  final String imageUrl;
  final String title;


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover
              )
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Image.asset(
                    "assets/images/logo.png",
                    width:
                    MediaQuery.of(context).size.width,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
              errorWidget: (context, url, error) =>
                  Image.asset(
                    "assets/images/logo.png",
                    width:
                    MediaQuery.of(context).size.width ,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
              width: MediaQuery.of(context).size.width,
              height: 130,
            ),
          ),
          Container(
            height: 30,
            alignment: Alignment.bottomCenter,
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),

            ),
          )
        ],
      ),
    );
  }
}
