//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elite_fm2/utils/constants.dart';
//import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class BlogInfoScreen extends StatefulWidget {
   BlogInfoScreen({Key? key,required this.title,required this.content,required this.Url}) : super(key: key);
  final String title;
  final String content;
  final String Url;


  @override
  _BlogInfoScreenState createState() => _BlogInfoScreenState();
}

class _BlogInfoScreenState extends State<BlogInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blackColor,

      ),
      body: Center(child:
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(20),
              //
              //     child: Image.network(widget.Url)),
              SizedBox(height: 20,),
              Text(
                widget.title,
                style: TextStyle(
                  color: redColor,
                  fontSize: 21
                ),
              ),
              SizedBox(height: 20,),
              // Container(
              //
              //   child: Html(
              //       shrinkWrap: true,
              //       data: widget.content, onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
              //     //open URL in webview, or launch URL in browser, or any other logic here
              //     launch(url!);
              //   }),
              // ),
              HtmlWidget(
                // the first parameter (`html`) is required
                  widget.content,

                // all other parameters are optional, a few notable params:

                // specify custom styling for an element
                // see supported inline styling below
                customStylesBuilder: (element) {
                  if (element.classes.contains('foo')) {
                    return {'color': 'red'};
                  }

                  return null;
                },

                // render a custom widget

                // these callbacks are called when a complicated element is loading
                // or failed to render allowing the app to render progress indicator
                // and fallback widget
                onErrorBuilder: (context, element, error) => Text('$element error: $error'),
                onLoadingBuilder: (context, element, loadingProgress) => CircularProgressIndicator(),

                // this callback will be triggered when user taps a link
                onTapUrl: (url) {
                   return launch(url);
                },

                // select the render mode for HTML body
                // by default, a simple `Column` is rendered
                // consider using `ListView` or `SliverList` for better performance
                renderMode: RenderMode.column,

                // set the default styling for text
              ),



            ],

          ),
        ),
      ),),
    );
  }
}
