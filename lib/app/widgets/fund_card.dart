import 'package:flutter/material.dart';
import 'package:mutualfund/app/data/models/mutual_fund.dart';

class FundCard extends StatelessWidget {
  final MutualFund fund;
  final VoidCallback? onTap;
  final Widget? trailing;
  
  const FundCard({
    Key? key,
    required this.fund,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey[900], // Dark card
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fund.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${fund.category} | ${fund.subcategory}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70, // Light white text
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildReturnChip('1Y', fund.oneYear),
                        const SizedBox(width: 8),
                        _buildReturnChip('3Y', fund.threeYear),
                        const SizedBox(width: 8),
                        _buildReturnChip('5Y', fund.fiveYear),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'NAV ₹${fund.nav}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1D ${fund.oneDay >= 0 ? '+' : ''}${fund.oneDay}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: fund.oneDay >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exp. Ratio ${fund.expenseRatio}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70, // Light white text
                    ),
                  ),
                ],
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildReturnChip(String period, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800], // Dark chip
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$period ${value.toStringAsFixed(1)}%',
        style: TextStyle(
          fontSize: 10,
          color: value >= 0 ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
