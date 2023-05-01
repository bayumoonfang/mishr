


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class AboutUs extends StatefulWidget{
  @override
  _AboutUs createState() => _AboutUs();
}


class _AboutUs extends State<AboutUs> {

  String versionVal = '...';
  String codeVal = '...';
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      versionVal = version;
      codeVal = code;
    });
  }

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }

  void initState() {
    super.initState();
    getSettings();
    getVersion();
  }


    @override
    Widget build(BuildContext context) {
      return WillPopScope(child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(getBahasa.toString() == "1" ? "Tentang Kami":"About Us", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
          elevation: 0,
          leading: Builder(
            builder: (context) =>
                IconButton(
                    icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,color:Colors.black,),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
          ),
        ),
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2,bottom: 2),
                child: Text("MIS HR", style: GoogleFonts.nunitoSans(fontSize: 68,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Aplikasi HR terbaik karya anak bangsa", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text("Developer Team", style: GoogleFonts.nunitoSans(fontSize: 22,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Team Leader/ Mobile Apps Developer", style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Ragil Bayu Respati", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("UI/UX Designer", style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Ragil Bayu Respati", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Backend and Front End Developer", style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Christian Kurnadi", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Akhmad Efendy Mooduto", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Eko Utomo", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text("Other Team", style: GoogleFonts.nunitoSans(fontSize: 22,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Initiator", style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text("Dimas Prasetyo Nugroho", style: GoogleFonts.nunitoSans(fontSize: 14),),
              ),

            ],
          )
        ),
        bottomSheet: Container(
          color: Colors.white,
          height: 60,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppHelper().app_company+" @"+AppHelper().app_createon, style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
              Text("Version "+versionVal+ " build "+codeVal, style: GoogleFonts.workSans(fontSize: 13)),
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