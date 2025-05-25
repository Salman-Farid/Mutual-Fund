import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/data/models/mutual_fund.dart';
import 'package:mutualfund/app/modules/dashboard/controllers/dashboard_controller.dart';

class ChartsController extends GetxController with GetSingleTickerProviderStateMixin {
  final DashboardController _dashboardController = Get.find<DashboardController>();

  late TabController tabController;
  final RxString selectedTimeRange = '3Y'.obs; // Changed default to 3Y to match your image
  final RxString selectedChartType = 'NAV'.obs;
  final RxString selectedInvestmentType = '1-Time'.obs;
  final RxDouble investmentAmount = 100000.0.obs; // 1L default
  final RxDouble sipAmount = 1000.0.obs; // 1k default
  final RxBool showTooltip = false.obs;
  final Rx<NavPoint?> selectedPoint = Rx<NavPoint?>(null);
  var sliderValue = 1.0.obs; // Starts at ₹1 L


  final List<String> timeRanges = ['1Y', '3Y', '5Y', 'MAX']; // Updated to match your widget
  final List<String> chartTypes = ['NAV', 'Investment'];
  final List<String> investmentTypes = ['1-Time', 'Monthly SIP'];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        if (tabController.index == 0) {
          selectedChartType.value = 'NAV';
        } else {
          selectedChartType.value = 'Investment';
        }
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  MutualFund? get selectedFund => _dashboardController.selectedFund.value;

  void setTimeRange(String range) {
    selectedTimeRange.value = range;
  }








  void updateSlider(double value) {
    sliderValue.value = value;
  }







  void setChartType(String type) {
    selectedChartType.value = type;
    if (type == 'NAV') {
      tabController.animateTo(0);
    } else {
      tabController.animateTo(1);
    }
  }

  void setInvestmentType(String type) {
    selectedInvestmentType.value = type;
  }

  void setInvestmentAmount(double amount) {
    investmentAmount.value = amount;
  }

  void setSipAmount(double amount) {
    sipAmount.value = amount;
  }

  void selectDataPoint(NavPoint? point) {
    selectedPoint.value = point;
    showTooltip.value = point != null;
  }

  List<NavPoint> getFilteredNavHistory() {
    if (selectedFund == null) return [];

    final now = DateTime.now();
    final navHistory = selectedFund!.navHistory;

    switch (selectedTimeRange.value) {
      case '1Y':
        final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        return navHistory.where((point) => point.date.isAfter(oneYearAgo)).toList();
      case '3Y':
        final threeYearsAgo = DateTime(now.year - 3, now.month, now.day);
        return navHistory.where((point) => point.date.isAfter(threeYearsAgo)).toList();
      case '5Y':
        final fiveYearsAgo = DateTime(now.year - 5, now.month, now.day);
        return navHistory.where((point) => point.date.isAfter(fiveYearsAgo)).toList();
      case 'MAX':
      default:
        return navHistory;
    }
  }

  // Get current investment value for display
  String getCurrentValue() {
    final returns = calculateInvestmentReturns();
    if (returns.isEmpty) return '₹0';

    if (selectedInvestmentType.value == '1-Time') {
      final currentValue = returns['oneTime']['currentValue'] ?? 0.0;
      return _formatCurrency(currentValue);
    } else {
      final currentValue = returns['sip']['currentValue'] ?? 0.0;
      return _formatCurrency(currentValue);
    }
  }

  // Get returns data for the bar chart
  Map<String, Map<String, dynamic>> getReturnsData() {
    final returns = calculateInvestmentReturns();
    if (returns.isEmpty) {
      return {
        'savingAcc': {'percentage': 5.1, 'amount': '₹1.19L'},
        'categoryAvg': {'percentage': 14.3, 'amount': '₹3.63L'},
        'directPlan': {'percentage': 16.2, 'amount': '₹4.55L'},
      };
    }

    final isOneTime = selectedInvestmentType.value == '1-Time';
    final data = isOneTime ? returns['oneTime'] : returns['sip'];
    final gainPercent = data['gainPercent'] ?? 0.0;
    final currentValue = data['currentValue'] ?? 0.0;

    // Calculate benchmark returns (these would typically come from your data source)
    final savingAccReturn = _calculateBenchmarkReturn(currentValue, 0.05); // 5% savings account
    final categoryAvgReturn = _calculateBenchmarkReturn(currentValue, 0.12); // 12% category average

    return {
      'savingAcc': {
        'percentage': 5.1,
        'amount': _formatCurrency(savingAccReturn)
      },
      'categoryAvg': {
        'percentage': 12.0,
        'amount': _formatCurrency(categoryAvgReturn)
      },
      'directPlan': {
        'percentage': gainPercent,
        'amount': _formatCurrency(currentValue)
      },
    };
  }

  // Get total profit for display
  String getTotalProfit() {
    final returns = calculateInvestmentReturns();
    if (returns.isEmpty) return '₹3.6L';

    final isOneTime = selectedInvestmentType.value == '1-Time';
    final data = isOneTime ? returns['oneTime'] : returns['sip'];
    final gain = data['gain'] ?? 0.0;

    return _formatCurrency(gain);
  }

  // Get total profit percentage
  String getTotalProfitPercent() {
    final returns = calculateInvestmentReturns();
    if (returns.isEmpty) return '355.3%';

    final isOneTime = selectedInvestmentType.value == '1-Time';
    final data = isOneTime ? returns['oneTime'] : returns['sip'];
    final gainPercent = data['gainPercent'] ?? 0.0;

    return '${gainPercent.toStringAsFixed(1)}%';
  }

  // Calculate investment returns based on NAV history
  Map<String, dynamic> calculateInvestmentReturns() {
    if (selectedFund == null) return {};

    final navHistory = getFilteredNavHistory();
    if (navHistory.isEmpty) return {};

    final firstNav = navHistory.first.value;
    final lastNav = navHistory.last.value;

    // Prevent division by zero
    if (firstNav == 0) return {};

    final navGrowth = lastNav / firstNav;

    // For one-time investment
    final oneTimeInvestment = investmentAmount.value;
    final oneTimeCurrentValue = oneTimeInvestment * navGrowth;
    final oneTimeGain = oneTimeCurrentValue - oneTimeInvestment;
    final oneTimeGainPercent = oneTimeInvestment > 0 ? (oneTimeGain / oneTimeInvestment) * 100 : 0;

    // For SIP investment (simplified calculation)
    double totalSipInvestment = 0;
    double sipCurrentValue = 0;

    if (selectedInvestmentType.value == 'Monthly SIP' && navHistory.length > 1) {
      final monthlyAmount = sipAmount.value;
      final monthsInPeriod = _getMonthsForTimeRange();

      // Simplified SIP calculation - assumes monthly investments
      for (int month = 0; month < monthsInPeriod; month++) {
        totalSipInvestment += monthlyAmount;

        // Calculate growth from investment date to current
        final monthsRemaining = monthsInPeriod - month;
        final growthFactor = _calculateGrowthFactor(monthsRemaining, navHistory);
        sipCurrentValue += monthlyAmount * growthFactor;
      }
    }

    final sipGain = sipCurrentValue - totalSipInvestment;
    final sipGainPercent = totalSipInvestment > 0 ? (sipGain / totalSipInvestment) * 100 : 0;

    return {
      'oneTime': {
        'investment': oneTimeInvestment,
        'currentValue': oneTimeCurrentValue,
        'gain': oneTimeGain,
        'gainPercent': oneTimeGainPercent,
      },
      'sip': {
        'investment': totalSipInvestment,
        'currentValue': sipCurrentValue,
        'gain': sipGain,
        'gainPercent': sipGainPercent,
      },
    };
  }

  // Helper methods
  String _formatCurrency(double amount) {
    if (amount >= 10000000) { // 1 crore
      return '₹${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) { // 1 lakh
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) { // 1 thousand
      return '₹${(amount / 1000).toStringAsFixed(1)}k';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  double _calculateBenchmarkReturn(double currentValue, double annualRate) {
    final years = _getYearsForTimeRange();
    final investment = selectedInvestmentType.value == '1-Time'
        ? investmentAmount.value
        : sipAmount.value * _getMonthsForTimeRange();

    return investment * (1 + (annualRate * years));
  }

  int _getMonthsForTimeRange() {
    switch (selectedTimeRange.value) {
      case '1Y':
        return 12;
      case '3Y':
        return 36;
      case '5Y':
        return 60;
      case 'MAX':
        return 120; // 10 years
      default:
        return 36;
    }
  }

  double _getYearsForTimeRange() {
    switch (selectedTimeRange.value) {
      case '1Y':
        return 1.0;
      case '3Y':
        return 3.0;
      case '5Y':
        return 5.0;
      case 'MAX':
        return 10.0;
      default:
        return 3.0;
    }
  }

  double _calculateGrowthFactor(int monthsRemaining, List<NavPoint> navHistory) {
    if (navHistory.isEmpty || monthsRemaining <= 0) return 1.0;

    // Simplified growth calculation
    final totalGrowth = navHistory.last.value / navHistory.first.value;
    final monthlyGrowthRate = (totalGrowth - 1) / navHistory.length * 30; // Approximate monthly rate

    return 1 + (monthlyGrowthRate * monthsRemaining);
  }
}