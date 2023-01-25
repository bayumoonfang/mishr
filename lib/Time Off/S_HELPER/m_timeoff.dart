



import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class m_timeoff {



  timeoff_create(selectedTimeOffTipe, startDate, endDate, _TimeStart, _TimeEnd, needTime, getKaryawanNo, getKaryawanNama,
      delegatedNo, delegatedName, _description, durationme, Baseme, fcm_message) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=timeoff_create"),
        body: {
          "attreq_code": selectedTimeOffTipe,
          "attreq_datefrom": startDate.toString(),
          "attreq_dateend": endDate.toString(),
          "attreq_timefrom": _TimeStart,
          "attreq_timeto": _TimeEnd,
          "attreq_needtime": needTime.toString(),
          "attreq_reqby": getKaryawanNo,
          "attreq_reqname": getKaryawanNama,
          "attreq_delegated": delegatedNo.toString(),
          "attreq_delegatedname": delegatedName.toString(),
          "attreq_description": _description,
          "attreq_lamahari" : durationme.toString(),
          "attreq__uploadme" : Baseme,
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
          print("YANG KELUAR ADALAH : "+ data["message"].toString());
          return[
            data["message"].toString()

          ];
        }
  }


  timeoff_cancel(getKaryawanNo, timeoff_number, getKaryawanNama, fcm_message ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=timeoff_cancel"),
        body: {
          "cancel_karyawan": getKaryawanNo,
          "cancel_timeoffnumber": timeoff_number,
          "cancel_getKaryawanNama": getKaryawanNama,
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




  timeoff_appr(timeoff_number, getKaryawanNo, valApp, noteApproveVal, fcm_message, fcm_message2) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=timeoff_appr"), body: {
      "approve_timeoffnumber": timeoff_number,
      "approve_timeoffkaryawanno": getKaryawanNo,
      "approve_timeoffapp": valApp,
      "approve_timeoffNote" : noteApproveVal,
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



  timeoff_reject(timeoff_number, getKaryawanNo, valApp, noteApproveVal, fcm_message, fcm_message2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=timeoff_reject"), body: {
      "reject_timeoffnumber": timeoff_number,
      "reject_timeoffkaryawanno": getKaryawanNo,
      "reject_timeoffapp": valApp,
      "reject_timeoffNote" : noteApproveVal,
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




  timeoff_delete(getIdRequest) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=timeoff_delete"),
        body: {
          "timeoff_iddelete": getIdRequest
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
