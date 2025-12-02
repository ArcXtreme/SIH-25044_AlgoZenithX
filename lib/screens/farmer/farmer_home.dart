import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/app_state.dart';
import '../../utils/translations.dart';
import '../../data/crop_data.dart'; // IMPORT THE NEW DATA FILE
import '../login_screen.dart';
import 'edit_profile_screen.dart';
import '../../widgets/quick_tools_widget.dart'; 

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  bool isOnline = true; 
  bool isRainy = false; // Toggles weather state

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final lang = appState.languageCode;
    
    // 1. GET DYNAMIC DATA BASED ON SELECTION
    // We don't hardcode "Paddy" anymore. We ask the CropData class.
    final CropInfo cropInfo = CropData.get(appState.selectedCrop);

    // Weather Visuals
    Color weatherBg = isRainy ? Colors.red[50]! : Colors.blue[50]!;
    Color weatherBorder = isRainy ? Colors.red[200]! : Colors.blue[100]!;
    Color weatherText = isRainy ? Colors.red[900]! : Colors.blue[900]!;
    IconData weatherIcon = isRainy ? FontAwesomeIcons.cloudShowersHeavy : FontAwesomeIcons.cloudSun;
    String weatherLabel = isRainy ? AppTranslations.get(lang, 'heavy_rain') : "28°C • Clear";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white background
      
      // --- DRAWER (Unchanged logic, just simplified code) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
              accountName: Text(appState.farmerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Text("${appState.district} • ${appState.season}"),
              currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Colors.green)),
              onDetailsPressed: () {Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));},
            ),
            ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: Text(AppTranslations.get(lang, 'logout')), onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));}),
          ],
        ),
      ),

      // --- APP BAR ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${AppTranslations.get(lang, 'welcome')}, ${appState.farmerName.split(' ')[0]}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            GestureDetector(
              onTap: () { setState(() { isOnline = !isOnline; }); },
              child: Row(children: [Icon(isOnline ? Icons.cloud_done : Icons.cloud_off, size: 12, color: isOnline ? Colors.green : Colors.grey), const SizedBox(width: 4), Text(isOnline ? AppTranslations.get(lang, 'online') : AppTranslations.get(lang, 'offline'), style: TextStyle(fontSize: 12, color: isOnline ? Colors.grey : Colors.red))]),
            ),
          ],
        ),
        actions: [
          // Weather Widget
          GestureDetector(
            onTap: () { setState(() { isRainy = !isRainy; }); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 16, left: 8, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: weatherBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: weatherBorder)),
              child: Row(children: [Icon(weatherIcon, size: 16, color: weatherText), const SizedBox(width: 8), Text(weatherLabel, style: TextStyle(fontWeight: FontWeight.bold, color: weatherText, fontSize: 12))]),
            ),
          )
        ],
      ),

      // --- FLOATING MIC ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(FontAwesomeIcons.microphone, color: Colors.white),
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CROP HEADER (Dynamic)
            // No more list of chips. Just the selected crop context.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current Season", style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                    Text(appState.selectedCrop, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1B5E20))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange[200]!)),
                  child: Text(cropInfo.stage, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange[800])),
                )
              ],
            ),
            const SizedBox(height: 20),

            // 2. HEALTH CARD (Dynamic)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: cropInfo.isHealthy ? Colors.green[50] : Colors.red[50],
                        child: Icon(cropInfo.isHealthy ? FontAwesomeIcons.leaf : FontAwesomeIcons.plantWilt, color: cropInfo.isHealthy ? Colors.green : Colors.red),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cropInfo.isHealthy ? "Healthy Crop" : "Attention Needed", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(cropInfo.days, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                      if(cropInfo.isHealthy) const Icon(Icons.check_circle, color: Colors.green) else const Icon(Icons.warning_amber_rounded, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: cropInfo.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2E7D32)),
                    ),
                  )
                ],
              ),
            ).animate().slideY(begin: 0.1, end: 0, duration: 400.ms),

            const SizedBox(height: 25),

            // 3. QUICK TOOLS (Widget)
            const QuickToolsWidget(),

            const SizedBox(height: 25),

            // 4. DO THIS TODAY (Fully Dynamic List)
            Text(AppTranslations.get(lang, 'do_today'), style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Dynamically build the cards from the CropInfo object
            if (cropInfo.tasks.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No tasks for today! Relax. 🍵")))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cropInfo.tasks.length,
                itemBuilder: (context, index) {
                  final task = cropInfo.tasks[index];
                  return _buildDynamicActionCard(task)
                      .animate().fadeIn(delay: (200 * index).ms).slideX();
                },
              ),
              
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicActionCard(Task task) {
    return GestureDetector(
      onTap: () {
        // In a real app, this would open the specific task detail
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opened: ${task.title}")));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: task.color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(task.icon, color: task.color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: task.color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(task.badge, style: TextStyle(color: task.color, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                      if (task.isMoney) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.trending_up, size: 14, color: Colors.green)
                      ]
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(task.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(task.subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}