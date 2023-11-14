import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import 'dynamicScreengetdata.dart';

class SurveyMenu extends StatefulWidget {
  const SurveyMenu({Key? key}) : super(key: key);

  @override
  State<SurveyMenu> createState() => _PostHarvestMenuState();
}

class _PostHarvestMenuState extends State<SurveyMenu> {
  String phyQuaCheck = "Physical Quality Check",
      harvest = "Harvest",
      postHarvest = "Post Harvest";

  String agentType = "";

  List<Menus> menu = [];

  List<Menus> menu1 = [];

  List<Menus> menus = [];

  List<Map>? dynamiccomponentMenus = [];



  @override
  void initState() {
    super.initState();
    translator();
  }

  void translator() async {
    String? Lang;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Lang = prefs.getString("langCode");
      print('langCode' + Lang!);
    } catch (e) {
      Lang = 'en';
      print('langCode' + Lang);
    }

    String qry =
        'select * from labelNamechange where tenantID =  \'griffith\' and lang = \'' +
            Lang! +
            '\'';

    List transList = await db.RawQuery(qry);
    print('farmerenrollmentlist :' + transList.toString());
    for (int i = 0; i < transList.length; i++) {
      String? classname = transList[i]['className'];
      String? labelName = transList[i]['labelName'];

      switch (classname) {
        case 'phyQuaCheck':
          setState(() {
            phyQuaCheck = labelName!;
          });
          break;
        case 'harvest':
          setState(() {
            harvest = labelName!;
          });
          break;
        case 'postHarvest':
          setState(() {
            postHarvest = labelName!;
          });
          break;
      }
    }
    menuConfiguration();
  }

  Future<void> menuConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    agentType = prefs.getString("agentType")!;
    print('agentType' + agentType);

    //dynamic menu

    String? Lang = 'en';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Lang = prefs.getString("langCode");
    } catch (e) {
      Lang = 'en';
    }
    print("Lang code menu " + Lang!);
    // dynamiccomponentMenus = [];
    // menus = [];
    //
    // String qrymenulist =
    //     'select dc.menuId,IFNULL(dl.langValue,dc.menuName) as menuName,dc.iconClass,dc.menuOrder,dc.txnTypeIdMenu,dc.menucommonClass,' +
    //         ' dc.entity,dc.seasonFlag,dc.agentType from dynamiccomponentMenu as dc left join dynamiccomponentLanguage ' +
    //         'as dl on dc.menuId=dl.componentID and dl.langCode= \'' +
    //         Lang +
    //         '\' and dc.agentType= \'' +
    //         agentType +
    //         '\' and dc.entity = "1" ';
    // dynamiccomponentMenus = await db.RawQuery(qrymenulist);
    //
    // print("dynamiccomponentMenus!.length Lang menu " +
    //     dynamiccomponentMenus!.length.toString());
    // print("dynamiccomponentMenus " + dynamiccomponentMenus!.toString());

    try {
      menu1.clear();
      setState(() async {
        String buyingCenter = agentType;
        List dyMenu = await db.RawQuery(
            'select  * from dynamiccomponentMenu where agentType LIKE "%$buyingCenter%" and is_survey ="1" ');
        print("dymenu:" + dyMenu.length.toString());
        switch (agentType) {

          case "02": //ceo
            for (int i = 0; i < dyMenu.length; i++) {
              setState(() {
                menu1.add(Menus(
                    menuName: dyMenu[i]['menuName'],
                    menuImage: "images/survey.png",
                    menutxnId: dyMenu[i]['txnTypeIdMenu']));
              });

            }

            break;

          case "03": //ceo
            for (int i = 0; i < dyMenu.length; i++) {
              setState(() {
                menu1.add(Menus(
                    menuName: dyMenu[i]['menuName'],
                    menuImage: "images/survey.png",
                    menutxnId: dyMenu[i]['txnTypeIdMenu']));
              });

            }

            break;
          case "04": //cto
            for (int i = 0; i < dyMenu.length; i++) {
            setState(() {
              menu1.add(Menus(
                  menuName: dyMenu[i]['menuName'],
                  menuImage:"images/survey.png",
                  menutxnId: dyMenu[i]['txnTypeIdMenu']));
            });


            }
            break;
          case "05": //vca
            for (int i = 0; i < dyMenu.length; i++) {
              setState(() {
                menu1.add(Menus(
                    menuName: dyMenu[i]['menuName'],
                    menuImage: "images/survey.png",
                    menutxnId: dyMenu[i]['txnTypeIdMenu']));
              });

            }

            break;

          case "06": //ceo
            for (int i = 0; i < dyMenu.length; i++) {
              setState(() {
                menu1.add(Menus(
                    menuName: dyMenu[i]['menuName'],
                    menuImage: "images/survey.png",
                    menutxnId: dyMenu[i]['txnTypeIdMenu']));
              });

            }

            break;

          case "08": //ceo
            for (int i = 0; i < dyMenu.length; i++) {
              setState(() {
                menu1.add(Menus(
                    menuName: dyMenu[i]['menuName'],
                    menuImage: "images/survey.png",
                    menutxnId: dyMenu[i]['txnTypeIdMenu']));
              });

            }

            break;

        }
      });
    } catch (e) {
      //  toast(e.toString());
    }
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
            "Survey",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (_, index) => InkWell(
                        onTap: () async {
                          String menutxnId = menu1[index].menutxnId!;
                          String menuName = menu1[index].menuName!;
                          if (agentType == "03") {
                            switch (index) {
                             default:
                               Navigator.of(context).push(
                                   MaterialPageRoute(
                                       builder:
                                           (BuildContext context) =>
                                           dynamicScreengetdata(
                                               menuName,
                                               menutxnId)));
                               break;
                            }
                          }else if (agentType == "04") {
                            switch (index) {
                              default:
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext context) =>
                                            dynamicScreengetdata(
                                                menuName,
                                                menutxnId)));
                                break;
                            }
                          }else if (agentType == "05") {
                            switch (index) {
                              default:
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext context) =>
                                            dynamicScreengetdata(
                                                menuName,
                                                menutxnId)));
                                break;
                            }
                          }else if (agentType == "06") {
                            switch (index) {
                              default:
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext context) =>
                                            dynamicScreengetdata(
                                                menuName,
                                                menutxnId)));
                                break;
                            }
                          }else if (agentType == "08") {
                            switch (index) {
                              default:
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext context) =>
                                            dynamicScreengetdata(
                                                menuName,
                                                menutxnId)));
                                break;
                            }
                          }else if (agentType == "02") {
                            switch (index) {
                              default:
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext context) =>
                                            dynamicScreengetdata(
                                                menuName,
                                                menutxnId)));
                                break;
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              )),
                          elevation: 3,
                          color: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  menu1[index].menuImage!,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    menu1[index].menuName!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: menu1.length,
                    ),
                  ),
                  flex: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Menus {
  String? menuName;
  String? menuImage;
  String? menutxnId;

  Menus({this.menuName, this.menuImage, this.menutxnId});
}
