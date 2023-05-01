


import 'dart:convert';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:unicons/unicons.dart';

import '../Profile/S_HELPER/g_profile.dart';


class AttendanceHistory extends StatefulWidget{
  final String getKaryawanNo;
  const AttendanceHistory(this.getKaryawanNo);
  @override
  _AttendanceHistory createState() => _AttendanceHistory();
}



class _AttendanceHistory extends State<AttendanceHistory> {
  var yearme = DateFormat('yyyy').format(DateTime.now());
  var monthme = DateFormat('MM').format(DateTime.now());
  final availableMaps = MapLauncher.installedMaps;
  var startDate = "0";
  var endDate = "0";
  TextEditingController _datefrom = TextEditingController();
  TextEditingController _dateto = TextEditingController();
  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }



  String filter = "thismonth";
  String filter2 = "";
  String txtFilter = "Show Data : 7 HARI TERAKHIR";
  bool btn1 = true;
  bool btn2 = false;
  show_map(String latme, String longme) async {
    //===============================
    bool isGoogleMaps =
        await MapLauncher.isMapAvailable(MapType.google) ?? false;

    if (isGoogleMaps) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(double.parse(latme), double.parse(longme)),
        title: "Location Clock In",

      );
    }
  }


  Future getData() async {
    setState(() {
      g_profile().getData_HistoryAttendance(widget.getKaryawanNo, filter, yearme, monthme,filter2,startDate.toString(),
          endDate.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        //backgroundColor: HexColor("#3a5664"),
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1"?  "Riwayat Kehadiran":"Attendance History",
          style: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
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
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 18,right: 26),
            child: InkWell(
              child : FaIcon(FontAwesomeIcons.filter,color: HexColor("#535967"),size: 18,),
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
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
                                      Text("Cari Periode",
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
                                  Column(
                                    children: [

                                      Padding(padding: const EdgeInsets.only(top: 25, right: 25,bottom: 30),
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
                                                        startDate = pickedDate.toString();
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
                                                          endDate = pickedDate.toString();
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


                                      Container(
                                        width: double.infinity,
                                        height: 65,
                                        padding: EdgeInsets.only(top: 10,bottom: 10),
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
                                          child: Text("Cari Data",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                              fontSize: 14),),
                                          onPressed: () {
                                            if(startDate.toString() == "0" || endDate.toString() == "0") {
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              AppHelper().showFlushBarsuccess(context, "Form tidak boleh kosong");
                                            } else {
                                              Navigator.pop(context);
                                              txtFilter = "Show Data : By Filter";
                                              g_profile().getData_HistoryAttendance(widget.getKaryawanNo, filter, yearme, monthme,filter2,startDate.toString(),
                                                  endDate.toString());
                                            }
                                            //dialog_appr1(context);
                                          },
                                        ),
                                      )

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    });
              },
            ),),

          Padding(
            padding: EdgeInsets.only(top: 18,right: 26),
            child: InkWell(
              child : FaIcon(FontAwesomeIcons.arrowDownWideShort,color: HexColor("#535967"),size: 20,),
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
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
                                      Text("Filter By Lama Data",
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
                                  Column(
                                    children: [

                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text("7 Hari Terakhir",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text("Tampilkan data 7 hari terakhir",
                                              style: GoogleFonts.workSans(
                                                  fontSize: 12)),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            filter2 = "";
                                            txtFilter = "Show Data : 7 HARI TERAKHIR";
                                            endDate = "0";
                                            startDate = "0";
                                            _dateto.clear();
                                            _datefrom.clear();
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),),


                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text("Bulan ini",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text("Tampilkan data dalam bulan ini",
                                              style: GoogleFonts.workSans(
                                                  fontSize: 12)),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            filter2 = "thismonth";
                                            txtFilter = "Show Data : BULAN INI";
                                            endDate = "0";
                                            startDate = "0";
                                            _dateto.clear();
                                            _datefrom.clear();
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),),

                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text("Tahun ini",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                          subtitle: Text("Tampilkan data dalam tahun ini",
                                              style: GoogleFonts.workSans(
                                                  fontSize: 12)),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            filter2 = "thisyear";
                                            txtFilter = "Show Data : TAHUN INI";
                                            endDate = "0";
                                            startDate = "0";
                                            _dateto.clear();
                                            _datefrom.clear();
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),)
                                    ],
                                  ),



                                ],
                              ),
                            ),
                          )
                      );
                    });
              },
            ),)


        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10,bottom: 15),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
            height: 40,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: OutlinedButton(child: Text(txtFilter,
                      style: GoogleFonts.nunitoSans(
                          color: HexColor("#1a76d2"),fontSize: 12,
                          fontWeight: FontWeight.bold),),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(), side: BorderSide(width: 1, color: HexColor("#1a76d2")),
                      ),
                      onPressed: (){},)
                ),
              ],
            )
        ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: FutureBuilder(
                    future: g_profile().getData_HistoryAttendance(widget.getKaryawanNo, filter, yearme, monthme,filter2,startDate.toString(),
                        endDate.toString()),
                    builder: (context, snapshot){
                      if (snapshot.data == null) {
                        return Center(
                          child: const SpinKitThreeBounce(
                            size: 30,
                            color: Colors.indigo,
                          ),
                        );
                      } else {
                        return snapshot.data == 0 || snapshot.data?.length == 0 ?
                        Container(
                            height: double.infinity, width : double.infinity,
                            child: new
                            Center(
                                child :
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/empty2.png',width: 150,),
                                    Padding(
                                      padding: EdgeInsets.only(left: 13),
                                      child:  new Text(
                                        getBahasa.toString() == "1" ? "Data Tidak Ditemukan": "Data Not Found",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 13),
                                      ),
                                    )
                                  ],
                                )))
                            :
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemExtent: 82,
                                itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                padding: const EdgeInsets.only(bottom: 85,top: 5),
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [

                                      InkWell(
                                        child: ListTile(
                                            visualDensity: VisualDensity(vertical: -2),
                                            dense : true,
                                            title:

                                            snapshot.data![i]["q"].toString() == "" ?
                                            Container(
                                              width: double.infinity,
                                              padding : EdgeInsets.all(6),
                                              child: Text(
                                                  getBahasa.toString() =="1" ?
                                                  AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                  AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                  AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()) :
                                                  AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFullEnglish(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                  style: GoogleFonts.workSans(fontSize: 12,color: Colors.black)),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color:
                                                //Jika sama sekali belum absen
                                                snapshot.data![i]["b"].toString() == '00:00' && snapshot.data![i]["c"].toString() == '00:00'  ? HexColor("#Fcdedf") :
                                                //Jika belum clock out
                                                snapshot.data![i]["b"].toString() != '00:00' && snapshot.data![i]["c"].toString() == '00:00' ? HexColor("#FF851B") :
                                                //Jika Sudah Clock In CLock Out
                                                HexColor("#EDEDED"),
                                              ),
                                            ) :

                                            Container(
                                              width: double.infinity,
                                              padding : EdgeInsets.all(6),
                                              child: Text(

                                                      AppHelper().getTanggalCustom(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getNamaBulanCustomFull(snapshot.data![i]["a"].toString()) + " "+
                                                      AppHelper().getTahunCustom(snapshot.data![i]["a"].toString()),
                                                  style: GoogleFonts.workSans(fontSize: 12, color: Colors.white)),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color:
                                                HexColor("#2196f3") ,
                                              ),
                                            ),
                                            subtitle:Column(
                                              children: [
                                                snapshot.data![i]["r"].toString() == "Bertugas" || snapshot.data![i]["r"].toString() == "Off" ?
                                                Padding(
                                                    padding: EdgeInsets.only(top: 5,left: 2),
                                                    child:
                                                    Align(alignment: Alignment.centerLeft,
                                                      child: Text(snapshot.data![i]["s"].toString().substring(8),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,fontSize: 13.5,color: Colors.black)
                                                      ),)
                                                ) :
                                                Padding(
                                                    padding: EdgeInsets.only(top: 5,left: 2),
                                                    child:
                                                    Align(alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          snapshot.data![i]["b"].toString() == '00:00' && snapshot.data![i]["c"].toString() == '00:00' ? "ABSEN" :
                                                          snapshot.data![i]["b"].toString() != '00:00' && snapshot.data![i]["c"].toString() == '00:00'  ?
                                                          "Clock In : "+snapshot.data![i]["b"].toString()+" | Clock Out : -" :
                                                          snapshot.data![i]["b"].toString() == '00:00' && snapshot.data![i]["c"].toString() == '00:00'  ?
                                                          "Clock In : - | Clock Out : -"  :
                                                          "Clock In : "+snapshot.data![i]["b"].toString()+" | Clock Out : "+snapshot.data![i]["c"].toString()
                                                          ,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,fontSize: 13.5,color: Colors.black)
                                                      ),)
                                                ),

                                                snapshot.data![i]["r"].toString() == "Bertugas" || snapshot.data![i]["r"].toString() == "Off" ?
                                                Padding(
                                                    padding: EdgeInsets.only(top: 3,left: 3),
                                                    child: Align(alignment: Alignment.centerLeft,
                                                      child: Text("Tidak perlu melakukan absensi",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.workSans(fontSize: 12.5,color: Colors.black)),)
                                                ) :
                                                Padding(
                                                    padding: EdgeInsets.only(top: 3,left: 3),
                                                    child: Align(alignment: Alignment.centerLeft,
                                                      child: Text(
                                                          snapshot.data![i]["b"].toString() == '00:00' && snapshot.data![i]["c"].toString() == '00:00' ? "(Belum melakukan absensi)" :
                                                          getBahasa.toString() =="1" ? "Telat : "+snapshot.data![i]["d"].toString()+" menit | "
                                                              "Overtime : "+snapshot.data![i]["e"].toString()+" menit" :
                                                          "Late : "+snapshot.data![i]["d"].toString()+" minute | "
                                                              "Overtime : "+snapshot.data![i]["e"].toString()+" minute",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.workSans(fontSize: 12.5,color: Colors.black)),)
                                                )
                                              ],
                                            )
                                        ),
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
                                                            Align(alignment: Alignment.centerLeft,child: Text(getBahasa.toString() =="1" ? "Detail Kehadiran":"Attendance Detail",
                                                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),)),
                                                            Padding(
                                                              padding: EdgeInsets.only(top:15),
                                                              child: Divider(height: 2,),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(top: 5,bottom: 10),
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Kode Jadwal":"Schedule Code",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 15),),
                                                                        Text(snapshot.data![i]["q"].toString() != '' ? snapshot.data![i]["q"].toString() :
                                                                        snapshot.data![i]["j"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Jadwal Jam Masuk":"Schedule Check In",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 15),),
                                                                        Text(snapshot.data![i]["f"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(getBahasa.toString() =="1" ? "Jadwal Jam Keluar": "Schedule Check Out",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 15),),
                                                                        Text(snapshot.data![i]["g"].toString(),
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),

                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text("Clock In",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 15),),
                                                                        Text(snapshot.data![i]["b"].toString() != "00:00" ? snapshot.data![i]["b"].toString() : "-",
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text("Clock Out",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.nunitoSans(fontSize: 15),),
                                                                        Text(snapshot.data![i]["c"].toString() != "00:00" ? snapshot.data![i]["c"].toString() : "-",
                                                                            style: GoogleFonts.nunitoSans(fontSize: 15)),],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),child: Divider(height: 5,),
                                                                  ),
                                                                  snapshot.data![i]["r"].toString() != 'Absen' ?
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text("Clock In Location",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.montserrat(fontSize: 14,fontWeight: FontWeight.bold),),
                                                                        ElevatedButton(onPressed: (){
                                                                          show_map(snapshot.data![i]["m"].toString(),
                                                                              snapshot.data![i]["n"].toString());
                                                                        }, child: Text(
                                                                            snapshot.data![i]["k"].toString(),style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                                            fontSize: 14)
                                                                        )),

                                                                      ],
                                                                    ),
                                                                  ) :Container(),
                                                                  snapshot.data![i]["c"].toString() != "00:00" && snapshot.data![i]["r"].toString() != 'Absen'  ?
                                                                  Padding(
                                                                    padding: EdgeInsets.only(top: 10),
                                                                    child:  Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Text("Clock Out Location",
                                                                          textAlign: TextAlign.left, style: GoogleFonts.montserrat(fontSize: 14,fontWeight: FontWeight.bold),),
                                                                        ElevatedButton(onPressed: (){}, child: Text(
                                                                            snapshot.data![i]["l"].toString(),style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                                                                            fontSize: 14)
                                                                        )),

                                                                      ],
                                                                    ),
                                                                  ) : Container()
                                                                ],
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                );
                                              });
                                        },
                                      ),


                                    ],
                                  );
                                },
                              ),
                            ),

                          ],
                        );

                      }
                    },
                  ),
                )
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