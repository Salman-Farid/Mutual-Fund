import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/modules/auth/controllers/auth_controller.dart';
import 'package:mutualfund/app/data/services/auth_service.dart';
import 'package:mutualfund/app/widgets/primary_button.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    
    return Scaffold(
      // Remove AppBar and use back button in body
      backgroundColor: Colors.black, // Dark background
      body: SafeArea(
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
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    height: 45,
                    child: TextField(
                      controller: controller.otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(color: Colors.white), // White text
                      onChanged: (value) {
                        controller.focusNextOtpField(context, index, value);
                        controller.focusPreviousOtpField(context, index, value);
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey[900], // Dark input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[800]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => controller.canResend.value
                      ? GestureDetector(
                          onTap: () => controller.resendOTP(),
                          child: const Text(
                            'Didn\'t Receive OTP? Resend',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Text(
                          '${controller.resendSeconds.value}sec Resend',
                          style: const TextStyle(
                            color: Colors.white70, // Light white text
                          ),
                        )),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: Obx(() {
                  final phone = authService.phoneNumber.value;
                  if (phone.isEmpty) return const SizedBox.shrink();
                  
                  return Text(
                    'OTP has been sent on ${phone.length > 7 ? phone.replaceRange(3, 7, '*****') : phone}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70, // Light white text
                    ),
                  );
                }),
              ),
              const Spacer(),
              Obx(() => PrimaryButton(
                text: 'Proceed',
                onPressed: () => controller.verifyOTP(),
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
    );
  }
}
