part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const WELCOME = _Paths.WELCOME;
  static const SIGNIN = _Paths.SIGNIN;
  static const OTP = _Paths.OTP;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const WATCHLIST = _Paths.WATCHLIST;
  static const CHARTS = _Paths.CHARTS;
  static const FUND_DETAIL = _Paths.FUND_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const WELCOME = '/welcome';
  static const SIGNIN = '/signin';
  static const OTP = '/otp';
  static const DASHBOARD = '/dashboard';
  static const WATCHLIST = '/watchlist';
  static const CHARTS = '/charts';
  static const FUND_DETAIL = '/fund-detail';
}
