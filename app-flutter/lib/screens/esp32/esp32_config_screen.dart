import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'esp32_config_viewmodel.dart';

class Esp32ConfigScreen extends StatelessWidget {
  const Esp32ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Esp32ConfigViewModel(),
      child: const _Esp32ConfigView(),
    );
  }
}

class _Esp32ConfigView extends StatelessWidget {
  const _Esp32ConfigView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<Esp32ConfigViewModel>();

    // Preview sample
    final sampleValue = (vm.thresholds.start + vm.thresholds.end) / 2;
    final color = sampleValue <= vm.thresholds.start
        ? Colors.green
        : (sampleValue <= vm.thresholds.end ? Colors.yellow : Colors.red);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 Configuration'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!vm.isConnected) ...[
              const SizedBox(height: 120),
              const Center(
                child: Text(
                  'Please connect your ESP32. \n'
                  'Once connected, you will be able to set the network, update delay, categories to monitor, '
                  'and energy consumption thresholds.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: Icon(
                  Icons.thermostat,
                  size: 180,
                  color: Colors.grey[300],
                ),
              ),
            ] else ...[
              // Power Toggle
              SwitchListTile(
                title: const Text('Power'),
                subtitle: Text(vm.isOn ? 'On' : 'Off'),
                value: vm.isOn,
                onChanged: vm.togglePower,
              ),
              const SizedBox(height: 16),

              // Network Selection
              const Text('Select Wi-Fi Network', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text('Choose SSID'),
                items: vm.availableSsids
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                value: vm.selectedSsid,
                onChanged: vm.selectSsid,
              ),
              const SizedBox(height: 24),

              // Update Delay
              const Text('Update Delay (seconds)', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: vm.delaySeconds.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '${vm.delaySeconds} s',
                onChanged: vm.updateDelay,
              ),
              const SizedBox(height: 24),

              // Categories
              const Text('Categories to Monitor', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: vm.categories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: vm.selectedCategories.contains(category),
                    onSelected: (_) => vm.toggleCategory(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Thresholds & Preview
              const Text('Energy Consumption Thresholds', style: TextStyle(fontWeight: FontWeight.bold)),
              RangeSlider(
                values: vm.thresholds,
                min: 0,
                max: 100,
                divisions: 20,
                labels: RangeLabels(
                  vm.thresholds.start.toStringAsFixed(0),
                  vm.thresholds.end.toStringAsFixed(0),
                ),
                onChanged: vm.updateThresholds,
              ),
              const SizedBox(height: 16),
              Text('Sample: ${sampleValue.toStringAsFixed(1)} kWh', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(height: 20, width: double.infinity, color: color),
            ],
            
            const SizedBox(height: 120),

            Center(
              child: ElevatedButton.icon(
                icon: vm.isConnecting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(vm.isConnected
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth),
                label: Text(
                  vm.isConnected ? 'Disconnect ESP32' : 'Connect ESP32', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                onPressed: vm.isConnecting ? null : vm.toggleConnection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}