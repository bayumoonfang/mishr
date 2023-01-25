


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/ApprovalList/page_apprdetaillembur.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Lembur/page_lembur_add.dart';
import 'package:abzeno/Request%20Attendance/page_reqattendapprovedetail.dart';
import 'package:abzeno/Request%20Attendance/page_reqattenddetail.dart';
import 'package:abzeno/Time%20Off/page_addtimeoff.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'S_HELPER/g_lembur.dart';



class PageLembur extends StatefulWidget{
  final String getKaryawanNo;
  final String getModul;
  final String getKaryawanNama;
  final String getEmail;
  const PageLembur(this.getKaryawanNo, this.getModul, this.getKaryawanNama, this.getEmail);
  @override
  _PageLembur createState() => _PageLembur();
}


class _PageLembur extends State<PageLembur> {

  TextEditingController _pinValue = TextEditingController();

  String getBahasa = "1";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
      });});
  }
  @override
  void initState() {
    super.initState();
    getSettings();
  }

  String filter = "";
  String filter2 = "";
  String filter3 = "";
  String sortby = '0';

  FutureOr onGoBack(dynamic value) {
    setState(() {
      g_lembur().getData_Lembur(widget.getKaryawanNo, filter, widget.getModul);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 15,right: 15,top: 10),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder(
                    future: g_lembur().getData_Lembur(widget.getKaryawanNo, filter, widget.getModul),
                    builder: (context, snapshot){
                      if (snapshot.data == null) {
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      } else {
                        return snapshot.data == 0 || snapshot.data?.length == 0 ?
                        Container(
                            height: double.infinity, width : double.infinity,
                            child: new
                            Center(
                                child :
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/empty2.png',width: 170,),
                                    Padding(
                                      padding: EdgeInsets.only(left: 13),
                                      child:  new Text(
                                        getBahasa.toString() == "1"? "Data tidak ditemukan": "Data Not Found",
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 13),
                                      ),
                                    )
                                  ],
                                )))
                            :
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(bottom: 15,top: 5),
                                child: Container(
                                  height: 50,
                                  child: TextFormField(
                                    enableInteractiveSelection: false,
                                    onChanged: (text) {
                                      setState(() {
                                        filter = text;
                                      });
                                    },
                                    style: GoogleFonts.nunito(fontSize: 15),
                                    decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.all(10),
                                      fillColor: HexColor("#f4f4f4"),
                                      filled: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white, width: 1.0,),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      hintText: getBahasa.toString() == "1"? 'Cari Lembur':'Search Overtime',
                                    ),
                                  ),
                                )
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemExtent: 90,
                                itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                padding: const EdgeInsets.only(bottom: 85),
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        child : ListTile(
                                            visualDensity: VisualDensity(horizontal: -2),
                                            dense : true,
                                            title:  Text(snapshot.data![i]["i"].toString(),  style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,fontSize: 15),),
                                            subtitle: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(top: 2),
                                                  child:   Align(alignment: Alignment.centerLeft,child: Row(
                                                    children: [
                                                      Text(
                                                              AppHelper().getTanggalCustom(snapshot.data![i]["f"].toString()) + " "+
                                                              AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["f"].toString()) + " "+
                                                              AppHelper().getTahunCustom(snapshot.data![i]["f"].toString())+ " - "+
                                                              AppHelper().getTanggalCustom(snapshot.data![i]["g"].toString()) + " "+
                                                              AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["g"].toString()) + " "+
                                                              AppHelper().getTahunCustom(snapshot.data![i]["g"].toString())

                                                          ,
                                                          style: GoogleFonts.workSans(fontSize: 14,color: Colors.black)),
                                                    ],
                                                  ),),
                                                ),

                                                Padding(
                                                    padding: EdgeInsets.only(top: 1,bottom: 1),
                                                    child: Align(alignment: Alignment.centerLeft,
                                                        child:Text("Assign to : "+snapshot.data![i]["e"].toString(),
                                                            style: GoogleFonts.nunito(fontSize: 14, color: Colors.black)))),


                                              ],
                                            ),
                                            trailing:
                                            snapshot.data![i]["j"].toString() != 'Fully Approved' ?
                                            Opacity(
                                              opacity: 0.9,
                                              child: Container(
                                                child: OutlinedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    side: BorderSide(
                                                      width: 1,
                                                      color: snapshot.data![i]["j"].toString() == 'Pending'? Colors.black54 :
                                                      snapshot.data![i]["j"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                      HexColor("#FF4136"),
                                                      style: BorderStyle.solid,
                                                    ),
                                                  ),
                                                  child: Text(snapshot.data![i]["j"].toString(),style: GoogleFonts.nunito(fontSize: 12,
                                                      color: snapshot.data![i]["j"].toString() == 'Pending'? Colors.black54 :
                                                      snapshot.data![i]["j"].toString() == 'Approved 1' ? HexColor("#0074D9") :
                                                      HexColor("#FF4136")),),
                                                  onPressed: (){},
                                                ),
                                                height: 25,
                                              ),
                                            ) :
                                            FaIcon(FontAwesomeIcons.circleCheck,color: HexColor("#3D9970"),size: 30,)
                                        ),
                                        onTap: (){
                                          EasyLoading.show(status: AppHelper().loading_text);
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          Navigator.push(context, ExitPage(page: ApprLemburDetail(snapshot.data![i]["a"].toString(), widget.getKaryawanNo,widget.getKaryawanNama))).then(onGoBack);

                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:5),child:
                                      Divider(height: 4,),),
                                    ],
                                  );
                                },
                              ),
                            ),

                          ],
                        );

                      }
                    },
                  )
              ),

            ],
          ),
        ),
        floatingActionButton:
        widget.getModul == 'createdbyme' ?
        Container(
          width: 62,
          height: 62,
          child: FloatingActionButton(
            backgroundColor: HexColor("#00a884"),
            child: FaIcon(FontAwesomeIcons.plus),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Navigator.push(context, ExitPage(page: LemburAdd(widget.getKaryawanNo, widget.getKaryawanNama, widget.getEmail, "Lembur in Same Day"))).then(onGoBack);
            },
          ),
        ) : Container()
    ), onWillPop: onWillPop);
  }


  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }


}