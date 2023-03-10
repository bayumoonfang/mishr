


import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Request%20Attendance/page_reqattend_gantishift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'S_HELPER/g_reqattend.dart';
import 'page_reqattend_correction.dart';

class RequestAttendAddHome2  extends StatefulWidget {
  final String getKaryawanNo;
  final String getModul;

  const RequestAttendAddHome2(this.getKaryawanNo, this.getModul);
  _RequestAttendAddHome2 createState() => _RequestAttendAddHome2();
}


class _RequestAttendAddHome2 extends State<RequestAttendAddHome2> {


    TextEditingController _requesttype = TextEditingController();
    TextEditingController _requestdatefrom = TextEditingController();
    TextEditingController _description = TextEditingController();
    var startDate;


    String getBahasa = "1";
    getSettings() async {
      //=====================================
      await AppHelper().getSession().then((value){
        setState(() {
          getBahasa = value[20];
        });});
    }

    @override
    void initState() {
      super.initState();
      getSettings();
      setState(() {
        _requesttype.text = widget.getModul;
      });
    }

    _get_ReqAttendCheck() async {
      await g_reqattend().get_ReqAttendCheck2(
          widget.getKaryawanNo, startDate.toString().substring(0,10), widget.getModul).then((value) {
        if (value[0] == 'ConnInterupted') {
          getBahasa.toString() == "1"?
          AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
          AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
          return false;
        } else {
          setState(() {
            //AppHelper().showFlushBarsuccess(context,value[0].toString());
            if(value[0].toString() == "1") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, ada pengajuan lain di hari yang sama.");
              return ;
            } else if(value[0].toString() == "1a") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, ada pengajuan lain di hari yang sama.");
              return ;
            } else if(value[0].toString() == "2") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, anda tidak bisa mengajukan di hari terpilih karena sudah ada kehadiran yang terbuat");
              return;
            }
           else if(value[0].toString() == "3") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, anda tidak bisa mengajukan di hari terpilih karena ada pengajuan time off lain di hari yang sama");
              return;
            }
            else if(value[0].toString() == "4") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, anda tidak bisa mengajukan di hari terpilih karena anda tidak ada jadwaldi ari tersebut");
              return;
            } else if(value[0].toString() == "5") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, ada pengajuan lain di hari yang sama.");
              return;
            } else if(value[0].toString() == "6") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, ada pengajuan lain di hari yang sama.");
              return;
            } else if(value[0].toString() == "7") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, anda tidak bisa membuat pengajuan di hari terpilih karena tidak ada jadwal di hari tersebut.");
              return;
            } else if(value[0].toString() == "8") {
              AppHelper().showFlushBarsuccess(context, "Mohon maaf, anda tidak bisa membuat pengajuan di hari terpilih karena jadwal anda OFF.");
              return;
            } else {

              if(_requesttype.text == 'Correction') {
                Navigator.push(context, ExitPage(page: CorrectionAttendance(widget.getKaryawanNo, _requesttype.text, startDate.toString(), _description.text,
                    _requestdatefrom.text)));
              } else if(_requesttype.text == 'Ganti Shift')  {
                Navigator.push(context, ExitPage(page: RequestGantiShift(widget.getKaryawanNo, _requesttype.text, startDate.toString(), _description.text,
                    _requestdatefrom.text)));
              }

            }

          });
        }
      });
    }



  @override
  Widget build(BuildContext context) {
      return WillPopScope(child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(getBahasa.toString() == "1"?  "Tambah Pengajuan":"Add Request", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(bottom:15),
          child: Stack(
            children: [
              Container(
                  padding: const EdgeInsets.only(left:28,right: 25),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/cloud.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  height: 235,
              ),


              Padding(padding: const EdgeInsets.only(top:50,left: 25,right: 25),
                  child:  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 30,left: 25,right: 25),
                            child: Column(
                              children: [
                                Align(alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: TextFormField(
                                      style: GoogleFonts.nunitoSans(fontSize: 16),
                                      textCapitalization: TextCapitalization.sentences,
                                      controller: _requesttype,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: FaIcon(
                                            FontAwesomeIcons.list,
                                            //color: clockColor,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                            top: 2),
                                        hintText: 'Choose request type',
                                        labelText: getBahasa.toString() == "1"?  'Tipe Permintaan': 'Request Type',
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
                                      enabled: false,
                                    ),
                                  ),),

                               Padding(
                                 padding: EdgeInsets.only(top: 25),
                                 child:  Align(alignment: Alignment.centerLeft,
                                   child: Padding(
                                     padding: const EdgeInsets.only(left: 0),
                                     child: TextFormField(
                                       style: GoogleFonts.nunitoSans(fontSize: 16),
                                       textCapitalization: TextCapitalization.sentences,
                                       controller: _requestdatefrom,
                                       decoration: InputDecoration(
                                         prefixIcon: Padding(
                                           padding: const EdgeInsets.only(right: 10),
                                           child: FaIcon(
                                             FontAwesomeIcons.calendar,
                                             //color: clockColor,
                                           ),
                                         ),
                                         contentPadding: const EdgeInsets.only(top: 2),
                                         hintText: getBahasa.toString() == "1"? 'Pilih Tanggal' : 'Pick Date',
                                         labelText: getBahasa.toString() == "1"? 'Tanggal ':'Date',
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
                                             _requestdatefrom.text = formattedDate; //set output date to TextField value.
                                           });
                                         } else {}
                                       },
                                     ),
                                   ),),
                               ),


                                Padding(
                                  padding: EdgeInsets.only(top: 25),
                                  child:  TextFormField(
                                    style: GoogleFonts.workSans(fontSize: 16),
                                    textCapitalization: TextCapitalization
                                        .sentences,
                                    maxLines: 4,
                                    controller: _description,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: FaIcon(
                                          FontAwesomeIcons.audioDescription,
                                          //color: clockColor,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 2),
                                      hintText: getBahasa.toString() == "1"?  'Deskripsi permintaan': 'Description of your request',
                                      labelText: getBahasa.toString() == "1"?  'Deskripsi': 'Description',
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

                                  ),
                                ),




                                Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(top : 40),
                                    width: double.infinity,
                                    height: 85,
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
                                      child: Text(getBahasa.toString() == "1"? "Lanjutkan" : "Next",style: GoogleFonts.lexendDeca(color: HexColor("#ffffff"),fontWeight: FontWeight.bold,
                                          fontSize: 14),),
                                      onPressed: () {

                                        if(_requesttype.text == "") {
                                          getBahasa.toString() == "1"?
                                          AppHelper().showFlushBarsuccessBottom(
                                              context, "Pilih Request Type dahulu") :
                                          AppHelper().showFlushBarsuccessBottom(
                                              context, "Please choose request type");
                                          return;
                                        } else if(_requestdatefrom.text == "") {
                                          getBahasa.toString() == "1"?
                                          AppHelper().showFlushBarsuccessBottom(
                                              context, "Tanggal tidak boleh kosong") :
                                          AppHelper().showFlushBarsuccessBottom(
                                              context, "Please filled date");
                                          return;
                                        } else if(_description.text == "") {
                                          getBahasa.toString() == "1"?
                                          AppHelper().showFlushBarsuccessBottom(
                                              context, "Description tidak boleh kosong") :
                                          AppHelper().showFlushBarsuccessBottom(
                                              context, "Please filled description");
                                          return;
                                        } else {
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          _get_ReqAttendCheck();
                                        }
                                      },
                                    )
                                )
                              ],
                            )
                        )


                      ],
                    ),

                  ),

              ),

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