


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Setting/page_setting.dart';
import 'package:abzeno/Time%20Off/page_DetailFileAttendanceReq.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:steps/steps.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

import 'S_HELPER/g_timeoff.dart';
import 'S_HELPER/m_timeoff.dart';
import 'page_detailactivitytimeoff.dart';


class TimeOffApproveDetail extends StatefulWidget{
  final String getTimeOffCode;
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getModulTab;
  const TimeOffApproveDetail(this.getTimeOffCode,this.getKaryawanNo, this.getKaryawanNama,this.getModulTab);
  @override
  _TimeOffApproveDetail createState() => _TimeOffApproveDetail();
}


class _TimeOffApproveDetail extends State<TimeOffApproveDetail> {
  bool _isPressedBtn = true;
  bool _isPressedHUD = false;
  TextEditingController _rejectnote1 = TextEditingController();
  TextEditingController _rejectnote2 = TextEditingController();
  TextEditingController _approveNote1 = TextEditingController();
  TextEditingController _approveNote2 = TextEditingController();
  String timeoff_reqBy = "...";
  String timeoff_datefrom = "2022-05-23";
  String timeoff_dateto = "2022-05-23";
  String timeoff_jumlahhari = "0";
  String timeoff_number = "...";
  String timeoff_tipe = "...";
  String timeoff_saldo = "0";
  String timeoff_description = "...";
  String timeoff_needtime = "...";
  String timeoff_starttime = "...";
  String timeoff_endtime = "...";
  String timeoff_status = "...";
  String timeoff_jabatan1 = "...";
  String timeoff_jabatan2 = "...";
  String timeoff_appr1_name = "...";
  String timeoff_appr1_date = "...";
  String timeoff_appr1_status = "...";
  String timeoff_appr1_note = "...";
  String timeoff_appr2_name = "...";
  String timeoff_appr2_date = "...";
  String timeoff_appr2_status = "...";
  String timeoff_appr2_note = "...";
  String timeoff_delegate = "...";
  String timeoff_delegate_name = "...";
  String timeoff_file = "...";
  String timeoff_datecreated = "2022-05-23";
  String timeoff_appr1 = "...";
  String timeoff_appr2 = "...";


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }


  _get_TimeOffDetail() async {
    await g_timeoff().get_TimeOffDetail(widget.getTimeOffCode, widget.getKaryawanNo).then((value){
      if(value[0] == 'ConnInterupted'){
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...");
        return false;
      } else {
        setState(() {
          timeoff_reqBy = value[0];
          timeoff_jumlahhari = value[1];
          timeoff_number = value[2];
          timeoff_tipe = value[3];
          timeoff_saldo = value[4];
          timeoff_description = value[5];
          timeoff_needtime = value[6];
          timeoff_starttime= value[7];
          timeoff_endtime = value[8];
          timeoff_status = value[9];
          timeoff_jabatan1 = value[10];
          timeoff_jabatan2 = value[11];
          timeoff_appr1_name = value[12];
          timeoff_appr1_date = value[13];
          timeoff_appr1_status = value[14];
          timeoff_appr1_note = value[15];
          timeoff_appr2_name = value[16];
          timeoff_appr2_date = value[17];
          timeoff_appr2_status = value[18];
          timeoff_appr2_note = value[19];
          timeoff_delegate = value[20];
          timeoff_delegate_name = value[21];
          timeoff_file = value[22];
          timeoff_datecreated = value[23];
          timeoff_datefrom = value[24];
          timeoff_dateto = value[25];
          timeoff_appr1 = value[26];
          timeoff_appr2 = value[27];
        });
      }
    });
    await getSettings();
  }


  @override
  void initState() {
    super.initState();
    _get_TimeOffDetail();
    EasyLoading.dismiss();
  }


  var noteApproveVal;
  String fcm_message = "";
  String fcm_message2 = "";
  _timeoff_appr(getAppr) async {
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      if(getAppr== "1") {
        noteApproveVal = _approveNote1.text;
        fcm_message =  getBahasa.toString() == "1" ? "CUTI telah disetujui oleh atasan anda sebagai approval 1" :
        "LEAVE has been approved by your supervisor as approval 1.";
        fcm_message2 =  getBahasa.toString() == "1" ? "Terdapat permintaan CUTI yang membutuhkan approval anda, "
            "silahkan buka aplikasi MISHR untuk melihat pengajuan ini." :
        "There is a LEAVE request that requires your approval, please open the MISHR application to view this submission.";
      } else {
        noteApproveVal = _approveNote2.text;
        fcm_message =  getBahasa.toString() == "1" ? "CUTI anda telah sepenuhnya disetujui" :
        "Your LEAVE has been fully approved.";
        fcm_message2 = "";
      }

      Navigator.pop(context);
      Navigator.pop(context);
    });
    await m_timeoff().timeoff_appr(timeoff_number, widget.getKaryawanNo, getAppr, noteApproveVal, fcm_message, fcm_message2).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          if(value[0] != '') {
            setState(() {
              _isPressedBtn = true;
              _isPressedHUD = false;
            });
            if(value[0] == '1') {

              if(widget.getModulTab == '1') {
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarconfirmed(context, "Time Off berhasil disetujui")
                      :
                  AppHelper().showFlushBarconfirmed(context, "Time Off Request has been Approved");
                });
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarconfirmed(context, "Time Off berhasil disetujui")
                      :
                  AppHelper().showFlushBarconfirmed(context, "Time Off Request has been Approved");
                });
              }

            } else {
              AppHelper().showFlushBarsuccess(context, value[0]);
              return;
            }
          }
        });
      }
    });
  }


  var noteRejectVal;
  _timeoff_reject(getAppr) async {
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      if(getAppr== "1") {
        noteRejectVal = _rejectnote1.text;
        fcm_message =  getBahasa.toString() == "1" ? "CUTI anda telah ditolak oleh atasan anda sebagai approval 1" :
        "LEAVE has been rejected by your supervisor as approval 1.";
        fcm_message2 =  "";
      } else {
        noteRejectVal = _rejectnote2.text;
        fcm_message =  getBahasa.toString() == "1" ? "CUTI anda telah ditolak oleh atasan anda sebagai approval 2" :
        "LEAVE has been rejected by your supervisor as approval 2.";
        fcm_message2 = "";
      }

      Navigator.pop(context);
      Navigator.pop(context);
    });
    await m_timeoff().timeoff_reject(timeoff_number, widget.getKaryawanNo, getAppr, noteRejectVal, fcm_message, fcm_message2).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
            if(value[0] == '1') {
              setState(() {
                _isPressedBtn = true;
                _isPressedHUD = false;
              });
              Navigator.pop(context);
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                getBahasa.toString() == "1"?
                AppHelper().showFlushBarconfirmed(context, "Time Off berhasil ditolak")
                    :
                AppHelper().showFlushBarconfirmed(context, "Time Off Request has been Rejected");
              });
            } else {
              setState(() {
                _isPressedBtn = true;
                _isPressedHUD = false;
              });
              AppHelper().showFlushBarsuccess(context, value[0]);
              return;
            }
        });
      }
    });
  }



  dialog_appr1(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "SETUJUI":"APPROVE"
          ,style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _timeoff_appr("1");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Setujui Permintaan" :"Approve Request"
        , style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menyetujui permintaan ini sebagai persetujuan 1 ?": "Would you like to continue approve this request as Approval 1 ?"
        , style: GoogleFonts.nunitoSans(),textAlign:
        TextAlign.left,),
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

  dialog_appr2(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "SETUJUI": "APPROVE"
          ,style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _timeoff_appr("2");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"?  "Setujui Permintaan":"Approve Request"
        , style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menyetujui permintaan ini sebagai persetujuan 2 ? ":
      "Would you like to continue approve this request as Approval 2 ?", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.left,),
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



  dialog_reject1(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "TOLAK":"REJECT"
          ,style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _timeoff_reject("1");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tolak Permintaan": "Reject Request"
        , style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menolak permintaan ini sebagai persetujuan 1 ?":
      "Would you like to continue reject this request as Approval 1 ?", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.left,),
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



  dialog_reject2(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"? "TOLAK" :"REJECT"
          ,style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _timeoff_reject("2");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"?  "Tolak Permintaan":"Reject Request"
        , style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menolak permintaan ini sebagai persetjuan 2 ? " :
      "Would you like to continue reject this request as Approval 2 ?", style: GoogleFonts.nunitoSans(),textAlign:
      TextAlign.left,),
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
          title: Text("Detail Time Off", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
      body: ModalProgressHUD(
        inAsyncCall: _isPressedHUD,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          color : Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 25,right: 25,top: 15,bottom: 80),
          child:
          SingleChildScrollView(
              child :
              Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                side: BorderSide(
                                  width: 1,
                                  color: timeoff_status.toString() == 'Pending'? Colors.black54 :
                                  timeoff_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  timeoff_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  HexColor("#FF4136"),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text(timeoff_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                  color: timeoff_status.toString() == 'Pending'? Colors.black54 :
                                  timeoff_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  timeoff_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  HexColor("#FF4136")),),
                              onPressed: (){},
                            ),
                            height: 25,
                          )
                      ),


                      InkWell(child :Text(getBahasa.toString() == "1"? "Lihat Detail" : "More Detail", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                          color: HexColor("#02ac0e")),),
                        onTap: (){
                          Navigator.push(context, ExitPage(page: PageDetailActivityTimeOff(timeoff_number.toString())));
                        },)


                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10),
                    child: Divider(height: 2,),
                  ),


                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child:    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: 5),
                                child: Text(timeoff_number.toString(), style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),))
                            ],
                          ),
                        ),
                      ),),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child :     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getBahasa.toString() == "1"? "Persetujuan":"Approval", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),
                        InkWell(child :Text( getBahasa.toString() == "1"? "Lihat Persetujuan" : "See More", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                            color: HexColor("#02ac0e")),),
                          onTap: (){
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(getBahasa.toString() == "1"? "Daftar Persetujuan" :"Approval List",
                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: FaIcon(FontAwesomeIcons.times,size: 20,),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top:15),
                                                child: Divider(height: 2,),
                                              ),
                                              Container(
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context).size.height * 0.45,
                                                  child:
                                                  Steps(
                                                    direction: Axis.vertical,
                                                    size: 10.0,
                                                    path: {
                                                      'color': HexColor("#DDDDDD"),
                                                      'width': 1.0},
                                                    steps: [
                                                      {
                                                        'color': Colors.white,
                                                        'background': HexColor("#00aa5b"),
                                                        'label': '1',
                                                        'content': Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(timeoff_appr1_name.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 15)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: Text("("+timeoff_jabatan1.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child:  Table(
                                                                  columnWidths: {
                                                                    0: FlexColumnWidth(3),
                                                                    1: FlexColumnWidth(4),
                                                                  },
                                                                  //border: TableBorder.all(), // Allows to add a border decoration around your table
                                                                  children: [
                                                                    TableRow(children :[
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(getBahasa.toString() == "1"? 'Catatan':'Appr Note', style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(timeoff_appr1_note == '' ? "-" : "#"+timeoff_appr1_note, style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                    ]),

                                                                    TableRow(children :[
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(getBahasa.toString() == "1"? 'Tanggal':'Appr Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(timeoff_appr1_date == '0000-00-00' ? "-" : timeoff_appr1_date, style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                    ]),

                                                                  ]
                                                              ),
                                                            ),


                                                            Container(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: OutlinedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  elevation: 0,
                                                                  side: BorderSide(
                                                                    width: 1,
                                                                    color: timeoff_appr1_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    timeoff_appr1_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136"),
                                                                    style: BorderStyle.solid,
                                                                  ),
                                                                ),
                                                                child: Text(timeoff_appr1_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                    color: timeoff_appr1_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    timeoff_appr1_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136")),),
                                                                onPressed: (){},
                                                              ),
                                                              height: 35,
                                                            )

                                                          ],
                                                        ),
                                                      },

                                                      {
                                                        'color': Colors.white,
                                                        'background': HexColor("#00aa5b"),
                                                        'label': '2',
                                                        'content': Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(timeoff_appr2_name.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 15)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: Text("("+timeoff_jabatan2.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child:  Table(
                                                                  columnWidths: {
                                                                    0: FlexColumnWidth(3),
                                                                    1: FlexColumnWidth(4),
                                                                  },
                                                                  //border: TableBorder.all(), // Allows to add a border decoration around your table
                                                                  children: [
                                                                    TableRow(children :[
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(getBahasa.toString() == "1"? 'Catatan':'Appr Note', style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(timeoff_appr2_note == '' ? "-" : "#"+timeoff_appr2_note, style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                    ]),

                                                                    TableRow(children :[
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(getBahasa.toString() == "1"? 'Tanggal': 'Appr Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                      Padding(padding: EdgeInsets.only(bottom: 5),
                                                                        child: Text(timeoff_appr2_date == '0000-00-00' ? "-" : timeoff_appr2_date, style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                    ]),

                                                                  ]
                                                              ),
                                                            ),


                                                            Container(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: OutlinedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  elevation: 0,
                                                                  side: BorderSide(
                                                                    width: 1,
                                                                    color: timeoff_appr2_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    timeoff_appr2_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136"),
                                                                    style: BorderStyle.solid,
                                                                  ),
                                                                ),
                                                                child: Text(timeoff_appr2_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                    color: timeoff_appr2_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    timeoff_appr2_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136")),),
                                                                onPressed: (){},
                                                              ),
                                                              height: 35,
                                                            )

                                                          ],
                                                        ),
                                                      },

                                                    ],

                                                  )),


                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                });
                          },),],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child :     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getBahasa.toString() == "1"? "Tanggal Pembuatan":"Created On" , textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),
                        Text(
                          getBahasa.toString() == "1"?
                          AppHelper().getTanggalCustom(timeoff_datecreated.toString()) + " "+
                              AppHelper().getNamaBulanCustomFull(timeoff_datecreated.toString()) + " "+
                              AppHelper().getTahunCustom(timeoff_datecreated.toString()) :
                          AppHelper().getTanggalCustom(timeoff_datecreated.toString()) + " "+
                              AppHelper().getNamaBulanCustomFullEnglish(timeoff_datecreated.toString()) + " "+
                              AppHelper().getTahunCustom(timeoff_datecreated.toString()), style: GoogleFonts.nunito(fontSize: 13),),],
                    ),
                  ),


                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //border: Border.all(color: HexColor("#8fe4f0")),
                          color: HexColor("#e6e7e9"),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),


                  Padding(
                      padding: EdgeInsets.only(top:20),
                      child: Align(alignment: Alignment.centerLeft,
                        child: Text(getBahasa.toString() == "1"? "Info Permintaan" : 'Request Info', style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),)),

                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(alignment: Alignment.centerLeft,
                        child:
                        Table(
                            columnWidths: {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(4),
                            },
                            //border: TableBorder.all(), // Allows to add a border decoration around your table
                            children: [
                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"?'Jenis Permintaan' : 'Request Type', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(timeoff_tipe.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Keterangan' : 'Description', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(timeoff_description.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              timeoff_file != '' ?
                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Attachment' : 'Attachment', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, ExitPage(page: DetailImageAttRequest(timeoff_file)));
                                      },
                                      child: Text(timeoff_file.toString(), style: GoogleFonts.nunito(fontSize: 14,color: Colors.blue) ),
                                    )

                                ),
                              ]) :   TableRow(children :[
                                Container(),
                                Container(),
                              ])

                            ]
                        ),

                      )),

                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(height: 2,)),

                  timeoff_status.toString() == 'Pending' ?
                  Padding(padding: const EdgeInsets.only(top: 10,bottom: 15),
                      child : Container(
                          padding: EdgeInsets.only(top: 2,bottom: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#8fe4f0")),
                            color: HexColor("#ebfffe"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  ListTile(
                            visualDensity: VisualDensity(horizontal: -2),
                            dense : true,
                            leading: FaIcon(FontAwesomeIcons.circleInfo,color:HexColor("#28b9e0"),

                            ),
                            title:Text(getBahasa.toString() == "1"? "Permintaan ini masih bisa untuk dibatalkan" :
                            "This request can still be cancelled",
                                style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                          )
                      )
                  ) : timeoff_status.toString() == 'Cancel' ?

                  Padding(padding: const EdgeInsets.only(top: 10,bottom: 15),
                      child : Container(
                          padding: EdgeInsets.only(top: 2,bottom: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#fb8fb1")),
                            color: HexColor("#ffeaef"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  ListTile(
                            visualDensity: VisualDensity(horizontal: -2),
                            dense : true,
                            leading: FaIcon(FontAwesomeIcons.circleInfo,color:HexColor("#d52f58"),

                            ),
                            title:Text(getBahasa.toString() == "1"? "Permintaan sudah dibatalkan" : "The request has been cancelled",
                                style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                          )
                      )
                  ) : timeoff_status.toString() == 'Rejected' ?

                  Padding(padding: const EdgeInsets.only(top: 10,bottom: 15),
                      child : Container(
                          padding: EdgeInsets.only(top: 2,bottom: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor("#fb8fb1")),
                            color: HexColor("#ffeaef"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  ListTile(
                            visualDensity: VisualDensity(horizontal: -2),
                            dense : true,
                            leading: FaIcon(FontAwesomeIcons.circleInfo,color:HexColor("#d52f58"),

                            ),
                            title:Text(getBahasa.toString() == "1"? "Permintaan ini sudah ditolak oleh atasan" : "This request has been rejected",
                                style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                          )
                      )
                  ) : Container(),



                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(alignment: Alignment.centerLeft,
                        child: Text(getBahasa.toString() == "1"?  "Rincian Permintaan" : "Request Detail", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),)),

                  Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Align(alignment: Alignment.centerLeft,
                        child:
                        Table(
                            columnWidths: {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(4),

                            },
                            //border: TableBorder.all(), // Allows to add a border decoration around your table
                            children: [
                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Permintaan Oleh':'Request By', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(timeoff_reqBy.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                             /* TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Delegasi':'Delegate', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(timeoff_delegate == 'null' ? '-' : timeoff_delegate_name, style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),*/

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Tanggal Mulai':'Start Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                      getBahasa.toString() == "1"?
                                      AppHelper().getTanggalCustom(timeoff_datefrom.toString()) + " "+
                                          AppHelper().getNamaBulanCustomSingkat(timeoff_datefrom.toString()) + " "+
                                          AppHelper().getTahunCustom(timeoff_datefrom.toString()) :
                                      AppHelper().getTanggalCustom(timeoff_datefrom.toString()) + " "+
                                          AppHelper().getNamaBulanCustomSingkatEnglish(timeoff_datefrom.toString()) + " "+
                                          AppHelper().getTahunCustom(timeoff_datefrom.toString()), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Tanggal Selesai':'End Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                      getBahasa.toString() == "1"?
                                      AppHelper().getTanggalCustom(timeoff_dateto.toString()) + " "+
                                          AppHelper().getNamaBulanCustomSingkat(timeoff_dateto.toString()) + " "+
                                          AppHelper().getTahunCustom(timeoff_dateto.toString()) :
                                      AppHelper().getTanggalCustom(timeoff_dateto.toString()) + " "+
                                          AppHelper().getNamaBulanCustomSingkatEnglish(timeoff_dateto.toString()) + " "+
                                          AppHelper().getTahunCustom(timeoff_dateto.toString())
                                      , style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Jam Mulai':'Start Time', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(timeoff_starttime.toString() == '00:00:00' ? "-" :
                                  timeoff_starttime.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Jam Selesai':'End Time', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(timeoff_endtime.toString() == '00:00:00' ? "-" :
                                  timeoff_endtime.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Jumlah Hari' : 'Days', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                      getBahasa.toString() == "1"?
                                      timeoff_jumlahhari.toString()+" hari" :
                                      timeoff_jumlahhari.toString()+" day", style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Saldo' : 'Balance', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                      getBahasa.toString() == "1"?
                                      timeoff_saldo.toString()+" hari" :
                                      timeoff_saldo.toString()+" day", style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                            ]
                        ),

                      )),

                ],
              )),
        ),
      ),
      bottomSheet:Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
        width: double.infinity,
        height: 50,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          children: [


            timeoff_appr1.toString() == widget.getKaryawanNo && timeoff_appr1_status.toString() == 'Waiting Approval' ?
            Container(
                width: 150,
                child:
                    Visibility(
                      visible: _isPressedBtn,
                      child :
                ElevatedButton(
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
                  child: Text(getBahasa.toString() == "1"? 'Setujui':"Approve Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
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
                                      Align(alignment: Alignment.centerLeft,child: Text(getBahasa.toString() == "1"?  'Catatan Persetujuan':"Approval Note",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                      Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                        child: Column(
                                          children: [
                                            Align(alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: TextFormField(
                                                  style: GoogleFonts.workSans(fontSize: 16),
                                                  textCapitalization: TextCapitalization
                                                      .sentences,
                                                  controller: _approveNote1,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 2),
                                                    hintText: getBahasa.toString() == "1"?  'Tulis catatan anda sebagai persetujuan 1': 'Write your notes as approval 1',
                                                    labelText: getBahasa.toString() == "1"?  'Catatan':'Note',
                                                    labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                        fontSize: 16.5, color: Colors.black87
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#8c8989")),
                                                    ),
                                                    border: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                  ),

                                                ),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 65,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
                                        child:
                                        ElevatedButton(
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
                                          child: Text(getBahasa.toString() == "1"? "Setujui": "Approve",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            dialog_appr1(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          );
                        });
                  },
                ))
            ) : Container(),



            timeoff_appr1.toString() == widget.getKaryawanNo && timeoff_appr1_status.toString() == 'Waiting Approval' ?
            Container(
                width: 150,
                child:
                Visibility(
                    visible: _isPressedBtn,
                    child :
                    ElevatedButton(
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
                  child: Text(getBahasa.toString() == "1"?  "Tolak":"Reject Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
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
                                      Align(alignment: Alignment.centerLeft,child: Text(getBahasa.toString() == "1"?  "Catatan Penolakan": "Reject Note",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                      Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                        child: Column(
                                          children: [
                                            Align(alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: TextFormField(
                                                  style: GoogleFonts.workSans(fontSize: 16),
                                                  textCapitalization: TextCapitalization
                                                      .sentences,
                                                  controller: _rejectnote1,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 2),
                                                    hintText: getBahasa.toString() == "1"?  'Tulis catatan anda sebagai persetujuan 1':
                                                    'Write your notes as approval 1',
                                                    labelText: getBahasa.toString() == "1"? 'Catatan' :'Note',
                                                    labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                        fontSize: 16.5, color: Colors.black87
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#8c8989")),
                                                    ),
                                                    border: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                  ),

                                                ),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 65,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
                                        child:
                                        ElevatedButton(
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
                                          child: Text(getBahasa.toString() == "1"?  "Tolak": "Reject",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            dialog_reject1(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          );
                        });
                  },
                ))
            ) : Container(),



            timeoff_appr2.toString() == widget.getKaryawanNo &&
                (timeoff_appr1_status.toString() == 'Approved' || timeoff_appr1_status.toString() != 'Rejected'
                    || timeoff_appr1_status.toString() != 'Waiting Approval') &&
                (timeoff_appr2_status.toString() == 'Waiting Approval') ?
            Container(
                width: 150,
                child:
                Visibility(
                    visible: _isPressedBtn,
                    child :
                    ElevatedButton(
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
                  child: Text(getBahasa.toString() == "1"?  "Setujui":"Approve Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
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
                                      Align(alignment: Alignment.centerLeft,child: Text(getBahasa.toString() == "1"?  "Catatan Persetujuan":"Approval Note",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                      Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                        child: Column(
                                          children: [
                                            Align(alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: TextFormField(
                                                  style: GoogleFonts.workSans(fontSize: 16),
                                                  textCapitalization: TextCapitalization
                                                      .sentences,
                                                  controller: _approveNote2,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 2),
                                                    hintText: getBahasa.toString() == "1"?  'Tulis catatan anda sebagai persetujuan 2'
                                                        :'Write your notes as approval 2',
                                                    labelText: getBahasa.toString() == "1"? 'Catatan' :'Note',
                                                    labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                        fontSize: 16.5, color: Colors.black87
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#8c8989")),
                                                    ),
                                                    border: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                  ),

                                                ),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 65,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
                                        child:
                                        ElevatedButton(
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
                                          child: Text(getBahasa.toString() == "1"? "Setujui":"Approve",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            dialog_appr2(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          );
                        });
                  },
                ))
            ) : Container(),


            timeoff_appr2.toString() == widget.getKaryawanNo &&
                (timeoff_appr1_status.toString() == 'Approved' || timeoff_appr1_status.toString() != 'Rejected'
                    || timeoff_appr1_status.toString() != 'Waiting Approval') &&
                (timeoff_appr2_status.toString() == 'Waiting Approval') ?
            Container(
                width: 150,
                child:
                Visibility(
                    visible: _isPressedBtn,
                    child :
                    ElevatedButton(
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
                  child: Text(getBahasa.toString() == "1"? "Tolak":"Reject Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {
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
                                      Align(alignment: Alignment.centerLeft,child: Text(getBahasa.toString() == "1"?
                                      "Catatan Persetujuan": "Approval Note",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                      Padding(padding: EdgeInsets.only(top: 25,bottom: 25),
                                        child: Column(
                                          children: [
                                            Align(alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0),
                                                child: TextFormField(
                                                  style: GoogleFonts.workSans(fontSize: 16),
                                                  textCapitalization: TextCapitalization
                                                      .sentences,
                                                  controller: _rejectnote2,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(
                                                        top: 2),
                                                    hintText: getBahasa.toString() == "1"? 'Tulis catatan anda sebagai persetujuan 2'
                                                        :'Write your notes as approval 2',
                                                    labelText: getBahasa.toString() == "1"? 'Catatan': 'Note',
                                                    labelStyle: TextStyle(fontFamily: "VarelaRound",
                                                        fontSize: 16.5, color: Colors.black87
                                                    ),
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    hintStyle: GoogleFonts.nunito(color: HexColor("#c4c4c4"), fontSize: 15),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#8c8989")),
                                                    ),
                                                    border: UnderlineInputBorder(borderSide: BorderSide(
                                                        color: HexColor("#DDDDDD")),
                                                    ),
                                                  ),

                                                ),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 65,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
                                        child:
                                        ElevatedButton(
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
                                          child: Text(getBahasa.toString() == "1"? "Tolak":"Reject",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            dialog_reject2(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          );
                        });
                  },
                ))
            ) : Container(),





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