



import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/PageFirstLoad.dart';
import 'package:abzeno/page_check.dart';
import 'package:abzeno/page_intoduction.dart';
import 'package:abzeno/page_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageBiometricSetting extends StatefulWidget {

  @override
  _PageBiometricSetting createState() => _PageBiometricSetting();
}


class _PageBiometricSetting extends State<PageBiometricSetting> {

  String getBiometricSetting = "0";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBiometricSetting = value[25];
      });});
  }


  @override
  void initState() {
    super.initState();
    getSettings();
  }

  _clearallpref() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    Navigator.pushReplacement(context, ExitPage(page: PageLogin("", "")));
  }

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("email", '');
      preferences.setString("username", '');
      preferences.setString("karyawan_id", '');
      preferences.setString("karyawan_nama", '');
      preferences.setString("karyawan_no", '');
      preferences.setString("karyawan_jabatan", '');
      preferences.setString("decode_pin", '');
      preferences.commit();
      _clearallpref();
    });
  }

  _action_fitur (String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("getBiometricActive", '');
    if (value == 'Aktif') {
      preferences.setString("biometric_setting", '1');
      preferences.setString("biometric_priority", 'Passcode');
      preferences.setBool("fingerscan_active", true);
      _logout();
      // Navigator.pushReplacement(context, ExitPage(page: PageFirstLoad("","")));
      // SchedulerBinding.instance?.addPostFrameCallback((_) {
      //   AppHelper().showFlushBarsuccess(context, "Fitur berhasil di aktifkan"); });
    } else {
      preferences.setString("biometric_setting", '0');
      Navigator.pushReplacement(context, ExitPage(page: PageFirstLoad("","")));
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        AppHelper().showFlushBarsuccess(context, "Fitur berhasil di nonaktifkan"); });
    }


  }



  dialog_aktif(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text("AKTIFKAN",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _action_fitur("Aktif");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Aktifkan Fitur", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text("Apakah anda yakin untuk mengaktifkan fitur ini ?", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.left,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  dialog_nonaktif(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text("MATIKAN",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _action_fitur("Matikan");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Matikan Fitur", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text("Apakah anda yakin untuk menonaktifkan fitur ini ?", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.left,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
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
            "Fingerscan and Passcode", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.black),),
          elevation: 0,
        ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              FaIcon(FontAwesomeIcons.lock,size: 50,),
              Padding(padding: EdgeInsets.only(top: 25),
                child: Text("Security Confirmation", style: GoogleFonts.nunito(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center),),
            Padding(padding: EdgeInsets.only(top: 25,left: 15,right: 15),
              child: Text("Cobain fitur terbaru misHR untuk keamanan akun anda, anda harus melakukan scan finger atau memasukkan passcode setiap kali masuk aplikasi misHR"
                  " jika anda mengaktifkan fitur ini", style: GoogleFonts.nunito(fontSize: 15),textAlign: TextAlign.center,),),

          ],
        ),
    ),
      bottomNavigationBar:
              Container(
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
              width: double.infinity,
              height: 68,
              child :
              getBiometricSetting == "0" || getBiometricSetting == null ?
              Padding(
                padding: EdgeInsets.only(top:10),
                child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#00aa5b"),
                        elevation: 0,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    child: Text("Aktifkan Sekarang",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                        fontSize: 14),),
                    onPressed: () {
                      dialog_aktif(context);
                    }
                ),
              ) :

              Padding(
                padding: EdgeInsets.only(top:10),
                child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#e21b4c"),
                        elevation: 0,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    child: Text("Matikan Sekarang",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                        fontSize: 14),),
                    onPressed: () {
                      dialog_nonaktif(context);
                    }
                ),
              )

              ),), onWillPop: onWillPop);
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