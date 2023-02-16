





import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/page_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Introduction extends StatefulWidget {
  final String getTokenMe;
  const Introduction(this.getTokenMe);
  @override
  _Introduction createState() => _Introduction();
}


class _Introduction extends State<Introduction> {

  //String aa = await DeviceInformation.deviceIMEINumber;
  String getBahasa = "1";

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontFamily: "VarelaRound",fontSize: 16);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",fontSize: 20),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
           /* Padding(padding: EdgeInsets.all(20),
            child: InkWell(
              child: FaIcon(FontAwesomeIcons.language,color: Colors.black,size: 28,),
              onTap: (){
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                          child : Container(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Padding(
                              padding: EdgeInsets.only(left: 25,right: 25,top: 25),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Change Language",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 17),),
                                      InkWell(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: FaIcon(FontAwesomeIcons.times,size: 20,),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:15),
                                  ),
                                  Column(
                                    children: [

                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text("Bahasa Indonesia",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            getBahasa = "1";
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),),


                                      InkWell(
                                        child : ListTile(
                                          visualDensity: VisualDensity(horizontal: -2),
                                          dense : true,
                                          title: Text("English",style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,fontSize: 15),),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.pop(context);
                                            getBahasa = "2";
                                          });
                                        },
                                      ),
                                      Padding(padding: const EdgeInsets.only(top:1),child:
                                      Divider(height: 1,),),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      );
                    });
              },
            ),)*/
          ],
        ),
        backgroundColor: Colors.white,
        body: IntroductionScreen(
          globalBackgroundColor: Colors.white,
          done: Text("Login"),
          onDone: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PageLogin(getBahasa, widget.getTokenMe)),
            );
          },
          pages: [
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/LOGO2.png",height: 400,
                  ),
                ),
                title: getBahasa == '1' ? "Aplikasi "+AppHelper().app_name : AppHelper().app_name+" Application",
                body: getBahasa == '1' ? "Selamat Datang di aplikasi HR terbaik karya anak bangsa" :
                "Welcome to the nation's best HR application",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/png1.png",width: 270,
                  ),
                ),
                title: getBahasa == '1' ? "Manajemen kehadiran kamu" : "Management of your attendance",
                body: getBahasa == '1' ? "Nikmati kemudahan manajamen kehadiran kamu setiap harinya" :
                      "Enjoy the convenience of managing your attendance every day",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/png2.png",height: 275,
                  ),
                ),
                title: getBahasa == '1' ? "Fitur Lengkap" : "Complete Features",
                body: getBahasa == '1' ? "Fitur paling lengkap dan mudah digunakan tanpa ribet hanya dalam satu aplikasi" :
                "The most complete and easy-to-use features without being complicated in just one application",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/png3.png",width: 300,
                  ),
                ),
                title: getBahasa == '1' ? "Report lengkap dan mudah" : "Complete and easy report",
                body: getBahasa == '1' ? "Semua kehadiran kamu terorganisir dengan baik dan sangat mudah dianalisa" :
                "All your attendance is well organized and very easy to analyze",
                footer: Text("@"+AppHelper().app_tag, style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
          ],
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip:  Text(getBahasa == '1' ? 'Lewati' : 'Skip'),
          next: const Icon(Icons.arrow_forward),
          curve: Curves.fastLinearToSlowEaseIn,
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );


  }
}