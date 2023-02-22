



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

import 'page_jadwallembur.dart';



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
    controller = new TabController(vsync: this, length: 3);
    loadData();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }



  showInfoDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(getBahasa.toString() == "1"? "TUTUP" : "CLOSE",style: GoogleFonts.lexendDeca(color: Colors.blue),),
      onPressed:  () {Navigator.pop(context);},
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(getBahasa.toString() == "1"? "Informasi" :"Information", style: GoogleFonts.nunitoSans(fontSize: 18,fontWeight: FontWeight.bold),textAlign:
      TextAlign.left,),
      content: Container(
          height: 90,
          child : Column(
            children: [
              Text("JIka pengajuan lembur anda sepenuhnya disetujui, maka akan ada menu baru di beranda anda untuk melakukan rekam kehadiran lembur."
                  , style: GoogleFonts.nunitoSans(),textAlign:
              TextAlign.left,),
            ],
          )
      ),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    var onWillPop;
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        titleSpacing: 0,
        //shape: Border(bottom: BorderSide(color: Colors.red)),
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1"? "Lembur":"Overtime", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.arrowLeft,size: 17,),
              color: Colors.black,
              onPressed: ()  {
                Navigator.pop(context);

              }),
        ),
        bottom: new TabBar(
          indicatorColor: Colors.black,
          controller: controller,
          labelColor: Colors.black,
          labelStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
          unselectedLabelStyle: GoogleFonts.varelaRound(fontSize: 13,color: Colors.black),
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            new Tab(text: getBahasa.toString() == "1"? "My Request":"Created By Me"),
            new Tab(text: getBahasa.toString() == "1"? "Approval": "Delegated to Me"),
            new Tab(text: getBahasa.toString() == "1"? "Jadwal Lembur": "Delegated to Me"),
          ],
        ),
        actions: [
        Container(
        width: 50,
        height: 50,
        child :
          Padding(
            padding: EdgeInsets.only(top: 17,right: 22),
            child: InkWell(
              child : FaIcon(FontAwesomeIcons.circleInfo,color: HexColor("#535967"),size: 22,),
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                showInfoDialog(context);
              },
            ),))

        ],
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          PageLembur(widget.getKaryawanNo, "createdbyme", widget.getKaryawanNama, widget.getEmail),
          PageLembur(widget.getKaryawanNo, "delegatedtome", widget.getKaryawanNama, widget.getEmail),
          JadwalLembur(widget.getKaryawanNo),
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

}