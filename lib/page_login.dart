



import 'dart:convert';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'helper/app_helper.dart';
import 'helper/app_link.dart';
import 'helper/page_route.dart';
import 'page_loginpin.dart';


class PageLogin extends StatefulWidget{
  final String getBahasa;
  final String getTokenMe;
  const PageLogin(this.getBahasa, this.getTokenMe);
  @override
  _PageLogin createState() => _PageLogin();
}



class _PageLogin extends State<PageLogin> {
  final _emailq = TextEditingController();
  bool isLoading = false;



  _checkEmail() async {
    if(_emailq.text.isEmpty) {
      AppHelper().showFlushBarerror(context, widget.getBahasa.toString() == "1"? "Email tidak boleh kosong" : "Email cannot be empty");
      return false;
    }

    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      isLoading = true;
    });
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      widget.getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
      AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
      EasyLoading.dismiss();
      setState(() {
        isLoading = false;
      });
      return false;
    }});
    final response = await http.post(Uri.parse(applink+"mobile/api_mobile.php?act=cek_emailuser"), body: {
      "email_user": _emailq.text
    }).timeout(Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      setState(() {
        isLoading = false;
      });
      widget.getBahasa.toString() == "1"?
      AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
      AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
      EasyLoading.dismiss();
      return http.Response('Error',500);
    });

    Map data = jsonDecode(response.body);
    if(data["message"] != '') {
      setState(() {
        isLoading = false;
      });
      if(data["message"] == '0') {
        AppHelper().showFlushBarsuccess(context, widget.getBahasa.toString() == "1" ? "Mohon maaf, email tidak ditemukan" :
        "Sorry, email not found");
      } else if(data["message"] == '2') {
        AppHelper().showFlushBarsuccess(context,widget.getBahasa.toString() == "1" ? "Mohon maaf, email anda sudah tidak aktif" : "Sorry, your email is no longer active");
      } else if(data["message"] == '1') {

        Navigator.push(context, ExitPage(page: PageLoginPIN(_emailq.text, widget.getBahasa, widget.getTokenMe)));
      }
    }

  }

  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 25,right: 25),
        child : Align(
            alignment: Alignment.centerLeft,
            child :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(alignment: Alignment.centerLeft,child : Text(widget.getBahasa.toString() == "1" ? "Halo, Login Yuk":
                    "Hello, ", style : GoogleFonts.poppins(fontWeight: FontWeight.bold,
                    fontSize: 32, color: HexColor("#44a440")))),
                Padding(padding: const EdgeInsets.only(top: 1),child :  Align(alignment: Alignment.centerLeft,
                    child : Text(widget.getBahasa.toString() == "1" ? "Email Kamu" : "Email", style : GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        fontSize: 18))),),
                Opacity(
                    opacity: 0.8,
                    child :    Padding(padding: const EdgeInsets.only(top: 5),child :  Align(alignment: Alignment.centerLeft,
                        child : Text(widget.getBahasa.toString() == "1" ?  "Pastikan email sudah terdaftar dan aktif ya":
                            "Make sure the email is registered and active", style : GoogleFonts.nunitoSans(
                            fontSize: 13))),)
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:  Padding(padding: EdgeInsets.only(top: 5),
                    child: Text(widget.getBahasa.toString() == "1" ? "(Jika belum terdaftar atau tidak bisa login hubungi HRD kamu ya)" :
                        "(If you haven't registered or can't log in, contact your HRD)", style : GoogleFonts.nunitoSans(
                        fontSize: 11)),),
                ),

                Padding(padding: const EdgeInsets.only(top: 10,right: 15),
                  child: TextFormField(
                    controller: _emailq,
                    // keyboardType: TextInputType.number,
                    //textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      hintText: widget.getBahasa.toString() == "1" ? 'contoh : HRD@mishr.com' : 'example : HRD@mishr.com'
                      /* prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 2), // add padding to adjust icon
                        child: Icon(Icons.phone, size: 20,),
                      ),*/
                    ),
                  ),
                ),

              ],
            )

        ),
      ),
      bottomSheet:
      isLoading == true ?
      Container(
          width: double.infinity,
          color: Colors.white,
          height: 65,
          padding : const EdgeInsets.only(left: 25,right: 25,bottom: 10),
          child :
          Center(
            child:  SizedBox(
              child: CircularProgressIndicator(),
              height: 30.0,
              width: 30.0,
            ),
          ))
          :
      Container(
          width: double.infinity,
          height: 65,
          padding : const EdgeInsets.only(left: 25,right: 25,bottom: 20),
          child :
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.white,
                    width: 0.1,
                    style: BorderStyle.solid
                ),
                  borderRadius: BorderRadius.circular(5.0),
                )),
            child : Text(widget.getBahasa.toString() == "1" ? "LANJUTKAN" : "CONTINUE", style: GoogleFonts.lato(fontWeight: FontWeight.bold),),
            onPressed: (){
              _checkEmail();
            },
          )
      ),

    ), onWillPop: onWillPop);
  }

  Future<bool> onWillPop() async {
   return false;
  }
}