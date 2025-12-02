import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/app_state.dart';
import '../../utils/translations.dart';
import '../login_screen.dart';
import 'edit_profile_screen.dart';
import '../../widgets/quick_tools_widget.dart'; 

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
    final currentCrop = appState.selectedCrop;
    
    // LOGIC
    bool isPaddy = currentCrop.contains("Paddy");
    
    // Translated Dynamic Data
    String stage = isPaddy ? AppTranslations.get(lang, 'veg_stage') : AppTranslations.get(lang, 'flow_stage');
    String days = "${AppTranslations.get(lang, 'day')} 45 ${AppTranslations.get(lang, 'of')} 120";
    String cropName = AppTranslations.get(lang, currentCrop);

    // Card variables
    String c1Title = isPaddy ? AppTranslations.get(lang, 'irrigate_title') : AppTranslations.get(lang, 'bollworm_title');
    String c1Sub = isPaddy ? AppTranslations.get(lang, 'moisture_low') : AppTranslations.get(lang, 'trap_alert');
    IconData c1Icon = isPaddy ? FontAwesomeIcons.droplet : FontAwesomeIcons.magnifyingGlass;
    String c1PopupTitle = isPaddy ? AppTranslations.get(lang, 'irrigation_alert') : AppTranslations.get(lang, 'pest_scouting');
    String c1PopupBody = isPaddy ? AppTranslations.get(lang, 'irrigation_body') : AppTranslations.get(lang, 'pest_body');
    String c1PopupFooter = isPaddy ? AppTranslations.get(lang, 'source_soil') : AppTranslations.get(lang, 'ai_conf');

    String c2Title = isPaddy ? AppTranslations.get(lang, 'neem_title') : AppTranslations.get(lang, 'spray_title');
    String c2Sub = isPaddy ? AppTranslations.get(lang, 'stem_borer') : AppTranslations.get(lang, 'pink_boll');
    String c2PopupTitle = isPaddy ? AppTranslations.get(lang, 'pest_control') : AppTranslations.get(lang, 'critical_intervention');
    String c2PopupBody = isPaddy ? AppTranslations.get(lang, 'neem_body') : AppTranslations.get(lang, 'chem_body');
    String c2PopupFooter = isPaddy ? AppTranslations.get(lang, 'organic') : AppTranslations.get(lang, 'safety');

    String c3Title = AppTranslations.get(lang, 'harvest_title');
    String c3Sub = isPaddy ? AppTranslations.get(lang, 'rice_rise') : AppTranslations.get(lang, 'cotton_stable');
    String c3PopupTitle = AppTranslations.get(lang, 'market_insight');
    String c3PopupBody = isPaddy ? AppTranslations.get(lang, 'rice_body') : AppTranslations.get(lang, 'cotton_body');
    String c3Badge = isPaddy ? AppTranslations.get(lang, 'save_money') : AppTranslations.get(lang, 'profit');
    String c3PopupFooter = AppTranslations.get(lang, 'govt_verify');

    Color healthColor = isHealthy ? Colors.green : Colors.orange;
    String healthTextKey = isHealthy ? 'healthy' : 'unhealthy';
    IconData healthIcon = isHealthy ? FontAwesomeIcons.leaf : FontAwesomeIcons.plantWilt;
    
    // Weather Logic
    Color weatherBgColor = isRainy ? Colors.red[50]! : Colors.blue[50]!;
    Color weatherBorderColor = isRainy ? Colors.red[200]! : Colors.blue[100]!;
    Color weatherTextColor = isRainy ? Colors.red[900]! : Colors.blue[900]!;
    IconData weatherIcon = isRainy ? FontAwesomeIcons.cloudShowersHeavy : FontAwesomeIcons.cloudSun;
    String weatherText = isRainy ? AppTranslations.get(lang, 'heavy_rain') : "28°C";

    // --- UI START ---
    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(image: NetworkImage("[https://www.transparenttextures.com/patterns/ag-square.png](https://www.transparenttextures.com/patterns/ag-square.png)"), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Color(0xFF2E7D32), BlendMode.darken)),
                color: Color(0xFF2E7D32),
              ),
              accountName: Text(appState.farmerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: Row(
                children: [
                   Text("${appState.district} • ${AppTranslations.get(lang, currentCrop)}"), 
                   const SizedBox(width: 8),
                   const Icon(Icons.edit, color: Colors.white70, size: 14)
                ],
              ),
              currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Colors.green)),
              onDetailsPressed: () {Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));},
            ),
            
            // SIDEBAR ITEMS (Fully Translated)
            Padding(padding: const EdgeInsets.only(left: 16, top: 10, bottom: 5), child: Text(AppTranslations.get(lang, 'my_farm'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))),
            ListTile(leading: const Icon(FontAwesomeIcons.wheatAwn, color: Colors.orange), title: Text(AppTranslations.get(lang, 'crop_details')), trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey), onTap: () {Navigator.pop(context); _showCropDetailsDialog(context, appState);}),
            ListTile(leading: const Icon(FontAwesomeIcons.flask, color: Colors.brown), title: Text(AppTranslations.get(lang, 'soil_card')), trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey), onTap: () {Navigator.pop(context); _showSoilHealthDialog(context);}),
            const Divider(),
            Padding(padding: const EdgeInsets.only(left: 16, top: 10, bottom: 5), child: Text(AppTranslations.get(lang, 'services'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))),
            ListTile(leading: const Icon(FontAwesomeIcons.shop, color: Colors.blue), title: Text(AppTranslations.get(lang, 'mandi')), onTap: () {Navigator.pop(context); _showMandiPricesSheet(context);}),
            ListTile(leading: const Icon(FontAwesomeIcons.handHoldingDollar, color: Colors.green), title: Text(AppTranslations.get(lang, 'kalia')), trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(4)), child: Text(AppTranslations.get(lang, 'active'), style: const TextStyle(fontSize: 10, color: Colors.green))), onTap: () {}),
            const Divider(),
            ListTile(leading: const Icon(Icons.language, color: Colors.indigo), title: Text(AppTranslations.get(lang, 'change_lang')), subtitle: Text(lang == 'en' ? "English" : (lang == 'hi' ? "हिंदी" : "ଓଡିଆ")), onTap: () {Navigator.pop(context); _showLanguageDialog(context, appState);}),
            ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: Text(AppTranslations.get(lang, 'logout')), onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));}),
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
            Text("${AppTranslations.get(lang, 'welcome')}, ${appState.farmerName.split(' ')[0]}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            GestureDetector(
              onTap: () { setState(() { isOnline = !isOnline; }); },
              child: Row(children: [Icon(isOnline ? Icons.cloud_done : Icons.cloud_off, size: 14, color: isOnline ? Colors.green : Colors.grey), const SizedBox(width: 4), Text(isOnline ? AppTranslations.get(lang, 'online') : AppTranslations.get(lang, 'offline'), style: TextStyle(fontSize: 12, color: isOnline ? Colors.grey : Colors.red))]),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () { setState(() { isRainy = !isRainy; }); },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 16, left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: weatherBgColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: weatherBorderColor), boxShadow: isRainy ? [BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 8)] : []),
              child: Row(children: [Icon(isRainy ? Icons.warning_amber_rounded : weatherIcon, size: 16, color: isRainy ? Colors.red : Colors.orange), const SizedBox(width: 8), Text(weatherText, style: TextStyle(fontWeight: FontWeight.bold, color: weatherTextColor))]),
            ).animate(target: isRainy ? 1 : 0).scaleXY(end: 1.05, duration: 800.ms, curve: Curves.easeInOut).then().scaleXY(end: 1.0),
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
                  Text(AppTranslations.get(lang, 'listening'), style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(AppTranslations.get(lang, 'try_saying'), style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 20),
                  TextButton(onPressed: () => Navigator.pop(context), child: Text(AppTranslations.get(lang, 'cancel'), style: const TextStyle(color: Colors.red)))
                ],
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(FontAwesomeIcons.microphone, color: Colors.white),
        label: Text(AppTranslations.get(lang, 'ask'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppTranslations.get(lang, 'your_crops'), style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            
            // CROP CHIPS (Translated)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: appState.myCrops.map((crop) {
                  bool isSelected = crop == currentCrop;
                  return GestureDetector(
                    onTap: () { appState.selectCrop(crop); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: isSelected ? const Color(0xFF2E7D32) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!), boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2))] : []),
                      child: Text(AppTranslations.get(lang, crop), style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            Text("$cropName ${AppTranslations.get(lang, 'health_suffix')}", style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // LEAF CARD
            GestureDetector(
              onTap: () { setState(() { isHealthy = !isHealthy; }); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: healthColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Column(
                  children: [
                    Row(children: [Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Icon(healthIcon, size: 40, color: healthColor)), const SizedBox(width: 20), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AppTranslations.get(lang, healthTextKey), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: healthColor)), Text(cropName, style: const TextStyle(fontSize: 14, color: Colors.grey))]), const Spacer(), Icon(isHealthy ? Icons.check_circle : Icons.warning, color: healthColor, size: 30)]),
                    const SizedBox(height: 15),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(days, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text(stage, style: TextStyle(fontSize: 12, color: healthColor))]), const SizedBox(height: 6), ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: isPaddy ? 0.4 : 0.6, minHeight: 8, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(healthColor)))]),
                  ],
                ),
              ),
            ),

            const QuickToolsWidget().animate().fade(delay: 350.ms).slideX(begin: 0.2, end: 0),

            const SizedBox(height: 24),

            Text(AppTranslations.get(lang, 'do_today'), style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold)).animate().fade(delay: 400.ms),
            const SizedBox(height: 12),
            
            _buildActionCard(title: c1Title, subtitle: c1Sub, icon: c1Icon, color: Colors.blue, badge: AppTranslations.get(lang, 'critical'), onTap: () => _showActionDetail(context, c1PopupTitle, c1PopupBody, c1PopupFooter)).animate().fade(delay: 400.ms).slideX(),
            _buildActionCard(title: c2Title, subtitle: c2Sub, icon: FontAwesomeIcons.bug, color: Colors.orange, badge: AppTranslations.get(lang, 'alert'), onTap: () => _showActionDetail(context, c2PopupTitle, c2PopupBody, c2PopupFooter)).animate().fade(delay: 500.ms).slideX(),
            _buildActionCard(title: c3Title, subtitle: c3Sub, icon: FontAwesomeIcons.indianRupeeSign, color: Colors.green, badge: c3Badge, isMoney: true, onTap: () => _showActionDetail(context, c3PopupTitle, c3PopupBody, c3PopupFooter)).animate().fade(delay: 600.ms).slideX(),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // --- HELPERS (Fully Translated) ---

  void _showActionDetail(BuildContext context, String title, String body, String footer) {
    final lang = Provider.of<AppState>(context, listen: false).languageCode;
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) => Container(padding: const EdgeInsets.all(24), height: 350, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)), const SizedBox(height: 10), Text(body, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)), const SizedBox(height: 20), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.verified, color: Colors.green, size: 20), const SizedBox(width: 10), Text(footer, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))])), const Spacer(), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)), child: Text(AppTranslations.get(lang, 'got_it'), style: const TextStyle(color: Colors.white, fontSize: 16))))])));
  }

  void _showCropDetailsDialog(BuildContext context, AppState state) {
    final lang = Provider.of<AppState>(context, listen: false).languageCode;
    bool isPaddy = state.selectedCrop.contains("Paddy");
    String cropName = AppTranslations.get(lang, state.selectedCrop);
    String sowingDate = isPaddy ? "15 June 2025" : "10 July 2025";
    String harvestDate = isPaddy ? "Oct 2025" : "Dec 2025";
    String nextAction = isPaddy ? AppTranslations.get(lang, 'apply_urea') : AppTranslations.get(lang, 'check_boll');
    String currentStage = isPaddy ? AppTranslations.get(lang, 'veg_stage') : AppTranslations.get(lang, 'flow_stage');

    showDialog(context: context, builder: (ctx) => AlertDialog(title: Row(children: [const Icon(FontAwesomeIcons.wheatAwn, color: Colors.orange), const SizedBox(width: 10), Text(cropName)]), content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [_buildDetailRow(AppTranslations.get(lang, 'sowing_date'), sowingDate), _buildDetailRow(AppTranslations.get(lang, 'current_stage'), currentStage), _buildDetailRow(AppTranslations.get(lang, 'expected_harvest'), harvestDate), _buildDetailRow(AppTranslations.get(lang, 'land_allocation'), isPaddy ? "1.5 Acres" : "1.0 Acre"), const Divider(), Text("${AppTranslations.get(lang, 'next_action')}: $nextAction", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))]), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppTranslations.get(lang, 'close')))]));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]));
  }

  void _showSoilHealthDialog(BuildContext context) {
    final lang = Provider.of<AppState>(context, listen: false).languageCode;
    final state = Provider.of<AppState>(context, listen: false);
    bool isPaddy = state.selectedCrop.contains("Paddy");
    showDialog(context: context, builder: (ctx) => AlertDialog(title: Row(children: [const Icon(FontAwesomeIcons.flask, color: Colors.brown), const SizedBox(width: 10), Text(AppTranslations.get(lang, 'soil_report'))]), content: Column(mainAxisSize: MainAxisSize.min, children: [_buildSoilRow(AppTranslations.get(lang, 'nitrogen'), isPaddy ? AppTranslations.get(lang, 'low') : AppTranslations.get(lang, 'optimal'), isPaddy ? Colors.red : Colors.green), _buildSoilRow(AppTranslations.get(lang, 'phosphorus'), AppTranslations.get(lang, 'medium'), Colors.orange), _buildSoilRow(AppTranslations.get(lang, 'potassium'), AppTranslations.get(lang, 'high'), Colors.green), const Divider(), Text(isPaddy ? AppTranslations.get(lang, 'rec_urea') : AppTranslations.get(lang, 'rec_good'), style: const TextStyle(fontWeight: FontWeight.bold))]), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppTranslations.get(lang, 'ok')))]));
  }

  Widget _buildSoilRow(String name, String level, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(name), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: Text(level, style: TextStyle(color: color, fontWeight: FontWeight.bold)))]));
  }

  void _showMandiPricesSheet(BuildContext context) {
    final lang = Provider.of<AppState>(context, listen: false).languageCode;
    showModalBottomSheet(context: context, builder: (ctx) => Container(padding: const EdgeInsets.all(20), height: 300, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AppTranslations.get(lang, 'mandi'), style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 15), _buildMandiRow(AppTranslations.get(lang, 'Paddy (Rice)'), "₹ 2,183 / Qt", true), _buildMandiRow(AppTranslations.get(lang, 'Cotton'), "₹ 6,620 / Qt", false), _buildMandiRow(AppTranslations.get(lang, 'Moong Dal'), "₹ 7,500 / Qt", true)])));
  }

  Widget _buildMandiRow(String crop, String price, bool isUp) {
    return ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(FontAwesomeIcons.sackDollar, color: Colors.green), title: Text(crop, style: const TextStyle(fontWeight: FontWeight.bold)), trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(price, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(width: 5), Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward, size: 16, color: isUp ? Colors.green : Colors.red)]));
  }

  void _showLanguageDialog(BuildContext context, AppState appState) {
    showDialog(context: context, builder: (ctx) => SimpleDialog(title: const Text("Select Language"), children: [SimpleDialogOption(onPressed: () { appState.setLanguage('en'); Navigator.pop(ctx); }, child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("English 🇺🇸"))), SimpleDialogOption(onPressed: () { appState.setLanguage('hi'); Navigator.pop(ctx); }, child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Hindi (हिंदी) 🇮🇳"))), SimpleDialogOption(onPressed: () { appState.setLanguage('or'); Navigator.pop(ctx); }, child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Odia (ଓଡିଆ) 🇮🇳")))]));
  }

  Widget _buildActionCard({required String title, required String subtitle, required IconData icon, required Color color, required String badge, bool isMoney = false, required VoidCallback onTap}) {
     return GestureDetector(onTap: onTap, child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))], border: Border.all(color: Colors.grey[200]!)), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)), SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(badge, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)), if (isMoney) ...[SizedBox(width: 6), Icon(Icons.trending_up, size: 14, color: Colors.green)]]), SizedBox(height: 4), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600]))])), Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)])));
  }
}