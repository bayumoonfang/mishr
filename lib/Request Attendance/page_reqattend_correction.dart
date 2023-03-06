



import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Request%20Attendance/S_HELPER/m_reqattend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'S_HELPER/g_reqattend.dart';


class CorrectionAttendance extends StatefulWidget{
  final String getKaryawanNo;
  final String getType;
  final String getDate;
  final String getDescription;
  final String getDate2;
  const CorrectionAttendance(this.getKaryawanNo, this.getType, this.getDate, this.getDescription, this.getDate2);
  @override
  _CorrectionAttendance createState() => _CorrectionAttendance();
}


class _CorrectionAttendance extends State<CorrectionAttendance> {
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  bool _isPressedBtn = false;
  bool _isVisibleForm = false;
  bool _isPressedHUD = false;
  var selectedTimeStart;
  var selectedTimeEnd;
  bool _isPressed = false;
  String getNameShift = "...";
  String getClockIn = "...";
  String getClockOut = "...";
  String getClockIn2 = "...";
  String getClockOut2 = "...";
  _get_ReqAttendSchedule() async {
    await g_reqattend().get_ReqAttendSchedule(
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

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }




String getAttenceMessage = "";
  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: AppHelper().loading_text);
    getSettings();
    _get_ReqAttendSchedule();
  }


  String fcm_message = "";
  _reqattend_correction_create() async {
    EasyLoading.show(status: AppHelper().loading_text);
    setState(() {
      _isPressedBtn = false;
      fcm_message =  getBahasa.toString() == "1" ? "Terdapat permintaan Koreksi Kehadiran yang membutuhkan approval anda, "
          "silahkan buka aplikasi MISHR untuk melihat pengajuan ini." :
      "There is a Attendance Correction request that requires your approval, please open the MISHR application to view this submission.";
    });
    await m_reqattend().reqattend_correction_create(widget.getKaryawanNo, widget.getDate,
        widget.getType, widget.getDescription, _TimeStart.text,_TimeEnd.text,
        getClockIn.toString(), getClockOut.toString(), getNameShift.toString(), getClockIn2, getClockOut2, fcm_message).then((value){
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
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarsuccess(context,
                      "Maaf data approval anda belum lengkap,silahkan hubungi HRD terkait hal ini") :
                  AppHelper().showFlushBarsuccess(context,
                      "Sorry, your approval data is incomplete, please contact HRD regarding this matter");
                });
                return;
            } else {
                Navigator.pop(context);
                Navigator.pop(context);
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarconfirmed(context,
                      "Persetujuan berhasil diposting, menunggu persetujuan") :
                  AppHelper().showFlushBarsuccess(context,
                      "Attendance Correction has been posted, and waiting for approval");
                });
            }
          }
        });
      }
    });
  }



  showDialogme(BuildContext context) {
    //FocusScope.of(context).requestFocus(new FocusNode());
    if(_TimeStart.text == "" || _TimeEnd.text == "") {
      getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Jam tidak boleh kosong") :
      AppHelper().showFlushBarsuccess(context, "Please filled clock");
      return false;
    } else  if(_TimeEnd.text == "") {
      getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Jam tidak boleh kosong") :
      AppHelper().showFlushBarsuccess(context, "Please filled clock");
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
          _reqattend_correction_create();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tambah Pengajuan Koreksi": "Add Attendance Correction", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
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
        title: Text(getBahasa.toString() == "1"? "Detail Pengajuan": "Attendance "+widget.getType, style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
            child: getAttenceMessage == "1" || getAttenceMessage == "2" ?
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/empty2.png',width: 140,),
                    getBahasa.toString() == "1"?
                    Text("Oh Sorry", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold),textAlign: TextAlign.center):
                    Text("Mohon Maaf", style: GoogleFonts.nunito(fontSize: 45,fontWeight: FontWeight.bold)),
                    getBahasa.toString() == "1"?
                    Text("Kami menemukan permintaan Anda yang lain", style: GoogleFonts.nunito(fontSize: 15),textAlign: TextAlign.center,):
                    Text("We find your another attendance request", style: GoogleFonts.nunito(fontSize: 15)),
                    getBahasa.toString() == "1"?
                    Text("Harap tunggu persetujuan atau batalkan permintaan terbaru Anda", style: GoogleFonts.nunito(fontSize: 15),textAlign: TextAlign.center):
                    Text("Please wait for approval or cancel your latest request", style: GoogleFonts.nunito(fontSize: 15))
                  ]),
            ) : getAttenceMessage == "3" ?
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/empty2.png',width: 140,),
                    getBahasa.toString() == "1"?
                    Text("Oh Sorry", style: GoogleFonts.nunito(fontSize: 35,fontWeight: FontWeight.bold)):
                    Text("Mohon Maaf", style: GoogleFonts.nunito(fontSize: 35,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                    getBahasa.toString() == "1"?
                    Text("Kami Tidak Menemukan Kehadiran dalam permintaan tanggal Anda", style: GoogleFonts.nunito(fontSize: 15),
                      textAlign: TextAlign.center,) :
                    Text("We Dont Find Attendance in your date request", style: GoogleFonts.nunito(fontSize: 15),
                      textAlign: TextAlign.center,),
                  ]),
            )  :
            Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top:20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("Schedule",style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,
                            color: Colors.black)),
                        Wrap(
                          // alignment: WrapAlignment.start,
                          spacing: 15,
                          children: [
                            Container(
                              width: 100,
                              child:   ListTile(
                                title: Text(getBahasa.toString() == "1"? "Jadwal": "Schedule",style: GoogleFonts.nunitoSans(fontSize: 12),),
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

                Container(
                    padding: EdgeInsets.only(top:15),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(getBahasa.toString() == "1"? "Kehadiran": "Attendance",style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,
                            color: Colors.black)),
                        Wrap(
                          // alignment: WrapAlignment.start,
                          spacing: 15,
                          children: [

                            Container(
                              width: 100,
                              child:   ListTile(
                                title: Text(getBahasa.toString() == "1"? "Jam Masuk": "Clock In",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                subtitle: Text(getClockIn2.toString() == '' ||
                                    getClockIn2.toString() == '0' ? "..." : getClockIn2.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                    color: Colors.black),),
                              ),
                            ),

                            Container(
                              width: 100,
                              child:   ListTile(
                                title: Text(getBahasa.toString() == "1"? "Jam Keluar": "Clock Out",style: GoogleFonts.nunitoSans(fontSize: 12),),
                                subtitle: Text(getClockOut2.toString() == "" || getClockOut2.toString() == "0"
                                    ? "..." : getClockOut2.toString(),style: GoogleFonts.nunitoSans(fontSize: 14,fontWeight: FontWeight.bold,
                                    color: Colors.black),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),


                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //border: Border.all(color: HexColor("#8fe4f0")),
                        color: HexColor("#e6e7e9"),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),

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
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FaIcon(
                          FontAwesomeIcons.clock,
                          //color: clockColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          top: 2),
                      hintText: getBahasa.toString() == "1"? 'Tentukan Jam Masuk': 'Pick Correction Clock In',
                      labelText: getBahasa.toString() == "1"? 'Clock In': 'Clock In',
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
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FaIcon(
                          FontAwesomeIcons.clock,
                          //color: clockColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          top: 2),
                      hintText: getBahasa.toString() == "1"? 'Tentukan Jam Keluar': 'Pick Correction Clock Out',
                      labelText: getBahasa.toString() == "1"? 'Clock Out': 'Clock Out',
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
              child: Text(getBahasa.toString() == "1"? "Ajukan Koreksi Kehadiran": "Create Request",style: GoogleFonts.lexendDeca(color: HexColor("#ffffff"),fontWeight: FontWeight.bold,
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