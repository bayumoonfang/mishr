

import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Notification/S_HELPER/m_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
class PageDetailNotification extends StatefulWidget{
  final String getTittle;
  final String getMessage;
  final String getDate;
  final String getMessageID;
  const PageDetailNotification(this.getTittle, this.getMessage, this.getDate, this.getMessageID);
  @override
  _PageDetailNotification createState() => _PageDetailNotification();
}


class _PageDetailNotification extends State<PageDetailNotification> {

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  _read_notif() async {
    EasyLoading.show(status: "Loading...");
    await m_notification().notification_read(widget.getMessageID).then((value){
      if(value[0] == 'ConnInterupted'){
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...");
        return false;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getSettings();
    _read_notif();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Detail Activity", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 25,right: 25,top: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(widget.getTittle, style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(widget.getDate, style: GoogleFonts.workSans(fontSize: 13,color: Colors.black),),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Divider(height: 5,),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text(widget.getMessage, style: GoogleFonts.workSans(fontSize: 14,color: Colors.black),),
              ),
            )
          ],
        ),
      ),

    ), onWillPop: onWillPop);
  }

  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}