



import 'dart:async';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_notificationspecific.dart';
import 'package:abzeno/Request%20Attendance/page_reqattendance.dart';
import 'package:abzeno/Time%20Off/ARCHIVED/page_myapproval.dart';
import 'package:abzeno/page_home.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'S_HELPER/g_reqattend.dart';



class PageReqAttendanceHome extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getEmail;
  const PageReqAttendanceHome(this.getKaryawanNo, this.getKaryawanNama, this.getEmail);
  @override
  _PageReqAttendanceHome createState() => _PageReqAttendanceHome();
}

class _PageReqAttendanceHome extends State<PageReqAttendanceHome> with SingleTickerProviderStateMixin {
  late TabController controller;


  String getNotifCountme = "0";
  getNotif() async {
    await AppHelper().getSpecificNotifCount("2").then((value){
      setState(() {
        getNotifCountme = value[0];
      });});
  }


  String getBahasa = "1";
  getSettings() async {
    //========================================
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }


  loadData() async {
    await getSettings();
    await getNotif();
    EasyLoading.dismiss();
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      //g_reqattend().getData_AttendRequest(widget.getKaryawanNo, filter, filter2, filter3, "Request");
      loadData();
    });
  }


  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    loadData();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }





  showInfoDialog(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    Widget cancelButton = TextButton(
      child: Text(getBahasa.toString() == "1"? "TUTUP" : "CLOSE",style: GoogleFonts.lexendDeca(color: Colors.blue,
          fontSize: textScale.toString() == '1.17' ? 13 : 15),),
      onPressed:  () {Navigator.pop(context);},
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Informasi" :"Information",
        style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 16 : 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Container(
          height: 65,
          child : Column(
            children: [
              Text("Ini adalah adalah menu untuk melihat daftar pengajuan dan approval untuk kehadiran anda",
                style: GoogleFonts.nunitoSans(fontSize: textScale.toString() == '1.17' ? 13 : 15),textAlign:
              TextAlign.left,),
            ],
          )
      ),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        //shape: Border(bottom: BorderSide(color: Colors.red)),
       // backgroundColor: HexColor("#3a5664"),
        title: Text("Pengajuan Kehadiran", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
        actions: [
          getNotifCountme != '0' ?
          Container(width: 50, height: 60, child :
          badges.Badge(
            showBadge: true,
            position: badges.BadgePosition.topStart(top: 9,start: 10),
            badgeContent: Text(getNotifCountme.toString(),style: GoogleFonts.nunitoSans(color:Colors.white,fontSize: 9),),
              badgeAnimation: badges.BadgeAnimation.scale (
                animationDuration: Duration(seconds: 1),
                loopAnimation: false,
              ),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                badgeColor: Colors.red,
                padding: EdgeInsets.all(5),
                elevation: 0,
              ),
            child:
            Padding(
                padding: EdgeInsets.only(top: 17.5),
                child: InkWell(
                    child : FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push(context, ExitPage(page: PageSpecificNotification(widget.getEmail, "2"))).then(onGoBack);
                    },
                )))) :
      Container(width: 50, height: 60, child :
          Padding(
            padding: EdgeInsets.only(top: 17,right: 24,left: 18),
            child: FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),)),
      Container(
        width: 50,
        height: 50,
        child :
          Padding(
            padding: EdgeInsets.only(top: 17,right: 22),
            child: InkWell(
              child : FaIcon(FontAwesomeIcons.circleInfo,color: HexColor("#535967"),size: 22,),
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                showInfoDialog(context);
              },
            ),))
        ],
        bottom: new TabBar(
          indicatorColor: Colors.black,
          controller: controller,
          labelColor: Colors.black,
          labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
          unselectedLabelStyle: GoogleFonts.varelaRound(fontSize: 13,color: Colors.black),
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            new Tab(text: "My Request"),
            new Tab(text: "Approval"),
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          RequestAttendance(widget.getKaryawanNo, "Request"),
          RequestAttendance(widget.getKaryawanNo, "Approve"),
        ],
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