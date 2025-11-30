import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/app_state.dart';
import '../../utils/translations.dart';
import '../login_screen.dart';
import 'edit_profile_screen.dart';
import '../../widgets/quick_tools_widget.dart'; // Make sure this file exists!

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  bool isHealthy = true; 
  bool isRainy = true;   
  bool isOnline = true; 

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final lang = appState.languageCode;
    
    Color healthColor = isHealthy ? Colors.green : Colors.orange;
    String healthTextKey = isHealthy ? 'healthy' : 'unhealthy';
    IconData healthIcon = isHealthy ? FontAwesomeIcons.leaf : FontAwesomeIcons.plantWilt;
    IconData weatherIcon = isRainy ? FontAwesomeIcons.cloudShowersHeavy : FontAwesomeIcons.cloudSun;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
              ),
              accountName: Text(appState.farmerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Row(
                children: [
                   Text("${appState.district} • ${appState.crop}"),
                   const SizedBox(width: 8),
                   const Icon(Icons.edit, color: Colors.white70, size: 14)
                ],
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.green),
              ),
              onDetailsPressed: () {
                Navigator.pop(context); 
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
              child: Text("MY FARM", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.wheatAwn, color: Colors.orange),
              title: const Text("Crop Details"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                 Navigator.pop(context);
                 _showCropDetailsDialog(context, appState); 
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.flask, color: Colors.brown),
              title: const Text("Soil Health Card"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                Navigator.pop(context); 
                _showSoilHealthDialog(context); 
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
              child: Text("SERVICES", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.shop, color: Colors.blue),
              title: const Text("Mandi Prices"),
              onTap: () {
                Navigator.pop(context);
                _showMandiPricesSheet(context); 
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.handHoldingDollar, color: Colors.green),
              title: const Text("KALIA Scheme Status"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(4)),
                child: const Text("Active", style: TextStyle(fontSize: 10, color: Colors.green)),
              ),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.indigo),
              title: const Text("Change Language"),
              subtitle: Text(lang == 'en' ? "English" : (lang == 'hi' ? "हिंदी" : "ଓଡିଆ")),
              onTap: () {
                Navigator.pop(context);
                _showLanguageDialog(context, appState); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppTranslations.get(lang, 'welcome')}, ${appState.farmerName.split(' ')[0]}",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            GestureDetector(
              onTap: () {
                setState(() { isOnline = !isOnline; });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(isOnline ? Icons.cloud_sync : Icons.save, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(isOnline ? "Back Online. Syncing data..." : "Offline Mode. Data saved locally."),
                      ],
                    ),
                    backgroundColor: isOnline ? Colors.green : Colors.grey[800],
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  )
                );
              },
              child: Row(
                children: [
                  Icon(isOnline ? Icons.cloud_done : Icons.cloud_off, size: 14, color: isOnline ? Colors.green : Colors.grey),
                  const SizedBox(width: 4),
                  Text(isOnline ? AppTranslations.get(lang, 'online') : "Offline Mode", style: TextStyle(fontSize: 12, color: isOnline ? Colors.grey : Colors.red)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () { setState(() { isRainy = !isRainy; }); },
            child: Container(
              margin: const EdgeInsets.only(right: 16, left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(weatherIcon, size: 16, color: isRainy ? Colors.blue[800] : Colors.orange),
                  const SizedBox(width: 8),
                  Text("28°C", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                ],
              ),
            ),
          )
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              height: 250,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.linesLeaning, size: 60, color: Colors.green),
                  const SizedBox(height: 20),
                  Text("Listening...", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Try saying: 'Pest alert in my area'", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 20),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.red)))
                ],
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(FontAwesomeIcons.microphone, color: Colors.white),
        label: Text(AppTranslations.get(lang, 'ask'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ).animate().scale(delay: 1000.ms, duration: 400.ms, curve: Curves.elasticOut),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRainy) ...[
              Container(width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red[200]!)), child: Row(children: [const Icon(Icons.warning_amber_rounded, color: Colors.red), const SizedBox(width: 10), Expanded(child: Text(AppTranslations.get(lang, 'rain_alert'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))])).animate().fade().slideY(begin: -0.5, end: 0),
            ],

            Text(AppTranslations.get(lang, 'crop_health'), style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            GestureDetector(
              onTap: () { setState(() { isHealthy = !isHealthy; }); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isHealthy ? [const Color(0xFFE8F5E9), Colors.white] : [const Color(0xFFFFF3E0), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: healthColor.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: healthColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(healthIcon, size: 40, color: healthColor),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppTranslations.get(lang, healthTextKey), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: healthColor)),
                            const Text("Paddy (Rice)", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                        const Spacer(),
                        Icon(isHealthy ? Icons.check_circle : Icons.warning, color: healthColor, size: 30)
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Day 45 of 120", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text("Vegetative Stage", style: TextStyle(fontSize: 12, color: healthColor)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.4, 
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(healthColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fade(delay: 200.ms).slideX(),

            // TOOLS WIDGET
            const QuickToolsWidget()
                .animate().fade(delay: 350.ms).slideX(begin: 0.2, end: 0),

            const SizedBox(height: 24),

            Text(AppTranslations.get(lang, 'do_today'), style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold))
              .animate().fade(delay: 400.ms),
            
            const SizedBox(height: 12),
            
            _buildActionCard(
              title: AppTranslations.get(lang, 'card1_title'), 
              subtitle: AppTranslations.get(lang, 'card1_sub'), 
              icon: FontAwesomeIcons.droplet, 
              color: Colors.blue, 
              badge: "Critical",
              onTap: () => _showActionDetail(context, "Irrigation Alert", "Soil Moisture dropped below 45%.", "Sensor: Node_483 (Active)")
            ).animate().fade(delay: 400.ms).slideX(),
            
            _buildActionCard(
              title: AppTranslations.get(lang, 'card2_title'), 
              subtitle: AppTranslations.get(lang, 'card2_sub'), 
              icon: FontAwesomeIcons.bug, 
              color: Colors.orange, 
              badge: "Alert",
              onTap: () => _showActionDetail(context, "Pest Detected", "Early signs of Stem Borer detected.", "AI Confidence: 92%")
            ).animate().fade(delay: 500.ms).slideX(),
            
            _buildActionCard(
              title: AppTranslations.get(lang, 'card3_title'), 
              subtitle: AppTranslations.get(lang, 'card3_sub'), 
              icon: FontAwesomeIcons.indianRupeeSign, 
              color: Colors.green, 
              badge: "Saves ₹500", 
              isMoney: true,
              onTap: () => _showActionDetail(context, "Market Insight", "Rice prices predicted to rise by ₹20/Qt.", "Verified by Govt ✅")
            ).animate().fade(delay: 600.ms).slideX(),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---
  void _showActionDetail(BuildContext context, String title, String body, String footer) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) => Container(padding: const EdgeInsets.all(24), height: 350, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))), const SizedBox(height: 20), Text(title, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)), const SizedBox(height: 10), Text(body, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)), const SizedBox(height: 20), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.verified, color: Colors.green, size: 20), const SizedBox(width: 10), Text(footer, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))])), const Spacer(), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)), child: const Text("Got it", style: TextStyle(color: Colors.white, fontSize: 16))))])));
  }
  void _showCropDetailsDialog(BuildContext context, AppState state) {
    showDialog(context: context, builder: (ctx) => AlertDialog(title: Row(children: [Icon(FontAwesomeIcons.wheatAwn, color: Colors.orange), SizedBox(width: 10), Text(state.crop)]), content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [_buildDetailRow("Sowing Date", "15 June 2025"), _buildDetailRow("Current Stage", "Vegetative Phase"), _buildDetailRow("Expected Harvest", "Oct 2025"), _buildDetailRow("Total Land", state.landSize), Divider(), Text("Next Action: Apply Urea in 2 days", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))]), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CLOSE"))]));
  }
  Widget _buildDetailRow(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]));
  }
  void _showSoilHealthDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(title: Row(children: [Icon(FontAwesomeIcons.flask, color: Colors.brown), SizedBox(width: 10), Text("Soil Report")]), content: Column(mainAxisSize: MainAxisSize.min, children: [_buildSoilRow("Nitrogen (N)", "Low", Colors.red), _buildSoilRow("Phosphorus (P)", "Medium", Colors.orange), _buildSoilRow("Potassium (K)", "High", Colors.green), Divider(), Text("Recommendation: Add Urea + DAP", style: TextStyle(fontWeight: FontWeight.bold))]), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))]));
  }
  Widget _buildSoilRow(String name, String level, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(name), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text(level, style: TextStyle(color: color, fontWeight: FontWeight.bold)))]));
  }
  void _showMandiPricesSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (ctx) => Container(padding: const EdgeInsets.all(20), height: 300, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Mandi Prices (Khordha)", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 15), _buildMandiRow("Paddy (Rice)", "₹ 2,183 / Qt", true), _buildMandiRow("Cotton", "₹ 6,620 / Qt", false), _buildMandiRow("Moong Dal", "₹ 7,500 / Qt", true)])));
  }
  Widget _buildMandiRow(String crop, String price, bool isUp) {
    return ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(FontAwesomeIcons.sackDollar, color: Colors.green), title: Text(crop, style: const TextStyle(fontWeight: FontWeight.bold)), trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(price, style: const TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 5), Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward, size: 16, color: isUp ? Colors.green : Colors.red)]));
  }
  void _showLanguageDialog(BuildContext context, AppState appState) {
    showDialog(context: context, builder: (ctx) => SimpleDialog(title: const Text("Select Language"), children: [SimpleDialogOption(onPressed: () { appState.setLanguage('en'); Navigator.pop(ctx); }, child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("English 🇺🇸"))), SimpleDialogOption(onPressed: () { appState.setLanguage('hi'); Navigator.pop(ctx); }, child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Hindi (हिंदी) 🇮🇳"))), SimpleDialogOption(onPressed: () { appState.setLanguage('or'); Navigator.pop(ctx); }, child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Odia (ଓଡିଆ) 🇮🇳")))]));
  }
  Widget _buildActionCard({required String title, required String subtitle, required IconData icon, required Color color, required String badge, bool isMoney = false, required VoidCallback onTap}) {
     return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey[200]!)), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)), SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(badge, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)), if (isMoney) ...[SizedBox(width: 6), Icon(Icons.trending_up, size: 14, color: Colors.green)]]), SizedBox(height: 4), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600]))])), Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)])));
  }
}