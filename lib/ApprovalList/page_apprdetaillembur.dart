




import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Lembur/S_HELPER/g_lembur.dart';
import 'package:abzeno/Lembur/S_HELPER/m_lembur.dart';
import 'package:abzeno/Lembur/page_lemburactivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:steps/steps.dart';


class ApprLemburDetail extends StatefulWidget{
  final String getLemburCode;
  final String getKaryawanNo;
  final String getKaryawanNama;

  const ApprLemburDetail(this.getLemburCode,this.getKaryawanNo, this.getKaryawanNama);
  @override
  _ApprLemburDetail createState() => _ApprLemburDetail();
}

class _ApprLemburDetail extends State<ApprLemburDetail> {

  bool _isPressedBtn = true;
  bool _isPressedHUD = false;
  String lembur_createdbyno = "...";
  String lembur_date = "2022-05-23";
  String lembur_dateto = "2022-05-23";
  String lembur_createdbyname = "...";
  String lembur_delegateto = "...";
  String lembur_delegatetoname = "...";
  String lembur_scheduleclockin = "Loading";
  String lembur_scheduleclockout = "Loading";
  String lembur_note = "...";
  String lembur_approval1 = "...";
  String lembur_approval1status = "...";
  String lembur_approval1date = "2022-05-23";
  String lembur_approval2 = "...";
  String lembur_approval2status = "...";
  String lembur_approval2date = "2022-05-23";
  String lembur_status = "...";
  String lembur_datecreated = "2022-05-23";
  String lembur_appr1nama = "...";
  String lembur_appr1jabatan = "...";
  String lembur_appr2nama = "...";
  String lembur_appr2jabatan = "...";
  String lembur_no = "...";
  _get_LemburDetail() async {
    await g_lembur().get_LemburDetail(
        widget.getLemburCode, widget.getKaryawanNo).then((value) {
      if (value[0] == 'ConnInterupted') {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          lembur_createdbyno = value[0];
          lembur_createdbyname = value[1];
          lembur_delegateto = value[2];
          lembur_delegatetoname = value[3];
          lembur_date = value[4];
          lembur_dateto = value[5];
          lembur_scheduleclockin = value[6];
          lembur_scheduleclockout = value[7];
          lembur_note = value[8];
          lembur_approval1 = value[9];
          lembur_approval1status = value[10];
          lembur_approval1date = value[11];
          lembur_approval2 = value[12];
          lembur_approval2status = value[13];
          lembur_approval2date = value[14];
          lembur_status = value[15];
          lembur_appr1nama = value[17];
          lembur_appr1jabatan = value[18];
          lembur_appr2nama = value[19];
          lembur_appr2jabatan = value[20];
          lembur_no = value[21];
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



  @override
  void initState() {
    super.initState();
    getSettings();
    EasyLoading.show(status: AppHelper().loading_text);
    _get_LemburDetail();
  }





  String fcm_message = "";
  String fcm_message2 = "";
  _lembur_reject(getAppr) async {
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      if(getAppr== "1") {
        fcm_message =  getBahasa.toString() == "1" ? "Pengajuan lembur anda telah ditolak oleh atasan anda sebagai approval 1" :
        "LEAVE has been rejected by your supervisor as approval 1.";
        fcm_message2 =  "";
      } else {
        fcm_message =  getBahasa.toString() == "1" ? "Pengajuan lembur anda telah ditolak oleh atasan anda sebagai approval 2" :
        "LEAVE has been rejected by your supervisor as approval 2.";
        fcm_message2 = "";
      }

      Navigator.pop(context);
    });
    await m_lembur().lembur_reject(lembur_no, widget.getKaryawanNo, getAppr, fcm_message, fcm_message2).then((value){
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
              AppHelper().showFlushBarconfirmed(context, "Pengajuan lembur berhasil ditolak")
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


  _lembur_apprv(getAppr) async {
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      if(getAppr== "1") {
        fcm_message =  getBahasa.toString() == "1" ? "Pengajuan lembur telah disetujui oleh atasan anda sebagai approval 1" :
        "LEAVE has been approved by your supervisor as approval 1.";
        fcm_message2 =  getBahasa.toString() == "1" ? "Terdapat pengajuan lembur yang membutuhkan approval anda, "
            "silahkan buka aplikasi MISHR untuk melihat pengajuan ini." :
        "There is a LEAVE request that requires your approval, please open the MISHR application to view this submission.";
      } else {
        fcm_message =  getBahasa.toString() == "1" ? "Pengajuan lembur anda telah sepenuhnya disetujui" :
        "Your LEAVE has been fully approved.";
        fcm_message2 = "";
      }

      Navigator.pop(context);
    });


    await m_lembur().lembur_approved(lembur_no, widget.getKaryawanNo, getAppr, fcm_message, fcm_message2).then((value){
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
                  AppHelper().showFlushBarconfirmed(context, "Pengajuan lembur berhasil disetujui");
                });
            } else if(value[0] == '2') {
                Navigator.pop(context);
                AppHelper().showFlushBarconfirmed(context, "Pengajuan lembur gagal diapprove karena di hari pengajuan tidak ada schedule atau jadwal OFF, silahkan"
                    " menghubungi pihak yang mengajukan, atau anda bisa menolak pengajuan ini");
                return ;
            } else if(value[0] == '3') {
              Navigator.pop(context);
              AppHelper().showFlushBarconfirmed(context, "Pengajuan lembur gagal diapprove karena di hari pengajuan tidak ada kehadiran yang berhasil direkam, silahkan"
                  " menghubungi pihak yang mengajukan, atau anda bisa menolak pengajuan ini");return ;
            } else {
              AppHelper().showFlushBarsuccess(context, value[0]);
              return;
            }
          }
        });
      }
    });
  }


  showDialogReject(BuildContext context, getModulDial) {
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
          _lembur_reject(getModulDial);
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
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menolak sebagai persetujuan "+getModulDial+" ?":
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


  showDialogApprove(BuildContext context, getModulDial) {
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
          _lembur_apprv(getModulDial);
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Setujui Pengajuan" :"Approve Request"
        , style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
        TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menyetujui sebagai persetujuan "+getModulDial+" ?"
          : "Would you like to continue approve this request as Approval 1 ?"
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




  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1" ?  "Detail Lembur":"Overtime Detail",
          style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
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
          child: SingleChildScrollView(
            child: Column(
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
                                color:
                                lembur_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                lembur_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                lembur_status.toString() == 'Rejected' ? HexColor("#FF4136") :
                                Colors.black54,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Text(lembur_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                              color:
                              lembur_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                              lembur_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                              lembur_status.toString() == 'Rejected' ? HexColor("#FF4136") :
                              Colors.black54,),),
                            onPressed: (){},
                          ),
                          height: 25,
                        )
                    ),


                    InkWell(child :Text(getBahasa.toString() == "1"? "Lihat Detail" : "More Detail", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                        color: HexColor("#02ac0e")),),
                      onTap: (){
                        Navigator.push(context, ExitPage(page: PageActivityLembur(lembur_no.toString())));
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
                              child: Text(widget.getLemburCode.toString(), style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),))
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
                      Text(getBahasa.toString() == "1"? "Persetujuan ": "Approval", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),
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
                                                Text(getBahasa.toString() == "1"? "Daftar Persetujuan": "Approval List",
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
                                                          Text(lembur_appr1nama.toString(),style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,fontSize: 15)),
                                                          Padding(
                                                            padding: EdgeInsets.only(top:5),
                                                            child: Text("("+lembur_appr1jabatan.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
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
                                                                      child: Text(getBahasa.toString() == "1"? 'Tanggal': 'Appr Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                    Padding(padding: EdgeInsets.only(bottom: 5),
                                                                      child: Text(lembur_approval1date == '0000-00-00' ? "-" : lembur_approval1date, style: GoogleFonts.nunito(fontSize: 14) ),),
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
                                                                  color: lembur_approval1status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                  lembur_approval1status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                  HexColor("#FF4136"),
                                                                  style: BorderStyle.solid,
                                                                ),
                                                              ),
                                                              child: Text(lembur_approval1status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                  color: lembur_approval1status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                  lembur_approval1status.toString() == 'Approved' ? HexColor("#3D9970") :
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
                                                          Text(lembur_appr2nama.toString(),style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,fontSize: 15)),
                                                          Padding(
                                                            padding: EdgeInsets.only(top:5),
                                                            child: Text("("+lembur_appr2jabatan.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
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
                                                                      child: Text(getBahasa.toString() == "1"? 'Tanggal': 'Appr Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                                                    Padding(padding: EdgeInsets.only(bottom: 5),
                                                                      child: Text(lembur_approval2date == '0000-00-00' ? "-" : lembur_approval2date, style: GoogleFonts.nunito(fontSize: 14) ),),
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
                                                                  color: lembur_approval2status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                  lembur_approval2status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                  HexColor("#FF4136"),
                                                                  style: BorderStyle.solid,
                                                                ),
                                                              ),
                                                              child: Text(lembur_approval2status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                  color: lembur_approval2status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                  lembur_approval2status.toString() == 'Approved' ? HexColor("#3D9970") :
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
                      Text(getBahasa.toString() == "1"? "Tanggal Pembuatan": "Created On", textAlign: TextAlign.left, style: GoogleFonts.nunito(fontSize: 13),),
                      Text( AppHelper().getTanggalCustom(lembur_datecreated.toString()) + " "+
                          AppHelper().getNamaBulanCustomFull(lembur_datecreated.toString()) + " "+
                          AppHelper().getTahunCustom(lembur_datecreated.toString()), style: GoogleFonts.nunito(fontSize: 13),),],
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

                lembur_status.toString() == 'Pending' ?
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
                ) : lembur_status.toString() == 'Cancel' ?

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
                ) : lembur_status.toString() == 'Rejected' ?

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
                    padding: EdgeInsets.only(top:20),
                    child: Align(alignment: Alignment.centerLeft,
                      child: Text(getBahasa.toString() == "1"? "Deskripsi Pengajuan Lembur" : "Overtime Description", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),)),

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
                                child: Text(getBahasa.toString() == "1"? 'Dibuat Oleh' : 'Created By', style: GoogleFonts.nunito(fontSize: 14) ),),
                              Padding(padding: EdgeInsets.only(bottom: 5),
                                child: Text(lembur_createdbyname.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                            ]),


                            TableRow(children :[
                              Padding(padding: EdgeInsets.only(bottom: 5),
                                child: Text(getBahasa.toString() == "1"? 'Catatan' : 'Note', style: GoogleFonts.nunito(fontSize: 14) ),),
                              Padding(padding: EdgeInsets.only(bottom: 5),
                                child: Text(lembur_note.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                            ]),

                            TableRow(children :[
                              Padding(padding: EdgeInsets.only(bottom: 5),
                                child: Text(getBahasa.toString() == "1"? 'Tanggal' : 'Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                              Padding(padding: EdgeInsets.only(bottom: 5),
                                child: Text(AppHelper().getTanggalCustom(lembur_date.toString()) + " "+
                                    AppHelper().getNamaBulanCustomFull(lembur_date.toString()) + " "+
                                    AppHelper().getTahunCustom(lembur_date.toString()), style: GoogleFonts.nunito(fontSize: 14) ),),
                            ]),

                            TableRow(children :[
                              Padding(padding: EdgeInsets.only(bottom: 5),
                                child: Text('Jam Selesai', style: GoogleFonts.nunito(fontSize: 14) ),),
                              Padding(padding: EdgeInsets.only(bottom: 5),
                                child: Text(lembur_scheduleclockin.toString().substring(0,5), style: GoogleFonts.nunito(fontSize: 14) ),),
                            ]),
                            // TableRow(children :[
                            //   Padding(padding: EdgeInsets.only(bottom: 5),
                            //     child: Text(getBahasa.toString() == "1"? 'Clock Out' : 'Clock Out', style: GoogleFonts.nunito(fontSize: 14) ),),
                            //   Padding(padding: EdgeInsets.only(bottom: 5),
                            //     child: Text(lembur_scheduleclockout.toString().substring(0,5), style: GoogleFonts.nunito(fontSize: 14) ),),
                            // ]),
                          ]
                      ),
                    )),


              ],
            ),
          ),
        ),
      ),
      bottomSheet:

      Visibility(
          visible: _isPressedBtn,
          child: Container(color: Colors.white,
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
              width: double.infinity,
              height: 65,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceEvenly,
                children: [


                  lembur_approval1.toString() == widget.getKaryawanNo && lembur_approval1status.toString() == 'Waiting Approval' ?
                  Container(
                      width: 150,
                      height: 45,
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
                          showDialogApprove(context, "1");
                        },
                      )
                  ) : Container(),



                  lembur_approval1.toString() == widget.getKaryawanNo && lembur_approval1status.toString() == 'Waiting Approval' ?
                  Container(
                      width: 150,
                      height: 45,
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
                          showDialogReject(context, "1");
                        },
                      )
                  ) : Container(),


                  //APPROVAL 2 ====================================
                  lembur_approval2.toString() == widget.getKaryawanNo && lembur_approval2status.toString() == 'Waiting Approval' &&
                      lembur_approval1status.toString() == 'Approved' ?
                  Container(
                      width: 150,
                      height: 45,
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
                          showDialogApprove(context, "2");
                        },
                      )
                  ) : Container(),



                  lembur_approval2.toString() == widget.getKaryawanNo && lembur_approval2status.toString() == 'Waiting Approval'  &&
                      lembur_approval1status.toString() == 'Approved'  ?
                  Container(
                      width: 150,
                      height: 45,
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
                          showDialogReject(context, "2");
                        },
                      )
                  ) : Container(),







                ],
              ))
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

