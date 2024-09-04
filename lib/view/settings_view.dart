import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/setting_controller.dart';


class SettingsView extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        return controller.settings.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: Text('Dark Mode'),
                value: controller.settings['dark_mode'] ?? false,
                onChanged: (value) {
                  controller.updateSettings({'dark_mode': value});
                },
              ),
              // Add more settings options here
            ],
          ),
        );
      }),
    );
  }
}
