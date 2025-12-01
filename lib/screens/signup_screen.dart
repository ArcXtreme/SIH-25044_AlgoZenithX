import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'farmer/farmer_home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedDistrict = "Khordha";
  
  // MULTI-SELECT LOGIC
  final List<String> _availableCrops = ["Paddy (Rice)", "Cotton", "Wheat", "Sugarcane", "Moong Dal"];
  final List<String> _selectedCrops = []; // Stores what user picks

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create Account", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20))),
            const Text("Join thousands of farmers in Odisha", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            const Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _nameController, decoration: InputDecoration(hintText: "e.g. Rajesh Kumar", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 16),

            const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: "e.g. 9876543210", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 16),

            const Text("District", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              items: const [DropdownMenuItem(value: "Khordha", child: Text("Khordha")), DropdownMenuItem(value: "Puri", child: Text("Puri")), DropdownMenuItem(value: "Cuttack", child: Text("Cuttack")), DropdownMenuItem(value: "Ganjam", child: Text("Ganjam"))],
              onChanged: (v) => setState(() => _selectedDistrict = v!),
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 16),

            // --- MULTI-SELECT CROPS ---
            const Text("What do you cultivate? (Select all)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _availableCrops.map((crop) {
                final isSelected = _selectedCrops.contains(crop);
                return FilterChip(
                  label: Text(crop),
                  selected: isSelected,
                  selectedColor: Colors.green[100],
                  checkmarkColor: Colors.green,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedCrops.add(crop);
                      } else {
                        _selectedCrops.remove(crop);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (_selectedCrops.isEmpty) 
              const Padding(padding: EdgeInsets.only(top: 8), child: Text("* Please select at least one crop", style: TextStyle(color: Colors.red, fontSize: 12))),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  if (_selectedCrops.isNotEmpty) {
                    // Save List to App State
                    Provider.of<AppState>(context, listen: false).updateProfile(
                      _nameController.text.isNotEmpty ? _nameController.text : "New Farmer",
                      _phoneController.text,
                      _selectedCrops, // Passing the LIST
                      "2.0 Acres",
                      _selectedDistrict
                    );
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FarmerHomeScreen()));
                  }
                },
                child: const Text("Register", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}