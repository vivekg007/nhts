import 'package:ucda/commonLang/translateModalClass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/transactionsummary.dart';


class TranslateFun {

  static Map<String,dynamic> langList = {};


  static Future<List<LanguageModal>> translate() async{
      String? Lang = 'en';
      List<LanguageModal> list =[];

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Lang = "en";
        if(Lang!.isEmpty){
          Lang = 'en';
        }
      } catch (e) {
        Lang = 'en';
      }


      String qry =
          'select * from labelNamechange where tenantID =  \'ucda\' and lang = \'${Lang!}\'';
      print('Lanquery' + qry);
      List transList = await db.RawQuery(qry);
      print('transList122' + transList.toString());

      list = transList.isNotEmpty ? transList.map((c) => LanguageModal.fromMap(c)).toList() : [];

      print('listLanquery' + list.toString());

      for(int i = 0 ; i < list.length ; i++){
        String? className = list[i].className;
        String? labelName = list[i].labelName;

        langList.addAll({className! : labelName});

      }

      print('langList' + langList.toString());


      return list;

  }

}