import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Task {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String badge; // "Critical", "Alert", "Profit"
  final bool isMoney; // Adds a trending up icon if true

  Task({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.badge,
    this.isMoney = false,
  });
}

class CropInfo {
  final String name;
  final String stage;
  final double progress; // 0.0 to 1.0
  final String days;
  final bool isHealthy;
  final List<Task> tasks;

  CropInfo({
    required this.name,
    required this.stage,
    required this.progress,
    required this.days,
    required this.isHealthy,
    required this.tasks,
  });
}

class CropData {
  // DEFAULT FALLBACK (If a crop isn't fully defined yet)
  static final CropInfo _default = CropInfo(
    name: "Crop",
    stage: "Growth Stage",
    progress: 0.5,
    days: "Day 30 of 90",
    isHealthy: true,
    tasks: [
      Task(title: "Check Soil Moisture", subtitle: "Ensure adequate water", icon: FontAwesomeIcons.droplet, color: Colors.blue, badge: "Daily"),
      Task(title: "Scout for Pests", subtitle: "Look for leaf damage", icon: FontAwesomeIcons.magnifyingGlass, color: Colors.orange, badge: "Alert"),
    ],
  );

  static final Map<String, CropInfo> _data = {
    // --- 1. PADDY ---
    "Paddy (Rice)": CropInfo(
      name: "Paddy (Rice)",
      stage: "Vegetative Stage",
      progress: 0.4,
      days: "Day 45 of 120",
      isHealthy: true,
      tasks: [
        Task(title: "Irrigate 200L", subtitle: "Soil moisture low (45%)", icon: FontAwesomeIcons.droplet, color: Colors.blue, badge: "Critical"),
        Task(title: "Apply Neem Oil", subtitle: "Stem Borer detected", icon: FontAwesomeIcons.bug, color: Colors.orange, badge: "Alert"),
        Task(title: "Wait to Harvest", subtitle: "Prices rising ₹20/Qt", icon: FontAwesomeIcons.indianRupeeSign, color: Colors.green, badge: "Profit +10%", isMoney: true),
      ],
    ),

    // --- 2. GROUNDNUT ---
    "Groundnut": CropInfo(
      name: "Groundnut",
      stage: "Pegging Stage",
      progress: 0.6,
      days: "Day 60 of 110",
      isHealthy: false, // Simulating an issue
      tasks: [
        Task(title: "Apply Gypsum", subtitle: "Boosts pod formation", icon: FontAwesomeIcons.cubesStacked, color: Colors.purple, badge: "Recommended"),
        Task(title: "Check Tikka Disease", subtitle: "Leaf spots observed", icon: FontAwesomeIcons.triangleExclamation, color: Colors.red, badge: "Critical"),
        Task(title: "Weeding", subtitle: "Clear inter-row space", icon: FontAwesomeIcons.scissors, color: Colors.brown, badge: "Routine"),
      ],
    ),

    // --- 3. SUGARCANE ---
    "Sugarcane": CropInfo(
      name: "Sugarcane",
      stage: "Grand Growth",
      progress: 0.7,
      days: "Month 6 of 12",
      isHealthy: true,
      tasks: [
        Task(title: "Detrashing", subtitle: "Remove dry leaves", icon: FontAwesomeIcons.leaf, color: Colors.green, badge: "Yield +5%"),
        Task(title: "Propping", subtitle: "Prevent lodging from wind", icon: FontAwesomeIcons.textHeight, color: Colors.blueGrey, badge: "Advisory"),
        Task(title: "Irrigation", subtitle: "Maintain 50% moisture", icon: FontAwesomeIcons.water, color: Colors.blue, badge: "Daily"),
      ],
    ),

    // --- 4. COTTON ---
    "Cotton": CropInfo(
      name: "Cotton",
      stage: "Boll Development",
      progress: 0.8,
      days: "Day 90 of 150",
      isHealthy: false,
      tasks: [
        Task(title: "Check Pink Bollworm", subtitle: "Pheromone trap alert", icon: FontAwesomeIcons.locust, color: Colors.red, badge: "High Risk"),
        Task(title: "Spray Potassium", subtitle: "Improves fiber strength", icon: FontAwesomeIcons.sprayCan, color: Colors.orange, badge: "Nutrition"),
      ],
    ),

    // --- 5. POTATO ---
    "Potato": CropInfo(
      name: "Potato",
      stage: "Tuber Bulking",
      progress: 0.75,
      days: "Day 70 of 90",
      isHealthy: true,
      tasks: [
        Task(title: "Stop Irrigation", subtitle: "10 days before harvest", icon: FontAwesomeIcons.ban, color: Colors.red, badge: "Important"),
        Task(title: "Check Late Blight", subtitle: "Humid weather alert", icon: FontAwesomeIcons.cloudRain, color: Colors.blue, badge: "Weather"),
      ],
    ),
    
    // --- 6. MAIZE ---
    "Maize": CropInfo(
      name: "Maize",
      stage: "Silking Stage",
      progress: 0.55,
      days: "Day 50 of 90",
      isHealthy: true,
      tasks: [
        Task(title: "Fall Armyworm Check", subtitle: "Inspect whorls", icon: FontAwesomeIcons.bug, color: Colors.orange, badge: "Alert"),
        Task(title: "Top Dress Urea", subtitle: "Apply 25kg/acre", icon: FontAwesomeIcons.sackDollar, color: Colors.green, badge: "Nutrition"),
      ],
    ),
  };

  // Helper to get data safely
  static CropInfo get(String cropName) {
    return _data[cropName] ?? _default;
  }
}