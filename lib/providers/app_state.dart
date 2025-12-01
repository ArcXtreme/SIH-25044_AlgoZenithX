import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // 1. ROLE & LANGUAGE
  int _userRole = 0;
  String _languageCode = 'en';

  // 2. FARMER DATA
  String _farmerName = "Rajesh Kumar";
  String _farmerPhone = "9876543210";
  String _landSize = "2.5 Acres";
  String _district = "Khordha";

  // 3. MULTI-CROP LOGIC (NEW!)
  List<String> _myCrops = ["Paddy (Rice)"]; // Default list
  String _selectedCrop = "Paddy (Rice)";    // The one currently showing on dashboard

  // Getters
  int get userRole => _userRole;
  String get languageCode => _languageCode;
  String get farmerName => _farmerName;
  String get farmerPhone => _farmerPhone;
  String get landSize => _landSize;
  String get district => _district;
  
  List<String> get myCrops => _myCrops;
  String get selectedCrop => _selectedCrop;

  // Setters
  void setUserRole(int role) {
    _userRole = role;
    notifyListeners();
  }

  void setLanguage(String code) {
    _languageCode = code;
    notifyListeners();
  }

  // Switch which crop we are looking at
  void selectCrop(String crop) {
    _selectedCrop = crop;
    notifyListeners(); // Updates the dashboard instantly
  }

  // Update Profile (Called from Signup/Edit)
  void updateProfile(String name, String phone, List<String> crops, String size, String dist) {
    _farmerName = name;
    _farmerPhone = phone;
    _myCrops = crops;
    _selectedCrop = crops.isNotEmpty ? crops[0] : "Paddy (Rice)"; // Default to first crop
    _landSize = size;
    _district = dist;
    notifyListeners();
  }
}