



import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';


import 'package:abzeno/ApprovalList/page_approvallist.dart';
import 'package:abzeno/Inbox/page_inboxhome.dart';
import 'package:abzeno/Notification/page_notification.dart';
import 'package:abzeno/Profile/page_profile.dart';
import 'package:abzeno/attendance/page_doattendance.dart';
import 'package:abzeno/page_changecabang.dart';
import 'package:abzeno/page_home2.dart';
import 'package:badges/badges.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Inbox/page_pesanpribadi.dart';
import 'Time Off/ARCHIVED/page_timeoffhome.dart';
import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'attendance/page_attendance.dart';
import 'page_login.dart';





class Home extends StatefulWidget{

  @override
  _Home createState() => _Home();
}


class _Home extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedPage = 0;
  String getNotifCountme = "0";
  String getCountApprovalList = "0";
  String getCountPesanList = "0";
  late List data;


  String getKaryawanNama = "...";
  String getKaryawanJabatan = "...";
  String getKaryawanNo = "...";
  String getScheduleName = "...";
  String getStartTime = "...";
  String getEndTime = "...";
  String getPIN = "...";
  String getEmail = "...";
  String getScheduleID = "...";
  String getScheduleBtn = "...";


  String getJamMasukSebelum = "...";
  String getJamKeluarSebelum = "...";

  getNotif() async {
    await AppHelper().getNotifCount().then((value){
      setState(() {
        getNotifCountme = value[0];
      });});
  }

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }

  getApprovalListCount() async {
    await AppHelper().getCountApprovalList().then((value){
      setState(() {
        getCountApprovalList = value[0];
      });});

  }



  getPesanListCount() async {
    await AppHelper().getPesanListCount(getKaryawanNo, getEmail).then((value){
      setState(() {
        getCountPesanList = value[0];
      });});
  }



  _startingVariable() async {
    EasyLoading.show(status: AppHelper().loading_text);
    await AppHelper().getSession().then((value){
      setState(() {
        getKaryawanNama = value[3];
        getKaryawanJabatan = value[5];
        getKaryawanNo = value[4];
        getEmail = value[0];
        getScheduleName = value[6];
        getStartTime = value[7];
        getEndTime = value[8];
        getScheduleID = value[15];
        getJamMasukSebelum = value[16];
        getJamKeluarSebelum = value[17];
        getPIN = value[18];
        getScheduleBtn = value[19];
      });});

    await getNotif();
    await getApprovalListCount();
    await getPesanListCount();
    await getSettings();
  }

  loadData2() async {
    await _startingVariable();
    EasyLoading.dismiss();
  }

  getMe() {

  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _tabController.animateTo(_currentIndex);
   // timer = Timer.periodic(Duration(seconds: 5), (Timer t) => runLoopMe());
    loadData2();
  }


  void runLoopMe() async {
    getNotif();
    getApprovalListCount();
    getPesanListCount();
    await AppHelper().getSchedule();
    await AppHelper().getSession().then((value){
      setState(() {
        getScheduleName = value[6];
        getStartTime = value[7];
        getEndTime = value[8];
        getScheduleID = value[15];
        getScheduleBtn = value[19];
      });});
    await getSettings();
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  late TabController _tabController;
  int _currentIndex = 2;


  @override
  Widget build(BuildContext context) {
      return WillPopScope(child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              PageApprovalList(getKaryawanNo, getKaryawanNama, runLoopMe),
              PageNotification(getEmail,"All", runLoopMe),
              Home2(getKaryawanNama, getKaryawanJabatan, getKaryawanNo,
                  getScheduleName,
                  getStartTime,
                  getEndTime,
                  getScheduleID,
                  getJamMasukSebelum,
                  getJamKeluarSebelum,getPIN,getScheduleBtn,getEmail, runLoopMe),
              PagePesanPribadi(getKaryawanNo, runLoopMe),
              Profile(getKaryawanNama, getKaryawanJabatan, getKaryawanNo)
              //PageMyApproval(widget.getKaryawanNo, widget.getKaryawanNama),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type : BottomNavigationBarType.fixed,
            selectedItemColor: HexColor(AppHelper().main_color),
            selectedLabelStyle: GoogleFonts.varelaRound(color:  HexColor(AppHelper().main_color),fontSize: 12),
            unselectedLabelStyle: GoogleFonts.varelaRound(fontSize: 11),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon:
                getCountApprovalList != "0" ?
                Badge(
                  showBadge: true,
                  animationType:  BadgeAnimationType.scale,
                  shape: BadgeShape.circle,
                  position: BadgePosition.topEnd(top: -2,end: -1),
                  child: const FaIcon(FontAwesomeIcons.fileSignature,size: 22,),
                ) :
                FaIcon(FontAwesomeIcons.fileSignature,size: 22,),
                label: 'Approval',
              ),
              BottomNavigationBarItem(
                icon:
                getNotifCountme != "0" ?
                Badge(
                  showBadge: true,
                  animationType:  BadgeAnimationType.scale,
                  shape: BadgeShape.circle,
                  position: BadgePosition.topEnd(top: -2,end: -3),
                  child: const FaIcon(FontAwesomeIcons.bell,size: 22,),
                ) :
                FaIcon(FontAwesomeIcons.bell,size: 22,),
                label: getBahasa.toString() == "1" ? 'Notifikasi':'Notification',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.homeAlt,size: 32,),
                label: getBahasa.toString() == "1" ? 'Beranda':'Home',
              ),
              BottomNavigationBarItem(
                icon:
                getCountPesanList != "0" ?
                Badge(
                  showBadge: true,
                  animationType:  BadgeAnimationType.scale,
                  shape: BadgeShape.circle,
                  position: BadgePosition.topEnd(top: -2,end: -3),
                  child: const FaIcon(FontAwesomeIcons.envelope,size: 22,),
                ) :
                FaIcon(FontAwesomeIcons.message,size: 22,),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user,size: 22,),
                label: getBahasa.toString() == "1" ? 'Profil':'Profile',
              ),
            ],
            currentIndex: _currentIndex,
            onTap: (currentIndex){
              setState(() {
                _currentIndex = currentIndex;
              });
              _tabController.animateTo(_currentIndex);

            },)
      ), onWillPop: onWillPop);
  }


  DateTime BackPressTime = DateTime.now();
  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if(now.difference(BackPressTime)< Duration(seconds: 2)){
      exit(0);
      return Future(() => true);
    }
    else{
      BackPressTime = DateTime.now();
      Fluttertoast.showToast(msg: getBahasa == '1' ? 'Tap 2x untuk keluar aplikasi' : 'Tap 2x to exit application');
      return Future(()=> false);
    }
  }
}

