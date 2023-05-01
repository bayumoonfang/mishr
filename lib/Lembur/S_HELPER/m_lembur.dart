




import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class m_lembur {



  lembur_create(
      _createdby,
      _createbyNo,
      // delegatedNo,
      // delegatedName,
      startDate,
      // endDate,
      // _TimeStart,
      _TimeEnd,
      _description,
      // durationme
      ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=lembur_create"),
        body: {
          "lembur_createdNo": _createbyNo,
          "lembur_createdname": _createdby,
          // "lembur_delegatedNo": delegatedNo,
          // "lembur_delegatedName": delegatedName,
          "lembur_datestart": startDate.toString(),
          // "lembur_dateend": endDate.toString(),
          // "lembur_timefrom": _TimeStart,
          "lembur_timeto": _TimeEnd,
          "lembur_description": _description,
          // "lembur_lamahari" : durationme.toString()
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



  lembur_approve(getLemburCode, getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=lembur_approve"), body: {
      "approve_lemburcode": getLemburCode,
      "approve_lemburkaryawanno": getKaryawanNo
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




  lembur_delete(getIdRequest) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=lembur_delete"),
        body: {
          "lembur_iddelete": getIdRequest
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


  lembur_cancel(getKaryawanNo, lembur_number, getKaryawanNama, fcm_message ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=lembur_cancel"),
        body: {
          "cancel_karyawan": getKaryawanNo,
          "cancel_lemburnumber": lembur_number,
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



 lembur_reject(timeoff_number, getKaryawanNo, valApp, fcm_message, fcm_message2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=lembur_reject"), body: {
      "reject_lemburno": timeoff_number,
      "reject_lemburkaryawanno": getKaryawanNo,
      "reject_lemburapp": valApp,
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



  lembur_approved(timeoff_number, getKaryawanNo, valApp, fcm_message, fcm_message2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=lembur_approved"), body: {
      "appr_lemburno": timeoff_number,
      "appr_lemburkaryawanno": getKaryawanNo,
      "appr_lemburapp": valApp,
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


}