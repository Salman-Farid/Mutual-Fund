import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/routes/app_pages.dart';
import 'package:mutualfund/app/widgets/primary_button.dart';

class WelcomeView extends GetView {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style to remove "AnyHow" text
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      // Remove the AppBar completely
      backgroundColor: Colors.black, // Dark background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              // Logo would go here
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text
                ),
              ),
              const Text(
                'DhanSaarthi!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'One step closer to smarter investing. Let\'s begin!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70, // Light white text
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Sign In',
                onPressed: () => Get.toNamed(Routes.SIGNIN),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
