import 'package:get/get.dart';
import 'package:mutualfund/app/data/models/mutual_fund.dart';
import 'package:mutualfund/app/data/models/watchlist.dart';
import 'package:mutualfund/app/data/providers/mutual_fund_provider.dart';
import 'package:mutualfund/app/data/providers/watchlist_provider.dart';
import 'package:mutualfund/app/data/services/auth_service.dart';
import 'package:mutualfund/app/routes/app_pages.dart';

class DashboardController extends GetxController {
  final MutualFundProvider _fundProvider = Get.find<MutualFundProvider>();
  final WatchlistProvider _watchlistProvider = Get.find<WatchlistProvider>();
  final AuthService _authService = Get.find<AuthService>();
  
  final RxList<Watchlist> watchlists = <Watchlist>[].obs;
  final RxList<MutualFund> allFunds = <MutualFund>[].obs;
  final Rx<MutualFund?> selectedFund = Rx<MutualFund?>(null);
  final RxBool isLoading = true.obs;
  final RxInt currentTabIndex = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      
      // Load all mutual funds from mock data
      allFunds.value = await _fundProvider.getAllFunds();
      
      // Load watchlists from local storage
      watchlists.value = await _watchlistProvider.getWatchlists();
      
      // Set a default selected fund if available
      if (allFunds.isNotEmpty && selectedFund.value == null) {
        selectedFund.value = allFunds[0];
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void changeTab(int index) {
    currentTabIndex.value = index;
  }
  
  void selectFund(MutualFund fund) {
    selectedFund.value = fund;
    if (currentTabIndex.value != 1) { // Charts tab
      currentTabIndex.value = 1;
    }
  }
  
  void viewFundDetails(MutualFund fund) {
    selectedFund.value = fund;
    Get.toNamed(Routes.FUND_DETAIL, arguments: fund);
  }
  
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
  
  // Refresh data when returning to dashboard
  void refreshData() {
    loadData();
  }
}
