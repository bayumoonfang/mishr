



import 'dart:convert';

import 'package:abzeno/Helper/m_helper.dart';
import 'package:abzeno/helper/app_helper.dart';
import 'package:abzeno/helper/app_link.dart';
import 'package:abzeno/helper/page_route.dart';
import 'package:abzeno/page_home.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:safe_device/safe_device.dart';


class ClockOut extends StatefulWidget {
  final String getKaryawanNo;
  final String getJam;
  final String getNamaHari;
  final String getNote;
  final String getType;
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getStartTime;
  final String getEndTime;
  final String getScheduleName;
  final String getWorkLocation;
  final String getLocationLat;
  final String getLocationLong;
  const ClockOut(this.getKaryawanNo, this.getJam, this.getNamaHari,this.getNote,this.getType,
      this.getKaryawanNama,
      this.getKaryawanJabatan,this.getStartTime,this.getEndTime,this.getScheduleName,
      this.getWorkLocation,this.getLocationLat,this.getLocationLong);
  @override
  _ClockOut createState()=> _ClockOut();
}


class _ClockOut extends State<ClockOut> {

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  showInvalidDateTimeSettingDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(getBahasa.toString() == "1"? "Tutup" : "Close",style: GoogleFonts.lexendDeca(color: Colors.black),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        style: ElevatedButton.styleFrom(
            primary: HexColor("#1a76d2"),
            elevation: 0,
            shape: RoundedRectangleBorder(side: BorderSide(
                color: Colors.white,
                width: 0.1,
                style: BorderStyle.solid
            ),
              borderRadius: BorderRadius.circular(5.0),
            )),
        child: Text(getBahasa.toString() == "1"?  "Pengaturan":"Setting",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold),),
        onPressed:  () {
          DatetimeSetting.openSetting();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Kesalahan Ditemukan" :"Error Found", style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign:
      TextAlign.center,),
      content: Text(getBahasa.toString() == "1"?  "Kami menemukan pengaturan waktu anda tidak standart, silahkan nyalakan pengaturan waktu dan tanggal otomatis di perangkat anda,"
          " atau tap button pengaturan di bawah ini"
          : "We found your time settings are not standard, please turn on automatic time and date settings on your device, or tap the settings button below", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.center,),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  _add_attendance() async {
    await m_helper().add_attendance(widget.getKaryawanNo, widget.getNamaHari,
        widget.getJam, widget.getNote, widget.getStartTime, widget.getEndTime,
      widget.getScheduleName, widget.getType, widget.getWorkLocation, widget.getLocationLat,
        widget.getLocationLong).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          if(value[0] != '') {
            if(value[0] == '0') {
              getBahasa.toString() == "1"?
              AppHelper().showFlushBarsuccess(context, "Anda sudah absen, atau anda tidak ada jadwal untuk hari ini") :
              AppHelper().showFlushBarsuccess(context, "You have been do attendance, or you have no schedule for today");
              return;
            } else if(value[0] == '1') {
              Navigator.pushReplacement(context, ExitPage(page: Home()));
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                getBahasa.toString() == "1"?
                AppHelper().showFlushBarconfirmed(context, "Horray ! "+widget.getType+" berhasil") :
                AppHelper().showFlushBarconfirmed(context, "Horray ! "+widget.getType+" successed");
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


  cek_datetimesetting() async {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();
    bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
    bool canMockLocation = await SafeDevice.canMockLocation;
    if (!timezoneAuto || !timeAuto) {
      EasyLoading.dismiss();
      showInvalidDateTimeSettingDialog(context);
      return false;
    } else {
      await _add_attendance();
    }
  }



  @override
  void initState() {
    super.initState();
    getSettings();
    EasyLoading.dismiss();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        //backgroundColor: HexColor(AppHelper().main_color),
        //backgroundColor: HexColor("#3a5664"),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          widget.getType.toString(), style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        leading: Builder(
          builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () => {
                Navigator.pop(context)
              }),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
              Padding(padding: EdgeInsets.only(top: 50),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.getKaryawanNama,style: GoogleFonts.nunito(fontSize: 23,fontWeight: FontWeight.bold),),
              ),),
            Padding(padding: EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.getKaryawanJabatan,style: GoogleFonts.nunito(fontSize: 15),),
              ),),

            Padding(padding: EdgeInsets.only(top: 55),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  getBahasa.toString() == "1"?
                  AppHelper().getTanggal_withhari().toString()
                    : AppHelper().getTanggal_withhariEnglish().toString()
                  ,style: GoogleFonts.nunito(fontSize: 12),),
              ),),

            Padding(padding: EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.getJam,style: GoogleFonts.nunito(fontSize: 32,fontWeight: FontWeight.bold),),
              ),),



            Padding(padding: EdgeInsets.only(top: 15),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 150,
                  child: ElevatedButton(child : Text(widget.getType.toString(),
                    style: GoogleFonts.lexendDeca(color:Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                    style: ElevatedButton.styleFrom(
                        //primary: HexColor("#075E54"),
                        primary: HexColor("#00aa5b"),
                        elevation: 0,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    onPressed: (){
                      EasyLoading.show(status: AppHelper().loading_text);
                      cek_datetimesetting();
                      //_add_attendance();
                      //Navigator.push(context, ExitPage(page: PageClockIn(getKaryawanNo, getJam, getWorkLocationId, AppHelper().getNamaHari().toString(),getWorkLat.toString(),getWorkLong.toString(),getScheduleID.toString()))).then(onGoBack);
                    },)
                )
              ),)


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