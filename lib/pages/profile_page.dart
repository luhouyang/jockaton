import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.all(50.0),
              child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0)),
                      child: const Placeholder(),
                    ),
                    const Positioned(
                        right: 5, bottom: 5, child: Icon(Icons.cancel)),
                  ],
                ),),
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
            child: Stack(
              children: [
                _isEditing 
                ? Column(children: [],) 
                : Column(children: [],),
                Positioned(
              child: ElevatedButton(onPressed: () {}, child: Text("Edit"))),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
