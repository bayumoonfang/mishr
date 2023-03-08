
import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class g_helper {

  Future<List> getData_AllCabang(getKaryawanNo, filter) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getOtherLocation&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter)).
    timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
    return http.Response('Error', 500);});
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }



  Future<List> getData_AllApprove(getKaryawanNo, filter, filter2, filter3) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
              backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getData_AllApprove&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter+"&filter2="+filter2+"&filter3="+filter3)).
    timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
    return http.Response('Error', 500);});
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }



  Future<List> getData_AllBahasa() async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getData_AllBahasa")).
    timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
    return http.Response('Error', 500);});

    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }



  Future<List> getData_Logs(getKaryawanEmail, filter) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getData_Logs&"
        "getEmail="+getKaryawanEmail+"&filter="+filter)).
    timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
    return http.Response('Error', 500);});
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }



  Future<List> getData_birthday() async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getData_birthday")).
    timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
    return http.Response('Error', 500);});
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }



}