
import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class m_bertugas {


  bertugas_create(startDate, endDate, getKaryawanNo, _description, durationme, Baseme, fcm_message, getModul) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=bertugas_create"),
        body: {
          "bertugas_datefrom": startDate.toString(),
          "bertugas_dateend": endDate.toString(),
          "bertugas_reqby": getKaryawanNo,
          "bertugas_description": _description,
          "bertugas_lamahari" : durationme.toString(),
          "bertugas_uploadme" : Baseme,
          "fcm_message" : fcm_message,
          "getModul" : getModul
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


  bertugas_delete(getIdRequest) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=bertugas_delete"),
        body: {
          "bertugas_iddelete": getIdRequest
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



  bertugas_cancel(getKaryawanNo, bertugas_number, fcm_message, bertugas_type ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink+"mobile/api_mobile.php?act=bertugas_cancel"),
        body: {
          "cancel_karyawan": getKaryawanNo,
          "cancel_bertugasnumber": bertugas_number,
          "fcm_message" : fcm_message,
          "cancel_bertugastype" : bertugas_type
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



  bertugas_approved(bertugas_number, getKaryawanNo, valApp, fcm_message, fcm_message2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=bertugas_approved"), body: {
      "appr_bertugasno": bertugas_number,
      "appr_bertugaskaryawanno": getKaryawanNo,
      "appr_bertugasapp": valApp,
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



  bertugas_rejected(bertugas_number, getKaryawanNo, valApp, fcm_message, fcm_message2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=bertugas_rejected"), body: {
      "reject_bertugasno": bertugas_number,
      "reject_bertugaskaryawanno": getKaryawanNo,
      "reject_bertugasapp": valApp,
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