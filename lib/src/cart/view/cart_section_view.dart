import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_pos/src/cart/bloc/cart_bloc.dart';
import 'package:mini_pos/src/cart/bloc/cart_events.dart';
import 'package:mini_pos/src/cart/bloc/cart_states.dart';
import 'package:mini_pos/src/cart/receipt.dart';
import 'package:mini_pos/src/cart/view/components/cart_line_items.dart';
import 'package:mini_pos/src/cart/view/widgets/cart_total_widget.dart';
import 'package:mini_pos/src/cart/view/widgets/receipt_dialog_widget.dart';

/// Widget displaying the shopping cart
class CartSection extends StatelessWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cart',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is! CartLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.lines.isEmpty) {
                  return const Center(
                    child: Text('Cart is empty\nTap items to add them'),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.lines.length,
                        itemBuilder: (context, index) {
                          final line = state.lines[index];
                          return CartLineItem(line: line);
                        },
                      ),
                    ),
                    CartTotalsWidget(totals: state.totals),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<CartBloc>().add(const ClearCart());
                            },
                            child: const Text('Clear Cart'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              _showReceipt(context, state);
                            },
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showReceipt(BuildContext context, CartLoaded cartState) {
    final receipt = buildReceipt(cartState, DateTime.now());

    showDialog(
      context: context,
      builder: (context) => ReceiptDialog(receipt: receipt),
    );
  }
}
