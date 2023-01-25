




import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/page_home.dart';
import 'package:abzeno/page_home2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'S_HELPER/g_reqattend.dart';
import 'S_HELPER/m_reqattend.dart';


class RequestLemburAnotherDay extends StatefulWidget{
  final String getKaryawanNo;
  final String getType;
  final String getDate;
  final String getDescription;
  final String getDate2;
  const RequestLemburAnotherDay(this.getKaryawanNo, this.getType, this.getDate, this.getDescription, this.getDate2);
  @override
  _RequestLemburAnotherDay createState() => _RequestLemburAnotherDay();
}


class _RequestLemburAnotherDay extends State<RequestLemburAnotherDay> {
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  var selectedTimeStart;
  var selectedTimeEnd;
  bool _isPressedBtn = false;
  bool _isVisibleForm = false;

  String getNameShift = "...";
  String getClockIn = "...";
  String getClockOut = "...";
  String getClockIn2 = "...";
  String getClockOut2 = "...";
  _get_ReqAttendSchedule() async {
    await g_reqattend().get_ReqAttendSchedule(
        widget.getKaryawanNo, widget.getDate).then((value) {
      if (value[0] == 'ConnInterupted') {
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...");
        return false;
      } else {
        setState(() {
          getNameShift = value[0];
          getClockIn = value[1];
          getClockOut = value[2];
          getClockIn2 = value[3];
          getClockOut2 = value[4];
          _isPressedBtn = true;
        });
      }
    });
  }


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  String getAttenceMessage = "...";
  _get_ReqAttendCheckLemburAnotherDay() async {
    await g_reqattend().get_ReqAttendCheckLemburAnotherDay(
        widget.getKaryawanNo, widget.getDate).then((value) {
      if (value[0] == 'ConnInterupted') {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          getAttenceMessage = value[0].toString();
          if(value[0].toString() == "0") {
            _get_ReqAttendSchedule();
          } else {
            _isPressedBtn = false;
          }
          _isVisibleForm = true;
        });
      }
    });
  }



  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: AppHelper().loading_text);
    getSettings();
    _get_ReqAttendCheckLemburAnotherDay();
  }



  _reqattend_lemburanotherday_create() async {
    EasyLoading.show(status: AppHelper().loading_text);
    setState(() {
      _isPressedBtn= false;
    });
    await m_reqattend().reqattend_lemburanotherday_create(widget.getKaryawanNo, widget.getDate,
        widget.getType, widget.getDescription, _TimeStart.text,_TimeEnd.text, getNameShift, getClockIn, getClockOut  ).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        setState(() {
          _isPressedBtn = true;
        }); return false;
      } else {
        setState(() {
          if (value[0] != '') {
            if (value[0] == '0') {
              setState(() {
                _isPressedBtn = true;
                AppHelper().showFlushBarsuccess(context,
                    getBahasa.toString() == "1"?
                    "Maaf data approval anda belum lengkap,silahkan hubungi HRD terkait hal ini" :
                    "Sorry, your approval data is incomplete, please contact HRD regarding this matter");
              });
              return;
            } else if (value[0] == '1') {
              setState(() {
                _isPressedBtn = true;
                AppHelper().showFlushBarsuccess(context,
                    getBahasa.toString() == "1"?
                    "Maaf anda sudah ada request di tanggal tersebut yang belum ditindaklanjuti, silahkan batalkan "
                        "request atau tunggu approval diproses" :
                    "Sorry, you already have a request on that date that hasn't been followed up, please cancel "
                        "request or wait for approval to be processed");
              });
              return;
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                AppHelper().showFlushBarconfirmed(context,
                    getBahasa.toString() == "1"?
                    "Permintaan "+widget.getType+" berhasil di posting, dan menunggu persetujuan":
                    "Attendance "+widget.getType+" has been posted, and waiting for approval");
              });
            }
          }
        });
      }
    });

  }



  showDialogme(BuildContext context) {
    if(_TimeStart.text == "") {
      AppHelper().showFlushBarsuccess(context, getBahasa.toString() == "1"? "Jam tidak boleh kosong" : "Please filled clock");
      return false;
    } else  if(_TimeEnd.text == "") {
      AppHelper().showFlushBarsuccess(context, getBahasa.toString() == "1"? "Jam tidak boleh kosong" : "Please filled clock");
      return false;
    }

    Widget cancelButton = TextButton(
      child: Text("Cancel",style: GoogleFonts.lexendDeca(color: Colors.black),),
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
        child: Text(getBahasa.toString() == "1"? "Iya": "Yes",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold),),
        onPressed:  () {
          Navigator.pop(context);
          _reqattend_lemburanotherday_create();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tambah Permintaan "+widget.getType : "Add Attendance "+widget.getType, style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign:
      TextAlign.center,),
      content: Text(getBahasa.toString() == "1"? "Apakah anda yakin membuat permintaan "+widget.getType+" ?": "Would you like to continue add attendance "+widget.getType+" ?", style: GoogleFonts.varelaRound(),textAlign:
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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1"? "Permintaan "+widget.getType: "Attendance "+widget.getType, style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
      body: Visibility(
        visible: _isVisibleForm,
        child:  Container(
          color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(left: 25,right: 25),
            child: getAttenceMessage == "1" || getAttenceMessage == "2" ?
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/empty2.png',width: 140,),
                    Text(getBahasa.toString() == "1"? "Mohon Maaf": "Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                    Text(getBahasa.toString() == "1"? "Kami menemukan permintaan yang lain":"We find another attendance request", style: GoogleFonts.nunito(fontSize: 15),
                      textAlign: TextAlign.center,),
                    Text(getBahasa.toString() == "1"? "Harap tunggu persetujuan atau batalkan permintaan terbaru Anda": "Please wait for approval or cancel your latest request", style: GoogleFonts.nunito(fontSize: 15),
                    textAlign: TextAlign.center,)
                  ]),
            ) : getAttenceMessage == "3" ?
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/empty2.png',width: 140,),
                    Text(getBahasa.toString() == "1"? "Mohon Maaf":"Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                    Text(getBahasa.toString() == "1"? "Anda sudah membuat kehadiran di tanggal ini":"You already create attendance in this date", style: GoogleFonts.nunito(fontSize: 15),
                      textAlign: TextAlign.center,),
                    Text(getBahasa.toString() == "1"? "Coba gunakan koreksi Kehadiran untuk kasus ini": "Try use Attendance correction for this case", style: GoogleFonts.nunito(fontSize: 15),
                      textAlign: TextAlign.center,)
                  ]),
            ) :
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child:   Padding(
                    padding: EdgeInsets.only(top:25),
                    child: Text(widget.getType+ " at ("+widget.getDate2+")",style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.bold,
                        color: Colors.black)),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child:  TextFormField(
                    style: GoogleFonts.workSans(fontSize: 16),
                    textCapitalization: TextCapitalization.sentences,
                    controller: _TimeStart,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 2),
                      hintText: getBahasa.toString() == "1"? 'Pilih jam masuk': 'Pick Clock In',
                      labelText: getBahasa.toString() == "1"? 'Jam Masuk': 'Clock In',
                      labelStyle: TextStyle(
                          fontFamily: "VarelaRound",
                          fontSize: 16.5, color: Colors.black87
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior
                          .always,
                      hintStyle: GoogleFonts.nunito(
                          color: HexColor("#c4c4c4"), fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor("#DDDDDD")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor("#8c8989")),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor("#DDDDDD")),
                      ),
                    ),
                    enableInteractiveSelection: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(
                          new FocusNode());
                      DatePicker.showTimePicker(context,
                        //showTitleActions: true,,
                        showSecondsColumn: false,
                        onChanged: (date) {
                          selectedTimeStart =
                              DateFormat("HH:mm").format(date);
                          _TimeStart.text = selectedTimeStart;
                        }, onConfirm: (date) {
                          selectedTimeStart =
                              DateFormat("HH:mm").format(date);
                          _TimeStart.text = selectedTimeStart;
                        },
                        currentTime: DateTime.now(),);
                    },
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child:  TextFormField(
                    style: GoogleFonts.workSans(fontSize: 16),
                    textCapitalization: TextCapitalization.sentences,
                    controller: _TimeEnd,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 2),
                      hintText: getBahasa.toString() == "1"? 'Pilih jam keluar': 'Pick Clock Out',
                      labelText: getBahasa.toString() == "1"? 'Jam Keluar': 'Clock Out',
                      labelStyle: TextStyle(
                          fontFamily: "VarelaRound",
                          fontSize: 16.5, color: Colors.black87
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior
                          .always,
                      hintStyle: GoogleFonts.nunito(
                          color: HexColor("#c4c4c4"), fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor("#DDDDDD")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor("#8c8989")),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor("#DDDDDD")),
                      ),
                    ),
                    enableInteractiveSelection: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(
                          new FocusNode());
                      DatePicker.showTimePicker(context,
                        //showTitleActions: true,
                        showSecondsColumn: false,
                        onChanged: (date) {
                          selectedTimeEnd =
                              DateFormat("HH:mm").format(date);
                          _TimeEnd.text = selectedTimeEnd;
                        }, onConfirm: (date) {
                          selectedTimeEnd =
                              DateFormat("HH:mm").format(date);
                          _TimeEnd.text = selectedTimeEnd;
                        },
                        currentTime: DateTime.now(),);
                    },
                  ),
                )




              ],
            )
        ),
      ),
      bottomSheet:

      Visibility(
      visible: _isPressedBtn,
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 45, right: 45, bottom: 10),
          width: double.infinity,
          height: 58,
          child:
          ElevatedButton(
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
            child: Text(getBahasa.toString() == "1"? "Buat Permintaan": "Create Request",style: GoogleFonts.lexendDeca(color: HexColor("#ffffff"),fontWeight: FontWeight.bold,
                fontSize: 14),),
            onPressed: () {
              //FocusScope.of(context).requestFocus(new FocusNode());
              showDialogme(context);
            },
          )
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