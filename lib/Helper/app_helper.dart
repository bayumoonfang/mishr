




import 'dart:convert';
import 'dart:io';



import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_link.dart';
import 'connection_cek.dart';
import 'session.dart';

class AppHelper{

  static var today = new DateTime.now();
  //var getBulan = new DateFormat.MMMM().format(today);
  //var getTahun = new DateFormat.y().format(today);
  var point_value = "1000";
  var main_color = "#075E54";
  var second_color = "#128C7E";
  var third_color = "#34B7F1";
  int range_max = 9999;
  var default_pass = "e10adc3949ba59abbe56e057f20f883e";
  var app_name = "MIS HR";
  var app_tag = "mishr";
  var app_company = "PT. Berjaya Abadi Investama";
  var app_createon = "2022";
  var loading_text = "Loading...";
  var merdeka_color = "Colors.white,Colors.white,Colors.red,Colors.red";



  String getTahun() {
    return new DateFormat.y().format(today);
  }

  String getTanggal() {
    return new DateFormat.d().format(today);
  }

  String getTanggalBefore() {
    return new DateFormat.d().format(today.subtract(Duration(days: 1)));
  }

  String getTahunBefore() {
    return new DateFormat.y().format(today.subtract(Duration(days: 1)));
  }


  String getNamaHari() {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(today.toString());
    var day = DateFormat('EEEE').format(dateTime);
    var hari = "";
    switch (day) {
      case 'Sunday':
        {hari = "Minggu";}
        break;
      case 'Monday':
        {hari = "Senin";}
        break;
      case 'Tuesday':
        {hari = "Selasa";}
        break;
      case 'Wednesday':
        {hari = "Rabu";}
        break;
      case 'Thursday':
        {hari = "Kamis";}
        break;
      case 'Friday':
        {hari = "Jumat";}
        break;
      case 'Saturday':
        {hari = "Sabtu";}
        break;
    }
    return hari;
  }



  String getNamaHariEnglish() {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(today.toString());
    var day = DateFormat('EEEE').format(dateTime);
    return day;
  }


  String getNamaBulanToday() {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(today.toString());
    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {month = "Januari";}
        break;
      case '02':
        {month = "Februari";}
        break;
      case '03':
        {month = "Maret";}
        break;
      case '04':
        {month = "April";}
        break;
      case '05':
        {month = "Mei";}
        break;
      case '06':
        {month = "Juni";}
        break;
      case '07':
        {month = "Juli";}
        break;
      case '08':
        {month = "Agustus";}
        break;
      case '09':
        {month = "September";}
        break;
      case '10':
        {month = "Oktober";}
        break;
      case '11':
        {month = "Nopember";}
        break;
      case '12':
        {month = "Desember";}
        break;
    }
    return month;
  }


  String getNamaBulanTodayEnglish() {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(today.toString());
    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {month = "January";}
        break;
      case '02':
        {month = "February";}
        break;
      case '03':
        {month = "March";}
        break;
      case '04':
        {month = "April";}
        break;
      case '05':
        {month = "May";}
        break;
      case '06':
        {month = "June";}
        break;
      case '07':
        {month = "July";}
        break;
      case '08':
        {month = "August";}
        break;
      case '09':
        {month = "September";}
        break;
      case '10':
        {month = "October";}
        break;
      case '11':
        {month = "November";}
        break;
      case '12':
        {month = "December";}
        break;
    }
    return month;
  }



  String getNamaBulanCustomSingkat(String getdate) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(getdate.toString());
    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {month = "Jan";}
        break;
      case '02':
        {month = "Feb";}
        break;
      case '03':
        {month = "Mar";}
        break;
      case '04':
        {month = "Apr";}
        break;
      case '05':
        {month = "Mei";}
        break;
      case '06':
        {month = "Jun";}
        break;
      case '07':
        {month = "Jul";}
        break;
      case '08':
        {month = "Agust";}
        break;
      case '09':
        {month = "Sept";}
        break;
      case '10':
        {month = "Okt";}
        break;
      case '11':
        {month = "Nop";}
        break;
      case '12':
        {month = "Des";}
        break;
    }
    return month;
  }


  String getNamaBulanCustomSingkatEnglish(String getdate) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(getdate.toString());
    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {month = "Jan";}
        break;
      case '02':
        {month = "Feb";}
        break;
      case '03':
        {month = "Mar";}
        break;
      case '04':
        {month = "Apr";}
        break;
      case '05':
        {month = "May";}
        break;
      case '06':
        {month = "Jun";}
        break;
      case '07':
        {month = "Jul";}
        break;
      case '08':
        {month = "August";}
        break;
      case '09':
        {month = "Sept";}
        break;
      case '10':
        {month = "Oct";}
        break;
      case '11':
        {month = "Nov";}
        break;
      case '12':
        {month = "Dec";}
        break;
    }
    return month;
  }

  String getNamaBulanCustomFull(String getdate) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(getdate.toString());
    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {month = "Januari";}
        break;
      case '02':
        {month = "Februari";}
        break;
      case '03':
        {month = "Maret";}
        break;
      case '04':
        {month = "April";}
        break;
      case '05':
        {month = "Mei";}
        break;
      case '06':
        {month = "Juni";}
        break;
      case '07':
        {month = "Juli";}
        break;
      case '08':
        {month = "Agustus";}
        break;
      case '09':
        {month = "September";}
        break;
      case '10':
        {month = "Oktober";}
        break;
      case '11':
        {month = "Nopember";}
        break;
      case '12':
        {month = "Desember";}
        break;
    }
    return month;
  }




  String getNamaBulanCustomFullEnglish(String getdate) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(getdate.toString());
    var m = DateFormat('MM').format(dateTime);
    var d = DateFormat('dd').format(dateTime).toString();
    var Y = DateFormat('yyyy').format(dateTime).toString();
    var month = "";
    switch (m) {
      case '01':
        {month = "January";}
        break;
      case '02':
        {month = "February";}
        break;
      case '03':
        {month = "March";}
        break;
      case '04':
        {month = "April";}
        break;
      case '05':
        {month = "May";}
        break;
      case '06':
        {month = "June";}
        break;
      case '07':
        {month = "July";}
        break;
      case '08':
        {month = "August";}
        break;
      case '09':
        {month = "September";}
        break;
      case '10':
        {month = "October";}
        break;
      case '11':
        {month = "November";}
        break;
      case '12':
        {month = "December";}
        break;
    }
    return month;
  }



  String getTanggalCustom(String getdate) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(getdate.toString());
    return new DateFormat.d().format(dateTime);
  }


  String getTahunCustom(String getdate) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(getdate.toString());
    return new DateFormat.y().format(dateTime);
  }




  String getNamaBulanBefore() {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(today.toString());
    var m = DateFormat('MM').format(dateTime.subtract(Duration(days: 1)));
    var d = DateFormat('dd').format(dateTime.subtract(Duration(days: 1)));
    var Y = DateFormat('yyyy').format(dateTime.subtract(Duration(days: 1)));
    var month = "";
    switch (m) {
      case '01':
        {month = "Januari";}
        break;
      case '02':
        {month = "Februari";}
        break;
      case '03':
        {month = "Maret";}
        break;
      case '04':
        {month = "April";}
        break;
      case '05':
        {month = "Mei";}
        break;
      case '06':
        {month = "Juni";}
        break;
      case '07':
        {month = "Juli";}
        break;
      case '08':
        {month = "Agustus";}
        break;
      case '09':
        {month = "September";}
        break;
      case '10':
        {month = "Oktober";}
        break;
      case '11':
        {month = "Nopember";}
        break;
      case '12':
        {month = "Desember";}
        break;
    }
    return month;
  }



  String getNamaBulanBeforeEnglish() {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(today.toString());
    var m = DateFormat('MM').format(dateTime.subtract(Duration(days: 1)));
    var d = DateFormat('dd').format(dateTime.subtract(Duration(days: 1)));
    var Y = DateFormat('yyyy').format(dateTime.subtract(Duration(days: 1)));
    var month = "";
    switch (m) {
      case '01':
        {month = "January";}
        break;
      case '02':
        {month = "February";}
        break;
      case '03':
        {month = "March";}
        break;
      case '04':
        {month = "April";}
        break;
      case '05':
        {month = "May";}
        break;
      case '06':
        {month = "June";}
        break;
      case '07':
        {month = "July";}
        break;
      case '08':
        {month = "August";}
        break;
      case '09':
        {month = "September";}
        break;
      case '10':
        {month = "October";}
        break;
      case '11':
        {month = "November";}
        break;
      case '12':
        {month = "December";}
        break;
    }
    return month;
  }



  String getTanggal_withhari() {
    return getNamaHari().toString()+", "+getTanggal().toString()+" "+getNamaBulanToday().toString()+ " "+getTahun().toString();
  }

  String getTanggal_nohari() {
    return getTanggal().toString()+" "+getNamaBulanToday().toString()+ " "+getTahun().toString();
  }
  String getTanggal_nohari_before() {
    return getTanggalBefore().toString()+" "+getNamaBulanBefore().toString()+ " "+getTahunBefore().toString();
  }

  //ENGLISH
  String getTanggal_withhariEnglish() {
    return getNamaHariEnglish().toString()+", "+getTanggal().toString()+" "+getNamaBulanTodayEnglish().toString()+ " "+getTahun().toString();
  }

  String getTanggal_nohariEnglish() {
    return getTanggal().toString()+" "+getNamaBulanTodayEnglish().toString()+ " "+getTahun().toString();
  }

  String getTanggal_nohari_beforeEnglish() {
    return getTanggalBefore().toString()+" "+getNamaBulanBeforeEnglish().toString()+ " "+getTahunBefore().toString();
  }



  String getTanggal_me(String val_tanggal) {
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(val_tanggal);
    return new DateFormat.y().format(dateTime);
  }

  Future<dynamic> getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return "Connect";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return "Connect";
    }
    return "ConnInterupted";
  }

  /*Future<dynamic> getConnect() async {
    ConnectionCek().check().then((internet){
      return "ConnInterupted";
    });
  }*/


  showFlushBarsuccess(BuildContext context, String stringme){
    Flushbar(
      message:  stringme,
      shouldIconPulse: false,
      duration:  Duration(seconds: 5),
      backgroundColor: Colors.black,
      flushbarPosition: FlushbarPosition.TOP ,
    )..show(context);
    EasyLoading.dismiss();
  }


  showFlushBarsuccessBottom(BuildContext context, String stringme){
    Flushbar(
      message:  stringme,
      shouldIconPulse: false,
      duration:  Duration(seconds: 5),
      backgroundColor: Colors.black,
      flushbarPosition: FlushbarPosition.BOTTOM ,
    )..show(context);
    EasyLoading.dismiss();
  }



  showFlushBarerror(BuildContext context, String stringme) {
    Flushbar(
      message:  stringme,
      shouldIconPulse: false,
      duration:  Duration(seconds: 5),
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP ,
    )..show(context);
    EasyLoading.dismiss();
  }


  showFlushBarconfirmed(BuildContext context, String stringme){
    Flushbar(
      messageText:  Text(stringme,style: TextStyle(color: HexColor("#f7f9f8")),),
      shouldIconPulse: false,
      duration:  Duration(seconds: 5),
      backgroundColor: HexColor("#01ab6f"),
      flushbarPosition: FlushbarPosition.TOP ,
    )..show(context);
    EasyLoading.dismiss();
  }


/*
  showsuccess(String txtError){
    BuildContext context;
    showFlushBarsuccess(context, txtError);
    return;
  }

  showerror(String txtError){
    BuildContext context;
    showFlushBarerror(context, txtError);
    return;
  }*/


  Future<dynamic> getNotifCount() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink + "mobile/api_mobile.php?act=getNotifCount&karyawanNo="+getKaryawanNo.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){http.Client().close();errorCode = 1;return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    } else {
      return [
        data["count_notif"].toString(), //0
      ];
    }

  }


  Future<dynamic> getSpecificNotifCount(getModul) async {
    String getKaryawanNo = await Session.getKaryawanNo();
    http.Response response = await http.Client().get(
        Uri.parse(applink + "mobile/api_mobile.php?act=getSpecificNotifCount&karyawanNo=" +
            getKaryawanNo.toString()+"&getModul="+getModul.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
    return [
      data["count_notif"].toString(), //0
    ];
  }


  Future<dynamic> getCountApprovalList() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink + "mobile/api_mobile.php?act=getCountApprovalList&karyawanNo="+getKaryawanNo.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){http.Client().close();errorCode = 1;return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    } else {
      return [
        data["count_approvallist"].toString(), //0
      ];
    }

  }




  Future<dynamic> getPesanListCount(getKaryawanNo, getEmail) async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink + "mobile/api_mobile.php?act=getPesanListCount&getKaryawanNo=" +
            getKaryawanNo.toString()+"&getEmail="+getEmail),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){http.Client().close();errorCode = 1;return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    } else {
      return [
        data["count_pesanlist"].toString(), //0
      ];
    }

  }



  Future<dynamic> getDetailUser() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getDetailUser&karyawan_no="+getKaryawanNo.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){ errorCode = 1; http.Client().close();return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    }  else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("getPIN", '');
      preferences.setString("getPIN", data["karyawan_password"].toString());
      return [
        data["karyawan_jabatan"].toString(), //0
        data["karyawan_nama"].toString(), //1
        data["karyawan_alamat_ktp"].toString(), //2
        data["karyawan_alamat"].toString(), //3
        data["karyawan_kelamin"].toString(), //4
        data["karyawan_ktp"].toString(), //5
        data["karyawan_marriage"].toString(), //6
        data["karyawan_agama"].toString(), //7
        data["karyawan_notelp"].toString(), //8
        data["karyawan_emailpribadi"].toString(), //9
        data["karyawan_email"].toString(), //10
        data["cabang_nama"].toString(), //11

        data["departemen_nama"].toString(), //12
        data["jabatan_nama"].toString(), //13
        data["level_nama"].toString(), //14
        data["nama_golongan"].toString(), //15
        data["karyawan_status"].toString(), //16
        data["karyawan_sip"].toString(), //17
        data["karyawan_tglmasuk"].toString(), //18
        data["karyawan_tgl_batas"].toString(), //19

        data["karyawan_bank"].toString(), //20
        data["karyawan_banklocation"].toString(), //21
        data["karyawan_accountname"].toString(), //22
        data["karyawan_accountnumber"].toString(), //23

        data["karyawan_pph21"].toString(), //24
        data["karyawan_salarytype"].toString(), //25
        data["karyawan_bpjs_kes"].toString(), //26
        data["karyawan_bpjs_ket"].toString(), //27
        data["karyawan_bpjskelas"].toString(), //28
        data["karyawan_bpjspaidby"].toString(), //29
        data["karyawan_npwp"].toString(), //30
      ];
    }

  }




  Future<dynamic> getLemburDetail() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getLemburDetail&karyawan_no="+getKaryawanNo.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){ errorCode = 1;http.Client().close();return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    }  else {
      return [
        data["attend_countme"].toString(), //0
        data["attend_schedulecheckin"].toString(), //1
        data["attend_schedulecheckout"].toString(), //2
        data["attend_checkin"].toString(), //3
        data["attend_checkout"].toString(), //4
      ];
    }

  }




  Future<dynamic> getWorkLocation() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=get_defaultworklocation&karyawan_no="+getKaryawanNo),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){http.Client().close(); errorCode = 1; return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    }  else {
      return [
        data["cabang_nama"].toString(), //0
        data["cabang_id"].toString(), //1
        data["cabang_lat"].toString(), //2
        data["cabang_long"].toString() //3
      ];
    }

  }





  Future<dynamic> getAttendanceSebelum() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=get_attendanceSebelum&karyawan_no="+getKaryawanNo),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){ errorCode = 1;http.Client().close();return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    }  else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("getJamMasukSebelum", '');
      preferences.setString("getJamKeluarSebelum", '');
      preferences.setString("getJamMasukSebelum", data["attend_checkin"].toString());
      preferences.setString("getJamKeluarSebelum", data["attend_checkout"].toString());
      return [
        "Sukses"
      ];
    }

  }



  Future<dynamic> getAttendance() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=get_attendance&karyawan_no="+getKaryawanNo),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){errorCode = 1; http.Client().close(); return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    }  else {
      return [
        data["attend_checkin"].toString(),
        data["attend_checkout"].toString()
      ];
    }
  }



  Future<dynamic> getSchedule() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    var today = new DateTime.now();
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(today.toString());
    var dateme = DateFormat('yyyy-MM-dd').format(dateTime);

    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getScheduleDetail&karyawanNo="+getKaryawanNo+"&getDate="+dateme.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);

    }
    );

    var data = jsonDecode(response.body);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("getStartTime", '');
    preferences.setString("getEndTime", '');
    preferences.setString("getScheduleName", '');
    preferences.setString("getScheduleID", '');
    preferences.setString("getScheduleBtn", '');

    preferences.setString("getStartTime", data["schedule_clockin"].toString());
    preferences.setString("getEndTime", data["schedule_clockout"].toString());
    preferences.setString("getScheduleName", data["schedule_name"].toString());
    //preferences.setString("getScheduleID", data["schedule_id"].toString());
    preferences.setString("getScheduleID", data["schedule_id"].toString());
    preferences.setString("getScheduleBtn", data["schedule_btn"].toString());
    return [
      "Sukses"
    ];
  }


  Future<dynamic> cekSettings() async {
    String getEmail = await Session.getEmail();
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getSettings&user="+getEmail.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("getBahasa", '');
    preferences.setString("getNotif1", '');
    preferences.setString("getNotif2", '');
    preferences.setString("getBahasa", data["setting_bahasa"].toString());
    preferences.setString("getNotif1", data["setting_notif1"].toString());
    preferences.setString("getNotif2", data["setting_notif2"].toString());
    return [
      "Sukses"
    ];
  }



  Future<dynamic> generateTokenFCM(String getToken) async {
    String getKaryawanNo = await Session.getKaryawanNo();
    var getTokenBaru;
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getFCMToken&karyawanNo="+getKaryawanNo.toString()+"&token="+getToken.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);}
    );
    print(applink+"mobile/api_mobile.php?act=getFCMToken&karyawanNo="+getKaryawanNo.toString()+"&token="+getToken.toString());

    var data = jsonDecode(response.body);

    print("TOKEN : "+ data["karyawantoken_token"].toString());
   // print("TOKEN BARU : "+getTokenBaru);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("getTokenSession", '');
    preferences.setString("getTokenSession", data["karyawantoken_token"].toString());
    return [
      "Sukses"
    ];
  }



  Future<dynamic> setFirstTimeLanguage(getBahasa) async {
    String getEmail = await Session.getEmail();
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=setFirstTimeLanguage&user="+getEmail.toString()+"&getBahasa="+getBahasa),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);}
    );
    var data = jsonDecode(response.body);
    return [
      "Sukses"
    ];
  }




   reloadSession() async {
    await cekSettings();
    await getSchedule();
    await getDetailUser();
    await getAttendanceSebelum();
    //await getAttendance();
    //await getWorkLocation();
  }


  Future<dynamic> getSession () async {
    String getEmail = await Session.getEmail();
    String getUsername = await Session.getUsername();
    String getKaryawanId = await Session.getKaryawanId();
    String getKaryawanNama = await Session.getKaryawanNama();
    String getKaryawanNo = await Session.getKaryawanNo();
    String getKaryawanJabatan = await Session.getKaryawanJabatan();
    String getStartTime = await Session.getStartTime();

    String getScheduleName = await Session.getScheduleName();
    String getEndTime = await Session.getEndTime();
    String getWorkLocation = await Session.getWorkLocation();
    String getJamMasuk = await Session.getJamMasuk();
    String getJamKeluar = await Session.getJamKeluar();
    String getWorkLocationId = await Session.getWorkLocationId();
    String getWorkLat = await Session.getWorkLat();
    String getWorkLong = await Session.getWorkLong();
    String getScheduleID = await Session.getScheduleID();
    String getJamMasukSebelum = await Session.getJamMasukSebelum();
    String getJamKeluarSebelum = await Session.getJamKeluarSebelum();
    String getPIN = await Session.getPIN();
    String getScheduleBtn = await Session.getScheduleBtn();
    String getBahasa = await Session.getBahasa();
    String getNotif1 = await Session.getNotif1();
    String getNotif2 = await Session.getNotif2();
    String getTokenSession = await Session.getTokenSession();


    return [
      getEmail, //0,
      getUsername, //1
      getKaryawanId, //2
      getKaryawanNama, //3
      getKaryawanNo, //4,
      getKaryawanJabatan, //5
      getScheduleName, //6
      getStartTime, //7
      getEndTime, //8
      getWorkLocation, //9
      getJamMasuk, //10
      getJamKeluar, //11
      getWorkLocationId, //12
      getWorkLat, //13
      getWorkLong, //14
      getScheduleID, //15
      getJamMasukSebelum, //16
      getJamKeluarSebelum, //17
      getPIN, //18
      getScheduleBtn, //19,
      getBahasa, //20
      getNotif1, //21
      getNotif2, //22
      getTokenSession //23
    ];

  }


  Future<dynamic> getNewVersion2() async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
        //exit(0);
        return;
      }});
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getNewVersion"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(Duration(seconds: 20),onTimeout: (){
            http.Client().close();errorCode = 1;return http.Response('Error',500);});
    var data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return false;
    }  else {
      EasyLoading.dismiss();
      return [
        data["get_newversion"].toString(),
        data["get_newversionbuild"].toString()
      ];
    }

  }




  Future<dynamic> getRangeMax() async {

    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getRangeMax"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
    return [
      data["get_rangemax"].toString()
    ];

  }




  Future<dynamic> getNationalDay(getMonth) async {
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getNationalDay&getMonth="+getMonth),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
    return [
      data["get_nationalday"].toString()
    ];
  }

  Future<dynamic> getNewWorkLocation(getLokasi) async {
    http.Response response = await http.Client().get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getNewWorkLocation&getLokasi="+getLokasi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
    return [
      data["cabang_lat"].toString(),
      data["cabang_long"].toString()
    ];
  }

}