




import 'package:abzeno/Bertugas/S_HELPER/g_bertugas.dart';
import 'package:abzeno/Bertugas/S_HELPER/m_bertugas.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Lembur/S_HELPER/g_lembur.dart';
import 'package:abzeno/Lembur/S_HELPER/m_lembur.dart';
import 'package:abzeno/Lembur/page_lemburactivity.dart';
import 'package:abzeno/Time%20Off/page_DetailFileAttendanceReq.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:steps/steps.dart';


class BertugasDetail extends StatefulWidget{
  final String getLemburCode;
  final String getKaryawanNo;

  const BertugasDetail(this.getLemburCode,this.getKaryawanNo);
  @override
  _BertugasDetail createState() => _BertugasDetail();
}

class _BertugasDetail extends State<BertugasDetail> {

  bool _isPressedBtn = true;
  bool _isPressedHUD = false;
  String bertugas_status = "...";
  String bertugas_karyawannama = "...";
  String bertugas_type = "...";
  String bertugas_deskripsi = "...";
  String bertugas_lamahari = "...";
  String bertugas_appr1 = "...";
  String bertugas_appr1_name = "...";
  String bertugas_appr1_jabatan = "...";
  String bertugas_appr1_status = "...";
  String bertugas_appr1_date = "2022-05-23";

  String bertugas_appr2 = "...";
  String bertugas_appr2_name = "...";
  String bertugas_appr2_jabatan = "...";
  String bertugas_appr2_status = "...";
  String bertugas_appr2_date = "2022-05-23";

  String bertugas_createddate = "2022-05-23";
  String bertugas_startdate = "2022-05-23";
  String bertugas_enddate = "2022-05-23";
  String bertugas_no = "...";
  String bertugas_file = "0";



  _get_BertugasDetail() async {
    await g_bertugas().get_BertugasDetail(
        widget.getLemburCode, widget.getKaryawanNo).then((value) {
      if (value[0] == 'ConnInterupted') {
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        return false;
      } else {
        setState(() {
          bertugas_status = value[0];
          bertugas_karyawannama = value[2];
          bertugas_type = value[4];
          bertugas_deskripsi = value[5];
          bertugas_lamahari = value[8];
          bertugas_appr1 = value[9];
          bertugas_appr1_name = value[10];
          bertugas_appr1_jabatan = value[11];
          bertugas_appr1_status = value[12];
          bertugas_appr1_date = value[13];

          bertugas_appr2 = value[14];
          bertugas_appr2_name = value[15];
          bertugas_appr2_jabatan = value[16];
          bertugas_appr2_status = value[17];
          bertugas_appr2_date = value[18];

          bertugas_createddate = value[3];
          bertugas_startdate = value[6];
          bertugas_enddate = value[7];
          bertugas_no = value[19];
          bertugas_file = value[20];
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
    _get_BertugasDetail();
  }




  String fcm_message = "";
  _bertugas_cancel() async {
    Navigator.pop(context);
    setState(() {
      _isPressedBtn = false;
      _isPressedHUD = true;
      fcm_message =  getBahasa.toString() == "1" ? "Pihak yang mengajukan telah membatalkan pengajuannya hari ini" :
      "The party that made LEAVE has canceled his leave today.";
    });
    await m_bertugas().bertugas_cancel(widget.getKaryawanNo, bertugas_no, fcm_message, bertugas_type).then((value){
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
                AppHelper().showFlushBarconfirmed(context, "Pengajuan has been cancel");
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


  dialog_lemburCancel(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("TUTUP",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget continueButton = Container(
      width: 100,
      child: TextButton(
        child: Text("BATALKAN",style: GoogleFonts.lexendDeca(color: Colors.blue,),),
        onPressed:  () {
          _bertugas_cancel();
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
          title: Text(getBahasa.toString() == "1" ?  "Detail Bertugas":"Overtime Detail", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
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
                                  bertugas_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                  bertugas_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                  bertugas_status.toString() == 'Fully Approved' ? HexColor("#FF4136") :
                                  Colors.black54,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text(bertugas_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                color:
                                bertugas_status.toString() == 'Approved 1' ? HexColor("#0074D9") :
                                bertugas_status.toString() == 'Fully Approved' ? HexColor("#3D9970") :
                                bertugas_status.toString() == 'Fully Approved' ? HexColor("#FF4136") :
                                Colors.black54,),),
                              onPressed: (){},
                            ),
                            height: 25,
                          )
                      ),


                      InkWell(child :Text(getBahasa.toString() == "1"? "Lihat Detail" : "More Detail", style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.bold,
                          color: HexColor("#02ac0e")),),
                        onTap: (){
                          Navigator.push(context, ExitPage(page: PageActivityLembur(bertugas_no.toString())));
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
                                child: Text(bertugas_no.toString(), style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),))
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
                                                            Text(bertugas_appr1_name.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 15)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: Text("("+bertugas_appr1_jabatan.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
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
                                                                        child: Text(bertugas_appr1_date == '0000-00-00' ? "-" : bertugas_appr1_date, style: GoogleFonts.nunito(fontSize: 14) ),),
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
                                                                    color: bertugas_appr1_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    bertugas_appr1_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136"),
                                                                    style: BorderStyle.solid,
                                                                  ),
                                                                ),
                                                                child: Text(bertugas_appr1_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                    color: bertugas_appr1_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    bertugas_appr1_status.toString() == 'Approved' ? HexColor("#3D9970") :
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
                                                            Text(bertugas_appr2_name.toString(),style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,fontSize: 15)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:5),
                                                              child: Text("("+bertugas_appr2_jabatan.toString()+")",style: GoogleFonts.nunitoSans(fontSize: 13)),
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
                                                                        child: Text(bertugas_appr2_date == '0000-00-00' ? "-" : bertugas_appr2_date, style: GoogleFonts.nunito(fontSize: 14) ),),
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
                                                                    color: bertugas_appr2_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    bertugas_appr2_status.toString() == 'Approved' ? HexColor("#3D9970") :
                                                                    HexColor("#FF4136"),
                                                                    style: BorderStyle.solid,
                                                                  ),
                                                                ),
                                                                child: Text(bertugas_appr2_status.toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                                    color: bertugas_appr2_status.toString() == 'Waiting Approval'? Colors.black54 :
                                                                    bertugas_appr2_status.toString() == 'Approved' ? HexColor("#3D9970") :
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
                        Text( AppHelper().getTanggalCustom(bertugas_createddate.toString()) + " "+
                            AppHelper().getNamaBulanCustomFull(bertugas_createddate.toString()) + " "+
                            AppHelper().getTahunCustom(bertugas_createddate.toString()), style: GoogleFonts.nunito(fontSize: 13),),],
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

                  bertugas_status.toString() == 'Pending' ?
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
                  ) : bertugas_status.toString() == 'Cancel' ?

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
                  ) : bertugas_status.toString() == 'Rejected' ?

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
                        child: Text(getBahasa.toString() == "1"? "Deskripsi Pengajuan" : "Overtime Description", style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold)),)),

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
                                  child: Text(getBahasa.toString() == "1"? 'Jenis' : 'Created By', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(bertugas_type.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),


                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Dibuat Oleh' : 'Created By', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(bertugas_karyawannama.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),


                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Catatan' : 'Note', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(bertugas_deskripsi.toString(), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Tanggal Mulai' : 'Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(AppHelper().getTanggalCustom(bertugas_startdate.toString()) + " "+
                                      AppHelper().getNamaBulanCustomFull(bertugas_startdate.toString()) + " "+
                                      AppHelper().getTahunCustom(bertugas_startdate.toString()), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Tanggal Selesai' : 'Date', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(AppHelper().getTanggalCustom(bertugas_enddate.toString()) + " "+
                                      AppHelper().getNamaBulanCustomFull(bertugas_enddate.toString()) + " "+
                                      AppHelper().getTahunCustom(bertugas_enddate.toString()), style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Lama Hari' : 'Note', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(bertugas_lamahari.toString()+" Hari", style: GoogleFonts.nunito(fontSize: 14) ),),
                              ]),

                              bertugas_file != '' ?
                              TableRow(children :[
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                  child: Text(getBahasa.toString() == "1"? 'Attachment' : 'Attachment', style: GoogleFonts.nunito(fontSize: 14) ),),
                                Padding(padding: EdgeInsets.only(bottom: 5),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, ExitPage(page: DetailImageAttRequest(bertugas_file)));
                                      },
                                      child: Text(bertugas_file.toString(), style: GoogleFonts.nunito(fontSize: 14,color: Colors.blue) ),
                                    )

                                ),
                              ]) :
                              TableRow(children :[
                                Container(),
                                Container(),
                              ])



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
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
              width: double.infinity,
              height: 58,
              child:
              bertugas_status == 'Pending'?
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
                  dialog_lemburCancel(context);
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

