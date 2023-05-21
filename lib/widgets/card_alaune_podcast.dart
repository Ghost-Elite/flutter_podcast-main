import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CardAlaunePodcasts extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final String? date;
  final String? imageUrl;
  final String? isActive;

  CardAlaunePodcasts(
      {Key? key,
      this.onTap,
      this.title,
      this.date,
      this.imageUrl,
      this.isActive})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.60,
        height: 290,
        //color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: NetworkImage(imageUrl!), fit: BoxFit.cover)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Text(Jiffy.parse(date!, pattern: "yyyy-MM-ddTHH")
                        .format(pattern: "dd-MM-yyyy")),
                  ),*/
                  isActive != null
                      ? Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.green,
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
