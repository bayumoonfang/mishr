


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_detailnotification.dart';
import 'package:abzeno/Request%20Attendance/S_HELPER/g_reqattend.dart';
import 'package:abzeno/Time%20Off/S_HELPER/g_timeoff.dart';
import 'package:abzeno/helper/app_helper.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
class PageReqAttendActivityDetail extends StatefulWidget{
  final String getReqAttendCode;
  const PageReqAttendActivityDetail(this.getReqAttendCode);
  @override
  _PageReqAttendActivityDetail createState() => _PageReqAttendActivityDetail();
}


class _PageReqAttendActivityDetail extends State<PageReqAttendActivityDetail> {

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  Future getData() async {
    setState(() {
      g_reqattend().getData_reqattendDetailActivity(widget.getReqAttendCode);
    });
  }

  @override
  void initState() {
    super.initState();
    getSettings();
  }



  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() =="1" ? "History Pengajuan": "Activity Request Attendance",
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) =>
              IconButton(
                  icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child : Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 10),
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child : Column(
                children: [
                  Expanded(
                      child: FutureBuilder(
                        future: g_reqattend().getData_reqattendDetailActivity(widget.getReqAttendCode),
                        builder: (context, snapshot){
                          if (snapshot.data == null) {
                            return Center(
                                child: const SpinKitThreeBounce(
                                  size: 30,
                                  color: Colors.indigo,
                                ),
                            );
                          } else {
                            return snapshot.data == 0 || snapshot.data?.length == 0 ?
                            Container(
                                height: double.infinity, width : double.infinity,
                                child: new
                                Center(
                                    child :
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset('assets/empty2.png',width: 150,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 13),
                                          child:  new Text(
                                            "Tidak ada data",
                                            style: new TextStyle(
                                                fontFamily: 'VarelaRound', fontSize: 13),
                                          ),
                                        )
                                      ],
                                    )))
                                :
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemExtent: textScale.toString() == '1.17' ? 130 :95,
                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                    padding: const EdgeInsets.only(bottom: 85,top: 10),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            child : ListTile(
                                              visualDensity: VisualDensity(vertical: -2),
                                              dense : true,
                                              title:
                                              Container(
                                                width: double.infinity,
                                                padding : EdgeInsets.all(6),
                                                child: Text(AppHelper().getTanggalCustom(snapshot.data![i]["d"].toString()) + " "+
                                                    AppHelper().getNamaBulanCustomFull(snapshot.data![i]["d"].toString()) + " "+
                                                    AppHelper().getTahunCustom(snapshot.data![i]["d"].toString())+ " - "+snapshot.data![i]["e"].toString(),
                                                    style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: HexColor("#EDEDED"),
                                                ),
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 5,left: 2),
                                                    child:  Align(alignment: Alignment.centerLeft,
                                                      child: Text(snapshot.data![i]["b"].toString(),
                                                          style: GoogleFonts.nunitoSans(fontSize: 14,color: Colors.black)),),
                                                  )
                                                ],
                                              ),

                                            ),
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:15)),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                              ],
                            );

                          }
                        },
                      )
                  ),
                  SizedBox(height: 15,)
                ],
              )
          )
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