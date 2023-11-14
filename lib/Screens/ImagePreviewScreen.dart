import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:path_provider/path_provider.dart';


class ImagePreviewScreen extends StatefulWidget {


  ImagePreviewScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImagePreviewScreen();
  }
}

class _ImagePreviewScreen extends State<ImagePreviewScreen> {

  List<String> images = [];
  String selectimage ='';
  int imagecount =0;
  @override
  void initState() {
    super.initState();
    images.add('images/1.jpg');
    images.add('images/2.jpg');
    images.add('images/3.jpg');
    images.add('images/4.jpg');
    images.add('images/5.jpg');
    images.add('images/6.jpg');
    images.add('images/7.jpg');
    images.add('images/8.jpg');
    images.add('images/9.jpg');
    images.add('images/10.jpg');
    images.add('images/11.jpg');
    images.add('images/12.jpg');
    images.add('images/13.jpg');
    images.add('images/14.jpg');
    images.add('images/15.jpg');
    selectimage =images[0];

  }

  @override
  void dispose() {
    super.dispose();


  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(


        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Symptoms',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          brightness: Brightness.light,

        ),
        body: Container(
          child: Stack(

            children: <Widget>[

              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  selectimage,
                  fit: BoxFit.cover,

                  alignment: Alignment.center,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: InkWell(
                    onTap: (){
                      if(imagecount!=0){
                        imagecount = imagecount-1;
                        setState(() {
                          selectimage =images[imagecount];
                        });
                      }
                    },
                    child: Card(
                        color: Colors.green,

                        child: Icon(Icons.chevron_left,color: Colors.white,size: 50,))),

              ),
              Container(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: (){
                      if(imagecount!=images.length){
                        imagecount = imagecount+1;
                        setState(() {
                          selectimage =images[imagecount];
                        });
                      }

                    },
                    child: Card(
                        color: Colors.green,

                        child: Icon(Icons.chevron_right,color: Colors.white,size: 50,))),

              ),
          
            ],
          ),),
      ),
    );
  }
}

