




import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class m_lembur {



  lembur_create(_createdby, _createbyNo, delegatedNo, delegatedName,
      startDate, endDate, _TimeStart, _TimeEnd, _description, durationme) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.post(
        Uri.parse(applink + "mobile/api_mobile.php?act=lembur_create"),
        body: {
          "lembur_createdNo": _createbyNo,
          "lembur_createdname": _createdby,
          "lembur_delegatedNo": delegatedNo,
          "lembur_delegatedName": delegatedName,
          "lembur_datestart": startDate.toString(),
          "lembur_dateend": endDate.toString(),
          "lembur_timefrom": _TimeStart,
          "lembur_timeto": _TimeEnd,
          "lembur_description": _description,
          "lembur_lamahari" : durationme.toString()
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






}