

import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class g_bertugas {

  Future<List> getdata_bertugas(getKaryawanNo, filter, filter2, getType) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getdata_bertugas&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter+"&filter2="+filter2+"&getType="+getType)).
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


  get_BertugasDetail(String getBertugasCode, String getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=get_BertugasDetail&getBertugasCode=" +
            getBertugasCode+"&getKaryawanNo="+getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return[
        data["a"].toString(), //0
        data["b"].toString(), //1
        data["c"].toString(), //2
        data["d"].toString(), //3
        data["e"].toString(), //4
        data["f"].toString(), //5
        data["g"].toString(), //6
        data["h"].toString(), //7
        data["i"].toString(), //8
        data["j"].toString(), //9
        data["k"].toString(), //10
        data["l"].toString(), //11
        data["m"].toString(), //12
        data["n"].toString(), //13
        data["o"].toString(), //14
        data["p"].toString(), //15
        data["q"].toString(), //16
        data["r"].toString(), //17
        data["s"].toString(), //18
        data["t"].toString(), //19
        data["u"].toString(), //20

      ];
    }
  }



  get_BertugasDetail2(String getBertugasCode, String getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=get_BertugasDetail2&getBertugasCode=" +
            getBertugasCode+"&getKaryawanNo="+getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return[
        data["a"].toString(), //0
        data["b"].toString(), //1
        data["c"].toString(), //2
        data["d"].toString(), //3
        data["e"].toString(), //4
        data["f"].toString(), //5
        data["g"].toString(), //6
        data["h"].toString(), //7
        data["i"].toString(), //8
        data["j"].toString(), //9
        data["k"].toString(), //10
        data["l"].toString(), //11
        data["m"].toString(), //12
        data["n"].toString(), //13
        data["o"].toString(), //14
        data["p"].toString(), //15
        data["q"].toString(), //16
        data["r"].toString(), //17
        data["s"].toString(), //18
        data["t"].toString(), //19
        data["u"].toString(), //20

      ];
    }
  }

}