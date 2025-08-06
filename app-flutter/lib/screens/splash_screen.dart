/*

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:datarium/screens/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? selectedNetwork;
  List<String> availableNetworks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNetworks();
  }

  Future<void> fetchNetworks() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/networks'),
      );
      debugPrint('🛰  [fetchNetworks] ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final list = data.map((e) => e['id'].toString()).toList();
        debugPrint('🛰  availableNetworks = $list');
        setState(() {
          availableNetworks = list;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load networks: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(' Error fetching networks: $e');
      setState(() => isLoading = false);
    }
  }

  void connectAndNavigate() {
    if (selectedNetwork != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(networkId: selectedNetwork!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/logo.jpg', width: 200, height: 200),
              const SizedBox(height: 20),
              const Text(
                "Sensibiliser sans culpabiliser",
                style: TextStyle(
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),

              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                DropdownButtonFormField<String>(
                  //  ───── clés pour que ça fonctionne ─────
                  isExpanded: true,
                  hint: const Text('Choisir un réseau'),
                  value: selectedNetwork,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items:
                      availableNetworks.map((network) {
                        return DropdownMenuItem(
                          value: network,
                          child: Text(network),
                        );
                      }).toList(),
                  onChanged:
                      (value) => setState(() {
                        selectedNetwork = value;
                      }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      selectedNetwork != null ? connectAndNavigate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Se connecter"),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:datarium/screens/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? selectedNetwork;
  List<String> availableNetworks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNetworks();
  }

  Future<void> fetchNetworks() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/networks'),
      );
      debugPrint('🛰 [fetchNetworks] ${response.statusCode}: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final list = data.map((e) => e['id'].toString()).toList();
        setState(() {
          availableNetworks = list;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load networks (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('💥 Error fetching networks: $e');
      setState(() => isLoading = false);
    }
  }

  void connectAndNavigate() {
    if (selectedNetwork != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(networkId: selectedNetwork!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/logo.jpg', width: 400, height: 400),
              const SizedBox(height: 20),
              const Text(
                "Sensibiliser sans culpabiliser",
                style: TextStyle(
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              ),
              const Spacer(),

              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: const Text('Choisir un réseau'),
                  value: selectedNetwork,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items:
                      availableNetworks.map((network) {
                        return DropdownMenuItem(
                          value: network,
                          child: Text(network),
                        );
                      }).toList(),
                  onChanged: (value) => setState(() => selectedNetwork = value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      selectedNetwork != null ? connectAndNavigate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Se connecter"),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
