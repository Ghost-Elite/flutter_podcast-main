import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_podcast/utils/utils_export.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_podcast/models/export_model.dart';
import 'package:flutter_podcast/pages/export_page.dart';
class RecherchePage extends StatefulWidget {
  var logoUrl;
  RecherchePage({Key? key,this.logoUrl,}) : super(key: key);
  @override
  _RecherchePageState createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
//Step 3
  var logger =Logger();
  _RecherchePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {

      } else {
        search();
      }
    });
  }

//Step 1
  final TextEditingController _filter = TextEditingController();
  final dio =  Dio(); // for http requests
  String _searchText = "";
  List names = []; // names we get from API
  List filteredNames = []; // names filtered by search text
  Icon _searchIcon =  Icon(Icons.search);
  Widget _appBarTitle = Text('Search Channel');

  void search(){
      var url = Uri.https(baseUrls, "api/clubs",{"search":_filter.text});
      log("message url $url");
       http.get(url).then((response){
        final json = jsonDecode(response.body);
        setState(() {
          filteredNames = json['data'];
        });
        log("message success $filteredNames");
        log("pas de donnes");

       }).onError((error, stackTrace){
         log("message error $error $stackTrace");

         // todo
       }).timeout(const Duration(seconds: 5));
  }

  //step 2.1
 /* void _getNames() async {
    String endpoint="clubs";
    var url = "${baseUrls+endpoint}";
    final response =
    await dio.get(url);
    print(response.data);
    List tempList = [];
    for (int i = 0; i < response.data['data'].length; i++) {
      tempList.add(response.data['data'][i]);

    }
    setState(() {
      names = tempList;
      filteredNames = names;
    });
    print(filteredNames.length);
  }*/

//Step 2.2


  //Step 4
  Widget _buildList() {
    /*if (_searchText.isEmpty !=null) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }*/
    return filteredNames ==null|| filteredNames.length >0 ? ListView.builder(
      itemCount: filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        //print(filteredNames.length);
        return InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return DetailsPublicationClubPage(
                titrePublic: filteredNames[index]['name'],
                pubUrl: filteredNames[index]['publication_url'],
                imageUrl: filteredNames[index]['image'],
                content: filteredNames[index]['description'],
              );
            }
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.40,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(filteredNames[index]['image']),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  SizedBox(width: 4,),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        filteredNames[index]['name'],
                        style: TextStyle(fontSize: 13),
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ) :Center(child: Text('${_filter.text.isEmpty ?"Recherche par mot-cles Ex: b,y,f ...":"Imposible de trouver <<${_filter.text}>>"}'),);
  }

  //STep6
 /* Widget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading:  IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }*/

  @override
  void initState() {
   // _getNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: ()=>Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: Form(
                      child: CustomTextField(
                        onPressed: (){
                         // filteredNames = names;
                          search();
                          //_filter.clear();
                        },
                        controller: _filter,
                        data: Icons.search,
                        suffixIcon: Icons.filter_list,
                        isObsecre: false,
                        isEmail: true,
                        hintText: 'Recherche',
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: ()=>_RecherchePageState(),
                    child: const Chip(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        label: Text('Recherche')
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: _buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}