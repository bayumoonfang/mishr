

/*
import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

import 'S_HELPER/g_profile.dart';


class AttendanceHistoryBACKUP extends StatefulWidget{
  final String getKaryawanNo;
  const AttendanceHistoryBACKUP(this.getKaryawanNo);
  @override
  _AttendanceHistoryBACKUP createState() => _AttendanceHistoryBACKUP();
}



class _AttendanceHistoryBACKUP extends State<AttendanceHistoryBACKUP> {
  var yearme = DateFormat('yyyy').format(DateTime.now());
  var monthme = DateFormat('MM').format(DateTime.now());
  final availableMaps = MapLauncher.installedMaps;


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  String filter = "thismonth";
  String filter2 = "";
  bool btn1 = true;
  bool btn2 = false;
  show_map(String latme, String longme) async {
    bool isGoogleMaps =
        await MapLauncher.isMapAvailable(MapType.google) ?? false;

    if (isGoogleMaps) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(double.parse(latme), double.parse(longme)),
        title: "Location Clock In",

      );
    }
  }


  Future getData() async {
    setState(() {
      g_profile().getData_HistoryAttendance(widget.getKaryawanNo, filter, yearme, monthme, filter2);
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        //backgroundColor: HexColor("#3a5664"),
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1"?  "Riwayat Kehadiran":"Attendance History",
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
      body: Container(
        padding: EdgeInsets.only(left: 15,right: 15,top: 10),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
            height: 30,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: OutlinedButton(child: Text(getBahasa.toString() =="1" ? "Bulan Ini" : "This Month",
                      style: GoogleFonts.nunitoSans(
                          color: btn1 == true ? HexColor("#1a76d2") : HexColor("#6b727c"),fontSize: 13,
                          fontWeight: btn1 == true ? FontWeight.bold : FontWeight.normal),),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(), side: BorderSide(width: 1, color: btn1 == true ? HexColor("#1a76d2") :
                      HexColor("#6b727c")),
                      ),
                      onPressed: (){
                        setState(() {
                          btn1 = true;
                          btn2 = false;
                          filter = "thismonth";
                        });
                      },)
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: OutlinedButton(child: Text(getBahasa.toString() =="1" ? "Tahun Ini" : "This Year",
                      style: GoogleFonts.nunitoSans(
                          color: btn2 == true ? HexColor("#1a76d2") : HexColor("#6b727c"),fontSize: 13,
                      fontWeight: btn2 == true ? FontWeight.bold : FontWeight.normal),),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(), side: BorderSide(width: 1, color: btn2 == true ? HexColor("#1a76d2") :
                      HexColor("#6b727c")),
                      ),
                      onPressed: (){
                        setState(() {
                          btn1 = false;
                          btn2 = true;
                          filter = "thisyear";
                        });
                      },)
                ),
              ],
            )
        ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: FutureBuilder(
                    future: g_profile().getData_HistoryAttendance(widget.getKaryawanNo, filter, yearme, monthme, filter2),
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
                                    Image.asset('assets/empty2.png',width: 170,),
                                    Padding(
                                      padding: EdgeInsets.only(left: 13),
                                      child:  new Text(
                                        getBahasa.toString() == "1" ? "Data Tidak Ditemukan": "Data Not Found",
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
                                itemExtent: 92,
                                itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                padding: const EdgeInsets.only(bottom: 85,top: 5),
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        child: ListTile(
                                            visualDensity: VisualDensity(vertical: -2),
                                            dense : true,
                                            title:

                                            snapshot.data![i]["q"].toString() == "" ?
                                            Container(
                                              width: double.infinity,
                                              padding : EdgeInsets.all(6),
                                              child: Text(
                                                  getBahasa.toString() =="1" ?
                                                  AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                  AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                  AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()) :
                                                  AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFullEnglish(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                  style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: HexColor("#EDEDED"),
                                              ),
                                            ) : Container(
                                              width: double.infinity,
                                              padding : EdgeInsets.all(6),
                                              child: Text(
                                                  getBahasa.toString() =="1" ?
                                                  AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()) :
                                                  AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFullEnglish(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                  style: GoogleFonts.workSans(fontSize: 12,color: Colors.white)),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: HexColor("#2196f3"),
                                              ),
                                            ),
                                            subtitle:Column(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(top: 5,left: 2),
                                                    child:
                                                    Align(alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          snapshot.data![i]["b"].toString() != '00:00' && snapshot.data![i]["c"].toString() == '00:00'  ?
                                                          "Clock In : "+snapshot.data![i]["b"].toString()+" | Clock Out : -" :
                                                          snapshot.data![i]["b"].toString() == '00:00' && snapshot.data![i]["c"].toString() == '00:00'  ?
                                                          "Clock In : - | Clock Out : -" :
                                                          "Clock In : "+snapshot.data![i]["b"].toString()+" | Clock Out : "+snapshot.data![i]["c"].toString() ,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)
                                                      ),)),
                                                Padding(
                                                    padding: EdgeInsets.only(top: 1,left: 3),
                                                    child: Align(alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          getBahasa.toString() =="1" ? "Telat : "+snapshot.data![i]["d"].toString()+" menit | "
                                                              "Lembur : "+snapshot.data![i]["e"].toString()+" menit" :
                                                          "Late : "+snapshot.data![i]["d"].toString()+" minute | "
                                                              "Overtime : "+snapshot.data![i]["e"].toString()+" minute",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.workSans(fontSize: 13,color: Colors.black)),)
                                                )
                                              ],
                                            )
                                        ),
                                        onTap: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                ),
                                              ),
                                              context: context,
                                              builder: (context) {
                                                return SingleChildScrollView(
                                                    child : Container(
                                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 25,right: 25,top: 25),
                                                        child: Column(
                                                          children: [
                                                            Align(alignment: Alignment.centerLeft,child: Text(getBahasa.toString() =="1" ? "Detail Kehadiran":"Attendance Detail",
                                                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:15),
                                                              child: Divider(height: 2,),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(top: 5,bottom: 10),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Kode Jadwal":"Schedule Code",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 14),),
                                                                        Text(snapshot.data![i]["j"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Jadwal Jam Masuk":"Schedule Check In",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 14),),
                                                                        Text(snapshot.data![i]["f"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Jadwal Jam Keluar": "Schedule Check Out",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 14),),
                                                                        Text(snapshot.data![i]["g"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),

                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Jam Masuk": "Clock In",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 14),),
                                                                        Text(snapshot.data![i]["b"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Jam Keluar": "Clock Out",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 14),),
                                                                        Text(snapshot.data![i]["c"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),child: Divider(height: 5,),
                                                                  ),

                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Lokasi Jam Masuk":"Clock In Location",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
                                                                        ElevatedButton(onPressed: (){
                                                                          show_map(snapshot.data![i]["m"].toString(),
                                                                              snapshot.data![i]["n"].toString());
                                                                        }, child: Text(
                                                                            snapshot.data![i]["k"].toString(),style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                                            fontSize: 14)
                                                                        )),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  snapshot.data![i]["c"].toString() != "00:00" ?
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Lokasi Jam Keluar": "Clock Out Location",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
                                                                        ElevatedButton(onPressed: (){}, child: Text(
                                                                            snapshot.data![i]["l"].toString(),style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                                            fontSize: 14)
                                                                        )),

                                                                      ],
                                                                    ),
                                                                  ) : Container()
                                                                ],
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                );
                                              });
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),

                          ],
                        );

                      }
                    },
                  ),
                )
            ),

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

}*/