import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mutualfund/app/data/models/mutual_fund.dart';
import '../controllers/fund_detail_controller.dart';

class FundDetailView extends GetView<FundDetailController> {
  const FundDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        backgroundColor: Colors.black, // Dark app bar
        title: Obx(() => controller.fund.value == null
            ? const Text('Fund Details', style: TextStyle(color: Colors.white)) // White text
            : Text(
          controller.fund.value!.name,
          style: const TextStyle(fontSize: 16, color: Colors.white), // White text
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
        actions: [
          Obx(() => controller.isLoading.value
              ? const SizedBox.shrink()
              : IconButton(
            icon: Icon(
              controller.isInWatchlist.value
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: controller.isInWatchlist.value ? Colors.blue : Colors.white, // White icon
            ),
            onPressed: controller.toggleWatchlist,
            tooltip: controller.isInWatchlist.value
                ? 'Remove from Watchlist'
                : 'Add to Watchlist',
          )),
        ],
      ),
      body: Obx(() {
        if (controller.fund.value == null) {
          return const Center(
            child: Text(
              'Fund not found',
              style: TextStyle(color: Colors.white), // White text
            ),
          );
        }

        if (controller.isLoading.value) {
          return const LoadingIndicator();
        }

        final fund = controller.fund.value!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFundHeader(fund),
                const SizedBox(height: 24),
                _buildWatchlistStatus(),
                const SizedBox(height: 24),
                _buildFundDetails(fund),
                const SizedBox(height: 24),
                _buildPastReturnsSection(fund),
                const SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFundHeader(MutualFund fund) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fund.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${fund.category} Fund", // Using category as fund house
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildWatchlistStatus() {
    return Obx(() => Row(
      children: [
        Icon(
          controller.isInWatchlist.value ? Icons.bookmark : Icons.bookmark_border,
          color: controller.isInWatchlist.value ? Colors.blue : Colors.white,
        ),
        const SizedBox(width: 8),
        Text(
          controller.isInWatchlist.value ? 'In Watchlist' : 'Add to Watchlist',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    ));
  }

  Widget _buildFundDetails(MutualFund fund) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fund Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Category', fund.category),
        _buildDetailRow('Subcategory', fund.subcategory),
        _buildDetailRow('NAV', '₹${fund.nav.toStringAsFixed(2)}'),
        _buildDetailRow('Expense Ratio', '${fund.expenseRatio}%'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPastReturnsSection(MutualFund fund) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Past Returns',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildReturnsRow('1 Year', fund.oneYear),
        _buildReturnsRow('3 Year', fund.threeYear),
        _buildReturnsRow('5 Year', fund.fiveYear),
      ],
    );
  }

  Widget _buildReturnsRow(String label, double value) {
    final formattedValue = NumberFormat('##.##').format(value);
    final isPositive = value >= 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            '$formattedValue%',
            style: TextStyle(
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // TODO: Implement invest action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Invest Now'),
        ),
        OutlinedButton(
          onPressed: () {
            // TODO: Implement compare action
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue),
            foregroundColor: Colors.blue,
          ),
          child: const Text('Compare'),
        ),
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
