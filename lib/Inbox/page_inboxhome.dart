



import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:abzeno/Inbox/S_HELPER/g_inbox.dart';
import 'package:abzeno/Inbox/page_pesanpribadi.dart';
import 'package:abzeno/Setting/page_bahasa.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class InboxHome extends StatefulWidget {
  final String getKaryawanNo;

  const InboxHome(this.getKaryawanNo);
  @override
  _InboxHome createState() => _InboxHome();
}


class _InboxHome extends State<InboxHome> {

  String getCountPesanPribadi = "0";
  _getCountPesanPribadi() async {
    await g_inbox().getCountPesanPribadi().then((value){
      setState(() {
        getCountPesanPribadi = value[0];
      });});
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
    _getCountPesanPribadi();
    getSettings();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Text(
          getBahasa.toString() == "1" ? "Kotak Masuk" : "Inbox", style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 10,left: 5,right: 15),
          child: Column(
            children: [
              InkWell(
                child: ListTile(
                  visualDensity: VisualDensity(vertical: -2),
                  dense : true,
                  onTap: (){
                    //Navigator.push(context, ExitPage(page: PagePesanPribadi(widget.getKaryawanNo)));
                  },
                  leading:
                  getCountPesanPribadi != "0" ?
                  Badge(
                    showBadge: true,
                    badgeAnimation: BadgeAnimation.scale (
                      animationDuration: Duration(seconds: 1),
                      loopAnimation: false,
                    ),
                    badgeStyle: BadgeStyle(
                      shape: BadgeShape.circle,
                      badgeColor: Colors.red,
                      padding: EdgeInsets.all(5),
                      elevation: 0,
                    ),
                    position: BadgePosition.topStart(top: -2,start: -4),
                    child: FaIcon(FontAwesomeIcons.envelope),
                  ) :
                  FaIcon(FontAwesomeIcons.envelope),
                  title: Text(getBahasa.toString() == "1" ? "Pesan Pribadi" : "Private Message",style: TextStyle(
                      color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                      fontWeight: FontWeight.bold)),
                  subtitle: Text(getBahasa.toString() == "1" ? "Pesan pribadi yang hanya dikirim untuk kamu" :
                  "Private messages sent only to you",style: TextStyle(
                      color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                  trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                child: Divider(height: 3,),),




              InkWell(
                child: ListTile(
                  visualDensity: VisualDensity(vertical: -2),
                  dense : true,
                  onTap: (){
                    //Navigator.push(context, ExitPage(page: ChangeNotifikasi(widget.getEmail)));
                  },

                  leading:FaIcon(FontAwesomeIcons.bullhorn),
                  title: Text(getBahasa.toString() == "1" ? "Pemberitahuan" : "Announcement",style: TextStyle(
                      color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                      fontWeight: FontWeight.bold)),
                  subtitle: Text(getBahasa.toString() == "1" ? "Pemberitahuan terkini seputar perusahaan" :
                  "Latest notifications about the company",style: TextStyle(
                      color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                  trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                child: Divider(height: 3,),),



            ],
          ),
        ),
      ),
    ), onWillPop: onWillPop);
  }


  Future<bool> onWillPop() async {
    try {
      //Navigator.pop(context);
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }


}