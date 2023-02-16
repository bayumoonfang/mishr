


import 'dart:async';

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Time%20Off/page_timeoffdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'S_HELPER/g_timeoff.dart';
import 'S_HELPER/m_timeoff.dart';
import 'page_addtimeoff.dart';

class PageTimeOffSaldo extends StatefulWidget{
  final String getKaryawanNo;
  const PageTimeOffSaldo(this.getKaryawanNo);
  @override
  _PageTimeOffSaldo createState() => _PageTimeOffSaldo();
}



class _PageTimeOffSaldo extends State<PageTimeOffSaldo> {

  String filter = "";
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
    loadData();
  }


  loadData() async {
    await getSettings();
    EasyLoading.dismiss();
  }


  Future getData() async {
    setState(() {
      g_timeoff().getData_AllTimeOffSaldo(widget.getKaryawanNo);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child : Column(
            children: [
              Expanded(
                  child: RefreshIndicator(
                    onRefresh: getData,
                    child: Padding(
                        padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                        child:FutureBuilder(
                          future: g_timeoff().getData_AllTimeOffSaldo(widget.getKaryawanNo),
                          builder: (context, snapshot){
                            if (snapshot.data == null) {
                              return Center(
                                child: const SpinKitThreeBounce(
                                  size: 30,
                                  color: Colors.indigo,
                                ),
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
                                          Image.asset('assets/empty2.png',width: 150,),
                                          Padding(
                                            padding: EdgeInsets.only(left: 13),
                                            child:  new Text(
                                              getBahasa.toString() == "1" ? "Tidak ada data": "No Data",
                                              style: new TextStyle(
                                                  fontFamily: 'VarelaRound', fontSize: 13),
                                            ),
                                          )
                                        ],
                                      )))
                                  :
                              Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemExtent: 85,
                                      itemCount: snapshot.data == null ? 0 : snapshot.data?.length,
                                      padding: const EdgeInsets.only(bottom: 85,top: 5),
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [
                                              ListTile(
                                                  visualDensity: VisualDensity(horizontal: -2),
                                                  dense : true,
                                                  title: Opacity(
                                                      opacity: 0.9,
                                                      child:
                                                      Padding(padding: EdgeInsets.only(top: 2),child:
                                                      Text("Code : ("+snapshot.data![i]["b"].toString()+")"+" |  Type : "+snapshot.data![i]["c"].toString(),
                                                        overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                            fontSize: 12),),)
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child:Padding(padding: EdgeInsets.only(top: 2),child:
                                                    Text(snapshot.data![i]["a"].toString(),
                                                      overflow: TextOverflow.ellipsis,  style: GoogleFonts.montserrat(
                                                          fontWeight: FontWeight.bold,fontSize: 14.5,color: Colors.black),),),
                                                  ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 5),
                                                        child:   Align(alignment: Alignment.centerLeft,child:
                                                        Text(snapshot.data![i]["e"].toString() == 'null' || snapshot.data![i]["e"].toString() == '0000-00-00' ? "Effective Date : -" :
                                                        "Effective Date : "+AppHelper().getTanggalCustom(snapshot.data![i]["e"].toString()) + " "+
                                                            AppHelper().getNamaBulanCustomSingkat(snapshot.data![i]["e"].toString()) + " "+
                                                            AppHelper().getTahunCustom(snapshot.data![i]["e"].toString()),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.nunitoSans(fontSize: 13,color: Colors.black)),),
                                                      )
                                                    ],
                                                  ),
                                                  trailing:
                                                  Opacity(
                                                    opacity: 0.9,
                                                    child: Container(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor: HexColor("#0074D9"),
                                                        ),
                                                        child:
                                            snapshot.data![i]["d"].toString() == "99" ?
                                            FaIcon(FontAwesomeIcons.infinity,size: 13.5,) :
                                                        Text(snapshot.data![i]["d"].toString(),style: GoogleFonts.nunito(fontSize: 13.5,
                                                            color: Colors.white,fontWeight: FontWeight.bold),),
                                                        onPressed: (){},
                                                      ),
                                                      height: 25,
                                                    ),
                                                  )
                                              ),

                                            Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                                child : Divider(thickness: 1,)),
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
                  )
              )
            ],
          )

      ), bottomNavigationBar:  Opacity(
      opacity: 0.8,
      child :    Container(
        width: double.infinity,
        color: HexColor("#DDDDDD"),
        padding : const EdgeInsets.only(left: 25,right: 25),
        child: ListTile(
            leading: FaIcon(FontAwesomeIcons.infoCircle,size: 25,),
            title: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                getBahasa.toString() == "1" ?
                "Jika ada ketidaksesuaian saldo time off, anda bisa menghubungi HRD anda untuk dilakukan kroscek terkait saldo time off anda"
                    : "If there is a discrepancy in your time off balance, you can contact your HRD to cross-check your time off balance"
                ,style: GoogleFonts.nunitoSans(fontSize: 11.5),),
            )
        ),
      ),
    ),);
  }

}

