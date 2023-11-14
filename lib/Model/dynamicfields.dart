import 'dart:io';

import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:signature/signature.dart';

import '../Screens/dynamicScreengetdata.dart';
import '../main.dart';
import 'equipmentmodel.dart';
import 'inputInfoModel.dart';

Widget txt_label_Dynamic(
    String label, Color color, double fontsize, bool headling) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: headling
        ? Container(
            color: color,
            padding: EdgeInsets.all(3),
            child: Text(
              label,
              style: TextStyle(fontSize: fontsize, color: Colors.white),
            ),
          )
        : Container(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontsize,
                color: color,
              ),
            ),
          ),
  );
  return objWidget;
}

Widget txt_label(String label, Color color, double fontsize, bool headling) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: headling
        ? Container(
            color: color,
            padding: EdgeInsets.all(3),
            child: Text(
              label,
              style: TextStyle(fontSize: fontsize, color: Colors.white),
            ),
          )
        : Container(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontsize,
                color: color,
              ),
              maxLines: 10,
            ),
          ),
  );
  return objWidget;
}

Widget txt_label_icon(
    String label, Color color, double fontsize, bool mandatory, IconData icon) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.green,
          size: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontsize,
                  color: color,
                ),
              ),
              mandatory
                  ? Container(
                      padding: EdgeInsets.only(left: 3),
                      child: Text(
                        '*',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    ),
  );
  return objWidget;
}

Widget txt_label_mandatory_Dynamic(
    String label, Color color, double fontsize, bool headling) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: headling
        ? Container(
            color: color,
            padding: EdgeInsets.all(3),
            child: Text(
              label,
              style: TextStyle(fontSize: fontsize, color: Colors.white),
            ),
          )
        : Container(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontsize,
                      color: color,
                    ),
                  ),
                  flex: 20,
                ),
                Expanded(
                  child: Text(
                    '*',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
  );
  return objWidget;
}

Widget txt_label_mandatory(
    String label, Color color, double fontsize, bool headling) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: headling
        ? Container(
            color: color,
            padding: EdgeInsets.all(3),
            child: Text(
              label,
              style: TextStyle(fontSize: fontsize, color: Colors.white),
            ),
          )
        : Container(
            //Flexible(
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: label,
                        style:
                            TextStyle(color: Colors.black, fontSize: fontsize),
                        children: [
                          TextSpan(
                              text: ' *',
                              style: TextStyle(
                                  color: Colors.red, fontSize: fontsize))
                        ]),
                    maxLines: 10,
                  ),
                ),
              ],
            ),
          ),
  );
  return objWidget;
}

Widget txtfield_dynamicWothoutcontroller(
    {String? intialVal,
    int? length,
    bool? initial,
    String? hint,
    required TextEditingController? txtcontroller,
    bool? focus,
    required String Position,
    String? componentType,
    String? sectionId,
    String? isMandatory,
    String? componentLabel,
    String? Type,
    String? componentID,
    List<ComponentModel>? componentidvalue,
    Function(String)? onChange}) {
  txtcontroller = TextEditingController();
  if (componentidvalue!.length > 0) {
    bool found = false;
    for (int v = 0; v < componentidvalue.length; v++) {
      print(
          "txtArea value ${componentID!}<>${componentidvalue[v].componentid}");
      if (componentidvalue[v].componentid == componentID) {
        print("txtArea value $componentID<>${componentidvalue[v].value}");

        txtcontroller.text = componentidvalue[v].value;
        txtcontroller.selection = TextSelection.fromPosition(
            TextPosition(offset: txtcontroller.text.length));
        found = true;
      }
    }
    print("txtArea value $found");
    if (!found) {
      // txtcontroller = new TextEditingController();
      txtcontroller.text = '';
      initial = true;
    }
  } else {
    //txtcontroller = new TextEditingController();
    txtcontroller.text = '';
    initial = true;
  }

  //txtcontroller.selection = TextSelection.fromPosition(TextPosition(offset: txtcontroller.text.length));//getting slow
  if (initial!) {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
            enabled: focus,
            style: TextStyle(color: Colors.black87),
            controller: txtcontroller,
            onChanged: onChange,
            onFieldSubmitted: onChange,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                hintMaxLines: 2,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
                hintText: hint,
                filled: false),
            validator: (String? value) {
              return value!.contains('@') ? 'Do not use the @ char.' : null;
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
              //FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z0-9]+$'))
            ]),
      ),
    ));
    return objWidget;
  } else {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
            enabled: focus,
            style: TextStyle(color: Colors.black87),
            controller: txtcontroller,
            initialValue: intialVal,
            onChanged: onChange,
            onFieldSubmitted: onChange,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
                hintText: hint,
                filled: false),
            validator: (String? value) {
              return value!.contains('@') ? 'Do not use the @ char.' : null;
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ]),
      ),
    ));
    return objWidget;
  }
}

Widget txt_labelsection(
    String label, Color color, double fontsize, bool headling) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 5),
    child: headling
        ? Container(
            color: color,
            padding: EdgeInsets.all(3),
            child: Html(
              data: label,
              style: {
                '#': Style(
                  fontSize: FontSize(fontsize),
                  color: Colors.white,
                ),
              },
            ))
        : Container(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontsize,
                color: color,
              ),
            ),
          ),
  );
  return objWidget;
}

Widget txtfield_dynamicwithchareactercontroller(
    {String? intialVal,
    int? length,
    bool? initial,
    String? hint,
    required TextEditingController? txtcontroller,
    bool? focus,
    required String Position,
    String? componentType,
    String? sectionId,
    String? isMandatory,
    String? componentLabel,
    String? Type,
    String? componentID,
    List<ComponentModel>? componentidvalue,
    Function(String)? onChange}) {
  txtcontroller = TextEditingController();
  print("lengthyu$length");
  if (componentidvalue!.length > 0) {
    bool found = false;
    for (int v = 0; v < componentidvalue.length; v++) {
      print(
          "txtArea value ${componentID!}<>${componentidvalue[v].componentid}");
      if (componentidvalue[v].componentid == componentID) {
        print("txtArea value $componentID<>${componentidvalue[v].value}");

        txtcontroller.text = componentidvalue[v].value;
        txtcontroller.selection = TextSelection.fromPosition(
            TextPosition(offset: txtcontroller.text.length));
        found = true;
      }
    }
    print("txtArea value $found");
    if (!found) {
      // txtcontroller = new TextEditingController();
      txtcontroller.text = '';
      initial = true;
    }
  } else {
    //txtcontroller = new TextEditingController();
    txtcontroller.text = '';
    initial = true;
  }

  //txtcontroller.selection = TextSelection.fromPosition(TextPosition(offset: txtcontroller.text.length));//getting slow
  if (initial!) {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintMaxLines: 2,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(length ?? 45),
            //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            // FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z ]+$'))
          ],
        ),
      ),
    ));
    return objWidget;
  } else {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          initialValue: intialVal,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(length ?? 45),
            FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z ]+$'))
          ],
        ),
      ),
    ));
    return objWidget;
  }
}

Widget MultiDropDownWithModel(
    {required List<DropdownModelClass> itemlist,
    required List<DropdownModelClass> selectedItems,
    required String hint,
    required Function() onClear,
    required Function(List<DropdownModelClass>) onChanged}) {
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<DropdownModelClass>.multiSelection(
        mode: Mode.BOTTOM_SHEET,
        showSearchBox: true,
        items: itemlist,
        filterFn: (instance, filter) {
          if (instance!.name.toLowerCase().contains(filter!.toLowerCase())) {
            print(filter);
            return true;
          } else {
            return false;
          }
        },
        dropdownBuilder: (context, selectedItem) => selectedItems.isEmpty
            ? Container(
                child: Text(
                  hint,
                  style: TextStyle(color: Colors.black),
                ),
              )
            : Container(
                child: Column(
                  children: selectedItems.map((e) {
                    return Container(
                      child: ListTile(
                        dense: true,
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        title: Transform(
                          transform: Matrix4.translationValues(-18, 0.0, 0.0),
                          child: Text(e.name,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
        popupItemBuilder: (context, item, isSelected) => Container(
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Text(
            item.name,
            style: const TextStyle(color: Colors.black, fontSize: 18.0),
          ),
        ),
        dropdownSearchDecoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          border: OutlineInputBorder(),
        ),
        searchFieldProps: TextFieldProps(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            labelText: "Search Option",
            prefixIcon: Icon(Icons.search),
          ),
        ),
        onChanged: onChanged,
        selectedItems: selectedItems,
      ),
    ),
  );
  return objWidget;
}

Widget txtArea_dynamic(
    {String? intialVal,
    var length,
    bool? initial,
    String? hint,
    TextEditingController? txtcontroller,
    bool? focus,
    String? Position,
    String? componentType,
    String? sectionId,
    String? isMandatory,
    String? componentLabel,
    String? Type,
    List<ComponentModel>? componentidvalue,
    Function(String)? onChange,
    String? componentID}) {
  print("dynfields hint UPPB ${hint!}");
  print("dynfields intialVal UPPB ${intialVal!}");
  print("dynfields initial UPPB ${initial!}");
  print("dynfields lengthB ${length!}");

  print("txtArea componentid ${componentidvalue!.length}");
  if (componentidvalue.length > 0) {
    bool found = false;
    for (int v = 0; v < componentidvalue.length; v++) {
      if (componentidvalue[v].componentid == componentID) {
        print("txtArea value ${componentidvalue[v].value}");
        txtcontroller = TextEditingController();
        txtcontroller.text = componentidvalue[v].value;
        txtcontroller.selection = TextSelection.fromPosition(
            TextPosition(offset: txtcontroller.text.length));
        found = true;
      }
    }
    if (!found) {
      txtcontroller = TextEditingController();
      txtcontroller.text = '';
      initial = true;
    }
  } else {
    txtcontroller = TextEditingController();
    txtcontroller.text = '';
    initial = true;
  }
  print("initial$initial");

  if (initial) {
    print("dynfields hint $hint");
    print("dynfields intialVal $intialVal");
    print("dynfields initial $initial");
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          maxLines: 5,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          onChanged: onChange,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: onChange,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(length ?? 45),
          ],
        ),
      ),
    ));
    return objWidget;
  } else {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          maxLines: 5,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          onChanged: onChange,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(length ?? 45),
          ],
        ),
      ),
    ));
    return objWidget;
  }
}

Widget txtfield_digitswithoutdecimalandController(
    {String? componentid,
    String? intialVal,
    int? length,
    bool? initial,
    String? hint,
    TextEditingController? txtcontroller,
    bool? focus,
    String? Position,
    String? componentType,
    String? sectionId,
    String? isMandatory,
    String? componentLabel,
    String? Type,
    List<ComponentModel>? componentidvalue,
    Function(String)? onChange}) {
  txtcontroller = TextEditingController();
  if (componentidvalue!.length > 0) {
    bool found = false;
    print("txtArea value ${componentidvalue.length}");
    for (int v = 0; v < componentidvalue.length; v++) {
      print(
          "textfieldscontrollervalues ${componentid!}<>${componentidvalue[v].componentid}<>${componentidvalue[v].value}");
      if (componentidvalue[v].componentid == componentid) {
        print("txtArea value ${componentidvalue[v].value}");
        txtcontroller!.text = componentidvalue![v].value;
        txtcontroller.selection = TextSelection.fromPosition(
            TextPosition(offset: txtcontroller.text.length));
        found = true;
      }
    }
    // if(!found){
    //   print("txtArea value not found");
    //   txtcontroller!.text = '';
    //   initial = true;
    // }
  } else {
    //txtcontroller = new TextEditingController();
    txtcontroller!.text = '';
    initial = true;
  }

  if (initial!) {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller!,
          //initialValue: intialVal!,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintMaxLines: 2,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            //FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(length ?? 100),
            FilteringTextInputFormatter.allow(RegExp(r"[0-9\s]"))
          ],
        ),
      ),
    ));
    return objWidget;
  } else {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller!,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(length ?? 100)
          ],
        ),
      ),
    ));
    return objWidget;
  }
}

Widget txtfield_digitswithoutdecimal(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(length ?? 100)
        ],
      ),
    ),
  ));
  return objWidget;
}

Widget cardlable_dynamic(String label) {
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        height: 40,
        alignment: Alignment.centerLeft,
        child: Text(
          label ?? '-',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
  return objWidget;
}

Widget txtFieldLargeDynamic(
    String label, TextEditingController txtcontroller, bool focus) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      height: 60,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        maxLines: 3,
        enabled: focus,
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_dynamic(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]"))
        ],
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_vehicleNumber(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          // FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]"))
        ],
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_email(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          //FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s]"))
        ],
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_dynamic1(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          FilteringTextInputFormatter.allow(RegExp(r"[0-9 ,*\s]"))
        ],
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_digitCharacter(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s]"))
        ],
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_digitCharacter1(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          //FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s]"))
        ],
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget listdesign(String Cropvalue, String estimatedvalue) {
  return Container(
    child: Column(
      children: <Widget>[
        Divider(
          height: 1.0,
          color: Colors.black,
        ),
        Container(
          child: Text(
            Cropvalue,
            style: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.normal,
                color: Colors.black),
          ),
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
        ),
        Container(
          child: Text(
            estimatedvalue,
            style: TextStyle(fontSize: 15.0),
          ),
          padding: EdgeInsets.all(10),
        ),
        Divider(
          height: 1.0,
          color: Colors.black,
        ),
      ],
    ),
  );
}

Widget txtfield_withcharacterdigits(
    String label, TextEditingController txtcontroller, bool focus,
    [int? length, int? decimallength]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          decimallength != null
              ? FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,' + decimallength.toString() + '}'))
              : LengthLimitingTextInputFormatter(length ?? 100),
          // FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z0-9\s]+$'))
        ],
        keyboardType: TextInputType.phone,
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget txtfield_digits(
    String label, TextEditingController? txtcontroller, bool focus,
    [int? length, int? decimallength]) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
        enabled: focus,
        inputFormatters: [
          LengthLimitingTextInputFormatter(length ?? 45),
          /*decimallength != null
              ? FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,' + decimallength.toString() + '}'))
              : LengthLimitingTextInputFormatter(length ?? 100),*/
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black87),
        controller: txtcontroller,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
            ),
            hintText: label,
            filled: false),
        validator: (String? value) {
          return value!.contains('@') ? 'Do not use the @ char.' : '';
        },
      ),
    ),
  ));
  return objWidget;
}

Widget btn_dynamic(
    {String? label,
    Color? bgcolor,
    Color? txtcolor,
    double? fontsize,
    Alignment? centerRight,
    double? margin,
    btnSubmit}) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin!),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: bgcolor,
        child:
            Text(label!, style: TextStyle(fontSize: fontsize, color: txtcolor)),
        onPressed: btnSubmit,
      ),
    ]),
  );
  return objWidget;
}

Widget datatable_dynamic({List<DataColumn>? columns, List<DataRow>? rows}) {
  Widget objWidget = Container(
    color: Colors.white,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: columns!, rows: rows!),
      ),
    ),
  );
  return objWidget;
}

// Widget cardDialog(){
//
// }

Widget btn_dynamic_tag(
    {String? label,
    Color? bgcolor,
    Color? txtcolor,
    double? fontsize,
    Alignment? centerRight,
    double? margin,
    btnSubmit,
    tag}) {
  Widget objWidget = Hero(
      tag: tag,
      child: Container(
        alignment: centerRight,
        margin: EdgeInsets.only(top: margin!),
        child: Wrap(children: <Widget>[
          MaterialButton(
            color: bgcolor,
            child: Text(label!,
                style: TextStyle(fontSize: fontsize, color: txtcolor)),
            onPressed: btnSubmit,
          ),
        ]),
      ));
  return objWidget;
}

Widget dropDownLists({
  String? hint,
  List<String>? items,
  String? value,
  Function(String?)? onChange,
}) {
  print(value);

  return DropdownButton<String>(
    hint: Text(hint!),
    icon: Icon(
      Icons.arrow_drop_down,
      color: Colors.green,
    ),
    value: value,
    onChanged: onChange,
    style: TextStyle(color: Colors.black, fontSize: 14),
    items: items!.map((String selection) {
      return DropdownMenuItem<String>(
        value: selection,
        child: Text(selection),
      );
    }).toList(),
  );
}

Widget chkbox_dynamic(
    {String? label, bool? checked, Function(bool?)? onChange}) {
  Widget objWidget = Container(
    child: Row(
      children: <Widget>[
        Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.green,
            value: checked,
            onChanged: onChange),
        Text(
          label!,
          style: TextStyle(color: Colors.green),
        ),
      ],
    ),
  );
  return objWidget;
}

Widget YearSelector(
    {BuildContext? context1,
    Function(DateTime?)? onConfirm,
    DateTime? selectedDate,
    String? slctyear}) {
  Widget objWidget = Column(
    children: <Widget>[
      Container(
          child: InkWell(
        onTap: () {
          showDialog(
            context: context1!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Select Year"),
                content: Container(
                  // Need to use container to add size constraint.
                  width: 300,
                  height: 300,
                  child: YearPicker(
                    firstDate: DateTime(DateTime.now().year - 100, 1),
                    lastDate: DateTime(DateTime.now().year + 100, 1),
                    initialDate: DateTime.now(),
                    // save the selected date to _selectedDate DateTime variable.
                    // It's used to set the previous selected date when
                    // re-showing the dialog.
                    selectedDate: selectedDate!,
                    onChanged: onConfirm!,
                  ),
                ),
              );
            },
          );
        },
        child: Row(
          children: <Widget>[
            const Icon(Icons.calendar_today),
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Text(
                slctyear!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
      const Divider(
        thickness: 1.0,
        height: 2.0,
        color: Colors.green,
      )
    ],
  );
  return objWidget;
}

Widget selectYear(
    {BuildContext? context1,
    Function(DateTime?)? onConfirm,
    String? slctyear}) {
  Widget objWidget = Column(
    children: <Widget>[
      Container(
          child: InkWell(
        onTap: () {
          DatePicker.showDatePicker(
            context1!,
            showTitleActions: true,
            minTime: DateTime(1900),
            maxTime: DateTime.now(),
            theme: DatePickerTheme(
                headerColor: Colors.green,
                backgroundColor: Colors.white,
                itemStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                cancelStyle: TextStyle(color: Colors.white, fontSize: 16),
                doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
            onChanged: (date) {
              print('change $date in time zone ${date.timeZoneOffset.inHours}');
            },
            onConfirm: onConfirm,
            locale: LocaleType.en,
          );
        },
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Text(
                slctyear!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
      Divider(
        thickness: 1.0,
        height: 2.0,
        color: Colors.green,
      )
    ],
  );
  return objWidget;
}

Widget selectDateDynamic(
    {BuildContext? context1,
    Function(DateTime?)? onConfirm,
    String? slctdate,
    String? ComponentId,
    List<DateModel>? datemodel}) {
  print("slctdate ${slctdate!}");
  slctdate = 'Select Date';
  for (int i = 0; i < datemodel!.length; i++) {
    if (ComponentId == datemodel[i].ComponentId) {
      slctdate = datemodel[i].Date;
    }
  }
  Widget objWidget = Column(
    children: <Widget>[
      Container(
          child: InkWell(
        onTap: () {
          DatePicker.showDatePicker(context1!,
              showTitleActions: true,
              minTime: DateTime(1900),
              maxTime: DateTime.now(),
              theme: DatePickerTheme(
                  headerColor: Colors.green,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  cancelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
              onChanged: (date) {
            print('change $date in time zone ${date.timeZoneOffset.inHours}');
          },
              onConfirm: onConfirm,
              currentTime: DateTime.now(),
              locale: LocaleType.en);
        },
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Text(
                slctdate!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
      Divider(
        thickness: 1.0,
        height: 2.0,
        color: Colors.green,
      )
    ],
  );
  return objWidget;
}

Widget selectFutureDate(
    {BuildContext? context1,
    Function(DateTime?)? onConfirm,
    String? slctdate,
    int? year,
    int? month,
    int? day}) {
  Widget objWidget = Column(
    children: <Widget>[
      Container(
          child: InkWell(
        onTap: () {
          DatePicker.showDatePicker(context1!,
              showTitleActions: true,
              minTime: DateTime(year!, month!, day!),
              maxTime: DateTime(2050),
              theme: DatePickerTheme(
                  headerColor: Colors.green,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  cancelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
              onChanged: (date) {
            print('change $date in time zone ${date.timeZoneOffset.inHours}');
          },
              onConfirm: onConfirm,
              currentTime: DateTime.now(),
              locale: LocaleType.en);
        },
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Text(
                slctdate!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
      Divider(
        thickness: 1.0,
        height: 2.0,
        color: Colors.green,
      )
    ],
  );
  return objWidget;
}

Widget selectDate(
    {BuildContext? context1,
    Function(DateTime?)? onConfirm,
    String? slctdate}) {
  Widget objWidget = Column(
    children: <Widget>[
      Container(
          child: InkWell(
        onTap: () {
          DatePicker.showDatePicker(context1!,
              showTitleActions: true,
              minTime: DateTime(1900),
              maxTime: DateTime.now(),
              theme: DatePickerTheme(
                  headerColor: Colors.green,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  cancelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
              onChanged: (date) {
            print('change $date in time zone ${date.timeZoneOffset.inHours}');
          },
              onConfirm: onConfirm,
              currentTime: DateTime.now(),
              locale: LocaleType.en);
        },
        child: Row(
          children: <Widget>[
            Icon(Icons.calendar_today),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              child: Text(
                slctdate!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      )),
      Divider(
        thickness: 1.0,
        height: 2.0,
        color: Colors.green,
      )
    ],
  );
  return objWidget;
}

//Widget dynamicRadio({List<RadioModel> sampleData, void Function(int position) ontap, BuildContext radioContext}) {
/*Widget dynamicRadio({List<RadioModel> sampleData, void Function(int position) ontap, BuildContext radioContext, int val}) {
  print("here");
  print("sampleData "+sampleData[0].buttonText);
  print("sampleData "+sampleData.length.toString());
  bool _value = false;
  Widget objWidget =Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: Text("Male"),
            leading: Radio(
              value: 1,
              toggleable:true,
              groupValue: val,
              onChanged: (value) {
                val = value;
                ontap(val);
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: Text("Female"),
            leading: Radio(
              value: 2,
              groupValue: val,
              toggleable:true,
              onChanged: (value) {
                val = value;
                ontap(value);
              },
              activeColor: Colors.green,
            ),
          ),
        ],
      )
  );
  return objWidget;
}*/

/*Widget dynamicRadio({List<RadioModel> sampleData, void Function(int position) ontap, BuildContext radioContext, int val}) {
  print("here");
  print("sampleData " + sampleData[0].buttonText);
  print("sampleData " + sampleData.length.toString());
  Widget objWidget = Container(
    child: ListView.builder(
        itemCount: sampleData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return new InkWell(
            //highlightColor: Colors.red,
            splashColor: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(sampleData[index].buttonText),
                  leading: Radio(
                    value: index,
                    toggleable:true,
                    groupValue: val,
                    onChanged: (value) {
                      val = value;
                      ontap(val);
                    },
                    activeColor: Colors.green,
                  ),
                ),
             ],
            )
          );
        }),
  );
  return objWidget;
}*/

//kiruba
Widget dynamicRadio(
    {List<dynamicDropModel>? sampleData,
    void Function(int position, String ComponentId, String DISP_SEQ,
            String? parentField)?
        ontap,
    BuildContext? radioContext,
    List<MultipleRadioModel>? multipleRadioList,
    String? ComponentId,
    String? parentField}) {
  int val = -1;
  print("multipleRadioList values ${multipleRadioList!.length}");
  for (int i = 0; i < multipleRadioList.length; i++) {
    if (multipleRadioList[i].componentID == ComponentId) {
      val = multipleRadioList[i].value;
      print("multipleRadioList selected " +
          ComponentId! +
          ' ' +
          multipleRadioList[i].value.toString());
    }
  }

  Widget objWidget = Container(
    child: ListView.builder(
        itemCount: sampleData!.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        primary: true,
        itemBuilder: (context, index) {
          return InkWell(
              //highlightColor: Colors.red,
              splashColor: Colors.blueAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(sampleData[index].property_value),
                    leading: Radio(
                      value: index,
                      toggleable: true,
                      groupValue: val,
                      onChanged: (value) {
                        int selected = value as int;
                        ontap!(selected, ComponentId!,
                            sampleData[index].DISP_SEQ, parentField);
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                ],
              ));
        }),
  );
  return objWidget;
}

/*Widget dynamicRadio({List<RadioModel> sampleData, void Function(int position) ontap, BuildContext radioContext}) {
  print("here");
  print("sampleData " + sampleData[0].buttonText);
  print("sampleData " + sampleData.length.toString());
  Widget objWidget = Container(
    child: ListView.builder(
        itemCount: sampleData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return new InkWell(
            //highlightColor: Colors.red,
            splashColor: Colors.blueAccent,
            onTap: () {
              ontap(index);
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
            },
            child: new RadioItem(sampleData[index]),
          );
        }),
  );
  return objWidget;
}*/
Widget singlesearchDropdownDynamic(
    {List<DropDownModel?>? itemlist,
    String? selecteditem,
    String? hint,
    Function()? onClear,
    BuildContext? context,
    String? componentLabel,
    bool? AddCatalog,
    bool? ishint,
    String? ComponentId,
    Function(String?)? onChanged}) {
  List<DropdownMenuItem> dropdownlist = [];
  String selectedValue = '';
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i]!.ComponentId;
    dropdownitems.add(item);
  }

  if (ishint == null) {
    ishint = false;
  }
  Widget objWidget = Row(
    children: [
      Expanded(
        child: Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          )),
          child: Container(
            child: Card(
              elevation: 2,
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              )),
              child: DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItems: true,
                  showSearchBox: true,
                  items: dropdownitems,
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                    border: OutlineInputBorder(),
                  ),
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      labelText: "Search Option",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  onChanged: onChanged!,
                  selectedItem: !ishint ? hint : selecteditem),
            ),
          ),
        ),
        flex: 10,
      ),
      AddCatalog!
          ? Expanded(
              child: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    var compController = TextEditingController();
                    showDialog(
                        context: context!,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text('Add ${componentLabel!}'),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Form(
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: compController,
                                      decoration: InputDecoration(
                                        labelText: componentLabel,
                                        icon: Icon(Icons.new_label),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    onChanged('#${compController.text}');
                                    Navigator.pop(context);
                                    // your code
                                  })
                            ],
                          );
                        });
                  }),
              flex: 1,
            )
          : Container()
    ],
  );
  return objWidget;
}
/*
class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    print("here");
    print("iem sel  " + _item.buttonText);
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}*/

Widget multisearchDropdownDynamic(
    {List<DropdownMenuItem>? itemlist,
    List<MutipleDropDownModel>? selectedlist,
    Function(List<String>)? onChanged,
    String? componentId,
    String? Label}) {
  List<String> selectedITEMS = [];
  for (int i = 0; i < selectedlist!.length; i++) {
    if (componentId == selectedlist[i].ComponentId) {
      selectedITEMS = selectedlist[i].selected;
    }
  }

  print('selectedITEMS ${selectedITEMS.length}');
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  Widget objWidget = Container(
      child: Card(
          elevation: 2,
          color: Colors.green,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          )),
          child: DropdownSearch<String>.multiSelection(
              /*  clearButton: InkWell(
                child: Text(""),
              ),*/
              showClearButton: true,
              mode: Mode.BOTTOM_SHEET,
              showSelectedItems: true,
              showSearchBox: true,
              items: dropdownitems,
              dropdownSearchDecoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                hintText: Label,
                border: OutlineInputBorder(),
              ),
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                  labelText: "Search Option",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              onChanged: onChanged!,
              selectedItems: selectedITEMS)));
  return objWidget;
}

Widget txtfield_dynamicaphanumericcontroller(
    {String? intialVal,
    int? length,
    bool? initial,
    String? hint,
    required TextEditingController? txtcontroller,
    bool? focus,
    required String Position,
    String? componentType,
    String? sectionId,
    String? isMandatory,
    String? componentLabel,
    String? Type,
    String? componentID,
    List<ComponentModel>? componentidvalue,
    Function(String)? onChange}) {
  txtcontroller = TextEditingController();
  if (componentidvalue!.length > 0) {
    bool found = false;
    for (int v = 0; v < componentidvalue!.length; v++) {
      print(
          "txtArea value ${componentID!}<>${componentidvalue[v].componentid}");
      if (componentidvalue[v].componentid == componentID) {
        print("txtArea value ${componentID!}<>${componentidvalue[v].value}");

        txtcontroller!.text = componentidvalue![v].value;
        txtcontroller.selection = TextSelection.fromPosition(
            TextPosition(offset: txtcontroller.text.length));
        found = true;
      }
    }
    print("txtArea value $found");
    if (!found) {
      // txtcontroller = new TextEditingController();
      txtcontroller!.text = '';
      initial = true;
    }
  } else {
    //txtcontroller = new TextEditingController();
    txtcontroller!.text = '';
    initial = true;
  }

  //txtcontroller.selection = TextSelection.fromPosition(TextPosition(offset: txtcontroller.text.length));//getting slow
  if (initial!) {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
            enabled: focus,
            style: TextStyle(color: Colors.black87),
            controller: txtcontroller,
            onChanged: onChange,
            onFieldSubmitted: onChange,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                hintMaxLines: 2,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
                hintText: hint,
                filled: false),
            validator: (String? value) {
              return value!.contains('@') ? 'Do not use the @ char.' : null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z0-9 ]+$')),
              LengthLimitingTextInputFormatter(length),
            ]),
      ),
    ));
    return objWidget;
  } else {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
            enabled: focus,
            style: TextStyle(color: Colors.black87),
            controller: txtcontroller,
            initialValue: intialVal,
            onChanged: onChange,
            onFieldSubmitted: onChange,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
                hintText: hint,
                filled: false),
            validator: (String? value) {
              return value!.contains('@') ? 'Do not use the @ char.' : null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z0-9 ]+$')),
              LengthLimitingTextInputFormatter(length),
            ]),
      ),
    ));
    return objWidget;
  }
}

Widget txtfield_digitswithdecimalandController(
    {String? componentid,
    String? intialVal,
    int? length,
    int? minlength,
    bool? initial,
    String? hint,
    TextEditingController? txtcontroller,
    bool? focus,
    String? Position,
    String? componentType,
    String? sectionId,
    String? isMandatory,
    String? componentLabel,
    String? Type,
    List<ComponentModel>? componentidvalue,
    Function(String)? onChange}) {
  txtcontroller = TextEditingController();
  int? maxlength = length;
  length = length! + minlength! + 1;
  if (componentidvalue!.length > 0) {
    bool found = false;
    print("txtArea value ${componentidvalue.length}");
    for (int v = 0; v < componentidvalue!.length; v++) {
      print(
          "textfieldscontrollervalues ${componentid!}<>${componentidvalue[v].componentid}<>${componentidvalue[v].value}");
      if (componentidvalue[v].componentid == componentid) {
        print("txtArea value ${componentidvalue[v].value}");
        txtcontroller!.text = componentidvalue![v].value;
        txtcontroller.selection = TextSelection.fromPosition(
            TextPosition(offset: txtcontroller.text.length));
        found = true;
      }
      txtcontroller.addListener(() {
        String? controllervalue = txtcontroller?.text;
        print("controllervalue${controllervalue!}");
        List<String> values = controllervalue.split(".");
        if (values[0].length > maxlength!) {
          //txtcontroller!.text = componentidvalue![v].value;
          txtcontroller!.text = '0';
        } else if (values[1].length > 2) {
          txtcontroller!.text = '';
        }
      });
    }
    // if(!found){
    //   print("txtArea value not found");
    //   txtcontroller!.text = '';
    //   initial = true;
    // }
  } else {
    //txtcontroller = new TextEditingController();
    txtcontroller!.text = '';
    initial = true;
  }

  if (initial!) {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller!,
          //initialValue: intialVal!,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintMaxLines: 2,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            LengthLimitingTextInputFormatter(length ?? 100)
          ],
        ),
      ),
    ));
    return objWidget;
  } else {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller!,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            // FilteringTextInputFormatter.allow(RegExp(r'^\d{1,' + length.toString() + '}\.?\d{0,1}')),
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            LengthLimitingTextInputFormatter(length ?? 100)
          ],
        ),
      ),
    ));
    return objWidget;
  }
}

Widget txtfield_digitswithdecimalandController1(
    {String? componentid,
    String? intialVal,
    int? length,
    int? minlength,
    bool? initial,
    String? hint,
    TextEditingController? txtcontroller,
    bool? focus,
    String? Position,
    String? componentType,
    String? sectionId,
    String? isMandatory,
    String? componentLabel,
    String? Type,
    List<ComponentModel>? componentidvalue,
    Function(String)? onChange}) {
  txtcontroller = TextEditingController();
  int? maxlength = length;
  length = length! + minlength! + 1;
  if (componentidvalue!.length > 0) {
    bool found = false;
    print("txtArea value ${componentidvalue.length}");
    for (int v = 0; v < componentidvalue!.length; v++) {
      print(
          "textfieldscontrollervalues ${componentid!}<>${componentidvalue[v].componentid}<>${componentidvalue[v].value}");
      if (componentidvalue[v].componentid == componentid) {
        print("txtArea value ${componentidvalue[v].value}");
        txtcontroller!.text = componentidvalue![v].value;
        txtcontroller.selection = TextSelection.fromPosition(
            TextPosition(offset: txtcontroller.text.length));
        found = true;
      }
      txtcontroller.addListener(() {
        String? controllervalue = txtcontroller?.text;
        print("controllervalue${controllervalue!}");
        List<String> values = controllervalue.split(".");
        if (values[0].length > maxlength!) {
          //txtcontroller!.text = componentidvalue![v].value;
          txtcontroller!.text = '0';
        } else if (values[1].length > 2) {
          txtcontroller!.text = '';
        }
      });
    }
    // if(!found){
    //   print("txtArea value not found");
    //   txtcontroller!.text = '';
    //   initial = true;
    // }
  } else {
    //txtcontroller = new TextEditingController();
    txtcontroller!.text = '';
    initial = true;
  }

  if (initial!) {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller!,
          //initialValue: intialVal!,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintMaxLines: 2,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            LengthLimitingTextInputFormatter(length ?? 100)
          ],
        ),
      ),
    ));
    return objWidget;
  } else {
    Widget objWidget = Container(
        child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller!,
          onChanged: onChange,
          onFieldSubmitted: onChange,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: hint,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: <TextInputFormatter>[
            // FilteringTextInputFormatter.allow(RegExp(r'^\d{1,' + length.toString() + '}\.?\d{0,1}')),
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            LengthLimitingTextInputFormatter(length ?? 100)
          ],
        ),
      ),
    ));
    return objWidget;
  }
}

Widget signaturePad(SignatureController signatureController, ByteData img,
    String encode, Function() clearPressed, Function() savePressed) {
  Widget objWidget = Container(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          width: 300,
          height: 180,
          child: Signature(
            controller: signatureController,
            height: 140,
            width: 280,
            backgroundColor: Colors.white,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          height: 60,
          width: 300,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 100,
                height: 42,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1.0,
                  color: Color(0xff001e48),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    minWidth: 100,
                    height: 32,
                    color: Colors.red,
                    child: Text(
                      'Clear',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    onPressed: clearPressed,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 100,
                height: 42,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1.0,
                  color: Color(0xff001e48),
                  clipBehavior: Clip.antiAlias,
                  child: MaterialButton(
                    minWidth: 100,
                    height: 32,
                    color: Colors.blue,
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    onPressed: savePressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  return objWidget;
}

Widget multipleImage_picker_dynamic(
    {Function(String ComponentID)? onPressed,
    List<MultipleImageModel>? imagelist,
    BuildContext? dialogContext,
    ondelete,
    String? ComponentID}) {
  List<File> imageFileList = [];
  for (int i = 0; i < imagelist!.length; i++) {
    if (imagelist[i].componentID == ComponentID) {
      File _beneficiaryimage = imagelist[i].image;
      imageFileList.add(_beneficiaryimage);
    }
  }

  Widget objWidget = Container(
      child: Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          onPressed: () => onPressed!(ComponentID!),
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
        ),
      ),
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (_, index) => InkWell(
            onLongPress: () async {
              var alertStyle = AlertStyle(
                animationType: AnimationType.shrink,
                overlayColor: Colors.black87,
                isCloseButton: false,
                isOverlayTapDismiss: false,
                titleStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                animationDuration: Duration(milliseconds: 400),
              );
              Alert(
                  context: dialogContext!,
                  style: alertStyle,
                  title: 'Delete',
                  desc: 'Are you sure want to delete ?',
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        ondelete(index);
                        Navigator.pop(dialogContext);
                      },
                      color: Colors.green,
                    )
                  ]).show();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              )),
              elevation: 3,
              color: Colors.white,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.file(
                      imageFileList[index],
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          itemCount: imageFileList.length,
        ),
      ),
    ],
  ));
  return objWidget;
}

Widget multipleImage_picker(
    {Function()? onPressed,
    List<File>? imagelist,
    BuildContext? dialogContext,
    ondelete,
    String? componentID,
    int? indexno,
    List? imageComponentIdlist}) {
  print("list $imageComponentIdlist");
  Widget objWidget = Container(
      child: Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: '',
          backgroundColor: appDatas.primaryColor,
          onPressed: onPressed,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
        ),
      ),
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (_, index) => InkWell(
            onLongPress: () async {
              var alertStyle = AlertStyle(
                animationType: AnimationType.shrink,
                overlayColor: Colors.black87,
                isCloseButton: false,
                isOverlayTapDismiss: false,
                titleStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                animationDuration: Duration(milliseconds: 400),
              );
              Alert(
                  context: dialogContext!,
                  style: alertStyle,
                  title: 'Delete',
                  desc: 'Are you sure want to delete ?',
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        ondelete(index);
                        Navigator.pop(dialogContext);
                      },
                      color: Colors.green,
                    )
                  ]).show();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              )),
              elevation: 3,
              color: Colors.white,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.file(
                      imagelist![index],
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          itemCount: imagelist!.length,
        ),
      ),
    ],
  ));
  return objWidget;
}

Widget img_picker(
    {String? label,
    Function()? onPressed,
    filename,
    imagepreviewbtn()?,
    ondelete}) {
  Widget objWidget = Container(
      child: Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: '',
          backgroundColor: Colors.green,
          onPressed: onPressed,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
        ),
      ),
      VerticalDivider(width: 10.0),
      Center(
        child: filename == null
            ? Text('')
            : InkWell(
                onTap: () async {
                  imagepreviewbtn!();
                }, // Handle your callback
                child: Container(
                    height: 200.0,
                    width: 200.0,
                    child: Image.file(
                      filename,
                    )),
              ),
      ),
      VerticalDivider(width: 10.0),
      Container(
        child: filename == null
            ? Text('')
            : Column(children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ondelete();
                  },
                ),
              ]),
      )
    ],
  ));
  return objWidget;
}

Widget familyInfo(
    String hint1,
    String hint2,
    Color color,
    double fontsize,
    bool underline,
    TextEditingController txtcontroller,
    TextEditingController controller2) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 15),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hint1,
                    style: TextStyle(
                      fontSize: fontsize,
                      color: color,
                      decoration: underline ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                Container(
                    child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: txtcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: hint1,
                      filled: false),
                  validator: (String? value) {
                    return value!.contains('@') ? 'Do not use the @ char.' : '';
                  },
                )),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hint2,
                    style: TextStyle(
                      fontSize: fontsize,
                      color: color,
                      decoration: underline ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                Container(
                    child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: controller2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: hint2,
                      filled: false),
                  validator: (String? value) {
                    return value!.contains('@') ? 'Do not use the @ char.' : '';
                  },
                )),
              ],
            ),
          ),
        )
      ],
    ),
  );
  return objWidget;
}

Widget btn_double_dynamic(
    String? txt1,
    String? txt2,
    Color? backcolor,
    Color? txtcolor,
    double? fontsize,
    Alignment? centerRight,
    double? margin,
    btnSubmit()) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin!),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: Colors.orange,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      SizedBox(width: 10.0),
      MaterialButton(
        color: backcolor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          btnSubmit();
        },
      ),
    ]),
  );
  return objWidget;
}

Widget btn_double_submit(
    String? txt1,
    String? txt2,
    Color? backcolor,
    Color? txtcolor,
    double? fontsize,
    Alignment? centerRight,
    double? margin,
    btnSubmit(),
    btnCancel()) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin!),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: Colors.orange,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          btnCancel();
        },
      ),
      SizedBox(width: 10.0),
      MaterialButton(
        color: backcolor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          btnSubmit();
        },
      ),
    ]),
  );
  return objWidget;
}

Widget radio_dynamic(
    {Map<String, String>? map,
    String? selectedKey,
    Function(String?)? onChange}) {
  Widget objWidget = Container(
    child: Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          CupertinoRadioChoice(
              selectedColor: Colors.green,
              choices: map!,
              onChange: onChange!,
              initialKeyValue: selectedKey)
        ],
      ),
    ),
  );
  return objWidget;
}

errordialog(dialogContext, String title, String description) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle:
        TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: dialogContext,
      style: alertStyle,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
          },
          color: Colors.green,
        )
      ]).show();
}

Widget addequipmentlist(
    {List<EquipmentModel>? equipment,
    List<DropdownMenuItem>? euipmeitems,
    List<DropdownMenuItem>? animalhouselist}) {
  Widget objWidget = Container(
    child: Column(children: <Widget>[
      Container(
          alignment: Alignment.centerLeft,
          child: Text("Equipment Details",
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ))),
      ListView.builder(
        shrinkWrap: true,
        itemCount: equipment == null ? 1 : equipment.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            // return the header
            return Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        "Equipment Type",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Count",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    flex: 2,
                  ),
                ],
              ),
            );
          }
          index -= 1;
          // return row
          var row = equipment![index];
          return Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        equipment[index].equipName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        equipment[index].equipCount,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
    ]),
  );
  return objWidget;
}

Widget multisearchDropdownHint(
    {String? hint,
    List<DropdownMenuItem>? itemlist,
    List<String>? selectedlist,
    Function(List<String>)? onChanged}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.green,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: DropdownSearch<String>.multiSelection(
        mode: Mode.BOTTOM_SHEET,
        showSelectedItems: true,
        showSearchBox: true,
        items: dropdownitems,
        dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            labelText: hint,
            prefixIcon: Icon(Icons.search),
          ),
        ),
        onChanged: onChanged!,
        selectedItems: selectedlist!),
  ));
  return objWidget;
}

Widget multisearchDropdown(
    {List<DropdownMenuItem>? itemlist,
    List<String>? selectedlist,
    Function(List<String?>)? onChanged,
    String? Label}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.green,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: DropdownSearch<String>.multiSelection(
        mode: Mode.BOTTOM_SHEET,
        showSelectedItems: true,
        showSearchBox: true,
        items: dropdownitems,
        dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          border: OutlineInputBorder(),
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            labelText: "Search Option",
            prefixIcon: Icon(Icons.search),
          ),
        ),
        onChanged: onChanged!,
        selectedItems: selectedlist!),
  ));
  return objWidget;
}

Widget singlesearchDropdown(
    {List<DropdownMenuItem>? itemlist,
    String? selecteditem,
    String? hint,
    Function()? onClear,
    Function(String?)? onChanged}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i].value;
    dropdownitems.add(item);
  }
  bool ishint = false;
  if (selecteditem == '') {
    ishint = true;
  }
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSelectedItems: true,
          showSearchBox: true,
          items: dropdownitems,
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: ishint ? hint : selecteditem),
    ),
  );
  return objWidget;
}

Widget DropdownDynamic(
    {List<DropDownModel?>? itemlist,
    DropdownModel? selecteditem,
    String? hint,
    Function()? onClear,
    BuildContext? context,
    String? componentLabel,
    bool? AddCatalog,
    bool? ishint,
    String? ComponentId,
    Function(DropdownModel?)? onChanged}) {
  List<DropdownModel>? dropdownlist = [];
  String selectedValue = '';
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemlist[i]!.ComponentId;
    if (itemlist[i]!.ComponentId == ComponentId) {
      dropdownlist = itemlist[i]!.dropdownitem;
    }
    // dropdownitems.add(item);
  }
  if (selecteditem == null) {
    selecteditem = DropdownModel(hint!, hint);
  }
  if (ishint == null) {
    ishint = false;
  }
  Widget objWidget = Row(
    children: [
      Expanded(
        child: Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          )),
          child: Container(
            child: Card(
              elevation: 2,
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              )),
              child: DropdownSearch<DropdownModel>(
                  mode: Mode.BOTTOM_SHEET,
                  showSearchBox: true,
                  items: dropdownlist,
                  dropdownBuilder: (context, selectedItem) => Container(
                        child: GestureDetector(
                          child: Text(
                            selecteditem!.name,
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0),
                          ),
                          // onTap: onClear,
                        ),
                      ),
                  popupItemBuilder: (context, item, isSelected) => Container(
                        //margin: EdgeInsets.all(2),
                        padding: EdgeInsets.all(15),
                        color: Colors.white, //green[50],
                        child: Text(
                          item.name,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                    border: OutlineInputBorder(),
                  ),
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      labelText: "Search Option",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  onChanged: onChanged!,
                  selectedItem: selecteditem),
            ),
          ),
        ),
        flex: 10,
      ),
      AddCatalog!
          ? Expanded(
              child: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    var compController = TextEditingController();
                    showDialog(
                        context: context!,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text('Add ${componentLabel!}'),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Form(
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: compController,
                                      decoration: InputDecoration(
                                        labelText: componentLabel,
                                        icon: Icon(Icons.new_label),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    onChanged(DropdownModel(
                                        '#${compController.text}',
                                        '#${compController.text}'));
                                    Navigator.pop(context);
                                    // your code
                                  })
                            ],
                          );
                        });
                  }),
              flex: 1,
            )
          : Container()
    ],
  );
  return objWidget;
}

Widget checkbox_dynamic(
    {String? label,
    bool? checked,
    Function(bool?)? onChange,
    String? ComponentId,
    List<CheckboxModel?>? selectedCheckbox}) {
  bool selected = false;
  for (int i = 0; i < selectedCheckbox!.length; i++) {
    if (ComponentId == selectedCheckbox[i]!.ComponentId) {
      selected = selectedCheckbox[i]!.selected;
    }
  }

  Widget objWidget = Container(
    child: Row(
      children: <Widget>[
        Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.green,
            value: selected,
            onChanged: onChange),
        Text(
          label!,
          style: TextStyle(color: Colors.green),
        ),
      ],
    ),
  );
  return objWidget;
}
/*Widget singlesearchDropdown(
    {List<DropdownMenuItem> itemlist,
      String selecteditem,
      String hint,
      Function() onClear,
      Function(String) onChanged}) {
  Widget objWidget = new Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: SearchableDropdown.single(
        style: TextStyle(color: Colors.black),
        items: itemlist,
        value: selecteditem,
        hint: hint,
        onClear: onClear,
        searchHint: hint,
        onChanged: onChanged,
        isExpanded: true,
      ),
    ),
  );
  return objWidget;
}*/

Widget singlesearchDropdownTest(
    {List<DropdownMenuItem>? itemlist,
    List<String>? itemName,
    String? selecteditem,
    String? hint,
    Function()? onClear,
    Function(String?)? onChanged}) {
  List<String> dropdownitems = [];
  for (int i = 0; i < itemlist!.length; i++) {
    String item = itemName![i];
    dropdownitems.add(item);
  }
  bool ishint = false;
  if (selecteditem == '') {
    ishint = true;
  }
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<String>(
          mode: Mode.BOTTOM_SHEET,
          showSelectedItems: true,
          showSearchBox: true,
          items: dropdownitems,
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: ishint ? hint : selecteditem),
    ),
  );
  return objWidget;
}

Widget singlesearchdynamic(
    {List<DropdownModel>? itemlist,
    DropdownModel? selecteditem,
    String? hint,
    Function()? onClear,
    Function(DropdownModel?)? onChanged}) {
  if (selecteditem == null) {
    selecteditem = DropdownModel(hint!, hint);
  }
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<DropdownModel>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          items: itemlist,
          filterFn: (instance, filter) {
            if (instance!.name.toLowerCase().contains(filter!.toLowerCase())) {
              print(filter);
              return true;
            } else {
              return false;
            }
          },
          dropdownBuilder: (context, selectedItem) => Container(
                child: GestureDetector(
                  child: Text(
                    selecteditem!.name,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  onTap: onClear,
                ),
              ),
          popupItemBuilder: (context, item, isSelected) => Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Text(
                  item.name,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem),
    ),
  );
  return objWidget;
}

/*Widget DropDownWithModel(
    {List<DropdownModel>? itemlist,
    DropdownModel? selecteditem,
    String? hint,
    Function()? onClear,
    Function(DropdownModel?)? onChanged}) {
  // bool ishint = false;
  // if (selecteditem == '') {
  //   ishint = true;
  // }
  print('selecteditem' + selecteditem.toString());
  if (selecteditem == null) {
    selecteditem = new DropdownModel(hint!, hint);
  }
  Widget objWidget =  Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<DropdownModel>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          items: itemlist,
          dropdownBuilder: (context, selectedItem) => Container(
                child: GestureDetector(
                  child: Text(
                    selecteditem!.name,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  onTap: onClear,
                ),
              ),
          popupItemBuilder: (context, item, isSelected) => Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Text(
                  item.name,
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(

            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem!),
    ),
  );
  return objWidget;
}*/

Widget DropDownWithModel(
    {List<DropdownModel>? itemlist,
    DropdownModel? selecteditem,
    String? hint,
    Function()? onClear,
    Function(DropdownModel?)? onChanged}) {
  selecteditem ??= DropdownModel(hint!, hint);
  Widget objWidget = Container(
    child: Card(
      elevation: 2,
      color: Colors.green,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      )),
      child: DropdownSearch<DropdownModel>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          items: itemlist,
          filterFn: (instance, filter) {
            if (instance!.name.toLowerCase().contains(filter!.toLowerCase())) {
              print(filter);
              return true;
            } else {
              return false;
            }
          },
          dropdownBuilder: (context, selectedItem) => Container(
                child: Text(
                  selecteditem!.name,
                  style: const TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
          popupItemBuilder: (context, item, isSelected) => Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Text(
                  item.name,
                  style: const TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
          dropdownSearchDecoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          searchFieldProps: TextFieldProps(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              labelText: "Search Option",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          onChanged: onChanged!,
          selectedItem: selecteditem),
    ),
  );
  return objWidget;
}

Widget addinputlist({
  List<InputInformation>? inputlist,
}) {
  Widget objWidget = Container(
    child: Column(children: <Widget>[
      Container(
          alignment: Alignment.center,
          child: Text("Return Products",
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ))),
      ListView.builder(
        shrinkWrap: true,
        itemCount: inputlist == null ? 1 : inputlist.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            // return the header
            return Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        "Quantity",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Price",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "Amount",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  )
                ],
              ),
            );
          }
          index -= 1;
          // return row
          var row = inputlist![index];
          return Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        inputlist[index].quantity,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        inputlist[index].price.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        inputlist[index].amount.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                        icon: Icon(Icons.border_color, color: Colors.black26),
                        onPressed: () {
                          confirmationInput(context, inputlist[index]);
                        },
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.black26),
                        onPressed: () {
                          //confirmationPopup(context,banklist[index]);
                        },
                      ),
                      alignment: Alignment.center,
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
    ]),
  );
  return objWidget;
}

Widget radio_dynamic_column(
    {Map<String, String>? map,
    String? selectedKey,
    Function(String?)? onChange}) {
  Widget objWidget = Container(
    child: Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),
          CupertinoRadioChoice(
              notSelectedColor: Colors.black12,
              selectedColor: Colors.green,
              choices: map!,
              onChange: onChange!,
              initialKeyValue: selectedKey)
        ],
      ),
    ),
  );
  return objWidget;
}

confirmationInput(dialogContext, InputInformation inputlist) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: dialogContext,
      style: alertStyle,
      title: "Update Return Products",
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: inputlist.quantity,
              ),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: inputlist.price.toString(),
              ),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: inputlist.amount.toString(),
              ),
              textInputAction: TextInputAction.next,
            ),
            /*TextField(
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: inputlist.ifsc_code,
              ),
              textInputAction: TextInputAction.done,
            ),*/
          ],
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          //onPressed:btncancel ,
          onPressed: () {
            //setState(() {
            Navigator.pop(dialogContext);
            //});
          },
          color: Colors.deepOrange,
        ),
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          //onPressed:btnok,
          onPressed: () {
            //setState(() {
            Navigator.pop(dialogContext);
            //});
          },
          color: Colors.green,
        )
      ]).show();
}

Widget btn_double_submit_cancel(
    String txt1,
    String txt2,
    Color backcolor,
    Color txtcolor,
    double fontsize,
    Alignment centerRight,
    double margin,
    btnSubmit(),
    btnCancel()) {
  Widget objWidget = Container(
    alignment: centerRight,
    margin: EdgeInsets.only(top: margin),
    child: Wrap(children: <Widget>[
      MaterialButton(
        color: Colors.orange,
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          btnCancel();
        },
      ),
      SizedBox(width: 10.0),
      MaterialButton(
        color: backcolor,
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          btnSubmit();
        },
      ),
    ]),
  );
  return objWidget;
}

Widget RecordWidget(
    String label, bool _isRecording, bool _isPaused, int _recordDuration) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Text(label),
    ),
  ));
  return objWidget;
}

Widget singleInfo(
  String hint1,
  Color color,
  double fontsize,
  bool underline,
  TextEditingController txtcontroller,
) {
  Widget objWidget = Container(
    margin: EdgeInsets.only(top: 15),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hint1,
                    style: TextStyle(
                      fontSize: fontsize,
                      color: color,
                      decoration: underline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                    child: TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: txtcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      hintText: hint1,
                      filled: false),
                  validator: (String? value) {
                    return value!.contains('@') ? 'Do not use the @ char.' : '';
                  },
                )),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  return objWidget;
}

Widget txtfieldAllowTwoDecimal(String label,
    TextEditingController? txtcontroller, bool focus, int length) {
  Widget objWidget = Container(
      child: Card(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    )),
    child: Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TextFormField(
          enabled: focus,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black87),
          controller: txtcontroller,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                color: Colors.black38,
              ),
              hintText: label,
              filled: false),
          validator: (String? value) {
            return value!.contains('@') ? 'Do not use the @ char.' : null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
            LengthLimitingTextInputFormatter(length),
          ]),
    ),
  ));
  return objWidget;
}

Widget fileUpload(
    {String? label,
    Function()? onPressed,
    filename,
    ondelete,
    String? uploadFileName}) {
  AssetImage assetimage = AssetImage('images/docs.png');
  Widget objWidget = Container(
      child: Row(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.green,
          onPressed: onPressed,
          tooltip: 'Pick Image',
          child: Icon(
            Icons.attach_file,
            color: Colors.white,
          ),
        ),
      ),
      VerticalDivider(width: 10.0),
      Center(
          child: filename == null
              ? Text("")
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 200.0,
                    child: Center(
                      child: Text(
                        uploadFileName!,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                )),
      VerticalDivider(width: 10.0),
      Container(
        child: filename == null
            ? Text('')
            : Column(children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ondelete();
                  },
                ),
              ]),
      )
    ],
  ));
  return objWidget;
}

Container Cus_submit_Button(
    {void Function()? submit, void Function()? cancel}) {
  return Container(
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(3),
            child: RaisedButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: cancel,
              color: Colors.redAccent,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(3),
            child: RaisedButton(
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: submit,
              color: Colors.green,
            ),
          ),
        ),
      ],
    ),
  );
}

class YearSelector1 extends StatelessWidget {
  const YearSelector1({
    Key? key,
    required this.context,
    required this.selectYear,
    required this.onConfirm,
    required this.selectedDate,
    required this.futureYear,
  }) : super(key: key);
  final BuildContext context;
  final Function(DateTime?) onConfirm;
  final DateTime? selectedDate;

  final String? selectYear;
  final int futureYear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Select Year"),
                  content: SizedBox(
                    // Need to use container to add size constraint.
                    width: 300,
                    height: 300,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                      )),
                      child: YearPicker(
                        firstDate: DateTime(DateTime.now().year - 100),
                        lastDate: DateTime(DateTime.now().year + futureYear),
                        initialDate: DateTime.now(),
                        // save the selected date to _selectedDate DateTime variable.
                        // It's used to set the previous selected date when
                        // re-showing the dialog.
                        selectedDate: selectedDate ?? DateTime.now(),
                        onChanged: (a) {
                          onConfirm(a);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.calendar_today),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  selectYear ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1.0,
          height: 2.0,
          color: Colors.green,
        )
      ],
    );
  }
}

class DropdownModelClass {
  String name, value;

  DropdownModelClass(this.name, this.value);
}

class DropdownModel {
  String name, value;

  DropdownModel(this.name, this.value);
}

class DropdownModel1 {
  String name, value, value1;

  DropdownModel1(this.name, this.value, this.value1);
}
