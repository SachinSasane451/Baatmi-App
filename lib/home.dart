

import 'dart:convert';
import 'package:baatmi/webView.dart';

import 'category.dart';
import 'package:baatmi/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = [
    "Top News",
    "India",
    "World",
    "stock",
    "Bollywood",
    "Sports",
    "Gaming",
    "Politics",
    "Finance",
    "Health"
  ];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    Map element;
    int i=0;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2021-12-12&to=2021-12-07&sortBy=popularity&apiKey=c2196ba6ef0542cbb6a458dbe4b76ecc";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsquery = NewsQueryModel();
          newsquery = NewsQueryModel.fromMap(element);
          newsModelList.add(newsquery);
          setState(() {
            isLoading = false;
          });

          if (i == 12) {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });

  }





  getNewsofIndia() async {
    Map element;
    int i=0;
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
        setState(() {
          for (element in data["articles"]) {
            try {
              i++;
              NewsQueryModel newsind = NewsQueryModel();
              newsind = NewsQueryModel.fromMap(element);
              newsModelListCarousel.add(newsind);
              setState(() {
                isLoading = false;
              });
              if (i == 7) {
                break;
              }
            } catch (e) {
              print(e);
            }
          }
        });


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("corona");
    getNewsofIndia();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baaτᴍi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Wala Container

              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("pls search properly");
                      } else {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => category(cat:searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.purple,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if ((value).replaceAll(" ", "") == "") {
                          print("Blank Search");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      category(cat: value)));
                        }

                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Search News"),
                    ),
                  )
                ],
              ),
            ),

            // category wale buttons
            Container(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder:(context)=>category(cat: navBarItem[index],)));                      },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purple
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter
                              ),
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(navBarItem[index],
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    })),

            // ghumne wale news
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: isLoading ? Container(height:200,child: Center(child: CircularProgressIndicator())): CarouselSlider(
                options: CarouselOptions(
                    height: 190, autoPlay: true, enlargeCenterPage: true),
                items: newsModelListCarousel.map((instance) {
                  return Builder(builder: (BuildContext context) {
                    try{
                    return Container(

                        child : InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        webview(instance.newsUrl)));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child : Stack(
                                  children : [
                                    ClipRRect(
                                        borderRadius : BorderRadius.circular(5),
                                        child : Image.network(instance.newsImg , fit: BoxFit.fitWidth, width: double.infinity,)
                                    ) ,
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.purple.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter
                                              )
                                          ),
                                          child : Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                                              child:Container( margin: EdgeInsets.symmetric(horizontal: 10), child: Text(instance.newsHead , style: TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold),))
                                          ),
                                        )
                                    ),
                                  ]
                              )
                          ),
                        )
                    );
                    } catch(e){print(e) ;return Container();}
                  });
                }).toList(),
              ),
            ),

            // Trending news container
            Container(
              child: Column(
                children: [
                  Container(

                    margin : EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text("Tre𝓷dingNeฬຮ" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 24
                        ),),
                      ],
                    ),
                  ),
                  isLoading ? Container(height: MediaQuery.of(context).size.height-350,child: Center(child:CircularProgressIndicator()),):
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        try{
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => webview(
                                            newsModelList[index].newsUrl)));
                              },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 240,width: double.infinity, )),

                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter
                                              )
                                          ),
                                          padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsModelList[index].newsHead,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,55)}...." : newsModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12)
                                                ,)
                                            ],
                                          )))
                                ],
                              ))),
                        );
                        }catch(e){print(e);return Container();}
                      }),

                  // Show more button
                  isLoading ? SizedBox():
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder:(context)=>category(cat: "Global",)));}, child: Text("SHOW MORE")),
                      ],
                    ),
                  )
                ],
              ),
            )


          ],
        ),
      ),
    );
  }

}