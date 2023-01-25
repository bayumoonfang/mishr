
import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class g_report {



  getDataAttendanceResume(String getKaryawanNo, String _datefrom, String _dateto) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    final response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getDataAttendanceResume&karyawan_no="+getKaryawanNo+"&datefrom="+_datefrom+"&dateto="+_dateto+"")).timeout(
        Duration(seconds: 10), onTimeout: () {
      http.Client().close(); errorCode = 1; return http.Response('Error', 500);});

    Map data = jsonDecode(response.body);
    if(errorCode == 1) {EasyLoading.dismiss();return ["1",http.Response('Error', 500)];
    } else if(errorCode == 2) {EasyLoading.dismiss(); return ["2"]; } else {
      EasyLoading.dismiss();
      return[
        data["attresume_numdays"].toString(),
        data["attresume_hadir"].toString(),
        data["attresume_tidakmasuk"].toString(),
        data["attresume_ijin"].toString(),
        data["attresume_alpa"].toString(),

      ];
    }
  }


}