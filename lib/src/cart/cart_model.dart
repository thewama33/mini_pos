import 'package:equatable/equatable.dart';
import '../catalog/model/item_model.dart';

/// Represents a line item in the shopping cart
class CartLine extends Equatable {
  /// Creates a cart line with the given [item], [quantity], and [discount]
  const CartLine({
    required this.item,
    required this.quantity,
    this.discount = 0.0,
  });

  /// The product item
  final Item item;

  /// Quantity of the item
  final int quantity;

  /// Discount percentage (0.0 to 1.0)
  final double discount;

  /// Calculates the net amount for this line
  /// Formula: price × qty × (1 – discount%)
  double get lineNet {
    final net = item.price * quantity * (1 - discount);
    return double.parse(net.toStringAsFixed(2));
  }

  /// Creates a [CartLine] from JSON data
  factory CartLine.fromJson(Map<String, dynamic> json) {
    return CartLine(
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      discount: (json['discount'] as num).toDouble(),
    );
  }

  /// Converts the [CartLine] to JSON format
  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'quantity': quantity,
      'discount': discount,
    };
  }

  /// Creates a copy of this CartLine with updated values
  CartLine copyWith({
    Item? item,
    int? quantity,
    double? discount,
  }) {
    return CartLine(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [item, quantity, discount];

  @override
  String toString() =>
      'CartLine(item: ${item.name}, qty: $quantity, discount: $discount)';
}

/// Represents the cart totals
class CartTotals extends Equatable {
  /// Creates cart totals with the given values
  const CartTotals({
    required this.subtotal,
    required this.vat,
    required this.grandTotal,
    required this.discount,
  });

  /// Subtotal before VAT
  final double subtotal;

  /// VAT amount (15% of subtotal)
  final double vat;

  /// Grand total including VAT
  final double grandTotal;
  final int discount;

  /// Creates empty totals (all zeros)
  static const CartTotals empty = CartTotals(
    subtotal: 0.0,
    vat: 0.0,
    grandTotal: 0.0,
    discount: 0,
  );

  /// Calculates totals from a list of cart lines
  factory CartTotals.fromLines(List<CartLine> lines) {
    final subtotal = lines.fold<double>(0.0, (sum, line) => sum + line.lineNet);
    final vat = subtotal * 0.15;
    final grandTotal = subtotal + vat;

    return CartTotals(
      subtotal: double.parse(subtotal.toStringAsFixed(2)),
      vat: double.parse(vat.toStringAsFixed(2)),
      grandTotal: double.parse(grandTotal.toStringAsFixed(2)),
      discount: lines.fold<int>(
          0, (sum, line) => sum + (line.discount * 100).toInt()),
    );
  }

  @override
  List<Object?> get props => [subtotal, vat, grandTotal, discount];

  @override
  String toString() =>
      'CartTotals(subtotal: $subtotal, vat: $vat, grandTotal: $grandTotal, discount: $discount)';
}
