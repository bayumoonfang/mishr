



import 'dart:convert';

import 'package:abzeno/Helper/g_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'Helper/m_helper.dart';
import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'page_login.dart';


class ChangeCabang extends StatefulWidget{
  final String getKaryawanNo;
  const ChangeCabang(this.getKaryawanNo);
  @override
  _ChangeCabang createState() => _ChangeCabang();
}



class _ChangeCabang extends State<ChangeCabang> {

  late List data;

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




  _change_cabang(getLocationID) async {

    await m_helper().change_cabang(getLocationID, widget.getKaryawanNo ).then((value){
      if(value == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          if(value[0] != '') {
            if(value[0] == '1') {
              setState(() {
                Navigator.pop(context);
                AppHelper().getWorkLocation();
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  AppHelper().showFlushBarconfirmed(context, getBahasa.toString() =="1" ? "Lokasi absen berhasil dirubah": "Working location has been changed");
                });
              });
            } else {
              AppHelper().showFlushBarsuccess(context, value[0]);
              return;
            }
          }
        });
      }
    });
  }


  String filter = "";
  Future getData() async {
    setState(() {
      g_helper().getData_AllCabang(widget.getKaryawanNo, filter);
    });
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        backgroundColor: HexColor("#3a5664"),
        title: Text(
          getBahasa.toString() =="1" ? "Ubah Lokasi Absen" : "Change Work Location", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        leading: Builder(
          builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => {
                Navigator.pop(context)
              }),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child :
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        onChanged: (text) {
                          setState(() {
                            filter = text;
                          });
                        },
                        style: GoogleFonts.nunito(fontSize: 15),
                        decoration: new InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          fillColor: HexColor("#f4f4f4"),
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0,),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: getBahasa.toString() =="1" ? 'Cari Lokasi...' : 'Search Location...',
                        ),
                      ),
                    )
                ),

                Padding(padding: const EdgeInsets.only(top: 10),),
                Expanded(
                    child: FutureBuilder(
                      future: g_helper().getData_AllCabang(widget.getKaryawanNo, filter),
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
                          ListView.builder(
                            itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                            padding: const EdgeInsets.only(left: 10,right: 15),
                            itemBuilder: (context, i) {
                              return Column(
                                children: [
                                  InkWell(
                                    child : ListTile(
                                      leading: FaIcon(FontAwesomeIcons.building,size: 23,),
                                      title: Row(
                                        children: [
                                          Padding(padding: const EdgeInsets.only(right: 5),child:
                                          Text(snapshot.data![i]["b"].toString(), style: GoogleFonts.nunito(fontSize: 15),),),
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      EasyLoading.show(status: AppHelper().loading_text);
                                      _change_cabang(snapshot.data![i]["a"].toString());
                                    },
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 0),child:
                                  Divider(height: 4,),)
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                ),

              ],
            ),
          )),
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