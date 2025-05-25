import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mutualfund/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';

class AuthService extends GetxService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final GetStorage _box = GetStorage();
  final RxBool isLoggedIn = false.obs;
  final RxString phoneNumber = ''.obs;
  final RxString email = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    // Initialize login state
    _initLoginState();

    // Listen to auth state changes
    _supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        isLoggedIn.value = true;
        _box.write('user_token', session.accessToken);
        _box.write('is_logged_in', true);

        if (session.user.email != null) {
          email.value = session.user.email!;
          _box.write('user_email', session.user.email);
        }

        // Use WidgetsBinding to ensure navigation happens after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute != Routes.DASHBOARD) {
            Get.offAllNamed(Routes.DASHBOARD);
          }
        });
      } else if (event == AuthChangeEvent.signedOut) {
        isLoggedIn.value = false;
        _box.remove('user_token');
        _box.remove('user_email');
        _box.remove('user_phone');
        _box.remove('is_logged_in');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(Routes.WELCOME);
        });
      }
    });
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  void _initLoginState() {
    try {
      final isLoggedInPref = _box.read<bool>('is_logged_in') ?? false;

      if (isLoggedInPref) {
        isLoggedIn.value = true;

        final storedEmail = _box.read<String>('user_email');
        if (storedEmail != null) {
          email.value = storedEmail;
        }

        final storedPhone = _box.read<String>('user_phone');
        if (storedPhone != null) {
          phoneNumber.value = storedPhone;
        }
        return;
      }

      final session = _supabaseClient.auth.currentSession;
      final token = _box.read<String>('user_token');

      if (session != null || token != null) {
        isLoggedIn.value = true;
        _box.write('is_logged_in', true);

        if (session?.user.email != null) {
          email.value = session!.user.email!;
          _box.write('user_email', session.user.email);
        }
      }
    } catch (e) {
      print('Error initializing login state: $e');
    }
  }

  String determineInitialRoute() {
    try {
      final isLoggedInPref = _box.read<bool>('is_logged_in') ?? false;

      if (isLoggedInPref) {
        isLoggedIn.value = true; // Set the state here too
        return Routes.DASHBOARD;
      }

      final session = _supabaseClient.auth.currentSession;
      final token = _box.read<String>('user_token');

      if (session != null || token != null) {
        isLoggedIn.value = true; // Set the state here too
        return Routes.DASHBOARD;
      }

      return Routes.WELCOME;
    } catch (e) {
      print('Error determining initial route: $e');
      return Routes.WELCOME;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        this.email.value = email;
        _box.write('user_email', email);
        _box.write('is_logged_in', true);
        isLoggedIn.value = true;
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error in signInWithEmail: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback',
      );

      if (response.user != null) {
        this.email.value = email;
        _box.write('user_email', email);
        _box.write('is_logged_in', true);
        isLoggedIn.value = true;
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error in signUpWithEmail: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String phone) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      phoneNumber.value = phone;

      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed(Routes.OTP);
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error in signIn: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.delayed(const Duration(seconds: 1));

      if (otp == "222222") {
        _box.write('user_token', 'mock_token');
        _box.write('user_phone', phoneNumber.value);
        _box.write('is_logged_in', true);
        isLoggedIn.value = true;
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        errorMessage.value = 'Invalid OTP! Please try again';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      print('Error in verifyOTP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();

      _box.remove('user_token');
      _box.remove('user_phone');
      _box.remove('user_email');
      _box.remove('is_logged_in');
      isLoggedIn.value = false;

      Get.offAllNamed(Routes.WELCOME);
    } catch (e) {
      errorMessage.value = 'An error occurred during sign out.';
      print('Error signing out: $e');
    }
  }

  void startResendTimer(RxInt resendSeconds, RxBool canResend) {
    canResend.value = false;
    resendSeconds.value = 30;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }
}
