import 'package:get/get.dart';
import 'package:mutualfund/app/modules/auth/bindings/auth_binding.dart';
import 'package:mutualfund/app/modules/auth/views/welcome_view.dart';
import 'package:mutualfund/app/modules/auth/views/signin_view.dart';
import 'package:mutualfund/app/modules/auth/views/otp_view.dart';
import 'package:mutualfund/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:mutualfund/app/modules/dashboard/views/dashboard_view.dart';
import 'package:mutualfund/app/modules/watchlist/bindings/watchlist_binding.dart';
import 'package:mutualfund/app/modules/watchlist/views/watchlist_view.dart';
import 'package:mutualfund/app/modules/charts/bindings/charts_binding.dart';
import 'package:mutualfund/app/modules/charts/views/charts_view.dart';
import 'package:mutualfund/app/modules/fund_detail/bindings/fund_detail_binding.dart';
import 'package:mutualfund/app/modules/fund_detail/views/fund_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.WATCHLIST,
      page: () => const WatchlistView(),
      binding: WatchlistBinding(),
    ),
    GetPage(
      name: _Paths.CHARTS,
      page: () => const ChartsView(),
      binding: ChartsBinding(),
    ),
    GetPage(
      name: _Paths.FUND_DETAIL,
      page: () => const FundDetailView(),
      binding: FundDetailBinding(),
    ),
  ];
}
