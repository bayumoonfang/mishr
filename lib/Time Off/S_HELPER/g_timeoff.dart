
import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class g_timeoff{

  function_NeedTime(String getVal, String getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getTimeOffNeedTime&timeoffcode=" +
            getVal + "&karyawan_no=" + getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

    Map data = jsonDecode(response.body);
    if(errorCode == 1) {EasyLoading.dismiss();return ["1",http.Response('Error', 500)];
    } else if(errorCode == 2) {EasyLoading.dismiss(); return ["2"]; } else {
      EasyLoading.dismiss();
      return[
        data["setttimeoff_needtime"].toString(),
        data["timeoff_quota"].toString()
      ];
    }
  }


  Future<List> getAllrequestTo(filter2) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
      http.Response response = await http.Client().get(
      Uri.parse(applink + "mobile/api_mobile.php?act=getAllrequestTo&filter="+
              filter2.toString()), headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"}).timeout(Duration(seconds: 10),
      onTimeout: () {http.Client().close(); errorCode = 1;
      return http.Response('Error', 500);});

      if(errorCode == 1) {EasyLoading.dismiss();return ["1",http.Response('Error', 500)];
      } else if(errorCode == 2) {EasyLoading.dismiss(); return ["2"]; } else {
        EasyLoading.dismiss();
        return json.decode(response.body);
      }

  }

  Future<List> getDataTimeOffType(getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(
        Uri.parse(applink+"mobile/api_mobile.php?act=getAlltimeOffType2&karyawan_no="+getKaryawanNo)).
        timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
        return http.Response('Error', 500);});

    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    } else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }


  get_TimeOffDetail(String getTimeOffCode, String getKaryawanNo) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getTimeOffDetail&timeoffcode=" +
            getTimeOffCode+"&getKaryawanNo="+getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

    Map data = jsonDecode(response.body);
    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return[
        data["attrequest_reqby_name"].toString(),
        data["attrequest_numdays"].toString(),
        data["attrequest_number"].toString(),
        data["setttimeoff_name"].toString(),
        data["timeoff_quota"].toString(),
        data["attrequest_description"].toString(),
        data["attrequest_needtime"].toString(),
        data["attrequest_timefrom"].toString(),
        data["attrequest_timeto"].toString(),
        data["attrequest_status"].toString(),
        data["jabatan_nama1"].toString(),
        data["jabatan_nama2"].toString(),
        data["attrequest_appr1_name"].toString(),
        data["attrequest_dateappr1"].toString(),
        data["attrequest_appr1_status"].toString(),
        data["attrequest_appr1_note"].toString(),
        data["attrequest_appr2_name"].toString(),
        data["attrequest_dateappr2"].toString(),
        data["attrequest_appr2_status"].toString(),
        data["attrequest_appr2_note"].toString(),
        data["attrequest_delegated"].toString(),
        data["attrequest_delegated_name"].toString(),
        data["attrequest_file"].toString(),
        data["attrequest_datecreated"].toString(),
        data["attrequest_datefrom"].toString(),
        data["attrequest_dateto"].toString(),
        data["attrequest_appr1"].toString(),
        data["attrequest_appr2"].toString()
      ];
    }
  }


  Future<List> getData_timeoffDetailActivity(getTimeOffNumber) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getDetailActivityTimeOff&"
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


  Future<List> getData_timeOffType() async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getData_timeOffType")).
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


  Future<List> getData_AllTimeOffRequest(getKaryawanNo, filter, filter2, filter3 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getData_AllTimeOffRequest&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter+"&filter2="+filter2+"&filter3="+filter3)).
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



  Future<List> getData_AllTimeOffApproval(getKaryawanNo, filter, filter2 ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getData_AllTimeOffApproval&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter+"&filter2="+filter2)).
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



  get_TimeOffApprovalCount(getKaryawanNo) async {
    //EasyLoading.show(status: "Loading...");
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=get_TimeOffApprovalCount&"
            "karyawan_no="+getKaryawanNo)).timeout(
        Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

    Map data = jsonDecode(response.body);

    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return[
        data["aa"].toString()
      ];
    }
  }



  Future<List> getData_NotificationSpecific(getKaryawanEmail, filter, getModul ) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getData_NotificationSpecific&"
        "getEmail="+getKaryawanEmail+"&filter="+filter+"&getModul="+getModul)).
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