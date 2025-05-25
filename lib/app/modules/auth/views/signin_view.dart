import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/modules/auth/controllers/auth_controller.dart';
import 'package:mutualfund/app/widgets/primary_button.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove AppBar and use back button in body
      backgroundColor: Colors.black, // Dark background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button without AppBar
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome Back,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text
                  ),
                ),
                const Text(
                  'We Missed You!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Glad to have you back at Dhan Saarthi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70, // Light white text
                  ),
                ),
                const SizedBox(height: 32),
                
                // Email/Password Login Section
                Obx(() => Text(
                  controller.isSignUp.value ? 'Create an account' : 'Sign in with email',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // White text
                  ),
                )),
                const SizedBox(height: 12),
                
                // Email field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[800]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[900], // Dark input field
                  ),
                  child: TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white), // White text
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey), // Grey hint text
                      prefixIcon: Icon(Icons.email, color: Colors.grey), // Grey icon
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Password field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[800]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[900], // Dark input field
                  ),
                  child: Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.showPassword.value,
                    style: const TextStyle(color: Colors.white), // White text
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.grey), // Grey hint text
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey), // Grey icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.showPassword.value ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey, // Grey icon
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  )),
                ),
                
                const SizedBox(height: 24),
                
                // Email/Password Sign In Button
                Obx(() => PrimaryButton(
                  text: controller.isSignUp.value ? 'Sign Up' : 'Sign In',
                  onPressed: () => controller.signInWithEmail(),
                  isLoading: controller.isLoading.value,
                )),
                
                const SizedBox(height: 12),
                
                // Toggle Sign Up/Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                      controller.isSignUp.value 
                          ? 'Already have an account? ' 
                          : 'Don\'t have an account? ',
                      style: const TextStyle(color: Colors.white70), // Light white text
                    )),
                    GestureDetector(
                      onTap: controller.toggleSignUpMode,
                      child: Obx(() => Text(
                        controller.isSignUp.value ? 'Sign In' : 'Sign Up',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[800])),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.white70), // Light white text
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[800])),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Phone Login Section
                const Text(
                  'Or sign in with phone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white, // White text
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[800]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[900], // Dark input field
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: const Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white, // White text
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white), // White text
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey), // Grey hint text
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 24),
                Obx(() => PrimaryButton(
                  text: 'Continue with Phone',
                  onPressed: () => controller.signIn(),
                  isLoading: controller.isLoading.value,
                )),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'By signing in, you agree to our T&C and Privacy Policy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70, // Light white text
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
