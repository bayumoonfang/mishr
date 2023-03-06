

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Request%20Attendance/page_attendancehistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'page_reqattend_addhome2.dart';
import 'page_reqattendancehome.dart';


class PageAttendanceHome extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getKaryawanEmail;
  const PageAttendanceHome(this.getKaryawanNo, this.getKaryawanNama, this.getKaryawanEmail );
  @override
  _PageAttendanceHome createState() => _PageAttendanceHome();
}


class _PageAttendanceHome extends State<PageAttendanceHome> {
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
    //=====================
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
          //backgroundColor: HexColor("#3a5664"),
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
            getBahasa.toString() == "1" ? "Kehadiran" : "Attendance", style: GoogleFonts.montserrat(fontSize: 17,
              fontWeight: FontWeight.bold,color: Colors.black,),),
          elevation: 1,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 5,right: 15),
            child: Column(
              children: [
                InkWell(
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, ExitPage(page: AttendanceHistory(widget.getKaryawanNo)));
                    },
                    title: Text(getBahasa.toString() == "1" ? "Riwayat Kehadiran" : "Attendance History",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Padding(padding: EdgeInsets.only(top: 5),child: Text(getBahasa.toString() == "1" ? "Telusuri riwayat kehadiran kamu setiap harinya" :
                    "Track your attendance history every day",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12))),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, ExitPage(page: RequestAttendAddHome2(widget.getKaryawanNo,"Correction")));
                    },
                    title: Text(getBahasa.toString() == "1" ? "Pengajuan Koreksi Kehadiran" : "Attendance Correction",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Padding(padding: EdgeInsets.only(top: 5),child: Text(getBahasa.toString() == "1" ? "Ajukan koreksi kehadiran kamu jika terjadi kesalahan" :
                    "Submit your attendance correction if something goes wrong",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12,height: 1.2)),),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, ExitPage(page: RequestAttendAddHome2(widget.getKaryawanNo,"Ganti Shift")));
                    },
                    title: Text(getBahasa.toString() == "1" ? "Pengajuan Ganti Shift" : "Change Shift",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Padding(padding: EdgeInsets.only(top: 5),child: Text(getBahasa.toString() == "1" ? "Ajukan pergantian shift dengan mudah hanya disini" :
                    "Apply for a change of shift easily only here",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12,height: 1.2))),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

              ],
            ),
          ),
        ),
        bottomSheet: Container(
            padding: EdgeInsets.only(left: 35, right: 35, bottom: 10),
            width: double.infinity,
            height: 55,
            child:
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //primary: HexColor(AppHelper().main_color),
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(
                      color: Colors.white,
                      width: 0.1,
                      style: BorderStyle.solid
                  ),
                    borderRadius: BorderRadius.circular(5.0),
                  )),
              child: Text(getBahasa.toString() == "1"?  "Daftar Pengajuan":"Request List",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                  fontSize: 14)),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  Navigator.push(context, ExitPage(page: PageReqAttendanceHome(widget.getKaryawanNo, widget.getKaryawanNama, widget.getKaryawanEmail)));
                });

              },
            )),
      ),
    );

  }
}