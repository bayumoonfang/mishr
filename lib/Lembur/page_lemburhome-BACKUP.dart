

/*

import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Lembur/page_lembur.dart';
import 'package:abzeno/Request%20Attendance/page_reqattendance.dart';
import 'package:abzeno/Time%20Off/ARCHIVED/page_myapproval.dart';
import 'package:abzeno/page_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';



class PageRLemburHome extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getEmail;
  const PageRLemburHome(this.getKaryawanNo, this.getKaryawanNama, this.getEmail);
  @override
  _PageRLemburHome createState() => _PageRLemburHome();
}

class _PageRLemburHome extends State<PageRLemburHome> with SingleTickerProviderStateMixin {
  late TabController controller;

  loadData() async {
    getSettings();
  }


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
    controller = new TabController(vsync: this, length: 4);
    loadData();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        backgroundColor: HexColor("#3a5664"),
        title: Text(getBahasa.toString() == "1"? "Lembur":"Overtime", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold),),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.white,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
        bottom: new TabBar(
          indicatorColor: Colors.white,
          controller: controller,
          labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 15),
          unselectedLabelStyle: GoogleFonts.varelaRound(fontSize: 13),
          //unselectedLabelColor: Colors.white,
          tabs: <Widget>[
            new Tab(text: getBahasa.toString() == "1"? "Dibuat oleh saya":"Created By Me"),
            new Tab(text: getBahasa.toString() == "1"? "Delegasi ke saya": "Delegated to Me"),
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          PageLembur(widget.getKaryawanNo, "createdbyme", widget.getKaryawanNama, widget.getEmail),
          PageLembur(widget.getKaryawanNo, "delegatedtome", widget.getKaryawanNama, widget.getEmail),
        ],
      ),
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

}*/