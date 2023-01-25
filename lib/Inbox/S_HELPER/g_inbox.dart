
import 'dart:convert';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/session.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class g_inbox {

  Future<List> getData_PesanPribadi(getKaryawanNo, filter, filter2) async {
    int errorCode = 0;
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      errorCode = 2; return false;}});
    http.Response response = await http.get(  Uri.parse(applink+"mobile/api_mobile.php?act=getData_PesanPribadi&"
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




  Future<dynamic> getCountPesanPribadi() async {
    String getKaryawanNo = await Session.getKaryawanNo();
    http.Response response = await http.Client().get(
        Uri.parse(applink + "mobile/api_mobile.php?act=getCountPesanPribadi&karyawanNo=" +
            getKaryawanNo.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 20),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
    return [
      data["count_notif"].toString(), //0
    ];
  }



}