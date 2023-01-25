


import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class m_reqattend {



  reqattend_cancel(getKaryawanNo, getReqAttendCode, fcm_message) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=reqattend_cancel"),
        body: {
          "cancel_karyawan": getKaryawanNo,
          "cancel_reqattendnumber": getReqAttendCode,
          "fcm_message" : fcm_message
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



  reqattend_delete(getIdRequest) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=reqattend_delete"),
        body: {
          "delete_reqattendid": getIdRequest
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



  reqattend_correction_create(getKaryawanNo, getDate, getType, getDescription, _TimeStart, _TimeEnd, getClockIn,
      getClockOut, getNameShift, getClockIn2, getClockOut2, fcm_message) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=reqattend_correction_create"),
        body: {
          "reqattend_karyawan": getKaryawanNo,
          "reqattend_date": getDate,
          "reqattend_type" : getType,
          "reqattend_description" : getDescription,
          "reqattend_clockin" : _TimeStart,
          "reqattend_clockout" : _TimeEnd,
          "reqattend_scheduleclockin" : getClockIn.toString(),
          "reqattend_scheduleclockout" : getClockOut.toString(),
          "reqattend_nameshift" : getNameShift.toString(),
          "reqattend_clockinbefore" : getClockIn2,
          "reqattend_clockoutbefore" : getClockOut2,
          "fcm_message" : fcm_message
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


  reqattend_approve(getReqAttendCode, getKaryawanNo, valApp, reqattend_type, fcm_message, fcm_message2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=reqattend_approve"), body: {
      "approve_reqattendnumber": getReqAttendCode,
      "approve_reqattendkaryawanno": getKaryawanNo,
      "approve_reqattendapp": valApp,
      "approve_type" : reqattend_type.toString(),
      "fcm_message" : fcm_message,
      "fcm_message2" : fcm_message2
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



  reqattend_reject(getReqAttendCode, getKaryawanNo, valApp, reqattend_type, fcm_message) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=reqattend_reject"), body: {
      "reject_reqattendnumber": getReqAttendCode,
      "reject_reqattendkaryawanno": getKaryawanNo,
      "reject_reqattendapp": valApp,
      "reject_reqattendtype": reqattend_type,
      "fcm_message" : fcm_message
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

  reqattend_gantishift_create(getKaryawanNo, getDate, getType, getDescription, selectedscheduleList,
      getNameShift, getClockIn2, getClockOut2, fcm_message) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=reqattend_gantishift_create"),
        body: {
          "reqattend_karyawan": getKaryawanNo,
          "reqattend_date": getDate,
          "reqattend_type" : getType,
          "reqattend_description" : getDescription,
          "reqattend_newschedule" : selectedscheduleList,
          "reqattend_shcedule" : getNameShift,
          "reqattend_clockinbefore" : getClockIn2,
          "reqattend_clockoutbefore" : getClockOut2,
          "fcm_message" : fcm_message
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




  reqattend_lembursameday_create(getKaryawanNo, getDate, getType, getDescription,
      getNameShift, getClockIn2, getClockOut2, _TimeStart) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=reqattend_lembursameday_create"),
        body: {
          "reqattend_karyawan": getKaryawanNo,
          "reqattend_date": getDate,
          "reqattend_type" : getType,
          "reqattend_description" : getDescription,
          "reqattend_shcedule" : getNameShift,
          "reqattend_clockinbefore" : getClockIn2,
          "reqattend_clockoutbefore" : getClockOut2,
          "reqattend_endtime" : _TimeStart,
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



  reqattend_lemburanotherday_create(getKaryawanNo, getDate,
  getType, getDescription, _TimeStart,_TimeEnd, getNameShift, getClockIn, getClockOut) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=reqattend_lemburanotherday_create"),
        body: {
          "reqattend_karyawan": getKaryawanNo,
          "reqattend_date": getDate,
          "reqattend_type" : getType,
          "reqattend_description" : getDescription,
          "reqattend_starttime" : _TimeStart,
          "reqattend_endtime" : _TimeEnd,
          "reqattend_shcedule" : getNameShift,
          "reqattend_clockin" : getClockIn,
          "reqattend_clockout" : getClockOut

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