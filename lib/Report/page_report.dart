


import 'package:abzeno/Report/S_HELPER/g_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../Helper/app_helper.dart';

class Report extends StatefulWidget{
  final String getKaryawanNo;
  const Report(this.getKaryawanNo);
  @override
  _Report createState() => _Report();
}


class _Report extends State<Report>{
  var startDate;
  var endDate;
  bool isVisibleResume = false;
  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();
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
    EasyLoading.dismiss();
  }


  String getAttendance_hari = "0";
  String getAttendance_hadir = "0";
  String getAttendance_tidakmasuk = "0";
  String getAttendance_ijin = "0";
  String getAttendance_alpa = "0";
  String prosentaseKehadiran = "0";
  String ratingMe = "0";
  _get_AttendanceResumeDetail() async {
    var prosentaseAwal;
    var prosentaseAkhir;
    EasyLoading.show(status: AppHelper().loading_text);

    if(_datefrom.text == '' || _dateto.text == '') {
      getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Tanggal harus diisi") :
      AppHelper().showFlushBarsuccess(context, "Date cannot be empty");
      EasyLoading.dismiss();
      return false;
    }


    await g_report().getDataAttendanceResume(widget.getKaryawanNo, startDate.toString(), endDate.toString()).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          getAttendance_hari = value[0];
          getAttendance_hadir = value[1];
          getAttendance_tidakmasuk = value[2];
          getAttendance_ijin = value[3];
          getAttendance_alpa = value[4];

          prosentaseAwal = ((int.parse(getAttendance_tidakmasuk) + int.parse(getAttendance_alpa)) / int.parse(getAttendance_hari)) * 100;
          prosentaseAkhir = 100 - prosentaseAwal;
          prosentaseKehadiran = prosentaseAkhir.toStringAsFixed(0);
          if(int.parse(prosentaseKehadiran) > 0 && int.parse(prosentaseKehadiran) < 20) {
            ratingMe = "1";
          } else if(int.parse(prosentaseKehadiran) >= 20 && int.parse(prosentaseKehadiran) < 40) {
            ratingMe = "2";
          } else if(int.parse(prosentaseKehadiran) >= 40 && int.parse(prosentaseKehadiran) < 60) {
            ratingMe = "3";
          } else if(int.parse(prosentaseKehadiran) >= 60 && int.parse(prosentaseKehadiran) < 80) {
            ratingMe = "4";
          } else if(int.parse(prosentaseKehadiran) >= 80 && int.parse(prosentaseKehadiran) <= 100) {
            ratingMe = "5";
          }
          isVisibleResume = true;
        });
        EasyLoading.dismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        //backgroundColor: HexColor("#3a5664"),
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1" ? "Resume Kehadiran" : "Attendance Resumes", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
      body:
      Container(
        color: HexColor("#fafafe"),
          height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 25, top: 5, right: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(top: 25, right: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 35),
                          child:
                          TextFormField(
                            style: GoogleFonts.nunitoSans(fontSize: 15),
                            textCapitalization: TextCapitalization
                                .sentences,
                            controller: _datefrom,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 2),
                              hintText: getBahasa.toString() == "1"? 'Pilih Tanggal Mulai' : 'Pick Start Date',
                              labelText: getBahasa.toString() == "1"? 'Periode Mulai': 'Start Date',
                              labelStyle: TextStyle(
                                fontFamily: "VarelaRound",
                                fontSize: 15, color: Colors.black87,
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
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  confirmText: 'CHOOSE',
                                  helpText: 'Select start date',
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                                setState(() {
                                  startDate = pickedDate;
                                  _datefrom.text =
                                      formattedDate; //set output date to TextField value.

                                });
                              } else {}
                            },
                          ),
                        ),
                      ),

                      new Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 1),
                            child:
                            TextFormField(
                              style: GoogleFonts.nunitoSans(fontSize: 15),
                              textCapitalization: TextCapitalization
                                  .sentences,
                              controller: _dateto,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    top: 2),
                                hintText: getBahasa.toString() == "1"? 'Pilih Tanggal Selesai':'Pick End Date',
                                labelText: getBahasa.toString() == "1"? 'Periode Akhir': 'End Date',
                                labelStyle: TextStyle(
                                    fontFamily: "VarelaRound",
                                    fontSize: 16.5, color: Colors.black87
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always,
                                hintStyle: GoogleFonts.nunito(
                                    color: HexColor("#c4c4c4"),
                                    fontSize: 15),
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
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022),
                                    confirmText: 'CHOOSE',
                                    helpText: 'Select end date',
                                    lastDate: DateTime(2100));
                                if (pickedDate != null) {
                                  String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(
                                      pickedDate);
                                  setState(() {
                                    endDate = pickedDate;
                                    _dateto.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                            )

                        ),
                      ),
                    ],
                  ),),

                Padding(
                  padding: EdgeInsets.only(top:15),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
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
                      child: Text(getBahasa.toString() == "1" ? "Hitung" : "Calculate",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                          fontSize: 14)),
                      onPressed: (){
                        _get_AttendanceResumeDetail();
                      },
                    ),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Divider(
                      height: 3,
                    )),

                Visibility(
                    visible: isVisibleResume,
                    child: Container(
                  child: Column(
                    children: [

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: RatingBar.builder(
                              initialRating: double.parse(ratingMe),
                              minRating: 0,
                              itemSize: 45,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(getBahasa.toString() == "1" ?  "Prosentase Kehadiran : "+ prosentaseKehadiran.toString()+"%" : "Attendance Percentage : "+ prosentaseKehadiran.toString()+"%", style: GoogleFonts.nunitoSans(fontSize: 12,color: Colors.black)),
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Divider(
                            height: 3,
                          )),


                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getBahasa.toString() == "1" ? "Resume Kehadiran" : "Attendance Resumes", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black)),
                          )
                        ),
                      Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getBahasa.toString() == "1" ? "Rincian Kehadiran dalam periode tertentu" : "Attendance Details in a certain period", style: GoogleFonts.nunitoSans(fontSize: 12,color: Colors.black)),
                          )
                      ),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 20),
                          child :
                           Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                                 border: Border.all(
                                   color: HexColor("#DDDDDD"),
                                   width: 0.5,
                                 ),
                               ),
                               padding: EdgeInsets.all(12),
                              child :
                              Wrap(
                                spacing: 15,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: [

                                  Container(
                                    child: Column(
                                        children: [
                                          Container(
                                              height: 80, width: 85,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: HexColor("#eff3f8"),
                                                border: Border.all(
                                                  color: HexColor("#DDDDDD"),
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top:14),
                                                      child: Text(getAttendance_hadir.toString(), style: GoogleFonts.montserrat(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top:9),
                                                      child: Text(getBahasa.toString() == "1" ? "Hadir" : "Arrive", style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                                                    ),
                                                  ],
                                                )
                                              )
                                          ),
                                        ],
                                    ),
                                  ),

                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 80, width: 85,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: HexColor("#eff3f8"),
                                              border: Border.all(
                                                color: HexColor("#DDDDDD"),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top:14),
                                                      child: Text(getAttendance_tidakmasuk.toString(), style: GoogleFonts.montserrat(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top:9),
                                                      child: Text(getBahasa.toString() == "1" ? "Tidak Masuk" : "Leave", style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                                                    ),
                                                  ],
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 80, width: 85,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: HexColor("#eff3f8"),
                                              border: Border.all(
                                                color: HexColor("#DDDDDD"),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top:14),
                                                      child: Text(getAttendance_ijin.toString(), style: GoogleFonts.montserrat(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top:9),
                                                      child: Text(getBahasa.toString() == "1" ? "Ijin" : "", style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                                                    ),
                                                  ],
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 80, width: 85,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: HexColor("#eff3f8"),
                                              border: Border.all(
                                                color: HexColor("#DDDDDD"),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top:14),
                                                      child: Text(getAttendance_alpa.toString(), style: GoogleFonts.montserrat(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black)),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top:9),
                                                      child: Text(getBahasa.toString() == "1" ? "Tanpa Ijin" : "Alpha", style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                                                    ),
                                                  ],
                                                )
                                            )
                                        ),
                                      ],
                                    ),
                                  ),


                                ],

                              )
                        ))





                        /*ExpansionTile(title: ),
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                    'data'
                                ),
                              )
                            ],)*/
                    ],
                  ),
                ))

              ],
            ),
          ),
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