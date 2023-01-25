


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Notification/page_detailnotification.dart';
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
class PageDetailActivityTimeOff extends StatefulWidget{
  final String getTimeOffNumber;
  const PageDetailActivityTimeOff(this.getTimeOffNumber);
  @override
  _PageDetailActivityTimeOff createState() => _PageDetailActivityTimeOff();
}


class _PageDetailActivityTimeOff extends State<PageDetailActivityTimeOff> {


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }


  @override
  void initState() {
    super.initState();
    getSettings();
  }




  Future getData() async {
    setState(() {
      g_timeoff().getData_timeoffDetailActivity(widget.getTimeOffNumber);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() =="1" ? "Aktifitas Time Off" : "Activity Time Off",overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
                        future: g_timeoff().getData_timeoffDetailActivity(widget.getTimeOffNumber),
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
                                        Image.asset('assets/nodata.png',width: 150,),
                                        new Text(
                                          "Data Not Found",
                                          style: new TextStyle(
                                              fontFamily: 'VarelaRound', fontSize: 15),
                                        ),
                                      ],
                                    )))
                                :
                            Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemExtent: 92,
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
                                                child: Text(
                                                    getBahasa.toString() =="1" ?
                                                    AppHelper().getTanggalCustom(snapshot.data![i]["d"].toString()) + " "+
                                                    AppHelper().getNamaBulanCustomFull(snapshot.data![i]["d"].toString()) + " "+
                                                    AppHelper().getTahunCustom(snapshot.data![i]["d"].toString())+ " - "+snapshot.data![i]["e"].toString()
                                                    :
                                                        AppHelper().getTanggalCustom(snapshot.data![i]["d"].toString()) + " "+
                                                        AppHelper().getNamaBulanCustomFullEnglish(snapshot.data![i]["d"].toString()) + " "+
                                                        AppHelper().getTahunCustom(snapshot.data![i]["d"].toString())+ " - "+snapshot.data![i]["e"].toString()

                                                    ,
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