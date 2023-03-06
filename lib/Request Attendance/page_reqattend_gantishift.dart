




import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'S_HELPER/g_reqattend.dart';
import 'S_HELPER/m_reqattend.dart';


class RequestGantiShift extends StatefulWidget{
  final String getKaryawanNo;
  final String getType;
  final String getDate;
  final String getDescription;
  final String getDate2;
  const RequestGantiShift(this.getKaryawanNo, this.getType, this.getDate, this.getDescription, this.getDate2);
  @override
  _RequestGantiShift createState() => _RequestGantiShift();
}


class _RequestGantiShift extends State<RequestGantiShift> {
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  var selectedTimeStart;
  var selectedTimeEnd;
  bool _isPressedBtn = false;
  bool _isVisibleForm = false;
  bool _isPressedHUD = false;
  String getNameShift = "...";
  String getClockIn = "...";
  String getClockOut = "...";
  String getClockIn2 = "...";
  String getClockOut2 = "...";
  _get_ReqAttendSchedule_Gantishift() async {
    await g_reqattend().get_ReqAttendSchedule_Gantishift(
        widget.getKaryawanNo, widget.getDate).then((value) {
      if (value[0] == 'ConnInterupted') {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
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



  List scheduleList = [];
  var selectedscheduleList;
  getAllSchedule() async {
    await g_reqattend().getAllSchedule().then((value) {
      if (value[0] == 'ConnInterupted') {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          scheduleList = value[0];
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
    EasyLoading.show(status: AppHelper().loading_text);
    getSettings();
    _get_ReqAttendSchedule_Gantishift();
    getAllSchedule();

  }


  String fcm_message = "";
  _reqattend_gantishift_create() async {
    EasyLoading.show(status: AppHelper().loading_text);
    setState(() {
      _isPressedBtn = false;
      fcm_message =  getBahasa.toString() == "1" ? "Terdapat permintaan Ganti Shift yang membutuhkan approval anda, "
          "silahkan buka aplikasi MISHR untuk melihat pengajuan ini." :
      "There is a Change Shift request that requires your approval, please open the MISHR application to view this submission.";
    });
    await m_reqattend().reqattend_gantishift_create(widget.getKaryawanNo, widget.getDate,
        widget.getType, widget.getDescription, selectedscheduleList , getNameShift.toString(), getClockIn2, getClockOut2, fcm_message).then((value){
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
                        "Sorry, your approval data is incomplete, please contact HRD regarding this matter"
                );
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
    FocusScope.of(context).requestFocus(new FocusNode());
    if(selectedscheduleList.toString() == 'null') {
      AppHelper().showFlushBarsuccess(context, getBahasa.toString() == "1"? "Jadwal harus dipilih" : "Please choose schedule");
      setState(() {
        _isPressedBtn = true;
      });
      return false;
    } else if (selectedscheduleList.toString() == getNameShift) {
      AppHelper().showFlushBarsuccess(context, getBahasa.toString() == "1"? "Jadwal baru tidak boleh sama" : "Please choose new schedule");
      setState(() {
        _isPressedBtn = true;
      });
      return false;
    }

    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text(getBahasa.toString() == "1"? "AJUKAN": "Yes",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          Navigator.pop(context);
          _reqattend_gantishift_create();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tambah Pengajuan Ganti Shift": "Add Attendance Correction", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Text( getBahasa.toString() == "1"? "Apakah anda yakin data sudah benar dan melanjutkan untuk mengirim pengajuan ?":
      "Are you sure the data is correct and continues to send a submission ?", style: GoogleFonts.nunitoSans(),textAlign:
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
        title: Text("Detail Pengajuan", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
        visible: true,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(left: 25,right: 25),
            child:

            Column(
              children: [

                Container(
                    padding: EdgeInsets.only(top:20),
                    width: double.infinity,
                    child: Column(
                      children: [

                        Text(getBahasa.toString() == "1"? "Jadwal Sebelumnya": "Current Schedule",style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,
                            color: Colors.black)),
                        Wrap(
                          // alignment: WrapAlignment.start,
                          spacing: 15,
                          children: [
                            Container(
                              width: 100,
                              child:   ListTile(
                                title: Text(getBahasa.toString() == "1"? "Jadwal":"Schedule",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                subtitle: Text(getNameShift.toString() == 'null' ? "OFF" :
                                getNameShift.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                    color: Colors.black),),
                              ),
                            ),
                            Container(
                              width: 100,
                              child:   ListTile(
                                title: Text(getBahasa.toString() == "1"? "Jam Masuk": "Clock In",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                subtitle: Text(getClockIn.toString() == '' ||
                                    getClockIn.toString() == '0' ? "..." : getClockIn.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                    color: Colors.black),),
                              ),
                            ),

                            Container(
                              width: 100,
                              child:   ListTile(
                                title: Text(getBahasa.toString() == "1"? "Jam Keluar": "Clock Out",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                subtitle: Text(getClockOut.toString() == "" || getClockOut.toString() == "0"
                                    ? "..." : getClockOut.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                    color: Colors.black),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),


                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Divider(height: 2,),
                ),


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
                  child:   Stack(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(getBahasa.toString() == "1"? "Jadwal Baru": "New Schedule",
                          style: TextStyle(fontFamily: "VarelaRound",
                              fontSize: 11.5, color: Colors.black87),),
                      ),),
                      Align(alignment: Alignment.centerLeft, child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: DropdownButton(
                          isExpanded: false,
                          hint: Text(getBahasa.toString() == "1"? "Pilih jadwal baru": "Choose new schedule",
                            style: GoogleFonts.workSans(
                                fontSize: 15, color: Colors.black),),
                          value: selectedscheduleList,
                          items:
                          scheduleList.map((item) {
                            return DropdownMenuItem(
                              value: item['a'].toString(),
                              child: Text(item['a'].toString()+ " ("+item['b'].toString().substring(0,5)+" - "+item['c'].toString().substring(0,5)+")",
                                  style: GoogleFonts.workSans(
                                      fontSize: 15, color: Colors.black)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              FocusScope.of(context).requestFocus(
                                  FocusNode());
                              // EasyLoading.show(status: "Loading...");
                              selectedscheduleList = value.toString();
                              //_getTimeOffNeedTime(value.toString());

                            });
                          },
                        ),
                      )),
                    ],
                  ),
                ),




              ],
            )
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
              child: Text(getBahasa.toString() == "1"? "Ajukan Ganti Shift": "Create Request",style: GoogleFonts.lexendDeca(color: HexColor("#ffffff"),fontWeight: FontWeight.bold,
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