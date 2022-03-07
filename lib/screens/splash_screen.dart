import 'package:elite_fm2/utils/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:elite_fm2/utils/constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:elite_fm2/screens/blogpage.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  _fetchData() async {

    final url =
        "https://www.googleapis.com/blogger/v3/blogs/6024280035161707736/posts/?key=AIzaSyANpJlM4MCqowDtGBel9YnspKGhYlXf9tc";
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      //HTTP OK is 200
      final Map items = json.decode(response.body);
      var post = items['items'];


      setState(() {

        posts = post;
      });
    }
  }


  @override
  void initState() {

    super.initState();
    _fetchData();
    Timer(Duration(seconds: 2),

            ()=>Navigator.pushReplacement(context,

            MaterialPageRoute(builder:

                (context) =>

                MaterialNavBar(),

            )

        )

    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 50),

        child: Container(


          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: blackColor,
            image: DecorationImage(
              image: AssetImage("assets/logoelitefm.png"),
            ),
          ),
        ),
      ),
    );
  }
}
