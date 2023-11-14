import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;

import 'package:rflutter_alert/rflutter_alert.dart';

class OtherGadgets extends StatefulWidget {
  @override
  OtherGadgetsScreeen createState() => OtherGadgetsScreeen();
}

class OtherGadgetsScreeen extends State<OtherGadgets>
    with TickerProviderStateMixin {
  bool _isChecked = true;
  String? _currText = '';

  List<String> text = ["InduceSmile.com", "Flutter.io", "google.com"];

  String? _radioValue; //Initial definition of radio button value
  String? choice;
  File? _image;

  Future getImage() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _radioValue = "one";
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void radioButtonChanges(String? value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          choice = value;
          break;
        case 'two':
          choice = value;
          break;
        case 'three':
          choice = value;
          break;
        default:
          choice = '';
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  Future<bool> _onBackPressed() async {
    return (await Alert(
      context: context,
      type: AlertType.warning,
      title: 'Cancel',
      desc: 'Are you sure want to cancel',
      buttons: [
        DialogButton(
          child: Text(
            'Yes',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            'No',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          _onBackPressed();
                        }),
                    title: Text(
                      'Others',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700),
                    ),
                    iconTheme: IconThemeData(color: Colors.white),
                    backgroundColor: Colors.green,
                    brightness: Brightness.light,
                  ),
                  body: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        color: Colors.black12,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text('Check Box'),
                      ),
                      Center(
                        child: Text(_currText!,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        child: Column(
                          children: text
                              .map((t) => CheckboxListTile(
                                    title: Text(t),
                                    value: _isChecked,
                                    onChanged: (val) {
                                      setState(() {
                                        _isChecked = val!;
                                        if (val == true) {
                                          _currText = t;
                                        }
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        color: Colors.black12,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Text('Radio Button'),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: 'one',
                                  groupValue: _radioValue,
                                  onChanged: radioButtonChanges,
                                ),
                                Text(
                                  "Seeds",
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: 'two',
                                  groupValue: _radioValue,
                                  onChanged: radioButtonChanges,
                                ),
                                Text(
                                  "Crops",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: _image == ''
                                ? Text('No image selected.')
                                : Image.file(_image!),
                          ),
                          FloatingActionButton(
                            onPressed: getImage,
                            tooltip: 'Pick Image',
                            child: Icon(Icons.add_a_photo),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
