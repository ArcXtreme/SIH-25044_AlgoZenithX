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
  // Controllers to capture user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedDistrict = "Khordha";
  String _selectedCrop = "Paddy (Rice)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Back Button to go back to Login
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
            // Title
            Text("Create Account", 
              style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20))
            ),
            const Text("Join thousands of farmers in Odisha", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            // 1. Name Input
            const Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "e.g. Rajesh Kumar", 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              )
            ),
            const SizedBox(height: 16),

            // 2. Phone Input
            const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "e.g. 9876543210", 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              )
            ),
            const SizedBox(height: 16),

            // 3. District Dropdown
            const Text("District", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              items: const [
                DropdownMenuItem(value: "Khordha", child: Text("Khordha")),
                DropdownMenuItem(value: "Puri", child: Text("Puri")),
                DropdownMenuItem(value: "Cuttack", child: Text("Cuttack")),
                DropdownMenuItem(value: "Ganjam", child: Text("Ganjam")),
              ],
              onChanged: (v) => setState(() => _selectedDistrict = v!),
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 16),

            // 4. Crop Dropdown
            const Text("Primary Crop", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              items: const [
                DropdownMenuItem(value: "Paddy (Rice)", child: Text("Paddy (Rice)")), 
                DropdownMenuItem(value: "Cotton", child: Text("Cotton")),
                DropdownMenuItem(value: "Wheat", child: Text("Wheat")),
                DropdownMenuItem(value: "Sugarcane", child: Text("Sugarcane")),
              ],
              onChanged: (v) => setState(() => _selectedCrop = v!),
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 30),

            // 5. Register Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () {
                  // SIMULATE REGISTRATION
                  // 1. Update the Global State with these new details
                  Provider.of<AppState>(context, listen: false).updateProfile(
                    _nameController.text.isNotEmpty ? _nameController.text : "New Farmer",
                    _phoneController.text,
                    _selectedCrop,
                    "2.0 Acres", // Default land size for new users
                    _selectedDistrict
                  );

                  // 2. Go to Dashboard
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (_) => const FarmerHomeScreen())
                  );
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