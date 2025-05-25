import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mutualfund/app/modules/charts/views/charts_view.dart';
import 'package:mutualfund/app/modules/watchlist/views/watchlist_view.dart';
import 'package:mutualfund/app/widgets/loading_indicator.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

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
      backgroundColor: Colors.black, // Dark background
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        return IndexedStack(
          index: controller.currentTabIndex.value,
          children: [
            _buildHomeTab(),
            const ChartsView(),
            const WatchlistView(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentTabIndex.value,
        onTap: controller.changeTab,
        backgroundColor: Colors.black, // Dark background
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
        ],
      )),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Welcome User,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => GestureDetector(
                    onTap: () => _showProfileOptions(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        'U',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Watchlist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.watchlists.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Looks like your watchlist is empty.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70, // Light white text
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => controller.changeTab(2), // Go to Watchlist tab
                          child: const Text('Add Mutual Funds'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadData(),
                  child: ListView.builder(
                    itemCount: controller.watchlists.length,
                    itemBuilder: (context, index) {
                      final watchlist = controller.watchlists[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        color: Colors.grey[900], // Dark card
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                watchlist.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // White text
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (watchlist.funds.isEmpty)
                                const Text(
                                  'No funds added yet',
                                  style: TextStyle(color: Colors.white70), // Light white text
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: watchlist.funds.length > 2 ? 2 : watchlist.funds.length,
                                  itemBuilder: (context, fundIndex) {
                                    final fund = watchlist.funds[fundIndex];
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        fund.name,
                                        style: const TextStyle(color: Colors.white), // White text
                                      ),
                                      subtitle: Text(
                                        '${fund.category} | ${fund.subcategory}',
                                        style: const TextStyle(color: Colors.white70), // Light white text
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'NAV ₹${fund.nav}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white, // White text
                                            ),
                                          ),
                                          Text(
                                            '1D ${fund.oneDay > 0 ? '+' : ''}${fund.oneDay}%',
                                            style: TextStyle(
                                              color: fund.oneDay >= 0 ? Colors.green : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () => controller.viewFundDetails(fund),
                                    );
                                  },
                                ),
                              if (watchlist.funds.length > 2)
                                TextButton(
                                  onPressed: () {
                                    // Navigate to watchlist detail
                                    controller.changeTab(2);
                                  },
                                  child: Text('View all ${watchlist.funds.length} funds'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page when implemented
                  Get.snackbar(
                    'Profile',
                    'Profile page coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.grey[800],
                    colorText: Colors.white,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page when implemented
                  Get.snackbar(
                    'Settings',
                    'Settings page coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.grey[800],
                    colorText: Colors.white,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  controller.signOut();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
