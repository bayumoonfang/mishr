
import 'dart:convert';

import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/page_home.dart';
import 'package:abzeno/page_intoduction.dart';
import 'package:abzeno/page_login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Helper/app_helper.dart';
import 'Helper/page_route.dart';

class PageCheck extends StatefulWidget{
  final String getBahasa;
  final String getTokenMe;
  const PageCheck(this.getBahasa, this.getTokenMe);
  //const PageCheck(this.getTokenMe);
  @override
  _PageCheck createState() => _PageCheck();
}

class _PageCheck extends State<PageCheck> {
  String getConnection = '1';
  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
        //getBahasa = widget.getBahasa;
      });});
  }


  _startingVariable() async {
    /*if(widget.getBahasa.isNotEmpty) {
      await AppHelper().setFirstTimeLanguage(widget.getBahasa);
    }*/
    await getSettings();
    await AppHelper().getConnect().then((value){
          if(value == 'ConnInterupted'){
              getBahasa.toString() == "1"?
              AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
              AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
              setState(() {
                getConnection = '0';
              });
              return false;
        } else {
            setState(() {
              getConnection = '1';
            });
        }
    });
    await AppHelper().getSession().then((value){
      setState(() {
        if(value[0] == '' || value[0] == null) {
          Navigator.pushReplacement(context, ExitPage(page:
          Introduction(widget.getTokenMe)));
        }
      });}
    );

    bool servicestatus = false;
    bool haspermission = false;
    late LocationPermission permission;
    late Position position;
    cekPermissionGeolocator() async {
      servicestatus = await Geolocator.isLocationServiceEnabled();
      if(servicestatus){
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            print('Location permissions are denied');
          }else if(permission == LocationPermission.deniedForever){
            print("'Location permissions are permanently denied");
          }else{
            haspermission = true;
          }
        }else{
          haspermission = true;
        }
        if(haspermission){
          setState(() {
            //refresh the UI
          });
        }
      }else{
        print("GPS Service is not enabled, turn on GPS location");
      }

      setState(() {
        //refresh the UI
      });
    }


    await AppHelper().reloadSession();
    if(widget.getTokenMe.toString() != '' || widget.getTokenMe.toString() != null) {
      await AppHelper().generateTokenFCM(widget.getTokenMe);
    }

    //await cek_datetimesetting();
    await cekPermissionGeolocator();
    Navigator.pushReplacement(context, ExitPage(page: Home()));

  }



  @override
  void initState() {
    super.initState();
     _startingVariable();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child : Visibility(
            child :
            getConnection == '1' ?
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SpinKitThreeBounce(
                    color: Colors.indigo,
                  ),
                ],
              ) :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/wifi-off.png',width: 220,),
                Text(getBahasa.toString() == "1"? "Koneksi Terputus": "Disconnected", style: GoogleFonts.nunito(fontSize: 25,fontWeight: FontWeight.bold)),
                Text(getBahasa.toString() == "1"? "Mohon periksa jaringan atau koneksi anda": "Please check your network or connection", style: GoogleFonts.nunito(fontSize: 15),
                  textAlign: TextAlign.center,),
                Padding(padding: EdgeInsets.only(top: 20),
                child: ElevatedButton(onPressed: (){
                  _startingVariable();
                }, child: Text(getBahasa.toString() == "1"? "Ulangi Lagi":"Reconnect",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                    fontSize: 14))),)
              ],
            )
          )
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: 60,
        width: double.infinity,
        child: Column(
 children: [
           Center(
               child:
               getConnection == '1' ?
               Text("Menyiapkan data anda...",  style: GoogleFonts.nunitoSans(
                   fontSize: 13)) : Container()
           ),
          Padding(
            padding: EdgeInsets.only(top:5,bottom: 10),
            child:  Center(
                child:
                Text(
                    "MIS HR : Aplikasi HR Terbaik Karya Anak Bangsa",  style: GoogleFonts.nunitoSans(
                    fontSize: 12,fontWeight: FontWeight.bold))
            ),
          )
 ],
        ),
      ),
    ), onWillPop: onWillPop);
  }

  bool shouldPop = true;
  Future<bool> onWillPop() async {
    //Navigator.pop(context);
    return shouldPop;
  }
}