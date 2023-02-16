


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

import 'S_HELPER/g_lembur.dart';




class JadwalLembur extends StatefulWidget{
  final String getKaryawanNo;
  const JadwalLembur(this.getKaryawanNo);
  @override
  _JadwalLembur createState() => _JadwalLembur();
}



class _JadwalLembur extends State<JadwalLembur> {
  var yearme = DateFormat('yyyy').format(DateTime.now());
  var monthme = DateFormat('MM').format(DateTime.now());
  final availableMaps = MapLauncher.installedMaps;
  var startDate = "0";
  var endDate = "0";
  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();
  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  String filter = "thismonth";
  String filter2 = "";
  String txtFilter = "Show Data : 7 HARI TERAKHIR";
  bool btn1 = true;
  bool btn2 = false;



  Future getData() async {
    setState(() {
      g_lembur().getData_jadwallembur(widget.getKaryawanNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(

      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10,bottom: 15),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: FutureBuilder(
                    future: g_lembur().getData_jadwallembur(widget.getKaryawanNo),
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
                                itemExtent: 82,
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
                                                color: snapshot.data![i]["r"].toString() == 'Absen' ? HexColor("#Fcdedf") : HexColor("#EDEDED"),
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
                                                color: HexColor("#2196f3") ,
                                              ),
                                            ),
                                            subtitle:Column(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(top: 5,left: 2),
                                                    child:
                                                    Align(alignment: Alignment.centerLeft,
                                                      child: Text( "Clock In : "+snapshot.data![i]["f"].toString()+" | Clock Out : "+snapshot.data![i]["g"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,fontSize: 13.5,color: Colors.black)
                                                      ),)),
                                                Padding(
                                                    padding: EdgeInsets.only(top: 5,left: 3),
                                                    child: Align(alignment: Alignment.centerLeft,
                                                      child: Text("#"+snapshot.data![i]["q"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.workSans(fontSize: 12.5,color: Colors.black)),)
                                                )
                                              ],
                                            )
                                        ),
                                        onTap: () {},
                                      ),


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

}