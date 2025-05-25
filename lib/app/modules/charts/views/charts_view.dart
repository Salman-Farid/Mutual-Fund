import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mutualfund/app/modules/charts/controllers/charts_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ChartsView extends GetView<ChartsController> {
  const ChartsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.selectedFund == null) {
          return const Center(
            child: Text(
              'Select a fund to view charts',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFundHeader(),
              _buildPerformanceMetrics(),
              _buildPerformanceComparison(),
              const SizedBox(height: 16),
              _buildChart(),
              const SizedBox(height: 16),
              _buildYearLabels(),
              const SizedBox(height: 8),
              _buildTimeRangeSelector(),
              const SizedBox(height: 24),
              _buildInvestmentAndReturnsSection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFundHeader() {
    final fund = controller.selectedFund!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fund.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Direct Growth',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '₹${fund.nav.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 16),
              Text(
                '${fund.oneDay >= 0 ? '+' : ''}${fund.oneDay.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: fund.oneDay >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[700]!,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildMetricColumn('Invested', '₹1.5k'),
            ),
            Container(
              width: 1,
              color: Colors.grey[600],
              margin: const EdgeInsets.only(left: 0, right: 16),
            ),
            Expanded(
              child: _buildMetricColumn('Current Value', '₹1.28k'),
            ),
            Container(
              width: 1,
              color: Colors.grey[600],
              margin: const EdgeInsets.only(left: 0, right: 16),
            ),
            Expanded(
              child: _buildMetricColumn('Total Gain', '₹-220.16', '-14.7', true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, [String? percentage, bool isNegative = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 8),
        if (percentage != null)
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isNegative ? Colors.white: Colors.red[400]  ,
                    ),
                    //overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.red[400],
                  size: 14,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    percentage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red[400],
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          )
        else
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
    );
  }

  Widget _buildPerformanceComparison() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 2,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Your Investments -19.75%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 2,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Nifty Midcap 150 -12.97%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final navHistory = controller.getFilteredNavHistory();

    if (navHistory.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final spots = navHistory.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final point = entry.value;
      return FlSpot(index, point.value);
    }).toList();

    // Create benchmark spots (slightly different performance)
    final benchmarkSpots = navHistory.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final point = entry.value;
      // Create a slightly different curve for the benchmark
      final benchmarkValue = point.value * (1 + (index % 10) / 100);
      return FlSpot(index, benchmarkValue);
    }).toList();

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Your investment line (blue)
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                ),
                // Benchmark line (orange)
                LineChartBarData(
                  spots: benchmarkSpots,
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.1),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      final index = touchedSpot.x.toInt();
                      if (index >= 0 && index < navHistory.length) {
                        final point = navHistory[index];
                        final isFirstLine = touchedSpot.barIndex == 0;
                        return LineTooltipItem(
                          '${DateFormat('dd-MM-yyyy').format(point.date)}\n₹${touchedSpot.y.toStringAsFixed(2)}',
                          TextStyle(
                            color: isFirstLine ? Colors.blue : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return null;
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                touchCallback: (event, touchResponse) {
                  if (event is FlTapUpEvent || event is FlPanEndEvent) {
                    controller.showTooltip.value = false;
                  } else if (touchResponse?.lineBarSpots != null &&
                      touchResponse!.lineBarSpots!.isNotEmpty) {
                    controller.showTooltip.value = true;
                  }
                },
              ),
              backgroundColor: Colors.black,
            ),
          ),
          Obx(() => controller.showTooltip.value
              ? Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '01-01-2022\nNAV: ₹105.40',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildYearLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('2022', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('2023', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('2024', style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text('2025', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: controller.timeRanges.map((range) {
          final isSelected = range == controller.selectedTimeRange.value;
          final isMax = range == 'MAX';

          return GestureDetector(
            onTap: () => controller.setTimeRange(range),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: isMax && !isSelected
                    ? Border.all(color: Colors.blue)
                    : null,
              ),
              child: Text(
                range,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isMax ? Colors.blue : Colors.grey),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInvestmentAndReturnsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Investment Calculator Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedInvestmentType.value == '1-Time'
                    ? 'If you invested ₹1L'
                    : 'If you invested p.m ₹1k',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),



              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  // color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color:  Colors.grey,
                    width: 1,
                  ),
                ),

                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.setInvestmentType('1-Time'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: controller.selectedInvestmentType.value == '1-Time'
                              ? const Color(0xFF2196F3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '1-Time',
                          style: TextStyle(
                            color: controller.selectedInvestmentType.value == '1-Time'
                                ? Colors.white
                                : const Color(0xFF9E9E9E),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.setInvestmentType('Monthly SIP'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: controller.selectedInvestmentType.value == 'Monthly SIP'
                              ? const Color(0xFF2196F3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Monthly SIP',
                          style: TextStyle(
                            color: controller.selectedInvestmentType.value == 'Monthly SIP'
                                ? Colors.white
                                : const Color(0xFF9E9E9E),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


          ],
          ),
          const SizedBox(height: 12),
          Obx(() => SfSlider(
            min: 1.0,
            max: 10.0,
            value: controller.sliderValue.value,
            interval: 9,
            showTicks: false,
            showLabels: true,
            enableTooltip: true,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.blueGrey.shade900,
            tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
              return '₹ ${actualValue.toInt()} L';
            },
            labelFormatterCallback: (dynamic actualValue, String formattedText) {
              return '₹ ${actualValue.toInt()} L';
            },
            onChanged: (dynamic value) {
              controller.sliderValue.value = value;
            },
          )),


          const SizedBox(height: 24),

          // Past Returns Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This Fund\'s past returns',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Row(
                children: [
                  Text(
                    controller.getTotalProfit(),
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    controller.getTotalProfitPercent(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Profit % (Absolute Return)',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 16),

          // Return Bars
          _buildReturnBars(),
        ],
      )),
    );
  }

  Widget _buildReturnBars() {
    final returnsData = controller.getReturnsData();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildReturnBarWithAmount(
            'Saving A/C',
            returnsData['savingAcc']!['percentage'],
            returnsData['savingAcc']!['amount'],
            Colors.grey[600]!
        ),
        _buildReturnBarWithAmount(
            'Category Avg.',
            returnsData['categoryAvg']!['percentage'],
            returnsData['categoryAvg']!['amount'],
            Colors.grey[600]!
        ),
        _buildReturnBarWithAmount(
            'Direct Plan',
            returnsData['directPlan']!['percentage'],
            returnsData['directPlan']!['amount'],
            const Color(0xFF4CAF50)
        ),
      ],
    );
  }

  Widget _buildReturnBarWithAmount(String label, double percentage, String amount, Color overlayColor) {
    return Column(
      children: [
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 40,
          height: 80,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Green background bar (full height)
              Container(
                width: 40,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Overlay bar from top (grey for lower values, transparent for green)
              if (overlayColor != const Color(0xFF4CAF50))
                Container(
                  width: 40,
                  height: (80 - (percentage / 20 * 80)).clamp(0, 80),
                  decoration: BoxDecoration(
                    color: overlayColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(

          width: 115,
          height: 1,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sell'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Invest More ↑'),
            ),
          ),
        ],
      ),
    );
  }
}
