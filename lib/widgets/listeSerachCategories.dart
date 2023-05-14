import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/widgets/export_widgets.dart';
import 'package:logger/logger.dart';

class ListeSearchCategories extends StatefulWidget {
  const ListeSearchCategories({Key? key}) : super(key: key);

  @override
  State<ListeSearchCategories> createState() => _ListeSearchCategoriesState();
}

class _ListeSearchCategoriesState extends State<ListeSearchCategories> {
  TextEditingController searchController = TextEditingController();
  final dio =  Dio(); // for http requests
  String _searchText = "";
  List names = [];
  List filteredNames = [];
  bool loading=false;
  var logger =Logger();
  _AcasPageState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = searchController.text;
        });
      }
    });
  }

  void _getNames() async {
    final response =
    await dio.get('https://seytutefes.com/api/publications${searchController.text}');

    List tempList = [];
    for (int i = 0; i < response.data['data'].length; i++) {
      tempList.add(response.data['data'][i]);
    }
    loading=true;
    setState(() {
      names = tempList;
      filteredNames = names;
    });
    logger.w("ghost",names[0]['title']);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
            SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
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
                      ),
                      InkWell(
                        onTap: ()=>Navigator.of(context).pop(),
                        child: Chip(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            label: Text('Annuler')
                        ),
                      )
                    ],
                  ),
                ),
              ),
            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (!_searchText.isEmpty) {
                        List tempList = [];
                        for (int i = 0; i < filteredNames.length; i++) {
                          if (filteredNames[i]['title'].toLowerCase().contains(_searchText.toLowerCase())) {
                            tempList.add(filteredNames[i]);
                          }
                              print(filteredNames);
                        }


                        filteredNames = tempList;
                      }
                  return Padding(
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
                              child: Text(

                                  filteredNames[index]['title'],
                                style: TextStyle(fontSize: 13),
                                maxLines: 3,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ) ;
                },
                childCount: names == null ? 0 : filteredNames.length,
                // 1000 list items
              ),
            )

          ],
        ),
      ),
    );
  }


}
