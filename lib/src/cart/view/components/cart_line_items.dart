// cart_line_items.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_pos/core/extentions/money_extenstions.dart';
import 'package:mini_pos/src/cart/bloc/cart_bloc.dart';
import 'package:mini_pos/src/cart/bloc/cart_events.dart';
import 'package:mini_pos/src/cart/cart_model.dart';

class CartLineItem extends StatefulWidget {
  const CartLineItem({super.key, required this.line});

  final CartLine line;

  @override
  State<CartLineItem> createState() => _CartLineItemState();
}

class _CartLineItemState extends State<CartLineItem> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(widget.line.item.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.line.item.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'L.E ${widget.line.item.price.asMoney} each',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    // ADDED: Discount display and edit button
                    if (widget.line.discount > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Discount: ${(widget.line.discount * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (widget.line.quantity > 1) {
                            context.read<CartBloc>().add(
                                  ChangeQty(widget.line.item.id, widget.line.quantity - 1),
                                );
                          } else {
                            context.read<CartBloc>().add(
                                  RemoveItem(widget.line.item.id),
                                );
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      Text('${widget.line.quantity}'),
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                                ChangeQty(widget.line.item.id, widget.line.quantity + 1),
                              );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                  // ADDED: Discount edit button
                  TextButton.icon(
                    onPressed: () => _showDiscountDialog(
                        context, context.read<CartBloc>(), widget.line),
                    icon: Icon(
                      Icons.discount,
                      color: widget.line.discount > 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).disabledColor,
                    ),
                    label: Text(
                      widget.line.discount > 0
                          ? '${(widget.line.discount * 100).toStringAsFixed(0)}%'
                          : 'Add Discount',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.line.discount > 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                  Text(
                    'L.E ${widget.line.lineNet.asMoney}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          // ADDED: Highlight discounted price
                          color: widget.line.discount > 0
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiscountDialog(BuildContext context, CartBloc bloc, CartLine line) {
  final discountController = TextEditingController(
    text: (line.discount * 100).toStringAsFixed(0),
  );
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Set Discount for ${line.item.name}'),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: discountController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Discount Percentage',
                suffixText: '%',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a discount percentage';
                }
                final discountValue = double.tryParse(value);
                if (discountValue == null ||
                    discountValue <= 0 ||
                    discountValue > 100) {
                  return 'Please enter a valid discount percentage (0-100)';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Original: L.E ${(line.item.price * line.quantity).asMoney}\n'
              'Discounted: L.E ${line.lineNet.asMoney}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final discountValue =
                  double.tryParse(discountController.text) ?? 0;

              bloc.add(
                ChangeDiscount(
                  line.item.id,
                  discountValue.clamp(0, 100) / 100,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Apply'),
        ),
      ],
    ),
  );
}
}
