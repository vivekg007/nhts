import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QrReader extends StatefulWidget {
  @override
  QrReaderScreeen createState() => QrReaderScreeen();
}

class QrReaderScreeen extends State<QrReader> with TickerProviderStateMixin {
  TextEditingController qrtextcontroller = new TextEditingController();
  String qrtext = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  _onBackPressed();
                }),
            title: Text(
              'Qr Generator',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.green,
            brightness: Brightness.light,
          ),
          body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      style: new TextStyle(color: Colors.green),
                      controller: qrtextcontroller,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          icon: Icon(Icons.code, color: Colors.green),
                          labelText: 'Enter Text to generate QR Code',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          fillColor: Colors.transparent,
                          filled: true),
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return value!.contains('@')
                            ? 'Do not use the @ char.'
                            : '';
                      },
                    ),
                  ),
                  Container(
                      child: QrImage(
                    data: qrtext,
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                    embeddedImage:
                        AssetImage('assets/images/my_embedded_image.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(80, 80),
                    ),
                  )),
                  RaisedButton(
                    child: Text(
                      'Generate',
                      style: new TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    onPressed: () {
                      //    clienttoken();
                      setState(() {
                        qrtext = qrtextcontroller.text;
                      });
                    },
                    color: Colors.green,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
