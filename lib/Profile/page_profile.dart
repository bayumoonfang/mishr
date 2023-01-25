


import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Profile/page_aboutus.dart';
import 'package:abzeno/Profile/page_activity.dart';
import 'package:abzeno/Profile/page_attendancehistory.dart';
import 'package:abzeno/Profile/page_changepin.dart';
import 'package:abzeno/Profile/page_fullprofile.dart';
import 'package:abzeno/helper/page_route.dart';
import 'package:abzeno/page_intoduction.dart';
import 'package:abzeno/page_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Profile extends StatefulWidget{
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getKaryawanNo;
  const Profile(this.getKaryawanNama, this.getKaryawanJabatan, this.getKaryawanNo);
  @override
  _Profile createState() => _Profile();
}


class _Profile extends State<Profile>{

  String getBahasa = "1";
  String getToken = "0";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
        getToken = value[23];
      });});
  }



  String versionVal = '...';
  String codeVal = '...';
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      String version = packageInfo.version;
      String code = packageInfo.buildNumber;
      versionVal = version;
      codeVal = code;
    });
  }


  void initState() {
    super.initState();
    getSettings();
    getVersion();
  }

  _clearallpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(context, ExitPage(page: Introduction(getToken)));
  }

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("email", '');
      preferences.setString("username", '');
      preferences.setString("karyawan_id", '');
      preferences.setString("karyawan_nama", '');
      preferences.setString("karyawan_no", '');
      preferences.commit();
      _clearallpref();
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: onWillPop, child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(bottom:15,top: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25,bottom: 20),
                child:   ListTile(
                  leading: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                        border: Border.all(
                          color: HexColor("#DDDDDD"), width: 1,
                        )
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                          'assets/user.png'),
                    ),),
                  title: Text(widget.getKaryawanNama, style: GoogleFonts.nunitoSans(fontSize: 17),),
                  subtitle: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,child:
                      Text(widget.getKaryawanJabatan, style: GoogleFonts.nunitoSans(fontSize: 14),),)
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 6,
                padding: const EdgeInsets.only(top: 50),
                color: HexColor("#f5f5f5"),
              ),


             Container(
               padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
               child: Column(
                 children: [
                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.user,size: 24,color : HexColor("#5ebef0")),
                         title: Text(getBahasa.toString() == "1" ? "Profil Saya" : "My Profile", style: GoogleFonts.nunito(fontSize: 16),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Detail penuh profil saya" : "Full Detail of my profile", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: PageFullProfile(widget.getKaryawanNo)));
                     },
                   ),

                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),
                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.lock,color : HexColor("#e28743")),
                         title: Text(getBahasa.toString() == "1" ?  "Ubah PIN" : "Change PIN", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Ubah PIN untuk keamanan lebih":"Change my PIN for better security", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: ChangePIN(widget.getKaryawanNo)));
                     },
                   ),

                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),
                  /* InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.penToSquare,color : HexColor("#3bc188")),
                         title: Text("My Approval", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("My list need my approval", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){},
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),
                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.bullhorn,color : HexColor("#f6706a")),
                         title: Text("My Activity", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("My Daily activity", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: MyActivity(widget.getKaryawanNo)));
                     },
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),*/
                   Opacity(
                     opacity: 0.4,
                     child: InkWell(
                       child : Padding(
                         padding: const EdgeInsets.only(bottom: 5),
                         child: ListTile(
                           minLeadingWidth : 25,
                           dense:true,
                           contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                           leading: FaIcon(FontAwesomeIcons.laptopFile,color : HexColor("#ffa427")),
                           title: Text(getBahasa.toString() == "1" ? "Histori Karir": "Career History", style: GoogleFonts.nunitoSans(fontSize: 16),),
                           subtitle: Text(getBahasa.toString() == "1" ? "Histori karir saya" : "My Career History", style: GoogleFonts.nunito(fontSize: 13),),
                           trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                         ),
                       ),
                       onTap: (){},
                     ),
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),

                   /* InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.clock,color : HexColor("#b35ef6")),
                         title: Text("Attendance History", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("All My Attendance History", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: AttendanceHistory(widget.getKaryawanNo)));
                     },
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),

                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.clipboardList,color : HexColor("#622df7")),
                         title: Text("My Schedule", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text("All My Shift Schedule", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){},
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),*/

                   InkWell(
                     child : Padding(
                       padding: const EdgeInsets.only(bottom: 5),
                       child: ListTile(
                         minLeadingWidth : 25,
                         dense:true,
                         contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                         leading: FaIcon(FontAwesomeIcons.infoCircle,color : HexColor("#3ad3e1")),
                         title: Text(getBahasa.toString() == "1" ? "Tentang Kami":"About Us", style: GoogleFonts.nunitoSans(fontSize: 16),),
                         subtitle: Text(getBahasa.toString() == "1" ? "Semua Tentang Kami": "All About Us", style: GoogleFonts.nunito(fontSize: 13),),
                         trailing: const FaIcon(FontAwesomeIcons.angleRight, size: 18,),
                       ),
                     ),
                     onTap: (){
                       Navigator.push(context, ExitPage(page: AboutUs()));
                     },
                   ),
                   const Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Divider(height: 2,),
                   ),

                  Padding(padding: EdgeInsets.only(top: 30),child:  Container(
                      padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                      width: double.infinity,
                      height: 55,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor("#fc6e67"),
                            elevation: 0,
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.white,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        child: Text("Logout"),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _logout();
                        },
                      )
                  ),),

                  Padding(
                     padding: EdgeInsets.only(bottom: 5),
                     child: Center(
                       child: Text("Version "+versionVal+ " build "+codeVal, style: GoogleFonts.workSans(fontSize: 13)),
                     ),
                   ),
                 ],
               ),
             )
            ],
          ),
        ),
      ),
    ));
  }

  Future<bool> onWillPop() async {
    try {
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}