import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // 1. ROLE & LANGUAGE
  int _userRole = 0;
  String _languageCode = 'en';

  // 2. EDITABLE FARMER PROFILE DATA
  String _farmerName = "Rajesh Kumar";
  String _farmerPhone = "9876543210";
  String _crop = "Paddy (Rice)";
  String _landSize = "2.5 Acres";
  String _district = "Khordha";

  // Getters
  int get userRole => _userRole;
  String get languageCode => _languageCode;
  String get farmerName => _farmerName;
  String get farmerPhone => _farmerPhone;
  String get crop => _crop;
  String get landSize => _landSize;
  String get district => _district;

  // Setters
  void setUserRole(int role) {
    _userRole = role;
    notifyListeners();
  }

  void setLanguage(String code) {
    _languageCode = code;
    notifyListeners();
  }

  // UPDATE PROFILE FUNCTION
  void updateProfile(String name, String phone, String newCrop, String size, String dist) {
    _farmerName = name;
    _farmerPhone = phone;
    _crop = newCrop;
    _landSize = size;
    _district = dist;
    notifyListeners(); // Updates the Sidebar and Dashboard instantly!
  }
}