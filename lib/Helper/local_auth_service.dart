


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class LocalAuth {

  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async => await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate(bool getFingerscanActive, String getBiometricPriority ) async {
    bool _isBiometricOnly = true;
    List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
    try{
      if(!await _canAuthenticate()) return false;

      if(Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          _isBiometricOnly = false;
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          if(getFingerscanActive == true) {
            _isBiometricOnly = true;
          } else {
            _isBiometricOnly = false;
          }
        }
      } else {
        if(getFingerscanActive == true) {
          _isBiometricOnly = true;
        } else {
          _isBiometricOnly = false;
        }
      }
      return await _auth.authenticate(
        localizedReason: " \n",
       authMessages: [
          AndroidAuthMessages(
            signInTitle: "Confirm fingerscan to enter misHR",
            cancelButton: "CANCEL",
          ),
          IOSAuthMessages(
            cancelButton: 'Close'
          )
        ],
        options: AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: _isBiometricOnly,
          //stickyAuth: true
        )
      );
    } catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}