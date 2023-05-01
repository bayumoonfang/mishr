
import 'dart:convert';
import 'dart:io';
import 'package:abzeno/Bertugas/S_HELPER/m_bertugas.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:unicons/unicons.dart';




class PageAddBertugas extends StatefulWidget{
  final String getKaryawanNo;
  final String getModul;
  const PageAddBertugas(this.getKaryawanNo, this.getModul);
  @override
  _PageAddBertugas createState() => _PageAddBertugas();
}


class _PageAddBertugas extends State<PageAddBertugas> {

  var startDate;
  var endDate;

  bool _isPressedBtn = true;
  bool _isPressedHUD = false;

  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _uploadme = TextEditingController();



  @override
  void initState() {
    super.initState();
    getSettings();
  }

  String filter2 = "";
  String saldoTimeOff = "";
  var Base64;
  var Baseme;

  late DateTime aa;
  late DateTime bb;
  String durationme = "";


  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }


  imageSelectorGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 5243194) {
        AppHelper().showFlushBarerror(context, "File tidak boleh lebih dari 5 MB");
        return false;
      } else {
        final file = result.files.first;
        final bytes = File(file.path!).readAsBytesSync();
        setState(() {
          _uploadme.text = file.name;
          Base64 = base64Encode(bytes);
        });
      }}else{}
  }



  String fcm_message = "";
  _perdin_create() async {
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      fcm_message = "Terdapat permintaan "+widget.getModul+" yang membutuhkan approval anda, "
          "silahkan buka aplikasi MISHR untuk melihat pengajuan ini.";
      // EasyLoading.show(status: "Loading...");
    });

    await m_bertugas().bertugas_create(startDate.toString(), endDate.toString(), widget.getKaryawanNo,
        _description.text, durationme.toString(), Baseme, fcm_message, widget.getModul).then((value){
      if(value[0] == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        setState(() {
          _isPressedBtn = true;
          _isPressedHUD = false;
        }); return false;
      } else {
        setState(() {
          if (value[0] != '') {
            setState(() {
              _isPressedBtn = true;
              _isPressedHUD = false;
            });
             if (value[0] == '1') {
              getBahasa.toString() == "1"?
              AppHelper().showFlushBarsuccess(context,
                  "Maaf data approval anda belum lengkap,silahkan hubungi HRD terkait hal ini")
                  :
              AppHelper().showFlushBarsuccess(context,
                  "Sorry, your approval data is incomplete, please contact HRD regarding this matter");
              return;
            } else if (value[0] == '2b') {
               AppHelper().showFlushBarsuccess(context,
                   "Maaf pengajuan gagal, karena ada pengajuan "+widget.getModul+" lain di salah satu hari pengajuan anda");
               return;
             } else if (value[0] == '3b' || value[0] == '4b' || value[0] == '5b') {
               AppHelper().showFlushBarsuccess(context,
                   "Maaf pengajuan gagal, karena ada pengajuan lain di salah satu hari pengajuan anda");
               return;
             } else if (value[0] == '2') {
               AppHelper().showFlushBarsuccess(context,
                   "Maaf pengajuan gagal, karena ada pengajuan "+widget.getModul+" lain di hari pengajuan anda");
               return;
             } else if (value[0] == '3' || value[0] == '4' || value[0] == '5') {
               AppHelper().showFlushBarsuccess(context,
                   "Maaf pengajuan gagal, karena ada pengajuan lain di hari pengajuan anda");
               return;
             } else if (value[0] == '6') {
               Navigator.pop(context);
               SchedulerBinding.instance?.addPostFrameCallback((_) {
                 getBahasa.toString() == "1"?
                 AppHelper().showFlushBarconfirmed(context, "Pengajuan "+widget.getModul+" berhasil di posting, menunggu persetujuan")
                     :AppHelper().showFlushBarconfirmed(context, "Time Off Request has been posted, waiting for approval");
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




  showDialogme(BuildContext context) {

    if(_dateto.text == '' || _datefrom.text == '') {
      getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Tanggal tidak boleh kosong"):
      AppHelper().showFlushBarsuccess(context, "Please filled date");
      return false;
    } else if(_description.text == '') {
      getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Description tidak boleh kosong"):
      AppHelper().showFlushBarsuccess(context, "Please filled description");
      return false;
    } else {
      DateTime aa = DateTime.parse(startDate.toString());
      DateTime bb = DateTime.parse(endDate.toString());
      int time = DateTime(bb.year, bb.month, bb.day).difference(DateTime(aa.year, aa.month, aa.day)).inDays;

      if(time < 0) {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Tanggal start date tidak boleh kurang dari end date") :
        AppHelper().showFlushBarsuccess(context, "The start date cannot be less than the end date");
        return false;
      } else if(time == 0) {
        setState(() {
          durationme = "1";
        });
      } else {
        setState(() {
          int durationint = time + 1;
          durationme = durationint.toString();
        });
      }
    }

    if(Base64 == null) {Baseme = '0';} else {Baseme = Base64;}

    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text( getBahasa.toString() == "1"? "AJUKAN":"SUBMIT",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          Navigator.pop(context);
          _perdin_create();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tambah Pengajuan "+widget.getModul+" ": "Add Request Time Off", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
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
    final textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(getBahasa.toString() == "1"? "Buat Pengajuan "+widget.getModul+"" : "Add Time Off", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
          elevation: 1,
          leading: Builder(
            builder: (context) =>
                IconButton(
                    icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,color: Colors.black),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isPressedHUD,
          progressIndicator: CircularProgressIndicator(),
          child : Container(
            color: Colors.white,
            height: double.infinity,
            child: Padding(
                padding: const EdgeInsets.only(left: 25, top: 5, right: 45),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Padding(padding: const EdgeInsets.only(top: 25, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: [
                            new Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child:
                                TextFormField(
                                  style: GoogleFonts.nunitoSans(fontSize: 15),
                                  textCapitalization: TextCapitalization
                                      .sentences,
                                  controller: _datefrom,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(UniconsLine.calendar_alt,
                                        //color: clockColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(top: 2),
                                    hintText: getBahasa.toString() == "1"? 'Pilih Tanggal Mulai' : 'Pick Start Date',
                                    labelText: getBahasa.toString() == "1"? 'Tanggal Mulai': 'Start Date',
                                    labelStyle: TextStyle(
                                      fontFamily: "VarelaRound",
                                      fontSize: 15, color: Colors.black87,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior
                                        .always,
                                    hintStyle: GoogleFonts.nunito(
                                        color: HexColor("#c4c4c4"), fontSize: 14),
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
                                  padding: const EdgeInsets.only(right: 15),
                                  child:
                                  TextFormField(
                                    style: GoogleFonts.nunitoSans(fontSize: 15),
                                    textCapitalization: TextCapitalization
                                        .sentences,
                                    controller: _dateto,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Icon(UniconsLine.calendar_alt,
                                          //color: clockColor,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 2),
                                      hintText: getBahasa.toString() == "1"? 'Pilih Tanggal Selesai':'Pick End Date',
                                      labelText: getBahasa.toString() == "1"? 'Tanggal Selesai': 'End Date',
                                      labelStyle: TextStyle(
                                          fontFamily: "VarelaRound",
                                          fontSize: 16.5, color: Colors.black87
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .always,
                                      hintStyle: GoogleFonts.nunito(
                                          color: HexColor("#c4c4c4"),
                                          fontSize: 14),
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





                      Padding(padding: const EdgeInsets.only(top: 25),
                          child: Column(
                            children: [

                              Align(alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: TextFormField(
                                    style: GoogleFonts.nunitoSans(fontSize: 16),
                                    textCapitalization: TextCapitalization
                                        .sentences,
                                    maxLines: 3,
                                    controller: _description,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Icon(UniconsLine.text_fields,
                                          //color: clockColor,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 2),
                                      hintText: getBahasa.toString() == "1"? 'Deskripsi permintaan':'Description of your time off',
                                      labelText: getBahasa.toString() == "1"? 'Deskripsi': 'Description',
                                      labelStyle: TextStyle(
                                          fontFamily: "VarelaRound",
                                          fontSize: 16.5, color: Colors.black87
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .always,
                                      hintStyle: GoogleFonts.nunito(
                                          color: HexColor("#c4c4c4"),
                                          fontSize: 14),
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
                                ),),
                            ],
                          )
                      ),


                      Padding(padding: const EdgeInsets.only(top: 25),
                          child: Column(
                            children: [

                              Align(alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: TextFormField(
                                    style: GoogleFonts.nunitoSans(fontSize: 16),
                                    textCapitalization: TextCapitalization
                                        .sentences,
                                    controller: _uploadme,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Icon(UniconsLine.file_plus_alt,
                                          //color: clockColor,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 2),
                                      hintText: getBahasa.toString() == "1"? 'Besar File max 5MB': 'Upload File (max 5MB)',
                                      suffixIcon:
                                      _uploadme.text != '' ?
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5),
                                          child:
                                          IconButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.times, size: 18,),
                                            onPressed: () {
                                              setState(() {
                                                _uploadme.clear();
                                              });
                                            },
                                          )) : null,
                                      labelText: getBahasa.toString() == "1"? 'Unggah File': 'Upload File',
                                      labelStyle: TextStyle(
                                          fontFamily: "VarelaRound",
                                          fontSize: 16.5, color: Colors.black87
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .always,
                                      hintStyle: GoogleFonts.nunito(
                                          color: HexColor("#c4c4c4"),
                                          fontSize: 14),
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
                                      imageSelectorGallery();
                                    },
                                  ),
                                ),),
                            ],
                          )
                      ),




                    ],
                  ),
                )
            ),
          ),
        ),
        bottomSheet: Visibility(
          visible: _isPressedBtn,
          child: Container(
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
              width: double.infinity,
              height: 68,
              child :

              saldoTimeOff.toString() != "0" ?
              Padding(
                padding: EdgeInsets.only(top:10),
                child:  ElevatedButton(
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
                    child: Text(getBahasa.toString() == "1"? "Ajukan Sekarang":"Submit Now",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                        fontSize: 14),),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showDialogme(context);
                    }
                ),
              ) :
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HexColor("#DDDDDD"),
                      elevation: 0,
                      shape: RoundedRectangleBorder(side: BorderSide(
                          color: Colors.white,
                          width: 0.1,
                          style: BorderStyle.solid
                      ),
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                  child: Text(getBahasa.toString() == "1"? "Ajukan Sekarang":"Create Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                      fontSize: 14),),
                  onPressed: () {

                  }
              )
          ) ,
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