import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuickToolsWidget extends StatelessWidget {
  const QuickToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Tools", 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 12),
        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildToolCard(context, FontAwesomeIcons.camera, "Scan Crop", Colors.purple, () => _openCameraSimulation(context)),
              _buildToolCard(context, FontAwesomeIcons.phone, "Helpline", Colors.green, () => _callHelpline(context)),
              _buildToolCard(context, FontAwesomeIcons.fileContract, "My Schemes", Colors.blue, () => _showSchemesList(context)),
              _buildToolCard(context, FontAwesomeIcons.newspaper, "Agri News", Colors.orange, () => _showNewsToast(context)),
              _buildToolCard(context, FontAwesomeIcons.cloudRain, "Weather Map", Colors.indigo, () {}),
            ],
          ),
        ),
      ],
    );
  }

  void _openCameraSimulation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("AI Crop Doctor", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.center_focus_weak, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text("Simulating Camera...", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Image Captured! Analyzing for pests..."), backgroundColor: Colors.green)
                );
              }, 
              child: const Text("Capture Photo")
            )
          ],
        ),
      )
    );
  }

  void _callHelpline(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(children: [Icon(Icons.phone_in_talk, color: Colors.white), SizedBox(width: 10), Text("Dialing Kisan Call Center...")]),
        backgroundColor: Colors.green,
      )
    );
  }

  void _showSchemesList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Available Schemes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("KALIA Scheme"),
              subtitle: Text("Status: Active"),
            ),
            const ListTile(
              leading: Icon(Icons.info_outline, color: Colors.orange),
              title: Text("PM-KISAN"),
              subtitle: Text("Action: KYC Pending"),
            ),
          ],
        ),
      )
    );
  }

  void _showNewsToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fetching latest market news...")));
  }

  // --- THE FIXED CARD (No Opacity Tricks) ---
  Widget _buildToolCard(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          // REMOVED THE SHADOW OPACITY TO FIX ERROR
          boxShadow: const [
            BoxShadow(
              color: Colors.black12, // Safe constant color
              blurRadius: 5, 
              offset: Offset(0, 2)
            )
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[100], // Safe constant color
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}