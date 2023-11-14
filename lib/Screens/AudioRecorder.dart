import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';

class AudioRecorder extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AudioRecorder> {
  String statusText = "";
  bool isComplete = false;
  bool isRecording =false;
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Navigator.of(context).pop();

                _onBackPressed();
              }),
          title: Text(
            'Record Audio',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          brightness: Brightness.light,
        ),
        body: Column(children: [

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              statusText,
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              play();
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              alignment: AlignmentDirectional.center,
              width: 100,
              height: 50,
              child: isComplete && recordFilePath != ''
                  ? Row(
                children: [
                  Icon(Icons.play_arrow_sharp,color:Colors.grey),
                  Text(
                    "Play",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),

                ],

                  )
                  : Container(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              !isRecording?Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.red.shade300),
                    child: Center(
                      child: Text(
                        'Start Record',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      isRecording= true;
                    });

                   startRecord();
                  },
                ),
              ):Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.blue.shade300),
                    child: Center(
                      child: Text(
                        RecordMp3.instance.status == RecordStatus.PAUSE
                            ? 'resume'
                            : 'pause',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    pauseRecord();
                  },
                ),
              ),
              isRecording?Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.green.shade300),
                    child: Center(
                      child: Text(
                        'stop',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    stopRecord();
                  },
                ),
              ):Container(),

            ],
          ),
          isComplete?GestureDetector(
            child: Container(
              height: 48.0,
              decoration: BoxDecoration(color: Colors.green.shade300),
              child: Center(
                child: Text(
                  'PROCEED',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            onTap: () {
             Navigator.pop(context,recordFilePath);
            },
          ):Container(),
        ]),
      ),
    );
  }



  void startRecord() async {
    bool hasPermission = true;
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Recording--->$type";

        setState(() {

        });
      });
    } else {
      statusText = "No Permission";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Play";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Pause";

        setState(() {

        });
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record Complete";
      isComplete = true;
      isRecording= false;
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Resumed";
      setState(() {});
    }
  }

  String recordFilePath='';

  Future<void> play() async {
    if (recordFilePath != '' && File(recordFilePath).existsSync()) {
      // AudioPlayer audioPlayer = AudioPlayer();
      // audioPlayer.play(recordFilePath, isLocal: true);
      toast('Playing'+recordFilePath);
      final player = AudioPlayer();
      // var duration = await player.setUrl('https://foo.com/bar.mp3');
      var duration = await player.setFilePath(recordFilePath);
      toast('duration'+duration.toString());
      player.play(); // Usually you don't want to wait for playback to finish.

      // var duration = await player.setAsset('path/to/asset.mp3');
    }else{
      toast('File Not found');
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/Agro_${i++}.mp3";
  }
}