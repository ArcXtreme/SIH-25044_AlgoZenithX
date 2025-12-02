import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Task {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String badge;
  final bool isMoney;
  final String popupTitle;
  final String popupBody;
  final String source;
  final bool isVerified;

  Task({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.badge,
    this.isMoney = false,
    required this.popupTitle,
    required this.popupBody,
    this.source = "AgriSense AI",
    this.isVerified = true,
  });
}

class CropInfo {
  final String name;
  final String stage;
  final double progress;
  final String days;
  final bool isHealthy;
  final String healthIssue;
  final List<Task> tasks;
  final List<double> yieldHistory; 
  final double predictedYield;     
  final String weatherType;        

  CropInfo({
    required this.name,
    required this.stage,
    required this.progress,
    required this.days,
    required this.isHealthy,
    this.healthIssue = "",
    required this.tasks,
    required this.yieldHistory,
    required this.predictedYield,
    required this.weatherType,
  });
}

class CropData {
  static final CropInfo _default = CropInfo(
    name: "Crop", stage: "Growth", progress: 0.5, days: "Day 30", isHealthy: true,
    tasks: [], yieldHistory: [10, 11, 12, 11, 13], predictedYield: 14, weatherType: "Sunny"
  );

  static final Map<String, CropInfo> _data = {
    // --- 1. PADDY (Rainy & Healthy) ---
    "Paddy (Rice)": CropInfo(
      name: "Paddy (Rice)",
      stage: "Vegetative Stage",
      progress: 0.4,
      days: "Day 45 of 120",
      isHealthy: true,
      yieldHistory: [35, 38, 36, 40, 42],
      predictedYield: 45.5,
      weatherType: "Rainy", 
      tasks: [
        Task(
          title: "Irrigate 200L",
          subtitle: "Soil moisture low (45%)",
          icon: FontAwesomeIcons.droplet,
          color: Colors.blue,
          badge: "Critical",
          popupTitle: "Irrigation Alert",
          popupBody: "Paddy requires standing water of 2-5cm at this stage. Your soil sensor indicates moisture has dropped. Irrigate immediately to prevent yield loss.",
          source: "Soil Sensor #1",
        ),
        Task(
          title: "Check Stem Borer",
          subtitle: "Risk: High",
          icon: FontAwesomeIcons.bug,
          color: Colors.orange,
          badge: "Advisory",
          popupTitle: "Pest Warning: Stem Borer",
          popupBody: "Humid weather detected. Look for 'Dead Hearts' (dried central shoots). If >5% damage, apply Chlorantraniliprole 0.4% GR.",
          source: "Agri-Weather AI",
        ),
      ],
    ),

    // --- 2. WHEAT (Sunny & Unhealthy Example) ---
    "Wheat": CropInfo(
      name: "Wheat",
      stage: "Crown Root Initiation",
      progress: 0.3,
      days: "Day 25 of 120",
      isHealthy: false, // <--- STRESS DETECTED! (RED CARD)
      healthIssue: "Yellow Rust Detected",
      yieldHistory: [18, 20, 19, 21, 18],
      predictedYield: 16.5, // Lower due to disease
      weatherType: "Sunny",
      tasks: [
        Task(
          title: "Spray Propiconazole",
          subtitle: "Rust pustules found",
          icon: FontAwesomeIcons.sprayCan,
          color: Colors.red,
          badge: "Urgent",
          popupTitle: "Yellow Rust Management",
          popupBody: "Yellow Rust (Stripe Rust) detected in your zone. Spray Propiconazole 25 EC @ 1ml/L water immediately to stop spread.",
          source: "Drone Survey #9",
        ),
        Task(
          title: "Apply Nitrogen",
          subtitle: "Top dressing due",
          icon: FontAwesomeIcons.sackDollar,
          color: Colors.green,
          badge: "Growth",
          popupTitle: "Fertilizer Schedule",
          popupBody: "It is time for the first top dressing of Urea (Nitrogen) after the first irrigation. Apply 40kg/acre.",
          source: "Schedule",
        ),
      ],
    ),

    // --- 3. POTATO (Sunny & Healthy) ---
    "Potato": CropInfo(
      name: "Potato",
      stage: "Tuber Bulking",
      progress: 0.60,
      days: "Day 55 of 90",
      isHealthy: true,
      yieldHistory: [80, 85, 90, 88, 92],
      predictedYield: 95.0,
      weatherType: "Sunny",
      tasks: [
        Task(
          title: "Check Late Blight",
          subtitle: "Cloudy weather alert",
          icon: FontAwesomeIcons.cloudRain,
          color: Colors.red,
          badge: "Disease Risk",
          popupTitle: "Late Blight Warning",
          popupBody: "Cool and cloudy weather is forecasted. This favors Late Blight. Prophylactic spray of Mancozeb @ 2g/L is recommended.",
          source: "Weather Station",
        ),
      ],
    ),

    // --- 4. SUGARCANE (Cloudy & Healthy) ---
    "Sugarcane": CropInfo(
      name: "Sugarcane",
      stage: "Grand Growth",
      progress: 0.5,
      days: "Month 6 of 12",
      isHealthy: true,
      yieldHistory: [300, 310, 305, 320, 330],
      predictedYield: 340.0,
      weatherType: "Cloudy",
      tasks: [
        Task(
          title: "Propping",
          subtitle: "Prevent lodging",
          icon: FontAwesomeIcons.textHeight,
          color: Colors.green,
          badge: "Operation",
          popupTitle: "Crop Propping",
          popupBody: "Cane height is significant. Tie plants together (Propping) to prevent falling down (lodging) during upcoming high winds.",
          source: "Calendar",
        ),
      ],
    ),
  };

  static CropInfo get(String cropName) {
    return _data[cropName] ?? _default;
  }
}