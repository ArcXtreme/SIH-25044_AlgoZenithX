import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import 'farmer_home.dart';

class CropInputScreen extends StatefulWidget {
  const CropInputScreen({super.key});

  @override
  State<CropInputScreen> createState() => _CropInputScreenState();
}

class _CropInputScreenState extends State<CropInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _areaController = TextEditingController();

  // --- 1. CROP TYPES ---
  final List<String> _cropTypes = [
    "Paddy (Rice)", "Groundnut", "Potato", "Urad", "Sesame", "Maize", 
    "Moong Dal", "Wheat", "Sugarcane", "Mustard", "Ragi", "Jute", 
    "Horsegram", "Rapeseed"
  ];
  String? _selectedCrop;

  // --- 2. SEASONS ---
  final List<String> _seasons = [
    "Autumn (June-Oct)", 
    "Winter (Nov-Feb)", 
    "Summer (Feb-May)"
  ];
  String? _selectedSeason;

  // --- 3. DISTRICTS (Odisha) ---
  final List<String> _districts = [
    "Angul", "Balangir", "Balasore", "Bargarh", "Bhadrak", "Boudh", 
    "Cuttack", "Deogarh", "Dhenkanal", "Gajapati", "Ganjam", "Jagatsinghpur", 
    "Jajpur", "Jharsuguda", "Kalahandi", "Kandhamal", "Kendrapara", "Kendujhar", 
    "Khordha", "Koraput", "Malkangiri", "Mayurbhanj", "Nabarangpur", "Nayagarh", 
    "Nuapada", "Puri", "Rayagada", "Sambalpur", "Subarnapur", "Sundargarh"
  ];
  String? _selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Farm Details", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // No back button, they MUST fill this
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's set up your farm profile 🚜",
                style: GoogleFonts.openSans(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),

              // --- 1. CROP SELECTION ---
              _buildSectionLabel("1. Select Crop"),
              DropdownButtonFormField<String>(
                value: _selectedCrop,
                decoration: _inputDecoration("Choose Crop"),
                items: _cropTypes.map((crop) => DropdownMenuItem(value: crop, child: Text(crop))).toList(),
                onChanged: (val) => setState(() => _selectedCrop = val),
                validator: (val) => val == null ? "Please select a crop" : null,
              ),
              const SizedBox(height: 20),

              // --- 2. SEASON SELECTION ---
              _buildSectionLabel("2. Select Season"),
              DropdownButtonFormField<String>(
                value: _selectedSeason,
                decoration: _inputDecoration("Choose Season"),
                items: _seasons.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _selectedSeason = val),
                validator: (val) => val == null ? "Please select a season" : null,
              ),
              const SizedBox(height: 20),

              // --- 3. DISTRICT SELECTION ---
              _buildSectionLabel("3. Select District"),
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                decoration: _inputDecoration("Choose District"),
                items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (val) => setState(() => _selectedDistrict = val),
                validator: (val) => val == null ? "Please select a district" : null,
              ),
              const SizedBox(height: 20),

              // --- 4. LAND AREA ---
              _buildSectionLabel("4. Land Area (Acres)"),
              TextFormField(
                controller: _areaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration("e.g. 2.5"),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Please enter land area";
                  if (double.tryParse(val) == null) return "Invalid number";
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // --- SUBMIT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  onPressed: _submitForm,
                  child: const Text("Go to Dashboard 🚀", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save data to AppState
      Provider.of<AppState>(context, listen: false).setFarmDetails(
        crop: _selectedCrop!,
        season: _selectedSeason!,
        district: _selectedDistrict!,
        area: _areaController.text,
      );

      // Navigate to Home
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const FarmerHomeScreen())
      );
    }
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }
}