

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';

import 'package:abzeno/Setting/page_bahasa.dart';
import 'package:abzeno/Setting/page_biometricsetting.dart';
import 'package:abzeno/Setting/page_biometricsetting2.dart';
import 'package:abzeno/Setting/page_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'dart:io' show Platform;

class SettingHome extends StatefulWidget{
  final String getEmail;

  const SettingHome(this.getEmail);
  @override
  SettingHomeState createState() => SettingHomeState();
}


class SettingHomeState extends State<SettingHome> {
  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }


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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
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
          title: Text(
            getBahasa.toString() == "1" ? "Pengaturan" : "Settings",
            style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black,),),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 5,right: 15),
            child: Column(
              children: [
                InkWell(
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, ExitPage(page: ChangeBahasa(widget.getEmail)));
                      },
                    title: Text(getBahasa.toString() == "1" ? "Ganti Bahasa" : "Change Language",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text(getBahasa.toString() == "1" ? "Pilih bahasa untuk aplikasi kamu" :
                        "Change language for your application",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

    Platform.isAndroid ?
      InkWell(
        child: ListTile(
          onTap: () {
            Navigator.push(context, ExitPage(page: PageBiometricSetting()));
          },
          title: Text(getBahasa.toString() == "1"
              ? "Fingerprint and Passcode"
              : "Security", style: TextStyle(
              color: Colors.black, fontFamily: 'VarelaRound', fontSize: 15,
              fontWeight: FontWeight.bold)),
          subtitle: Text(getBahasa.toString() == "1"
              ? "Tambah proteksi untuk keamanan akun anda "
              :
          "Change language for your application", style: TextStyle(
              color: Colors.black, fontFamily: 'VarelaRound', fontSize: 12)),
          trailing: FaIcon(
            FontAwesomeIcons.angleRight, color: HexColor("#594d75"), size: 15,),
        ),
      ) : Container(),

                Platform.isAndroid ?
      Padding(padding: const EdgeInsets.only(top: 5, left: 15),
        child: Divider(height: 3,),) : Container(),


                // InkWell(
                //   child: ListTile(
                //     onTap: (){
                //       Navigator.push(context, ExitPage(page: PageBiometricSetting2()));
                //     },
                //     title: Text(getBahasa.toString() == "1" ? "Fingerprint and Passcode Setting" : "Security",style: TextStyle(
                //         color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                //         fontWeight: FontWeight.bold)),
                //     subtitle: Text(getBahasa.toString() == "1" ? "Atur prioritas keamanan anda" :
                //     "Change language for your application",style: TextStyle(
                //         color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                //     trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                //   ),
                // ),
                // Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                //   child: Divider(height: 3,),),



/*
                InkWell(
                  child: ListTile(
                    onTap: (){
                        Navigator.push(context, ExitPage(page: ChangeNotifikasi(widget.getEmail)));
                      },
                    title: Text(getBahasa.toString() == "1" ? "Notifikasi" : "Notification",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text(getBahasa.toString() == "1" ? "Atur notifikasi pemberitahuan untuk aplikasi kamu" :
                        "Set notification for your application",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),*/



              ],
            ),
          ),
        ),
      ),
    );

  }
}