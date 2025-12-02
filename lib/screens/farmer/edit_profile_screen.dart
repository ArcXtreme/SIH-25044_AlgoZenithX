import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _landController;
  
  String _selectedCrop = "Paddy (Rice)";
  String _selectedDistrict = "Khordha";

  @override
  void initState() {
    super.initState();
    final state = Provider.of<AppState>(context, listen: false);
    _nameController = TextEditingController(text: state.farmerName);
    _phoneController = TextEditingController(text: state.farmerPhone);
    _landController = TextEditingController(text: state.landSize);
    
    // Safety check: If the current crop isn't in our new short list, default to Paddy
    _selectedCrop = (state.selectedCrop == "Wheat" || state.selectedCrop == "Sugarcane") 
        ? "Paddy (Rice)" 
        : state.selectedCrop;
        
    _selectedDistrict = state.district;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<AppState>(context, listen: false).updateProfile(
                _nameController.text,
                _phoneController.text,
                [_selectedCrop], // Send as List
                _landController.text,
                _selectedDistrict
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile Updated Successfully! ✅"), backgroundColor: Colors.green)
              );
            },
            child: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(radius: 50, backgroundColor: Colors.green, child: Icon(Icons.person, size: 60, color: Colors.white)),
                  Positioned(
                    bottom: 0, right: 0,
                    child: CircleAvatar(radius: 15, backgroundColor: Colors.white, child: Icon(Icons.camera_alt, size: 18, color: Colors.grey[800])),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildLabel("Full Name"),
            TextField(controller: _nameController, decoration: _inputDecor("Enter Name")),
            const SizedBox(height: 20),

            _buildLabel("Phone Number"),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: _inputDecor("Enter Phone")),
            const SizedBox(height: 20),

            _buildLabel("District"),
            DropdownButtonFormField<String>(
              initialValue: _selectedDistrict,
              items: ["Khordha", "Puri", "Cuttack", "Ganjam"].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _selectedDistrict = v!),
              decoration: _inputDecor("Select District"),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Primary Crop"),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCrop,
                        // --- ONLY PADDY AND COTTON NOW ---
                        items: ["Paddy (Rice)", "Cotton"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _selectedCrop = v!),
                        decoration: _inputDecor("Select Crop"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Land Size"),
                      TextField(controller: _landController, decoration: _inputDecor("e.g. 2.5 Acres")),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Align(alignment: Alignment.centerLeft, child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))));

  InputDecoration _inputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.green)),
    );
  }
}