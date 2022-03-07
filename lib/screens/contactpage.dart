// ignore_for_file: prefer_const_constructors
import 'package:elite_fm2/utils/constants.dart';
import 'package:elite_fm2/utils/maintitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:app_review/app_review.dart';

List ?data;

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);



  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    FirebaseFirestore.instance
        .collection('allstudios')
        .doc('4lGA5mjxDJrPhvTaNIYd')
        .get()
        .then((docSnapshot) {
      data = docSnapshot.get('names');
      setState(() {
        isLoading = false;
      });
    });
  }

  CollectionReference<Map<String, dynamic>> socialLinks = FirebaseFirestore.instance.collection('socialLinks');

  _launch(String uri) async {
    launch(uri);
    // if (await canLaunch(uri)) {
    //   await
    // } else {
    //   throw 'Could not launch $uri';
    // }
  }
  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        actions: [
          GestureDetector(
            onTap: (){
              launch('https://www.elitefmlive.com/');
           },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('Visit Website')),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              mainTitle("Contact", 200),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Studio",
                        style: TextStyle(color: whiteColor, fontSize: 23),
                      ),
                    ),
                    Divider(
                      thickness: 0,
                      color: lineColor,
                    ),
                  ],
                ),
              ),
              Container(

                padding: EdgeInsets.symmetric(horizontal: 20),
                child:
                data==null? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)):
                ListView.builder(
                    itemCount: data==null?0:data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap:(){
                        launch(data![index]['link']);
                      },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  data![index]['title'],
                                  style: TextStyle(
                                    color: redColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){

                                  },
                                  child: SvgPicture.asset(
                                    'assets/chat.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            // indent: 20,
                            // endIndent: 20,
                            thickness: 0,
                            color: lineColor,
                          ),
                        ],
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      socialLinks.doc('Faceboook').get().then((value) {

                        return _launch(value.data()!['link']);

                      });
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.facebookF,
                      color: whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      socialLinks.doc('Instagram').get().then((value) {

                        return _launch(value.data()!['link']);

                      });                    },
                    icon: FaIcon(
                      FontAwesomeIcons.instagramSquare,
                      color: whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      socialLinks.doc('Whatsapp').get().then((value) {

                        return _launch('https://wa.me/${value.data()!['link']}?text=Hey There!');

                      });
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      socialLinks.doc('Youtube').get().then((value) {

                        return _launch(value.data()!['link']);

                      });;
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.youtube,
                      color: whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {

                      socialLinks.doc('Spotify').get().then((value) {

                       return _launch(value.data()!['link']);

                      });

                    },
                    icon: FaIcon(
                      FontAwesomeIcons.spotify,
                      color: whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      socialLinks.doc('Gmail').get().then((value) {

                         _launch("mailto:${value.data()!['link']}");

                      });

                    },
                    icon: FaIcon(
                      FontAwesomeIcons.envelope,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  print('checking review');
                  final InAppReview inAppReview = InAppReview.instance;

                  inAppReview.openStoreListing(appStoreId: '1592092113');

                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(int i=0;i<5;i++)
                          Icon(Icons.star,color:Colors.white,size:30),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Rate Us",
                      style: TextStyle(color: whiteColor, fontSize: 15),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
