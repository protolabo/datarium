import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Esp32ConfigViewModel extends ChangeNotifier {
  // Connection state
  bool isConnected = false;
  bool isConnecting = false;
  bool isOn = false;

  // Wi‑Fi networks (simulated scan)
  final List<String> availableSsids = ['Home_Network', 'Office_WiFi', 'ESP32_Hotspot'];
  String? selectedSsid;

  // Update delay
  int delaySeconds = 2;

  // Categories
  final List<String> categories = ['Streaming', 'Gaming', 'AI/LLM'];
  final Set<String> selectedCategories = {};

  // Consumption thresholds
  RangeValues thresholds = const RangeValues(10, 20);

  // UI panels state
  List<bool> panelOpen = [false, false, false, false];

  // Toggle BLE connection
  Future<void> toggleConnection() async {
    isConnecting = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    isConnected = !isConnected;
    isConnecting = false;
    if (!isConnected) isOn = false;
    notifyListeners();
  }

  // Toggle power
  void togglePower(bool value) {
    if (isConnected) {
      isOn = value;
      notifyListeners();
    }
  }

  // Select SSID
  void selectSsid(String? ssid) {
    if (isConnected) {
      selectedSsid = ssid;
      notifyListeners();
    }
  }

  // Update delay
  void updateDelay(double seconds) {
    if (isConnected) {
      delaySeconds = seconds.round();
      notifyListeners();
    }
  }

  // Toggle category
  void toggleCategory(String category) {
    if (isConnected) {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
      notifyListeners();
    }
  }

  // Update thresholds
  void updateThresholds(RangeValues values) {
    if (isConnected) {
      thresholds = values;
      notifyListeners();
    }
  }

  // Toggle panel
  void togglePanel(int index) {
    panelOpen[index] = !panelOpen[index];
    notifyListeners();
  }
}