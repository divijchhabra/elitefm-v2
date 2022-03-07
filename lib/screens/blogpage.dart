// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite_fm2/screens/bloginfoscreen.dart';
import 'package:elite_fm2/utils/constants.dart';
import 'package:elite_fm2/utils/maintitle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
var posts;
class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {






  var _isLoading = true; //For progress bar

  var imgUrl;
  //initialization
  void initState() {
    super.initState();
    _fetchData();

  }

  //Function to fetch data from JSON
  @override
  _fetchData() async {
    print("attempting");

    final url =
        "https://www.googleapis.com/blogger/v3/blogs/6024280035161707736/posts/?key=AIzaSyANpJlM4MCqowDtGBel9YnspKGhYlXf9tc";
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      //HTTP OK is 200
      final Map items = json.decode(response.body);
      var post = items['items'];


      setState(() {
        _isLoading = false;
        posts = post;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mainTitle("Blog", 130),
                SizedBox(
                  height: 30,
                ),

                        posts==null?

                        CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),) :
                            /*
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                      children: snapshot.data!.docs.map((document  ) {
                        return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BlogInfoScreen(doc: document,)),
                              );

                            },
                            child: blogcard(doc: document,));


                      }).toList(),
                      );


                             */

        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts != null ? posts.length : 0,
            itemBuilder: (BuildContext context, int index) {

              final post = posts[index];
              final title = post["title"];
              final url = post["author"]["image"]["url"];
              final postDesc = post["content"];
              return
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            BlogInfoScreen(
                                title: title, Url: url, content: postDesc)),
                      );
                    },
                    child: blogcard(
                        title: title, content: postDesc, url: url, post: post));
            }
     ),


                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 150,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class blogcard extends StatefulWidget {
  const blogcard({
    Key? key,
    required this.title,
    required this.content,
    required this.url,
    required this.post,
  }) : super(key: key);
  final String title;
  final String content;
  final String url;
  final dynamic post;


  @override
  _blogcardState createState() => _blogcardState();
}

class _blogcardState extends State<blogcard> {
  bool isliked = false;
  bool isbookmarked = false;
  int ?data;
  String ?id;

  Future<void> getData() async {
  id= widget.post['blog']['id'];

    await FirebaseFirestore.instance
        .collection('likedBlogs')
        .doc(id)
        .get()
        .then((docSnapshot) {
      data = docSnapshot.get('likes');

    });
    setState(() {

    });

  }
   void islikedd(String name) async{
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isliked = (prefs.getBool(name)??false);
    });


  }
   void unlike(String name) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setBool(name, false);
      isliked = false;
    });

  }

  void like(String name) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool(name, true);
      isliked = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    islikedd(widget.post['blog']['id']);

    getData();
  }
  @override
  Widget build(BuildContext context) {


       return Padding(
         padding: const EdgeInsets.symmetric(vertical:8),
         child: Stack(
          children: [

            Card(

              // color: Color(0xff434343),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 220,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // image: DecorationImage(
                    //     fit: BoxFit.cover,
                    //     image: NetworkImage(
                    //
                    //       widget.url,
                    //
                    //
                    //     )
                    // )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0,
                    bottom: 0,
                    right: 20,
                    left: 20,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: SizedBox(
                          width: 200,
                          child: Divider(
                            thickness: 4,
                            color: redColor,
                            // indent: 170,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 125,
                        child: Html(
                          data: widget.content,
                          //Optional parameters:

                        ),
                      ),


                      /*
                      Text(
                        "${widget.title}",
                        style:
                        TextStyle(color: Colors.white, fontSize: 16),
                      ),

                       */
                      // SizedBox(height: widget.doc['desc2']==''?75:20,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   // ignore: prefer_const_literals_to_create_immutables
                      //   children: [
                      //
                      //     FutureBuilder(
                      //       future :getData(),
                      //       builder: (context, snapshot) {
                      //         return Text(
                      //           data == null ? "0" : data.toString(),
                      //           style: TextStyle(
                      //               fontSize: 12, color: Colors.black),
                      //         );
                      //       }
                      //     ),
                      //
                      //     SizedBox(width: 10,),
                      //     GestureDetector(
                      //       onTap: ()async {
                      //         String id= widget.post['blog']['id'];
                      //         if (isliked) {
                      //          await FirebaseFirestore.instance.collection(
                      //               'likedBlogs')
                      //               .doc(id)
                      //               .set({"likes": FieldValue.increment(0)});
                      //           // isliked = false;
                      //           unlike(id);
                      //         } else {
                      //          await  FirebaseFirestore.instance.collection(
                      //               'likedBlogs')
                      //               .doc(id)
                      //               .set({"likes": FieldValue.increment(1)});
                      //           // isliked = true;
                      //           like(id);
                      //         }
                      //
                      //         setState(() {
                      //
                      //         });
                      //         getData();
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           shape: BoxShape.circle,
                      //           // ignore: prefer_const_literals_to_create_immutables
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 blurRadius: 1,
                      //                 color: Color(0xff000000),
                      //                 spreadRadius: 0.5)
                      //           ],
                      //         ),
                      //         child: CircleAvatar(
                      //           backgroundColor: Colors.white,
                      //           child: FaIcon(
                      //             FontAwesomeIcons.solidHeart,
                      //             color: isliked ? redColor : Colors.black,
                      //             size: 20,
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),


                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Share.share("Check out this blog ${widget.post['url']}");
                        print("f");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, bottom: 0, top: 13),
                        child: Icon(
                          Icons.share,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),


                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isbookmarked) {
                            isbookmarked = false;
                          } else {
                            isbookmarked = true;
                          }
                        });
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.only(right: 8.0, bottom: 8),
                        child: Icon(
                          Icons.bookmark,
                          color: isbookmarked ? Colors.red : Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
      ),
       )
      ;


  }
}
