import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpControllers = List.generate(6, (_) => TextEditingController());
  
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt resendSeconds = 30.obs;
  final RxBool canResend = false.obs;
  final RxBool isSignUp = false.obs;
  final RxBool showPassword = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
  
  void startResendTimer() {
    _authService.startResendTimer(resendSeconds, canResend);
  }
  
  void toggleSignUpMode() {
    isSignUp.value = !isSignUp.value;
    errorMessage.value = '';
  }
  
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }
  
  Future<void> signInWithEmail() async {
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return;
    }
    
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return;
    }
    
    isLoading.value = true;
    try {
      if (isSignUp.value) {
        await _authService.signUpWithEmail(emailController.text, passwordController.text);
      } else {
        await _authService.signInWithEmail(emailController.text, passwordController.text);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Either the email/password is incorrect or the email is not registered!';
      print('Error in signInWithEmail: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Future<void> signInWithGoogle() async {
  //   isLoading.value = true;
  //   try {
  //     await _authService.signInWithGoogle();
  //   } catch (e) {
  //     errorMessage.value = 'An error occurred. Please try again.';
  //     print('Error in signInWithGoogle: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  
  Future<void> signIn() async {
    if (phoneController.text.isEmpty) {
      errorMessage.value = 'Please enter your phone number';
      return;
    }
    
    if (phoneController.text.length != 10) {
      errorMessage.value = 'Please enter a valid 10-digit phone number';
      return;
    }
    
    isLoading.value = true;
    try {
      await _authService.signIn(phoneController.text);
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      print('Error in signIn: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> verifyOTP() async {
    final otp = otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      errorMessage.value = 'Please enter a valid OTP';
      return;
    }
    
    isLoading.value = true;
    try {
      await _authService.verifyOTP(otp);
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      print('Error in verifyOTP: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void resendOTP() {
    if (canResend.value) {
      signIn();
      startResendTimer();
    }
  }
  
  // Helper method to focus next OTP field
  void focusNextOtpField(BuildContext context, int currentIndex, String value) {
    if (value.isNotEmpty && currentIndex < 5) {
      FocusScope.of(context).nextFocus();
    }
  }
  
  // Helper method to focus previous OTP field
  void focusPreviousOtpField(BuildContext context, int currentIndex, String value) {
    if (value.isEmpty && currentIndex > 0) {
      FocusScope.of(context).previousFocus();
    }
  }
}
