





import 'dart:async';

import 'package:abzeno/page_auth.dart';
import 'package:abzeno/page_check.dart';
import 'package:abzeno/page_intoduction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'Helper/app_helper.dart';
import 'Helper/app_link.dart';
import 'Helper/page_route.dart';
import 'dart:io' show Platform;

class PageFirstLoad extends StatefulWidget {
  final String getBahasa;
  final String getTokenMe;
  const PageFirstLoad(this.getBahasa,this.getTokenMe);
  @override
  _PageFirstLoad createState() => _PageFirstLoad();
}



class _PageFirstLoad extends State<PageFirstLoad> {

  String versionVal = '...';
  String codeVal = '...';
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      versionVal = version;
      codeVal = code;
    });
  }

  getSession() async {
    await AppHelper().getSession().then((value){
      setState(() {
        if(value[0] == '' || value[0] == null) {
          Navigator.pushReplacement(context, ExitPage(page: Introduction(widget.getTokenMe)));
        } else {
          if(Platform.isAndroid) {
            if(value[25].toString() == '' || value[25].toString() == null || value[25].toString() == "0" || value[25].toString() == "null") {
              Navigator.pushReplacement(context, ExitPage(page: PageCheck("",widget.getTokenMe)));
            } else{
              Navigator.pushReplacement(context, ExitPage(page: PageAuth(widget.getTokenMe,value[24])));
            }
          } else {
            Navigator.pushReplacement(context, ExitPage(page: PageCheck("",widget.getTokenMe)));
          }

        }
      });
    });
  }

  String getSpecialday_name = '1';
  String getSpecialday_splashimage = '0';
  getSpecialDay() async {
    await AppHelper().getSpecialDay().then((value) {
      setState(() {
        getSpecialday_name = value[0];
        getSpecialday_splashimage = value[3];
      });
    });
  }

  getData() async {
      // await getSpecialDay();
      await getVersion();
      await getSession();
  }

  void initState() {
    super.initState();
    getData();


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        body:
        Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
        )
    ), onWillPop: onWillPop);
  }

  bool shouldPop = true;
  Future<bool> onWillPop() async {
    //Navigator.pop(context);
    return shouldPop;
  }


}