


import 'dart:async';
import 'dart:convert';

import 'package:abzeno/Attendance/page_doattendancelembur.dart';
import 'package:abzeno/attendance/page_doattendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart%20';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator; // you can change this to what you want
import 'package:intl/intl.dart';
import 'package:location/location.dart' as locator;
import '../helper/app_helper.dart';
import '../helper/app_link.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helper/page_route.dart';
import '../page_login.dart';


class PageClockInLembur extends StatefulWidget{
  final String getKaryawanNo;
  final String getJam;
  final String getLocationId;
  final String getNamaHari;
  final String getLocationLat;
  final String getLocationLong;
  final String getAttendanceType;
  final String getKaryawanNama;
  final String getKaryawanJabatan;
  final String getStartTime;
  final String getEndTime;
  final String getScheduleName;
  final String getWorkLocation;
  const PageClockInLembur(
      this.getKaryawanNo,
      this.getJam,
      this.getLocationId,
      this.getNamaHari,
      this.getLocationLat,
      this.getLocationLong,
      this.getAttendanceType,
      this.getKaryawanNama,
      this.getKaryawanJabatan,
      this.getStartTime,
      this.getEndTime,
      this.getScheduleName,
      this.getWorkLocation);
  @override
  _PageClockInLembur createState() => _PageClockInLembur();
}



class _PageClockInLembur extends State<PageClockInLembur> {
  late double _distanceInMeters;
  bool _isvisibleBtn = false;
  bool isPressed = false;
  var jarak = 0;
  LatLng _initialcameraposition = LatLng(-7.281798579483975, 112.73688279669264);
  late LatLng currentPostion = LatLng(-7.134805, 111.863460);
  late LatLng _locationCabang;
  late GoogleMapController _controller;
  locator.Location _location = locator.Location();
  bool servicestatus = false;
  bool haspermission = false;
  late geolocator.Position position;
  String long = "", lat = "";
  final _noteclockin = TextEditingController();
  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Marker> markers = new Set();
  var getJam2 = '';


  String gpsOff = "0";
  checkGps() async {
    EasyLoading.show(status: AppHelper().loading_text);
    setState(() {
      _locationCabang = LatLng(double.parse(widget.getLocationLat), double.parse(widget.getLocationLong));
    });
    EasyLoading.dismiss();
    LocationPermission permission = await Geolocator.checkPermission();
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppHelper().showFlushBarerror(context,'Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          AppHelper().showFlushBarerror(context,"'Location permissions are permanently denied");
        }else{
          haspermission = true;
          await getLocation();
        }
        EasyLoading.dismiss();
      }else{
        haspermission = true;
        await getLocation();
        EasyLoading.dismiss();
      }
      if(haspermission){
        await getLocation();
        EasyLoading.dismiss();
      }

      setState(() {
        gpsOff = "0";
      });
    }else{
      getBahasa.toString() == "1" ?
      AppHelper().showFlushBarerror(context,"Layanan GPS tidak diaktifkan, aktifkan lokasi GPS")
          :
      AppHelper().showFlushBarerror(context,"GPS Service is not enabled, turn on GPS location");
      setState(() {
        gpsOff = "1";
        _isvisibleBtn = false;
      });
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }



  checkGps2() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){

    }else{
      setState(() {
        gpsOff = "1";
        _isvisibleBtn = false;
      });
      EasyLoading.dismiss();
    }
  }




  late LocationSettings locationSettings;

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      long = position.longitude.toString();
      lat = position.latitude.toString();
      getme(long,lat);
      _isvisibleBtn = true;
    });
  }


  void _onMapCreated(GoogleMapController _cntlr) async
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          //CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
          CameraPosition(target: currentPostion,zoom: 15),
        ),
      );
    });
  }


  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(currentPostion.toString()),
        position: currentPostion, //position of marker
        infoWindow: InfoWindow( //popup info
          title: getBahasa.toString() == "1"? 'Lokasi Saya' : 'My Location',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add second marker
        markerId: MarkerId(_locationCabang.toString()),
        position: _locationCabang, //position of marker
        infoWindow: InfoWindow( //popup info
          title: getBahasa.toString() == "1"? 'Lokasi Absen' : 'Attendance Location',
          //snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
    return markers;
  }



  void getme(String LongVal, String LatVal) async {
    _distanceInMeters = await GeolocatorPlatform.instance.distanceBetween(double.parse(widget.getLocationLat)
        , double.parse(widget.getLocationLong), double.parse(LatVal), double.parse(LongVal));
    jarak = _distanceInMeters.ceil();
  }

  String getBahasa = "1";
  String getToken = "0";
  getSettings() async {
    await AppHelper().getSession().then((value){
      setState(() {
        getBahasa = value[20];
        getToken = value[23];
      });});
  }

  _startingVariable() async {
    EasyLoading.show(status: AppHelper().loading_text);
    _noteclockin.clear();
    await getSettings();
    await AppHelper().getConnect().then((value){
      if(value == 'ConnInterupted'){
        getBahasa.toString() == "1"?
        AppHelper().showFlushBarsuccess(context, "Koneksi terputus...") :
        AppHelper().showFlushBarsuccess(context, "Connection Interupted...");
        setState(() {
          isPressed = false;
        });
        return false;
      } else {
        setState(() {
          isPressed = true;
        });
      }
    });
    await AppHelper().getSession().then((value){
      setState(() {
        if(value[0] == "" || value[0] == null) {
          Navigator.pushReplacement(context, ExitPage(page: PageLogin(getBahasa, getToken)));
          EasyLoading.dismiss();
        }
      });});
    await checkGps();
    EasyLoading.dismiss();
  }


  _loaddata() async {
      await _startingVariable();
  }


  var _timeString = DateFormat('HH:mm').format(DateTime.now());
  void _getCurrentTime()  {
    setState(() {
      _timeString = "${DateFormat('HH').format(DateTime.now())}:${DateFormat('mm').format(DateTime.now())}";
      checkGps2();
    });
  }


  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds:1), (Timer t)=> _getCurrentTime());
    _loaddata();

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
        //backgroundColor: HexColor("#3a5664"),
        backgroundColor: Colors.white,
        title: Text(_timeString, style: GoogleFonts.montserrat(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.black),),
        centerTitle: true,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
              icon: new FaIcon(FontAwesomeIcons.times,size: 22,color: Colors.black),
              color: Colors.white,
              onPressed: ()  {
                Navigator.pop(context);
              }),
        ),
        actions: [
            Padding(padding: EdgeInsets.all(19),
            child: InkWell(
              onTap: (){
                _loaddata();
              },
              child: FaIcon(FontAwesomeIcons.refresh,color: Colors.black,size: 20,),
            ),)
        ],

      ),
      body: Container(
        width: double.infinity,
        height: 350,
        child: SingleChildScrollView(
          child : Column(
            children: <Widget>[
              currentPostion == null ?
              Container(
                  height: 180,
                  child : Center(
                    child: CircularProgressIndicator(),
                  )
              )
                  :
              Container(
                height: 180,
                child : GoogleMap(
                  initialCameraPosition: CameraPosition(target: currentPostion),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: false,
                  markers: getmarkers(),
                  zoomGesturesEnabled : false,
                  scrollGesturesEnabled : false,
                  rotateGesturesEnabled : false,
                  circles: Set.from([Circle( circleId: CircleId('currentCircle'),
                    center: _locationCabang,
                    radius: 300,
                    fillColor: Colors.blue.shade100.withOpacity(0.5),
                    strokeColor:  Colors.blue.shade100.withOpacity(0.1),
                  ),],),
                ),
              ),
              Divider(height: 1,),

              Padding(padding: const EdgeInsets.only(left: 25,top: 5,right: 25),
                  child: Column(
                    children: [


                  Padding(
                  padding: const EdgeInsets.only(left: 0,top: 25)),
                      widget.getAttendanceType == 'Clock In' ?
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: TextFormField(
                          style: GoogleFonts.workSans(fontSize: 16),
                          textCapitalization: TextCapitalization.sentences,
                          controller: _noteclockin,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: FaIcon(
                                FontAwesomeIcons.audioDescription,
                                //color: clockColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                top: 2),
                            hintText: getBahasa.toString() == "1" ? 'Tuliskan Catatan Kehadiran':'Input Attendance Note',
                            labelText: getBahasa.toString() == "1" ? 'Catatan Kehadiran':'Attendance Note',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#8c8989")),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD")),
                            ),
                          ),
                        ),
                      ),): Container()
                    ],
                  )
              ),

              Padding(padding: const EdgeInsets.only(top: 40,left: 25,right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child:     Text(
                        getBahasa.toString() == "1" ? "Jarak anda dari lokasi absen":"Your distance from current location",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.varelaRound(fontSize: 12),
                      ),
                    ),
                    Text(jarak.toString()+" meters",
                        style: GoogleFonts.varelaRound(fontSize: 13,fontWeight: FontWeight.bold)),
                  ],
                ),),
              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Align(alignment: Alignment.centerLeft, child : Text(
                    getBahasa.toString() == "1" ? "(jarak tidak boleh lebih dari "+AppHelper().range_max.toString()+" meter)":
                    "(Not Allowed in more than "+AppHelper().range_max.toString()+" meters)",
                    style: GoogleFonts.varelaRound(fontSize: 10))),
              ),
              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(),
              ),
            ],
          )
        ),
      ),
      bottomSheet: Container(
        height: 120,
        width: double.infinity,
        child : Column(
          children: [

            gpsOff == "0" ?
       Opacity(
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
                   "Pastikan GPS anda menyala saat melakukan absensi"
                       : "Make sure your GPS is on when making attendance"
                   ,style: GoogleFonts.nunitoSans(fontSize: 12),),
               )
           ),
         ),
       ) :
            Opacity(
              opacity: 0.8,
              child :    Container(
                width: double.infinity,
                color: HexColor("#ffeaef"),
                padding : const EdgeInsets.only(left: 25,right: 25),
                child: ListTile(
                    leading: FaIcon(FontAwesomeIcons.infoCircle,size: 25,),
                    title: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        getBahasa.toString() == "1" ?
                        "Mohon maaf, Layanan GPS anda tidak aktif, aktifkan lokasi GPS dan silahkan coba lagi"
                            : "Sorry, your GPS service is not active, please activate GPS location and please try again"
                        ,style: GoogleFonts.nunitoSans(fontSize: 12),),
                    )
                ),
              ),
            ),


            Container(
                width: double.infinity,
                height: 62,
                padding : const EdgeInsets.only(left: 25,right: 25,bottom: 10,top: 5),
                child :
                  Visibility(
                    visible: _isvisibleBtn,
                    child:

                    isPressed == true ?
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          //primary: HexColor("#075E54"),
                          primary: HexColor("#00aa5b"),
                          shape: RoundedRectangleBorder(side: BorderSide(
                              color: Colors.white,
                              width: 0.1,
                              style: BorderStyle.solid
                          ),
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      child : Text(widget.getAttendanceType.toString()+ " Lembur",style: GoogleFonts.lexendDeca(color: Colors.white,fontWeight: FontWeight.bold,
                          fontSize: 14),),
                      onPressed: (){
                        setState(() {
                          //isPressed = true;
                        });
                        //_addattendance();
                        if(int.parse(jarak.toString()) > AppHelper().range_max ) {
                          getBahasa.toString() == "1" ?
                            AppHelper().showFlushBarerror(context, "Maaf anda tidak bisa absen karena berada diluar area yang ditentukan")
                          : AppHelper().showFlushBarerror(context, "Sorry you can't do attendance because you are outside the designated area");
                          setState(() {
                            //isPressed = false;
                          });
                          return;
                        } else {

                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.getAttendanceType.toString() == 'Clock In' ?
                          Navigator.push(context, ExitPage(page: ClockOutLembur(
                              widget.getKaryawanNo,
                              _timeString,
                              AppHelper().getNamaHari().toString(),
                              _noteclockin.text,
                              "Clock In",
                              widget.getKaryawanNama,
                          widget.getKaryawanJabatan,
                          widget.getStartTime,widget.getEndTime,widget.getScheduleName,
                          widget.getWorkLocation,
                          widget.getLocationLat,
                          widget.getLocationLong)))
                              :
                          Navigator.push(context, ExitPage(page: ClockOutLembur(
                              widget.getKaryawanNo,
                              _timeString,
                              AppHelper().getNamaHari().toString(),
                              _noteclockin.text,
                              "Clock Out",
                              widget.getKaryawanNama,
                              widget.getKaryawanJabatan,
                              widget.getStartTime,widget.getEndTime,widget.getScheduleName,
                              widget.getWorkLocation,
                              widget.getLocationLat,
                              widget.getLocationLong)));
                        }
                        //EasyLoading.show(status: "Loading...");
                      },
                    )
                :
                Opacity(
                  opacity : 0.5,
                      child : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: HexColor("#DDDDDD"),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.white,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        child : Text("CLOCK IN",style: GoogleFonts.lexendDeca(color:Colors.white,fontWeight: FontWeight.bold,
                            fontSize: 14),),
                        onPressed: (){
                        },
                      )
                    )
                )
            ),
          ],
        )
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

