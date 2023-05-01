

import 'package:abzeno/Bertugas/page_bertugasadd.dart';
import 'package:abzeno/Bertugas/page_bertugaslist-home.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';



class PageBertugasHome extends StatefulWidget{
  final String getKaryawanNo;
  const PageBertugasHome(this.getKaryawanNo);
  @override
  _PageBertugasHome createState() => _PageBertugasHome();
}


class _PageBertugasHome extends State<PageBertugasHome> {
  Future<bool> onWillPop() async {
    try {
      Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }


  String getBahasa = "1";
  getSettings() async {
    //=====================
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          //backgroundColor: HexColor("#3a5664"),
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) =>
                IconButton(
                    icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
          ),
          title: Text(
            getBahasa.toString() == "1" ? "Bertugas" : "Duty", style: GoogleFonts.montserrat(fontSize: 15,
            fontWeight: FontWeight.bold,color: Colors.black,),),
          elevation: 1,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 5,right: 15),
            child: Column(
              children: [
                InkWell(
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, ExitPage(page: PageAddBertugas(widget.getKaryawanNo,"Perjalanan Dinas")));
                    },
                    title: Text(getBahasa.toString() == "1" ? "Perjalanan Dinas" : "Attendance History",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Padding(padding: EdgeInsets.only(top: 5),child: Text(
                        getBahasa.toString() == "1" ? "Ajukan rencana perjalanan dinas kamu disini" :
                    "Track your attendance history every day",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12))),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, ExitPage(page: PageAddBertugas(widget.getKaryawanNo,"Training")));
                    },
                    title: Text(getBahasa.toString() == "1" ? "Training" : "Attendance Correction",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Padding(padding: EdgeInsets.only(top: 5),child: Text(
                        getBahasa.toString() == "1" ? "Ajukan rencana pelatihan kamu disini" :
                    "Submit your attendance correction if something goes wrong",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12,height: 1.2)),),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),



              ],
            ),
          ),
        ),
        bottomSheet: Container(
            padding: EdgeInsets.only(left: 35, right: 35, bottom: 10),
            width: double.infinity,
            height: 55,
            child:
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //primary: HexColor(AppHelper().main_color),
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(
                      color: Colors.white,
                      width: 0.1,
                      style: BorderStyle.solid
                  ),
                    borderRadius: BorderRadius.circular(5.0),
                  )),
              child: Text(getBahasa.toString() == "1"?  "Daftar Pengajuan":"Request List",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                  fontSize: 14)),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  Navigator.push(context, ExitPage(page: PageBertugasListHome(widget.getKaryawanNo)));
                });

              },
            )),
      ),
    );

  }
}