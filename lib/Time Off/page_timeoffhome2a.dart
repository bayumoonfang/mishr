



import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_notificationspecific.dart';
import 'package:abzeno/Time%20Off/ARCHIVED/page_myapproval.dart';
import 'package:abzeno/page_home.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'S_HELPER/g_timeoff.dart';
import 'S_HELPER/m_timeoff.dart';
import 'page_addtimeoff.dart';
import 'ARCHIVED/page_myrequest.dart';
import 'package:http/http.dart' as http;

import 'page_timeoff_list.dart';
import 'page_timeoff_saldo.dart';
import 'page_timeoffapprovallist.dart';
import 'page_timeoffdetail.dart';
class PageTimeOffHome2a extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getKaryawanEmail;
  const PageTimeOffHome2a(this.getKaryawanNo,this.getKaryawanNama, this.getKaryawanEmail);
  @override
  _PageTimeOffHome2a createState() => _PageTimeOffHome2a();
}

class _PageTimeOffHome2a extends State<PageTimeOffHome2a> with SingleTickerProviderStateMixin {
  late TabController controller;
  String getNotifCountme = "0";
  getNotif() async {
    await AppHelper().getSpecificNotifCount("Attendance Request TimeOff").then((value){
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
          height: textScale.toString() == '1.17' ? 190 : 210,
          child : Column(
            children: [
              Text("Ini adalah menu untuk pengajuan time off seperti cuti, ijin, dan lain - lain. Jika ada ketidaksesuaian saldo pengajuan "
                  "maka bisa menghubungi HRD anda untuk pengecekan data lebih lanjut",
                style: textScale.toString() == '1.17' ? GoogleFonts.nunitoSans(fontSize: 12) :
                GoogleFonts.nunitoSans(fontSize: 15),textAlign:
              TextAlign.left,),
              SizedBox(height: 10,),
              Text("Anda bisa menghapus data pengajuan anda yang sudah anda batalkan dengan tahan tap 2 detik pada data anda ",
                style: textScale.toString() == '1.17' ? GoogleFonts.nunitoSans(fontSize: 12) :
                GoogleFonts.nunitoSans(fontSize: 15),textAlign:
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



  String approval_count = "0";
  loadData() async {
    await getSettings();
    await getNotif();
    await g_timeoff().get_TimeOffApprovalCount(widget.getKaryawanNo).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          approval_count = value[0];
        });
      }
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 4);
    loadData();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  FutureOr onGoBack(dynamic value) {
    setState(() {
      // g_timeoff().getData_AllTimeOffRequest(widget.getKaryawanNo, filter, filter2, filter3);
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        backgroundColor: Colors.white,
        title: Text("Time Off", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
        bottom: new TabBar(
          indicatorColor: Colors.black,
          controller: controller,
          labelColor: Colors.black,
          labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),
          unselectedLabelStyle: GoogleFonts.varelaRound(fontSize: 12,color: Colors.black),
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            new Tab(text: getBahasa.toString() == "1"? "My Request":"Created By Me"),
            new Tab(text: getBahasa.toString() == "1"? "Approval": "Delegated to Me"),
            new Tab(text: getBahasa.toString() == "1"? "Saldo": "Delegated to Me"),
          ],
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
           child:
           InkWell( child :
            FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),
             onTap: (){
               FocusScope.of(context).requestFocus(FocusNode());
               Navigator.push(context, ExitPage(page: PageSpecificNotification(widget.getKaryawanEmail, "Attendance Request TimeOff"))).then(onGoBack);
             },
       ))))

             :
      Container(width:50, height: 60, child :
         Padding(
           padding: EdgeInsets.only(top: 17,right: 24,left: 18),
           child: FaIcon(FontAwesomeIcons.bell,color: HexColor("#535967"),size: 20,),)),

      Container(width: 50, height: 50, child :
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
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          PageTimeOffList(widget.getKaryawanNo, widget.getKaryawanNama,"Request"),
          PageTimeOffList(widget.getKaryawanNo, widget.getKaryawanNama,"Approval"),
          PageTimeOffSaldo(widget.getKaryawanNo),
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