import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/modules/watchlist/controllers/watchlist_controller.dart';
import 'package:mutualfund/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mutualfund/app/widgets/loading_indicator.dart';
import 'package:mutualfund/app/widgets/fund_card.dart';
import 'package:mutualfund/app/data/models/watchlist.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        backgroundColor: Colors.black, // Dark app bar
        title: const Text('Watchlist', style: TextStyle(color: Colors.white)), // White text
        actions: [
          Obx(() => controller.isAddingFunds.value
              ? IconButton(
            icon: const Icon(Icons.close, color: Colors.white), // White icon
            onPressed: controller.toggleAddFundsMode,
          )
              : IconButton(
            icon: const Icon(Icons.add, color: Colors.white), // White icon
            onPressed: controller.toggleAddFundsMode,
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        if (controller.isAddingFunds.value) {
          return _buildAddFundsView();
        }

        return _buildWatchlistView();
      }),
      floatingActionButton: Obx(() => controller.isAddingFunds.value
          ? const SizedBox.shrink()
          : FloatingActionButton(
        onPressed: () => _showCreateWatchlistDialog(context),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Create Watchlist',
      )),
    );
  }

  Widget _buildWatchlistView() {
    return Column(
      children: [
        _buildWatchlistTabs(),
        Expanded(
          child: Obx(() {
            final selectedWatchlist = controller.getSelectedWatchlist();

            if (selectedWatchlist == null) {
              return Center(
                child: Text(
                  'No watchlist available. Create one to get started.',
                  style: TextStyle(color: Colors.white70), // Light white text
                ),
              );
            }

            if (selectedWatchlist.funds.isEmpty) {
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
                      onPressed: controller.toggleAddFundsMode,
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
                padding: const EdgeInsets.all(16),
                itemCount: selectedWatchlist.funds.length,
                itemBuilder: (context, index) {
                  final fund = selectedWatchlist.funds[index];
                  return Dismissible(
                    key: Key(fund.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (_) => controller.removeFundFromWatchlist(fund.id),
                    child: FundCard(
                      fund: fund,
                      onTap: () {
                        // Navigate to fund detail/chart view
                        final dashboardController = Get.find<DashboardController>();
                        dashboardController.viewFundDetails(fund);
                      },
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildWatchlistTabs() {
    return SizedBox(
      height: 50,
      child: Obx(() {
        if (controller.watchlists.isEmpty) {
          return Center(
            child: Text(
              'No watchlists available',
              style: TextStyle(color: Colors.white70), // Light white text
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.watchlists.length,
          itemBuilder: (context, index) {
            final watchlist = controller.watchlists[index];

            return Obx(() {
              final isSelected = watchlist.id == controller.selectedWatchlistId.value;

              return GestureDetector(
                onTap: () {
                  controller.selectWatchlist(watchlist.id);
                },
                onLongPress: () => _showWatchlistOptionsDialog(context, watchlist),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey[800], // Dark chip
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    watchlist.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70, // White/light white text
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }

  Widget _buildAddFundsView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.setSearchQuery,
            style: const TextStyle(color: Colors.white), // White text
            decoration: InputDecoration(
              hintText: 'Search mutual funds...',
              hintStyle: TextStyle(color: Colors.grey[500]), // Grey hint text
              prefixIcon: const Icon(Icons.search, color: Colors.grey), // Grey icon
              suffixIcon: controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey), // Grey icon
                onPressed: () {
                  controller.searchController.clear();
                  controller.setSearchQuery('');
                },
              )
                  : null,
              filled: true,
              fillColor: Colors.grey[900], // Dark input field
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[800]!), // Dark border
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[800]!), // Dark border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue), // Blue border when focused
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.filteredFunds.isEmpty) {
              return Center(
                child: Text(
                  'No mutual funds found',
                  style: TextStyle(color: Colors.white70), // Light white text
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredFunds.length,
              itemBuilder: (context, index) {
                final fund = controller.filteredFunds[index];
                final isAlreadyAdded = controller.isFundInSelectedWatchlist(fund.id);

                return FundCard(
                  fund: fund,
                  trailing: isAlreadyAdded
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white), // White icon
                    onPressed: () => controller.addFundToWatchlist(fund.id),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showCreateWatchlistDialog(BuildContext context) {
    controller.watchlistNameController.clear();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900], // Dark dialog
        title: const Text(
          'Create a new watchlist',
          style: TextStyle(color: Colors.white), // White text
        ),
        content: TextField(
          controller: controller.watchlistNameController,
          style: const TextStyle(color: Colors.white), // White text
          decoration: InputDecoration(
            hintText: 'Watchlist name',
            hintStyle: TextStyle(color: Colors.grey[500]), // Grey hint text
            filled: true,
            fillColor: Colors.grey[800], // Dark input field
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!), // Dark border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!), // Dark border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue), // Blue border when focused
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70, // Light white text
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.createWatchlist();
              Get.back();
              // Force UI update
              controller.update();
            },
            child: const Text('Create'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showWatchlistOptionsDialog(BuildContext context, Watchlist watchlist) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900], // Dark dialog
        title: const Text(
          'Edit Watchlist',
          style: TextStyle(color: Colors.white), // White text
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white), // White icon
              title: const Text(
                'Rename',
                style: TextStyle(color: Colors.white), // White text
              ),
              onTap: () {
                Get.back();
                _showRenameWatchlistDialog(context, watchlist);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                _showDeleteWatchlistDialog(context, watchlist);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameWatchlistDialog(BuildContext context, Watchlist watchlist) {
    controller.watchlistNameController.text = watchlist.name;

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900], // Dark dialog
        title: const Text(
          'Rename Watchlist',
          style: TextStyle(color: Colors.white), // White text
        ),
        content: TextField(
          controller: controller.watchlistNameController,
          style: const TextStyle(color: Colors.white), // White text
          decoration: InputDecoration(
            hintText: 'New name',
            hintStyle: TextStyle(color: Colors.grey[500]), // Grey hint text
            filled: true,
            fillColor: Colors.grey[800], // Dark input field
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!), // Dark border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[700]!), // Dark border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue), // Blue border when focused
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70, // Light white text
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.renameWatchlist(
                watchlist.id,
                controller.watchlistNameController.text,
              );
              Get.back();
            },
            child: const Text('Rename'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteWatchlistDialog(BuildContext context, Watchlist watchlist) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900], // Dark dialog
        title: const Text(
          'Delete Watchlist',
          style: TextStyle(color: Colors.white), // White text
        ),
        content: Text(
          'Do you want to delete ${watchlist.name}?',
          style: const TextStyle(color: Colors.white), // White text
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70, // Light white text
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteWatchlist(watchlist.id);
              Get.back();
              Get.snackbar(
                'Success',
                'Your Watchlist has been deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.grey[800],
                colorText: Colors.white,
              );
            },
            child: const Text('Yes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
