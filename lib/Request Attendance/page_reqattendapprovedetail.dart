
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:steps/steps.dart';
import 'S_HELPER/g_reqattend.dart';
import 'S_HELPER/m_reqattend.dart';
import 'page_reqattendactivitydetail.dart';


class ReqAttendApproveDetail extends StatefulWidget{
  final String getReqAttendCode;
  final String getKaryawanNo;
  //final String getKaryawanNama;
  final String getModulTab;
  const ReqAttendApproveDetail(this.getReqAttendCode,this.getKaryawanNo, this.getModulTab);
  @override
  _ReqAttendApproveDetail createState() => _ReqAttendApproveDetail();
}

class _ReqAttendApproveDetail extends State<ReqAttendApproveDetail> {

  bool _isPressedBtn = true;
  bool _isPressedHUD = false;

  String reqattend_status = "...";
  String reqattend_date = "2022-05-23";
  String reqattend_type = "...";
  String reqattend_scheduleclockin = "...";
  String reqattend_scheduleclockout = "...";
  String reqattend_clockin = "...";
  String reqattend_clockout = "...";
  String reqattend_description = "...";
  String reqattend_approv1 = "...";
  String reqattend_approve1_status = "...";
  String reqattend_approve1_date = "...";
  String reqattend_approv1_nama = "...";
  String reqattend_approv1_jabatan = "...";
  String reqattend_approv2 = "...";
  String reqattend_approve2_status = "...";
  String reqattend_approve2_date = "...";
  String reqattend_approv2_nama = "...";
  String reqattend_approv2_jabatan = "...";
  String reqattend_datecreated = "2022-05-23";
  String reqattend_schedulecode = "...";
  String reqattend_karyawannam = "...";
  String getClockIn = "...";
  String getClockOut = "...";
  String getClockIn2 = "...";
  String getClockOut2 = "...";
  String reqattend_schedulebefore = "...";
  String reqattend_scheduleclockinbefore = "...";
  String reqattend_scheduleclockoutbefore = "...";


  _get_ReqAttendDetail() async {
    await g_reqattend().get_ReqAttendDetail(
        widget.getReqAttendCode, widget.getKaryawanNo).then((value) {
      if (value[0] == 'ConnInterupted') {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          reqattend_status = value[0];
          reqattend_type = value[1];
          reqattend_date = value[2];
          reqattend_scheduleclockin = value[3];
          reqattend_scheduleclockout = value[4];
          reqattend_clockin = value[5];
          reqattend_clockout = value[6];
          reqattend_description = value[7];
          reqattend_approv1 = value[8];
          reqattend_approve1_status = value[9];
          reqattend_approve1_date = value[10];
          reqattend_approv1_nama = value[11];
          reqattend_approv1_jabatan = value[12];
          reqattend_approv2 = value[13];
          reqattend_approve2_status = value[14];
          reqattend_approve2_date = value[15];
          reqattend_approv2_nama = value[16];
          reqattend_approv2_jabatan = value[17];
          reqattend_datecreated = value[18];
          reqattend_schedulecode = value[19];
          reqattend_karyawannam = value[20];
          getClockIn2 = value[21];
          getClockOut2 = value[22];
          reqattend_schedulebefore = value[23];
          reqattend_scheduleclockinbefore = value[24];
          reqattend_scheduleclockoutbefore = value[25];
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
    _get_ReqAttendDetail();
  }


  String fcm_message = "";
  String fcm_message2 = "";
  _reqattend_approve(getAppr) async {
    //======================================
    Navigator.pop(context);
    setState(() {
      _isPressedHUD = true;
      _isPressedBtn = false;
      if(getAppr== "1") {
        fcm_message =  getBahasa.toString() == "1" ? "Permintaan telah disetujui oleh atasan anda sebagai approval 1" :
        "Request has been approved by your supervisor as approval 1.";
        fcm_message2 =  getBahasa.toString() == "1" ? "Terdapat permintaan yang membutuhkan approval anda, "
            "silahkan buka aplikasi MISHR untuk melihat pengajuan ini." :
        "There is a request that requires your approval, please open the MISHR application to view this submission.";
      } else {
        fcm_message =  getBahasa.toString() == "1" ? "Permintaan anda telah sepenuhnya disetujui" :
        "Your request has been fully approved.";
        fcm_message2 = "";
      }

    });
    await m_reqattend().reqattend_approve(widget.getReqAttendCode, widget.getKaryawanNo, getAppr, reqattend_type.toString(), fcm_message, fcm_message2).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
            if(value[0] == '1') {
              setState(() {
                _isPressedHUD = false;
                _isPressedBtn = true;
              });

              if(widget.getModulTab == "1") {
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  AppHelper().showFlushBarconfirmed(context, getBahasa.toString() == "1"? "Permintaan berhasil disetujui": "Request has been Approved");
                });
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  AppHelper().showFlushBarconfirmed(context, getBahasa.toString() == "1"? "Permintaan berhasil disetujui": "Request has been Approved");
                });
              }

            } else {
              setState(() {
                _isPressedHUD = false;
                _isPressedBtn = true;
              });
              AppHelper().showFlushBarsuccess(context, value[0]);
              return;
            }
        });
      }
    });
  }




  _reqattend_reject(getAppr) async {
    Navigator.pop(context);
    setState(() {
      _isPressedHUD = true;
      _isPressedBtn = false;
      if(getAppr== "1") {
        fcm_message =  getBahasa.toString() == "1" ? "Permintaan anda telah ditolak oleh atasan anda sebagai approval 1" :
        "Request has been rejected by your supervisor as approval 1.";
        fcm_message2 =  "";
      } else {
        fcm_message =  getBahasa.toString() == "1" ? "Permintaan anda telah ditolak oleh atasan anda sebagai approval 2" :
        "Request has been rejected by your supervisor as approval 2.";
        fcm_message2 = "";
      }
    });
    await m_reqattend().reqattend_reject(widget.getReqAttendCode, widget.getKaryawanNo, getAppr, reqattend_type.toString(), fcm_message).then((value){
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
              if(widget.getModulTab == "1") {
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  AppHelper().showFlushBarconfirmed(context, getBahasa.toString() == "1"? "Permintaan berhasil ditolak": "Request has been rejected");

                });
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  AppHelper().showFlushBarconfirmed(context, getBahasa.toString() == "1"? "Permintaan berhasil ditolak": "Request has been rejected");
                });
              }
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



  showDialog1(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "SETUJUI":"Approve",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _reqattend_approve("1");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Setujui Permintaan" :"Approve Request", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menyetujui sebagai persetujuan 1 ?":
      "Would you like to continue approve this request as Approval 1 ?", style: GoogleFonts.nunitoSans(),textAlign: TextAlign.left,),
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


  showDialog2(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "SETUJUI": "Approve",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _reqattend_approve("2");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"?  "Setujui Permintaan":"Approve Request",style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menyetujui sebagai persetujuan 2 ? ":
      "Would you like to continue approve this request as Approval 2 ?", style: GoogleFonts.nunitoSans(),textAlign: TextAlign.left,),
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


  showDialogReject1(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"?  "TOLAK":"Reject",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _reqattend_reject("1");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
        actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tolak Permintaan": "Reject Request",
        style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menolak sebagai persetujuan 1 ?":
      "Would you like to continue reject this request as Approval 1 ?", style: GoogleFonts.nunitoSans(),textAlign: TextAlign.left,),
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



  showDialogReject2(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"? "TOLAK" :"Reject"
          ,style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _reqattend_reject("2");
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"?  "Tolak Permintaan":"Reject Request",
        style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
      content: Text(getBahasa.toString() == "1"?  "Apakah anda yakin menolak sebagai persetjuan 2 ? " :
      "Would you like to continue reject this request as Approval 2 ?", style: GoogleFonts.nunitoSans(),textAlign: TextAlign.left,),
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
        title: Text("Detail Pengajuan", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 0,
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
        child : Container(
          color : Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 25,right: 25,top: 15,bottom: 80),
          child: SingleChildScrollView(
              child : Column(
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
                                  color: reqattend_status.toString() == 'Pending'? Colors.black54 :
                                  reqattend_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  reqattend_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  HexColor("#FF4136"),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text(reqattend_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                  color: reqattend_status.toString() == 'Pending'? Colors.black54 :
                                  reqattend_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  reqattend_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  HexColor("#FF4136")),),
                              onPressed: (){},
                            ),
                            height: 25,
                          )
                      ),

                      InkWell(child :Text( getBahasa.toString() == "1"? "Lihat Detail" : "More Detail", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                          color: HexColor("#02ac0e")),),
                        onTap: (){
                          Navigator.push(context, ExitPage(page: PageReqAttendActivityDetail(widget.getReqAttendCode.toString())));
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
                                child: Text(widget.getReqAttendCode.toString(), style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),))
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
                                                            Text(reqattend_approv1_nama.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 15)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: Text("("+reqattend_approv1_jabatan.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
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
                                                                        child: Text(reqattend_approve1_date == '0000-00-00' ? "-" : reqattend_approve1_date, style: GoogleFonts.nunito(fontSize: 14) ),),
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
                                                                    color: reqattend_approve1_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    reqattend_approve1_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136"),
                                                                    style: BorderStyle.solid,
                                                                  ),
                                                                ),
                                                                child: Text(reqattend_approve1_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                    color: reqattend_approve1_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    reqattend_approve1_status.toString() == 'Approved' ? HexColor("#3D9970") :
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
                                                            Text(reqattend_approv2_nama.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 15)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: Text("("+reqattend_approv2_jabatan.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
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
                                                                        child: Text(reqattend_approve2_date == '0000-00-00' ? "-" : reqattend_approve2_date, style: GoogleFonts.nunito(fontSize: 14) ),),
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
                                                                    color: reqattend_approve2_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    reqattend_approve2_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136"),
                                                                    style: BorderStyle.solid,
                                                                  ),
                                                                ),
                                                                child: Text(reqattend_approve2_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                    color: reqattend_approve2_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    reqattend_approve2_status.toString() == 'Approved' ? HexColor("#3D9970") :
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
                        Text( AppHelper().getTanggalCustom(reqattend_datecreated.toString()) + " "+
                            AppHelper().getNamaBulanCustomFull(reqattend_datecreated.toString()) + " "+
                            AppHelper().getTahunCustom(reqattend_datecreated.toString()), style: GoogleFonts.nunito(fontSize: 13),),],
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
                        child: Text(getBahasa.toString() == "1"? "Info Permintaan" : "Request Info", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),)),

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
                                  child: Text(getBahasa.toString() == "1"? 'Jenis Permintaan' : 'Request Type', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(reqattend_type.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Keterangan' : 'Description', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(reqattend_description.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),
                            ]
                        ),
                      )),

                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(height: 2,)),

                  reqattend_status.toString() == 'Pending' ?
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
                  ) : reqattend_status.toString() == 'Cancel' ?

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
                  ) : reqattend_status.toString() == 'Rejected' ?

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
                  ) : reqattend_status.toString() == 'Fully Approved' ?

                  Padding(padding: const EdgeInsets.only(top: 10,bottom: 15),
                      child : Container(
                          padding: EdgeInsets.only(top: 2,bottom: 2),
                          decoration: BoxDecoration(
                            //border: Border.all(color: HexColor("#06a912")),
                            color: HexColor("#d6ffdd"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  ListTile(
                            visualDensity: VisualDensity(horizontal: -2),
                            dense : true,
                            leading: FaIcon(FontAwesomeIcons.circleCheck,color:HexColor("#06a912"),

                            ),
                            title:Text(getBahasa.toString() == "1"? "Permintaan ini sudah sepenuhnya disetujui" :
                            "This application has been fully approved",
                                style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                          )
                      )
                  ) : Container(),

                  Padding(
                      padding: EdgeInsets.only(top: 20),
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
                            children: [

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Tanggal Permintaan':'Request Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child:   Text(
                                      getBahasa.toString() == "1"?
                                      AppHelper().getTanggalCustom(reqattend_date.toString()) + " "+
                                          AppHelper().getNamaBulanCustomFull(reqattend_date.toString()) + " "+
                                          AppHelper().getTahunCustom(reqattend_date.toString()) :
                                      AppHelper().getTanggalCustom(reqattend_date.toString()) + " "+
                                          AppHelper().getNamaBulanCustomFullEnglish(reqattend_date.toString()) + " "+
                                          AppHelper().getTahunCustom(reqattend_date.toString()), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),


                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Permintaan Oleh': 'Request By', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(reqattend_karyawannam.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),


                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Jadwal Sebelumnya': 'Previous Schedule', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                    child: InkWell(
                                      child: Text( getBahasa.toString() == "1"? "Selengkapnya" : "See More", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                                          color: HexColor("#02ac0e")),),
                                      onTap: () {
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
                                                              Text(getBahasa.toString() == "1"? "Jadwal Sebelumnya": "Previous Schedule",
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
                                                          ),
                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(reqattend_schedulebefore.toString() == 'null' ? '-' : reqattend_schedulebefore.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Jadwal Sebelumnya": "Previous Schedule",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),


                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(reqattend_scheduleclockinbefore.toString() == '' ? '-' : reqattend_scheduleclockinbefore.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Jam Masuk sebelumnya di tanggal permintaan anda": "Previous Clock In at requested date",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),

                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(reqattend_scheduleclockoutbefore.toString() == '' ? '-' : reqattend_scheduleclockoutbefore.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Jam Keluar sebelumnya di tanggal permintaan anda": "Previous Clock Out at requested date",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),

                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              );
                                            });
                                      },
                                    )),
                              ]),



                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5,right: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Kehadiran Sebelumnya': 'Previous Attendance', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                    child: InkWell(
                                      child: Text( getBahasa.toString() == "1"? "Selengkapnya" : "See More", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                                          color: HexColor("#02ac0e")),),
                                      onTap: () {
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
                                                              Text(getBahasa.toString() == "1"? "Kehadiran Sebelumnya": "Previous Attendance",
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
                                                          ),

                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(getClockIn2.toString() == '00:00' ? '-' : getClockIn2.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Jam Masuk di tanggal permintaan anda": "Clock In at request date",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),

                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(getClockOut2.toString() == '00:00' ? '-' : getClockOut2.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Jam Keluar di jam permintaan anda": "Clock Out at request date",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),

                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              );
                                            });
                                      },
                                    )),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Pengajuan Jadwal': 'Schedule Request', style: GoogleFonts.nunito(fontSize: 14) ),),

                                Padding(padding: EdgeInsets.only(bottom: 5),
                                    child: InkWell(
                                      child: Text( getBahasa.toString() == "1"? "Selengkapnya" : "See More", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                                          color: HexColor("#02ac0e")),),
                                      onTap: () {
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
                                                              Text(getBahasa.toString() == "1"? "Pengajuan Jadwal": "Schedule Request",
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
                                                          ),

                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(reqattend_schedulecode.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Kode Jadwal": "Schedule Request",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),

                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(reqattend_scheduleclockin.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Clock In": "Clock In request",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),

                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: -2),
                                                            dense : true,
                                                            title: Text(reqattend_scheduleclockout.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 17),),
                                                            subtitle: Text(getBahasa.toString() == "1"? "Clock Out": "Clock Out request",
                                                                style: GoogleFonts.workSans(
                                                                    fontSize: 12)),
                                                          ),
                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                          Divider(height: 1,),),

                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              );
                                            });
                                      },
                                    )),

                              ]),





                            ]
                        ),

                      )),

                ],
              )
          ),

        ),
      ),
      bottomSheet: Visibility(
        visible: _isPressedBtn,
        child: Container(color: Colors.white,
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
        width: double.infinity,
        height: 55,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            reqattend_approv1.toString() == widget.getKaryawanNo && reqattend_approve1_status.toString() == 'Waiting Approval' ?
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
                    showDialog1(context);
                  },
                )
            ) : Container(),



            reqattend_approv1.toString() == widget.getKaryawanNo && reqattend_approve1_status.toString() == 'Waiting Approval' ?
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
                    showDialogReject1(context);
                  },
                )
            ) : Container(),



            reqattend_approv2.toString() == widget.getKaryawanNo &&
                (reqattend_approve2_status.toString() == 'Waiting Approval' && reqattend_status.toString() == 'Approved 1') ?
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
                    showDialog2(context);
                  },
                )
            ) : Container(),


            reqattend_approv2.toString() == widget.getKaryawanNo &&
                (reqattend_approve2_status.toString() == 'Waiting Approval' && reqattend_status.toString() == 'Approved 1') ?
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
                    showDialogReject2(context);
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