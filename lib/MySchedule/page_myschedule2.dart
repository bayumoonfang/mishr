


import 'dart:convert';

import 'package:abzeno/Attendance/page_attendance.dart';
import 'package:abzeno/Helper/app_helper.dart';
import 'package:abzeno/Helper/app_link.dart';
import 'package:abzeno/Helper/page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../Request Attendance/page_attendancehome.dart';


class MySchedule2 extends StatefulWidget{
  final String getKaryawanNo;
  final String getKaryawanNama;
  final String getKaryawanEmail;
  const MySchedule2(this.getKaryawanNo, this.getKaryawanNama, this.getKaryawanEmail );
  @override
  _MySchedule2 createState() => _MySchedule2();
}


class _MySchedule2 extends State<MySchedule2> {
  late CalendarController _controller;
  late Map<DateTime, List<dynamic>> _events;
  late List<dynamic> _selectedEvents;
  late List<dynamic> _getEvents = [];
  late TextEditingController _eventController;
  late SharedPreferences prefs;
  List<dynamic> getSchedulemeaa = [];

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
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    prefsData();
  }
  List timeOffTypeList = [];
  String getType = "...";
  Future getScheduleNew() async {
    var response = await http.get(Uri.parse(
        applink + "mobile/api_mobile.php?act=getScheduleNew&karyawan_no=" +
            widget.getKaryawanNo));
    var jsonData = json.decode(response.body);
    setState(() {
      timeOffTypeList = jsonData;
      timeOffTypeList.map((item) {
        setState(() {
          if(item['keterangan'].toString() != '-' && item['keterangan'].toString() != 'null') {
            DateTime dt = DateTime.parse(item['tahun'].toString()+"-"+item['bulan'].toString()+"-"+item['tgl'].toString());
            _events[dt] = [
              getBahasa.toString() == "1"?  "Jadwal : "+item['keterangan'].toString()+" \n"+
                  "("+item['kodeschedule'].toString()+") "+item['start'].toString()+" - "+item['end'].toString() :
              "Schedule Name : "+item['keterangan'].toString()+" \n"+
                  "("+item['kodeschedule'].toString()+") "+item['start'].toString()+" - "+item['end'].toString()
            ];
          }
          //prefs.setString("events", json.encode(encodeMap(_events)));
        });
      }).toList();
    });

  }



  prefsData() async {
    //prefs = await SharedPreferences.getInstance();
    //prefs.setString("events", '');
    EasyLoading.show(status: AppHelper().loading_text);
    await getScheduleNew();
    EasyLoading.dismiss();
   /* setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });*/
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(getBahasa.toString() == "1"? "Jadwal Saya":"My Schedule", style: GoogleFonts.montserrat(
            fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        elevation: 1,
        leading: Builder(
          builder: (context) =>
              IconButton(
                  icon: new FaIcon(FontAwesomeIcons.arrowLeft, size: 17,color: Colors.black,),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
        ),
        actions: [
          Padding(padding: EdgeInsets.all(19),
            child: InkWell(
              onTap: (){
                setState(() {
                  prefsData();
                });
              },
              child: FaIcon(FontAwesomeIcons.refresh,color: Colors.black,size: 20,),
            ),)
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                events: _events,
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: (date, events,holidays) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
                builders: CalendarBuilders(
                  singleMarkerBuilder: (context, date, event) {
                    return Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                      width: 7.0,
                      height: 13,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    );
                  },
                  selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                calendarController: _controller,
              ),
              Padding(padding: EdgeInsets.only(left: 25,right: 25,bottom: 15),child: Divider(height: 5,),),
              ..._selectedEvents.map((event) => Padding(
                padding: const EdgeInsets.only(left: 25,top: 5),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,
                          child:      Text(event,
                              style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold,fontSize: 14))),
                    ],
                  ),
                ),
              )),

            ],
          ),
        )
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
        child: Text(getBahasa.toString() == "1"?  "Buat Pengajuan":"Create Request",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
            fontSize: 14)),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            Navigator.push(context, ExitPage(page: PageAttendanceHome(widget.getKaryawanNo, widget.getKaryawanNama, widget.getKaryawanEmail)));
          });

        },
      )),
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