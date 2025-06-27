import 'package:flutter/material.dart';
import 'package:mini_pos/core/extentions/money_extenstions.dart';
import 'package:mini_pos/src/cart/cart_model.dart';

/// Widget displaying cart totals
class CartTotalsWidget extends StatelessWidget {
  const CartTotalsWidget({super.key, required this.totals});

  final CartTotals totals;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:'),
                Text('L.E ${totals.subtotal.asMoney}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('VAT (15%):'),
                Text('L.E ${totals.vat.asMoney}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'L.E ${totals.grandTotal.asMoney}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
