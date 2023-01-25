

import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'app_link.dart';


class m_helper{



  change_cabang(getLocationID, getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: "No Connection", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14); return false;
      }});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=change_cabang"),
        body: {
          "location_id": getLocationID,
          "karyawan_no": getKaryawanNo
        }).timeout(Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);}
    );
    Map data = jsonDecode(response.body);
    if(errorCode == 1) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Connection Timeout", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black, textColor: Colors.white, fontSize: 14);
      return ["ConnInterupted",http.Response('Error', 500)];
    } else {
      EasyLoading.dismiss();
      return[
        data["message"].toString()
      ];
    }
  }




  add_attendance(getKaryawanNo, getNamaHari, getJam, getNote, getStartTime, getEndTime, getScheduleName, getType,
      getWorkLocation, getLocationLat, getLocationLong) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=add_attendance"),
        body: {
          "att_karyawanno": getKaryawanNo,
          "att_namaHari": getNamaHari,
          "att_jam": getJam,
          "att_note": getNote,
          "att_getStartTime": getStartTime,
          "att_getEndTime": getEndTime,
          "att_getScheduleName": getScheduleName,
          "att_type" : getType,
          "att_locationname" : getWorkLocation,
          "att_locationlat" : getLocationLat,
          "att_locationlong" : getLocationLong
        }).timeout(Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);}
    );
    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    } else {
      EasyLoading.dismiss();
      return[
        data["message"].toString()
      ];
    }
  }




  add_attendancelembur(getKaryawanNo, getNamaHari, getJam, getNote, getStartTime, getEndTime, getScheduleName, getType,
      getWorkLocation, getLocationLat, getLocationLong) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=add_attendancelembur"),
        body: {
          "att_karyawanno": getKaryawanNo,
          "att_namaHari": getNamaHari,
          "att_jam": getJam,
          "att_note": getNote,
          "att_getStartTime": getStartTime,
          "att_getEndTime": getEndTime,
          "att_getScheduleName": getScheduleName,
          "att_type" : getType,
          "att_locationname" : getWorkLocation,
          "att_locationlat" : getLocationLat,
          "att_locationlong" : getLocationLong
        }).timeout(Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);}
    );
    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    } else {
      EasyLoading.dismiss();
      return[
        data["message"].toString()
      ];
    }
  }



  change_bahasa(getBahasaID, getEmail) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=change_Bahasa"),
        body: {
          "bahasa_id": getBahasaID,
          "karyawan_email": getEmail
        }).timeout(Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);}
    );
    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    } else {
      EasyLoading.dismiss();
      return[
        data["message"].toString()
      ];
    }
  }



  review_create(reviewText, getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=review_create"),
        body: {
          "review_karyawanno": reviewText,
          "review_namaHari": getKaryawanNo
        }).timeout(Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);}
    );
    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    } else {
      EasyLoading.dismiss();
      return[
        data["message"].toString()
      ];
    }
  }



}