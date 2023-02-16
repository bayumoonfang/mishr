

import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class g_lembur {


  Future<List> getData_Lembur(getKaryawanNo, filter, getModul, filter2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getData_Lembur&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter+"&getModul="+getModul+"&filter2="+filter2)).
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



  get_LemburDetail(String getLemburCode, String getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=get_LemburDetail&getLemburCode=" +
            getLemburCode+"&getKaryawanNo="+getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return[
        data["a"].toString(),
        data["b"].toString(),
        data["c"].toString(),
        data["d"].toString(),
        data["e"].toString(),
        data["f"].toString(),
        data["g"].toString(),
        data["h"].toString(),
        data["i"].toString(),
        data["j"].toString(),
        data["k"].toString(),
        data["l"].toString(),
        data["m"].toString(),
        data["n"].toString(),
        data["o"].toString(),
        data["p"].toString(),
        data["q"].toString(),
        data["r"].toString(), //17
        data["s"].toString(), //18
        data["t"].toString(), //19
        data["u"].toString(), //20
        data["v"].toString(), //20
      ];
    }
  }



  Future<List> getData_lemburActivity(getTimeOffNumber) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getData_lemburActivity&"
        "getTimeOffNumber="+getTimeOffNumber)).
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


  Future<List> getData_jadwallembur(getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getdata_jadwallembur&"
        "karyawan_no="+getKaryawanNo)).
    timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
    return http.Response('Error', 500);});
    print(applink+"mobile/api_mobile.php?act=getdata_jadwallembur&"
        "karyawan_no="+getKaryawanNo);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }


}