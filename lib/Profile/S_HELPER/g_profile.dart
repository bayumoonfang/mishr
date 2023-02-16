

import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/session.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class g_profile {


  Future<List> getData_HistoryAttendance(getKaryawanNo, filter, yearme, monthme, filter2,startDate,
  endDate) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(Uri.parse(applink+"mobile/api_mobile.php?act=getAttendanceHistory&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter+"&yearme="+yearme.toString()+"&monthme="+monthme.toString()+"&filter2="+filter2.toString()+"&startDate="+startDate.toString()+"&endDate="+endDate.toString())).
    timeout(Duration(seconds: 10), onTimeout: () {http.Client().close(); errorCode = 1;
    return http.Response('Error', 500);});
    print(applink+"mobile/api_mobile.php?act=getAttendanceHistory&"
        "karyawan_no="+getKaryawanNo+"&filter="+filter+"&yearme="+yearme.toString()+"&monthme="+monthme.toString()+"&filter2="+filter2.toString());

    if(errorCode == 1 || errorCode == 2) {
      EasyLoading.dismiss();
      return ["ConnInterupted",http.Response('Error', 500)];
    }  else {
      EasyLoading.dismiss();
      return json.decode(response.body);
    }
  }

}