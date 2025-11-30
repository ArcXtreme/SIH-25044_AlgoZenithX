import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart'; 
import '../login_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE), 
      
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80, 
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)], 
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AgriCommand HQ", 
              style: GoogleFonts.exo2(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 1)
            ),
            Row(
              children: [
                const Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                const SizedBox(width: 6),
                Text("Systems Online • Odisha Region", 
                  style: GoogleFonts.openSans(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.white), 
            tooltip: "Sync Data",
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fetching real-time data from district nodes... 📡"),
                    backgroundColor: Color(0xFF0D1B2A),
                    behavior: SnackBarBehavior.floating,
                  )
                );
            }
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.redAccent), 
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()))
          ),
          const SizedBox(width: 10),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LIVE ALERTS
            Text("Live Critical Alerts", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAlertCard("Locust Swarm", "Ganjam Sector 4", Colors.red),
                  _buildAlertCard("Heavy Rain", "Puri Coastal", Colors.orange),
                  _buildAlertCard("Low Nitrogen", "Khordha Block B", Colors.amber),
                ],
              ),
            ).animate().slideX(duration: 600.ms),

            const SizedBox(height: 25),

            // 2. STATS
            Row(
              children: [
                _buildStatCard("Model Accuracy", "87%", FontAwesomeIcons.chartLine, Colors.purple),
                const SizedBox(width: 15),
                _buildStatCard("Active Sensors", "1,240", FontAwesomeIcons.towerBroadcast, Colors.green),
                const SizedBox(width: 15),
                _buildStatCard("Pending Loans", "45", FontAwesomeIcons.fileInvoiceDollar, Colors.blue),
              ],
            ).animate().slideY(begin: 0.2, end: 0, delay: 200.ms),

            const SizedBox(height: 25),

            // 3. THE MAP (FIXED LAYOUT)
            Text("Geospatial Intel", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
            const SizedBox(height: 10),
            
            Container(
              height: 350, // Defined Height
              width: double.infinity, // Full Width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))],
                border: Border.all(color: Colors.white, width: 4),
              ),
              // ClipRRect ensures the map doesn't spill out of the rounded corners
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Positioned.fill FORCES the map to fill the container
                    Positioned.fill(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: const LatLng(20.2961, 85.8245), 
                          initialZoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.sih.agrisense', 
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(point: const LatLng(20.2961, 85.8245), color: Colors.green.withOpacity(0.3), borderStrokeWidth: 2, borderColor: Colors.green, useRadiusInMeter: true, radius: 1500),
                              CircleMarker(point: const LatLng(20.3100, 85.8400), color: Colors.red.withOpacity(0.3), borderStrokeWidth: 2, borderColor: Colors.red, useRadiusInMeter: true, radius: 1200),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Legend (Floating on top)
                    Positioned(
                      bottom: 15, left: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLegendItem(Colors.green, "Projected High Yield"),
                            const SizedBox(height: 4),
                            _buildLegendItem(Colors.red, "Pest Risk Detected"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ).animate().fade(delay: 300.ms),

            const SizedBox(height: 25),

            // 4. LIST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subsidy Approvals", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
                TextButton(onPressed: (){}, child: const Text("View All"))
              ],
            ),
            
            _buildFarmerRow(context, "Suresh Das", "Khordha", "High Yield", true)
              .animate().slideX(delay: 400.ms),
            _buildFarmerRow(context, "Amit Nayak", "Puri", "Pest Risk", false)
              .animate().slideX(delay: 500.ms),
            _buildFarmerRow(context, "Ravi Kumar", "Cuttack", "High Yield", true)
              .animate().slideX(delay: 600.ms),
              
            const SizedBox(height: 80), 
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){}, 
        label: const Text("Broadcast Advisory", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.campaign, color: Colors.white),
        backgroundColor: const Color(0xFFD32F2F), 
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildAlertCard(String title, String location, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color), 
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))], 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.warning, size: 16, color: color), 
            const SizedBox(width: 5),
            Text("ALERT", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10))
          ]),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(location, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.blueGrey[400], fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmerRow(BuildContext context, String name, String district, String status, bool approve) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
        border: Border.all(color: Colors.blueGrey[50]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(name[0], style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(district, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 5),
                    const Text("•", style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 5),
                    Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: status == "Pest Risk" ? Colors.red : Colors.green)),
                  ],
                )
              ],
            ),
          ),
          if (approve)
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Subsidy Approved! ✅"), backgroundColor: Color(0xFF0D1B2A))
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D1B2A), 
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Approve", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            )
          else
            OutlinedButton(
               onPressed: () {},
               style: OutlinedButton.styleFrom(
                 side: const BorderSide(color: Colors.orange),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
               ),
               child: const Text("Verify", style: TextStyle(fontSize: 13, color: Colors.orange)),
            )
        ],
      ),
    );
  }
}