import 'package:flutter/material.dart';

class HouseholdSetupScreen extends StatelessWidget {
  const HouseholdSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Household Setup')),
      body: const Center(child: Text('Setup your household here')),
    );
  }
}