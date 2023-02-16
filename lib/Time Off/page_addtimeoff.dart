



import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Helper/page_route.dart';
import '../page_home.dart';
import 'S_HELPER/g_timeoff.dart';
import 'S_HELPER/m_timeoff.dart';



class PageAddTimeOff extends StatefulWidget{
    final String getKaryawanNo;
    final String getKaryawanNama;
    const PageAddTimeOff(this.getKaryawanNo, this.getKaryawanNama);
  @override
  _PageAddTimeOff createState() => _PageAddTimeOff();
}


class _PageAddTimeOff extends State<PageAddTimeOff> {

  var selectedTimeOffTipe;
  List timeOffTypeList = [];
  var selectedRequestto;
  var needTime;
  var selectedTimeStart;
  var selectedTimeEnd;
  var startDate;
  var endDate;
  var delegatedNo;
  var delegatedName;
  List RequesttoList = [];
  String provinsi = '';
  bool _isPressedBtn = true;
  bool _isPressedHUD = false;
  String timeoffType = 'For Myself';
  var items = [
    'For Myself',
    'Request for Someone'
  ];

  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _delegate = TextEditingController();
  TextEditingController _TimeStart = TextEditingController();
  TextEditingController _TimeEnd = TextEditingController();
  TextEditingController _uploadme = TextEditingController();
  TextEditingController _timeofftype = TextEditingController();


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




  _getTimeOffNeedTime(String getVal) async {
    EasyLoading.show(status: AppHelper().loading_text);
    await g_timeoff().function_NeedTime(getVal, widget.getKaryawanNo).then((value){
          if(value[0] == 'ConnInterupted'){
            getBahasa.toString() == "1"?
            AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
            AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
              return false;
          } else {
            setState(() {
              needTime = value[0];
              saldoTimeOff = value[1];
            });
          }
    });
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
  _timeoff_create() async {
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      fcm_message =  getBahasa.toString() == "1" ? "Terdapat permintaan CUTI yang membutuhkan approval anda, "
          "silahkan buka aplikasi MISHR untuk melihat pengajuan ini." :
          "There is a LEAVE request that requires your approval, please open the MISHR application to view this submission.";
     // EasyLoading.show(status: "Loading...");
    });

      await m_timeoff().timeoff_create(selectedTimeOffTipe, startDate.toString(),
        endDate.toString(), _TimeStart.text, _TimeEnd.text,needTime.toString(),
        widget.getKaryawanNo, widget.getKaryawanNama, delegatedNo.toString(),
        delegatedName.toString(), _description.text, durationme.toString(), Baseme, fcm_message).then((value){
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
                if (value[0] == '0') {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarsuccess(context, "Maaf kuota anda tidak mencukupi")
                      :
                  AppHelper().showFlushBarsuccess(context, "Insufficient Balance");
                  return;
                } else if (value[0] == '1') {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarsuccess(context,
                      "Maaf data approval anda belum lengkap,silahkan hubungi HRD terkait hal ini")
                  :
                  AppHelper().showFlushBarsuccess(context,
                      "Sorry, your approval data is incomplete, please contact HRD regarding this matter");
                  return;
                } else if (value[0] == '2') {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarsuccess(context,
                      "Maaf anda masih ada request attendance yang belum di tindaklanjuti  di hari yang sama,"
                          "silahkan batalkan request attendance atau tunggu pengajuan di approved") :
                  AppHelper().showFlushBarsuccess(context,
                      "Sorry, you still have attendance requests that have not been followed up on the same day,"
                          "Please cancel the attendance request or wait for the submission to be approved");
                  return;
                } else if (value[0] == '3') {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarsuccess(context,
                      "Maaf anda masih ada pengajuan lain yang belum di tindaklanjuti  di hari yang sama,"
                          "silahkan batalkan pengajuan dan coba lagi") :
                  AppHelper().showFlushBarsuccess(context,
                      "Sorry, you still have a Time Off application that has not been followed up on the same day,"
                          "Please cancel the Time Off application or wait for the application to be approved");
                  return;
                } else if (value[0] == '4') {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarsuccess(context,"Maaf ada jadwal OFF di hari atau salah satu hari pengajuan anda")
                  :AppHelper().showFlushBarsuccess(context,"Sorry there is an OFF schedule on the day or one of the days of your application");
                  return;
                } else if (value[0] == '6') {
                  getBahasa.toString() == "1"?
                  AppHelper().showFlushBarsuccess(context,"Maaf untuk ijin tidak boleh lebih dari 1 hari")
                  :AppHelper().showFlushBarsuccess(context,"Sorry for permission can not be more than 1 day");
                  return;
                } else if (value[0] == '6a') {
                  AppHelper().showFlushBarsuccess(context,"Maaf cuti anda belum bisa dipakai, atau cuti anda sudah habis masa berlaku");
                  return;
                } else if (value[0] == '5') {
                  //Navigator.pop(context);
                  //Navigator.pop(context);
                  Navigator.pop(context);
                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                    getBahasa.toString() == "1"?
                    AppHelper().showFlushBarconfirmed(context, "Time Off berhasil di posting, menunggu persetujuan")
                    :AppHelper().showFlushBarconfirmed(context, "Time Off Request has been posted, waiting for approval");
                  });
                }  else {
                  AppHelper().showFlushBarsuccess(context, value[0]);
                  return;
                }
              }
        });
      }
    });
  }




  showDialogme(BuildContext context) {

    if(_timeofftype.text == '') {
      getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Type Time Off harus dipilih") :
      AppHelper().showFlushBarsuccess(context, "Please choose time off type");
      return false;
    }

    if(needTime == 'Yes') {
      if(_TimeStart == '' || _TimeEnd == '') {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Jam tidak boleh kosong"):
        AppHelper().showFlushBarsuccess(context, "Please filled clock");
        return false;
      }
    }

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
          _timeoff_create();
        },
      ),
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Tambah Pengajuan Time Off": "Add Request Time Off", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
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




  void show_requestto() {
    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              content: StatefulBuilder(
                builder: (context, setState) =>
                    Container(
                        height: 380,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 5,bottom: 10),
                              height: 55,
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                onChanged: (text) {
                                  setState(() {
                                    filter2 = text; });},
                                style: GoogleFonts.nunito(fontSize: 15),
                                decoration: new InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  fillColor: HexColor("#f4f4f4"),
                                  filled: true,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Icon(
                                      Icons.search, size: 18,
                                      color: HexColor("#6c767f"),),),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, width: 1.0,),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: HexColor("#f4f4f4"), width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: 'Search...',
                                ),
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder(
                                  future: g_timeoff().getAllrequestTo(filter2),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.data == null) {
                                      return Center(
                                          child: CircularProgressIndicator()
                                      );
                                    } else {
                                      return snapshot.data == 0 || snapshot.data.length == 0 ?
                                      Container(
                                          height: double.infinity, width: double.infinity,
                                          child: new
                                          Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  new Text(
                                                    "Tidak ada data",
                                                    style: new TextStyle(
                                                        fontFamily: 'VarelaRound',
                                                        fontSize: 14),)],)))
                                          :
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                              width: 100,
                                              height: 315,
                                              child: ListView.builder(
                                                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                                  itemBuilder: (context, i) {
                                                    return SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 5),
                                                                child: InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        _delegate.text = snapshot.data[i]["b"].toString();
                                                                        delegatedNo = snapshot.data[i]["a"].toString();
                                                                        delegatedName = snapshot.data[i]["b"].toString();
                                                                        Navigator.pop(context);
                                                                      });
                                                                    },
                                                                    child: ListTile(
                                                                      leading: Container(
                                                                        width: 35,
                                                                        height: 35,
                                                                        decoration: new BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            border: Border.all(color: HexColor("#DDDDDD"), width: 1,)
                                                                        ),
                                                                        child: CircleAvatar(
                                                                          backgroundColor: Colors.white,
                                                                          backgroundImage: AssetImage(
                                                                              'assets/user.png'),
                                                                        ),),
                                                                      title: Text(
                                                                        snapshot.data[i]["b"].toString(),
                                                                        style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold),),
                                                                      subtitle: Text(
                                                                        snapshot.data[i]["c"].toString(),
                                                                        style: GoogleFonts.nunito(fontSize: 13),),
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: const EdgeInsets.only(top: 5),
                                                                child: Divider(height: 1)),
                                                          ],
                                                        )
                                                    );
                                                  }
                                              )
                                          ),
                                        ],

                                      );
                                    }
                                  }
                              ),
                            )

                          ],
                        )

                    ),
              )
          );
        }
    );
  }






  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1"? "Buat Pengajuan Time Off" : "Add Time Off", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
                    Padding(padding: const EdgeInsets.only(top: 25),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: TextFormField(
                                  style: GoogleFonts.nunitoSans(fontSize: 16),
                                  textCapitalization: TextCapitalization.sentences,
                                  controller: _timeofftype,
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
                                    hintText: getBahasa.toString() == "1"? 'Pilih jenis time off':'Choose time off type',
                                    labelText: getBahasa.toString() == "1"? 'Jenis time off': 'Time Off Type',
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
                                                color: Colors.white,
                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 25,right: 25,top: 25),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(getBahasa.toString() == "1"? "Pilih Jenis Time Off":"Choose Time Off Type",
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
                                                        padding: EdgeInsets.only(top:25),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top:15),
                                                        color: Colors.white,
                                                        height: MediaQuery.of(context).size.height * 0.45,
                                                        child: FutureBuilder(
                                                            future: g_timeoff().getDataTimeOffType(widget.getKaryawanNo),
                                                            builder: (context, snapshot){
                                                              if (snapshot.data == null) {
                                                                return Center(
                                                                    child: CircularProgressIndicator()
                                                                );
                                                              } else {
                                                                return snapshot.data == 0 || snapshot.data?.length == 0 ?
                                                                Container(
                                                                    height: double.infinity, width : double.infinity,
                                                                    color: Colors.white,
                                                                    child: new
                                                                    Center(
                                                                        child :
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Image.asset('assets/nodata.png',width: 90,),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 13),
                                                                              child:  new Text(
                                                                                  getBahasa.toString() == "1"? "Tidak Ada Data" : "No Data",
                                                                                style: new TextStyle(
                                                                                    fontFamily: 'VarelaRound', fontSize: 13),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )))
                                                                    :
                                                                ListView.builder(
                                                                    itemExtent: 72,
                                                                    itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                                                    itemBuilder: (context, i) {
                                                                      return Column(
                                                                        children: [
                                                                          InkWell(
                                                                            child : ListTile(
                                                                              visualDensity: VisualDensity(horizontal: -2),
                                                                              dense : true,
                                                                              title: Text(snapshot.data![i]["b"].toString(),style: GoogleFonts.montserrat(
                                                                                  fontWeight: FontWeight.bold,fontSize: 15),),
                                                                              subtitle: Text(

                                                                      snapshot.data![i]["e"].toString() == '99' ?  "(Tidak ada batas kuota)" :
                                                                      "Sisa Kuota : "+snapshot.data![i]["e"].toString()  ,
                                                                                  style: GoogleFonts.workSans(
                                                                                      fontSize: 12)),
                                                                            ),
                                                                            onTap: (){
                                                                              setState(() {
                                                                                selectedTimeOffTipe = snapshot.data![i]["c"].toString();
                                                                                _timeofftype.text = snapshot.data![i]["b"].toString();
                                                                                _getTimeOffNeedTime(snapshot.data![i]["c"].toString());
                                                                                Navigator.pop(context);
                                                                              });
                                                                            },
                                                                          ),
                                                                          Padding(padding: const EdgeInsets.only(top:1),child:
                                                                          Divider(height: 1,),)
                                                                        ],
                                                                      );
                                                                    }
                                                                );
                                                              }
                                                            }
                                                        ),
                                                      )


                                                    ],
                                                  ),
                                                ),
                                              )
                                          );
                                        });
                                    FocusScope.of(context).requestFocus(
                                        new FocusNode());
                                  },

                                ),
                              ),),
                          ],
                        )
                    ),




                    saldoTimeOff.toString() != "" && saldoTimeOff.toString() != "99" ?
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
                                leading: FaIcon(FontAwesomeIcons.circleInfo,color:
                                saldoTimeOff.toString() != '0' ? HexColor("#28b9e0")
                                    : HexColor("#f9591d"),
                                ),
                                title: Text(getBahasa.toString() == "1"? "Sisa Kuota : "+saldoTimeOff.toString()+ " Hari"
                                    : "Balance : "+saldoTimeOff.toString()+ " Day",
                                    style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(getBahasa.toString() == "1"? "Hubungi HRD jika saldo anda tidak sesuai" :
                                          "Contact HRD if your balance does not match",
                                          style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),
                                    )
                                  ],
                                )
                            )
                        )
                    ) : Container(),

                    Padding(padding: const EdgeInsets.only(top: 25, right: 25),
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
                                    child: FaIcon(
                                      FontAwesomeIcons.calendar,
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
                                      child: FaIcon(
                                        FontAwesomeIcons.calendar,
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

                    needTime == 'Yes' ?
                    Padding(padding: const EdgeInsets.only(top: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [


                          new Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child:
                                  TextFormField(
                                    style: GoogleFonts.nunitoSans(fontSize: 16),
                                    textCapitalization: TextCapitalization
                                        .sentences,
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
                                      hintText: getBahasa.toString() == "1"? 'Pilih Jam':'Pick Time',
                                      labelText: getBahasa.toString() == "1"? 'Jam Mulai':'Start Time',
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
                                      DatePicker.showTimePicker(context,
                                        //showTitleActions: true,
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
                                  )
                              )
                          ),


                          new Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child:
                                TextFormField(
                                  style: GoogleFonts.nunitoSans(fontSize: 16),
                                  textCapitalization: TextCapitalization
                                      .sentences,
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
                                    hintText: getBahasa.toString() == "1"? 'Pilih Jam':'Pick Time',
                                    labelText: getBahasa.toString() == "1"? 'Jam Selesai': 'End Time',
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
                                )
                            ),
                          ),

                        ],
                      ),) :Container(),





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
                                      child: FaIcon(
                                        FontAwesomeIcons.audioDescription,
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
                              ),),
                          ],
                        )
                    ),



                    Visibility(
                      visible: false,
                      child: Padding(padding: const EdgeInsets.only(top: 25),
                        child: Column(
                          children: [

                            Align(alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: TextFormField(
                                  style: GoogleFonts.nunitoSans(fontSize: 16),
                                  textCapitalization: TextCapitalization
                                      .sentences,
                                  controller: _delegate,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FaIcon(
                                        FontAwesomeIcons.userCircle,
                                        //color: clockColor,
                                      ),
                                    ),
                                    suffixIcon:
                                    _delegate.text != '' ?
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5),
                                        child:
                                        IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.times, size: 18,),
                                          onPressed: () {
                                            setState(() {
                                              _delegate.clear();
                                            });
                                          },
                                        )) : null,
                                    contentPadding: const EdgeInsets.only(
                                        top: 2),
                                    hintText: getBahasa.toString() == "1"? 'Delegasi ke (Opsional)': 'Delegated to (Optional)',
                                    labelText: getBahasa.toString() == "1"? 'Delegasi': 'Delegate',
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
                                    show_requestto();
                                    FocusScope.of(context).requestFocus(
                                        new FocusNode());
                                  },
                                ),
                              ),),
                          ],
                        )
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
                                  controller: _uploadme,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FaIcon(
                                        FontAwesomeIcons.folderPlus,
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
            height: 58,
            child :

            saldoTimeOff.toString() != "0" ?
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
                child: Text(getBahasa.toString() == "1"? "Ajukan Sekarang":"Submit Now",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                    fontSize: 14),),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDialogme(context);
                }
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
                child: Text(getBahasa.toString() == "1"? "Buat Permintaan":"Create Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
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