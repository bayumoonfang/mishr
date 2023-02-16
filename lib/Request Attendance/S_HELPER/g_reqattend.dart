

import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;


class g_reqattend{


        get_ReqAttendApprCount(getKaryawanNo) async {
          int errorCode = 0;
          await AppHelper().getConnect().then((value) {
            if (value == 'ConnInterupted') {
              errorCode = 2;
              return false;
            }
          });
          final response = await http.get(Uri.parse(
              applink + "mobile/api_mobile.php?act=get_ReqAttendApprCount&"
                  "karyawan_no=" + getKaryawanNo)).timeout(
              Duration(seconds: 10), onTimeout: () {
            http.Client().close();
            errorCode = 1;
            return http.Response('Error', 500);
          });

          Map data = jsonDecode(response.body);
          if (errorCode == 1 || errorCode == 2) {
            EasyLoading.dismiss();
            return ["ConnInterupted", http.Response('Error', 500)];
          } else {
            EasyLoading.dismiss();
            return [
              data["aa"].toString()
            ];
          }
        }


        Future<List> getData_AttendRequest(getKaryawanNo, filter, filter2, filter3, getModul ) async {
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getData_AttendRequest&"
              "karyawan_no="+getKaryawanNo+"&filter="+filter+"&filter3="+filter3+"&getModul="+getModul)).
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



        get_ReqAttendDetail(String getReqAttendCode, String getKaryawanNo) async {
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          final response = await http.get(Uri.parse(
              applink + "mobile/api_mobile.php?act=get_ReqAttendDetail&reqattendcode=" +
                  getReqAttendCode+"&getKaryawanNo="+getKaryawanNo)).timeout(
              Duration(seconds: 10), onTimeout: () {
            http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

          Map data = jsonDecode(response.body);
          if(errorCode == 1 || errorCode == 2) {
            EasyLoading.dismiss();
            return ["ConnInterupted",http.Response('Error', 500)];
          }  else {
            EasyLoading.dismiss();
            return[
              data["reqattend_status"].toString(),
              data["reqattend_type"].toString(),
              data["reqattend_date"].toString(),
              data["reqattend_scheduleclockin"].toString(),
              data["reqattend_scheduleclockout"].toString(),
              data["reqattend_clockin"].toString(),
              data["reqattend_clockout"].toString(),
              data["reqattend_description"].toString(),
              data["reqattend_approv1"].toString(),
              data["reqattend_approve1_status"].toString(),
              data["reqattend_approve1_date"].toString(),
              data["reqattend_approv1_nama"].toString(),
              data["reqattend_approv1_jabatan"].toString(),
              data["reqattend_approv2"].toString(),
              data["reqattend_approve2_status"].toString(),
              data["reqattend_approve2_date"].toString(),
              data["reqattend_approv2_nama"].toString(),
              data["reqattend_approv2_jabatan"].toString(),
              data["reqattend_datecreated"].toString(),
              data["reqattend_schedulecode"].toString(),
              data["karyawan_nama"].toString(),
              data["reqattend_clockinbefore"].toString(),
              data["reqattend_clockoutbefore"].toString(),
              data["reqattend_schedulebefore"].toString(),
              data["reqattend_scheduleclockinbefore"].toString(),
              data["reqattend_scheduleclockoutbefore"].toString()
            ];
          }
        }



        get_ReqAttendCheck(String getKaryawanNo, String getDate) async {
          EasyLoading.show(status: "Loading...");
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          final response = await http.get(Uri.parse(
              applink + "mobile/api_mobile.php?act=get_ReqAttendCheck&karyawanNo=" +
                  getKaryawanNo+"&getDate="+getDate)).timeout(
              Duration(seconds: 10), onTimeout: () {
            http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

          Map data = jsonDecode(response.body);
          if(errorCode == 1 || errorCode == 2) {
            EasyLoading.dismiss();
            return ["ConnInterupted",http.Response('Error', 500)];
          }  else {
            EasyLoading.dismiss();
            return[
              data["message"].toString(),
            ];
          }
        }



        get_ReqAttendSchedule(String getKaryawanNo, String getDate) async {
          EasyLoading.show(status: "Loading...");
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          final response = await http.get(Uri.parse(
              applink + "mobile/api_mobile.php?act=get_ReqAttendSchedule&karyawanNo=" +
                  getKaryawanNo+"&getDate="+getDate)).timeout(
              Duration(seconds: 10), onTimeout: () {
            http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

          Map data = jsonDecode(response.body);
          if(errorCode == 1 || errorCode == 2) {
            EasyLoading.dismiss();
            return ["ConnInterupted",http.Response('Error', 500)];
          }  else {
            EasyLoading.dismiss();
            return[
              data["schedule_name"].toString(),
              data["schedule_clockin"].toString(),
              data["schedule_clockout"].toString(),
              data["clockin"].toString(),
              data["clockout"].toString()
            ];
          }
        }



        Future<List> getData_reqattendDetailActivity(getReqAttendCode) async {
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getData_reqattendDetailActivity&"
              "getReqAttendCode="+getReqAttendCode)).
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





        getAllSchedule() async {
              int errorCode = 0;
              await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
                errorCode = 2; return false;}});
              var response = await http.get(Uri.parse(
                  applink + "mobile/api_mobile.php?act=getAllSchedule")).
              timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
              return http.Response('Error', 500);});
              var jsonData = json.decode(response.body);
              if(errorCode == 1 || errorCode == 2) {
                EasyLoading.dismiss();
                return ["ConnInterupted",http.Response('Error', 500)];
              } else {
                EasyLoading.dismiss();
                return [jsonData];
              }
        }


        get_ReqAttendCheck_gantishift(String getKaryawanNo, String getDate) async {
          EasyLoading.show(status: "Loading...");
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          final response = await http.get(Uri.parse(
              applink + "mobile/api_mobile.php?act=get_ReqAttendCheck_gantishift&karyawanNo=" +
                  getKaryawanNo+"&getDate="+getDate)).timeout(
              Duration(seconds: 10), onTimeout: () {
            http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

          Map data = jsonDecode(response.body);
          if(errorCode == 1 || errorCode == 2) {
            EasyLoading.dismiss();
            return ["ConnInterupted",http.Response('Error', 500)];
          }  else {
            EasyLoading.dismiss();
            return[
              data["message"].toString(),
            ];
          }
        }



        get_ReqAttendSchedule_Gantishift(String getKaryawanNo, String getDate) async {
          EasyLoading.show(status: "Loading...");
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          final response = await http.get(Uri.parse(
              applink + "mobile/api_mobile.php?act=get_ReqAttendSchedule_Gantishift&karyawanNo=" +
                  getKaryawanNo+"&getDate="+getDate)).timeout(
              Duration(seconds: 10), onTimeout: () {
            http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

          Map data = jsonDecode(response.body);
          if(errorCode == 1 || errorCode == 2) {
            EasyLoading.dismiss();
            return ["ConnInterupted",http.Response('Error', 500)];
          }  else {
            EasyLoading.dismiss();
            return[
              data["schedule_name"].toString(),
              data["schedule_clockin"].toString(),
              data["schedule_clockout"].toString(),
              data["clockin"].toString(),
              data["clockout"].toString()
            ];
          }
        }


        get_ReqAttendCheckLemburAnotherDay(String getKaryawanNo, String getDate) async {
          EasyLoading.show(status: "Loading...");
          int errorCode = 0;
          await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
            errorCode = 2; return false;}});
          final response = await http.get(Uri.parse(
              applink + "mobile/api_mobile.php?act=get_ReqAttendCheckLemburAnotherDay&karyawanNo=" +
                  getKaryawanNo+"&getDate="+getDate)).timeout(
              Duration(seconds: 10), onTimeout: () {
            http.Client().close(); errorCode = 1; return http.Response('Error', 500);});
          print(
              applink + "mobile/api_mobile.php?act=get_ReqAttendCheckLemburAnotherDay&karyawanNo=" +
                  getKaryawanNo+"&getDate="+getDate);
          Map data = jsonDecode(response.body);
          if(errorCode == 1 || errorCode == 2) {
            EasyLoading.dismiss();
            return ["ConnInterupted",http.Response('Error', 500)];
          }  else {
            EasyLoading.dismiss();
            return[
              data["message"].toString(),
            ];
          }
        }

}