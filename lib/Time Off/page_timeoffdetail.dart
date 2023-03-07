


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


class TimeOffDetail extends StatefulWidget{
  final String getTimeOffCode;
  final String getKaryawanNo;
  final String getKaryawanNama;
  const TimeOffDetail(this.getTimeOffCode,this.getKaryawanNo, this.getKaryawanNama);
  @override
  _TimeOffDetail createState() => _TimeOffDetail();
}


class _TimeOffDetail extends State<TimeOffDetail> {
  bool _isPressedBtn = true;
  bool _isPressedHUD = false;

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
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
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
        });
      }
    });
    await getSettings();
  }


  loadData2() async {
    await _get_TimeOffDetail();
    EasyLoading.dismiss();
  }


  @override
  void initState() {
    super.initState();
    //EasyLoading.show(status: AppHelper().loading_text);
    loadData2();
  }



  String fcm_message = "";
  _timeoff_cancel() async {
    Navigator.pop(context);
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      fcm_message =  getBahasa.toString() == "1" ? "Pihak yang membuat CUTI telah membatalkan pengajuannya hari ini" :
      "The party that made LEAVE has canceled his leave today.";
    });
    await m_timeoff().timeoff_cancel(widget.getKaryawanNo, timeoff_number, widget.getKaryawanNama, fcm_message).then((value){
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
              Navigator.pop(context);
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                AppHelper().showFlushBarconfirmed(context, "Time Off Request has been Cancel");
              });
            } else if(value[0] == '2') {
              //Navigator.pop(context);
              AppHelper().showFlushBarsuccess(context, "Gagal membatalkan pengajuan anda.");
              return;
            } else {
              AppHelper().showFlushBarsuccess(context, value[0]);
              return;
            }
          }
        });
      }
    });
  }


  dialog_timeoffCancel(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text("BATALKAN",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _timeoff_cancel();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text("Batalkan Pengajuan", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text("Apakah anda yakin untuk membatalkan pengajuan ini ?", style: GoogleFonts.nunitoSans(),textAlign:
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
      bottomSheet: Visibility(
        visible: _isPressedBtn,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
            width: double.infinity,
            height: 58,
            child:
            timeoff_status == 'Pending'?
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
              child: Text(getBahasa.toString() == "1"? "Batalkan Pengajuan" : "Cancel Submission",style: GoogleFonts.lexendDeca(color: HexColor("#ffeaef"),fontWeight: FontWeight.bold,
                  fontSize: 14),),
              onPressed: () {
                dialog_timeoffCancel(context);
              },
            ) :
            Container()
        ),
      )
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