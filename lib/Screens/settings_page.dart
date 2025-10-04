import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_application/Screens/note_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF152e6a),
      appBar: AppBar(
        title: Text('settings'.tr(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'select_language'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      context.locale.languageCode == 'en' ? "EN" : "AR",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: context.locale.languageCode == 'ar',
                      onChanged: (value) {
                        if (value) {
                          context.setLocale(const Locale('ar'));
                        } else {
                          context.setLocale(const Locale('en'));
                        }
                        setState(() {}); // refresh text + switch
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF092462),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0 || index == 1 || index == 2) { // settings tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotePage()),
              );
            }
          },
          
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_none_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.credit_card),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              label: ""
              
            ),
          ],
        ),
      ),
    );
  }
}