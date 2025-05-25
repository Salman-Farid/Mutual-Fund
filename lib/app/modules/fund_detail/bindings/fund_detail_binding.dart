import 'package:get/get.dart';
import 'package:mutualfund/app/data/providers/watchlist_provider.dart';
import 'package:mutualfund/app/modules/fund_detail/controllers/fund_detail_controller.dart';

class FundDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure WatchlistProvider is registered
    if (!Get.isRegistered<WatchlistProvider>()) {
      Get.put<WatchlistProvider>(WatchlistProvider(), permanent: true);
    }
    
    Get.put<FundDetailController>(FundDetailController());
  }
}
