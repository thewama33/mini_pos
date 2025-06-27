import 'package:equatable/equatable.dart';
import 'package:mini_pos/src/cart/bloc/cart_states.dart';
import 'package:mini_pos/src/cart/cart_model.dart';

/// Represents a receipt header with timestamp and store information
class ReceiptHeader extends Equatable {
  /// Creates a receipt header with the given [timestamp] and optional [storeInfo]
  const ReceiptHeader({
    required this.timestamp,
    this.storeInfo = 'Mini-POS Store',
  });

  /// Timestamp when the receipt was generated
  final DateTime timestamp;

  /// Store information
  final String storeInfo;

  @override
  List<Object?> get props => [timestamp, storeInfo];

  @override
  String toString() =>
      'ReceiptHeader(timestamp: $timestamp, store: $storeInfo)';
}

/// Represents a line item on the receipt
class ReceiptLine extends Equatable {
  /// Creates a receipt line from a [CartLine]
  const ReceiptLine({
    required this.itemId,
    required this.itemName,
    required this.unitPrice,
    required this.quantity,
    required this.discount,
    required this.lineNet,
  });

  /// Item ID
  final String itemId;

  /// Item name
  final String itemName;

  /// Unit price of the item
  final double unitPrice;

  /// Quantity purchased
  final int quantity;

  /// Discount percentage applied
  final double discount;

  /// Net amount for this line
  final double lineNet;

  /// Creates a ReceiptLine from a CartLine
  factory ReceiptLine.fromCartLine(CartLine cartLine) {
    return ReceiptLine(
      itemId: cartLine.item.id,
      itemName: cartLine.item.name,
      unitPrice: cartLine.item.price,
      quantity: cartLine.quantity,
      discount: cartLine.discount,
      lineNet: cartLine.lineNet,
    );
  }

  @override
  List<Object?> get props =>
      [itemId, itemName, unitPrice, quantity, discount, lineNet];

  @override
  String toString() =>
      'ReceiptLine($itemName x$quantity = L.E ${lineNet.toStringAsFixed(2)})';
}

/// Represents the receipt totals section
class ReceiptTotals extends Equatable {
  /// Creates receipt totals with the given values
  const ReceiptTotals({
    required this.subtotal,
    required this.vat,
    required this.grandTotal,
    required this.discount,
  });

  /// Subtotal before VAT
  final double subtotal;

  /// VAT amount
  final double vat;

  /// Grand total including VAT
  final double grandTotal;
  final int discount;

  /// Creates ReceiptTotals from CartTotals
  factory ReceiptTotals.fromCartTotals(CartTotals cartTotals) {
    return ReceiptTotals(
      subtotal: cartTotals.subtotal,
      vat: cartTotals.vat,
      grandTotal: cartTotals.grandTotal,
      discount: cartTotals.discount,
    );
  }

  @override
  List<Object?> get props => [subtotal, vat, grandTotal, discount];

  @override
  String toString() =>
      'ReceiptTotals(grandTotal: L.E ${grandTotal.toStringAsFixed(2)})';
}

/// Represents a complete receipt
class Receipt extends Equatable {
  /// Creates a receipt with the given [header], [lines], and [totals]
  const Receipt({
    required this.header,
    required this.lines,
    required this.totals,
  });

  /// Receipt header information
  final ReceiptHeader header;

  /// List of receipt line items
  final List<ReceiptLine> lines;

  /// Receipt totals
  final ReceiptTotals totals;

  @override
  List<Object?> get props => [header, lines, totals];

  @override
  String toString() =>
      'Receipt(${lines.length} items, total: L.E ${totals.grandTotal.toStringAsFixed(2)})';
}

/// Pure function to build a receipt from cart state and timestamp
Receipt buildReceipt(CartLoaded cartState, DateTime timestamp) {
  final header = ReceiptHeader(timestamp: timestamp);

  final lines = cartState.lines
      .map((cartLine) => ReceiptLine.fromCartLine(cartLine))
      .toList();

  final totals = ReceiptTotals.fromCartTotals(cartState.totals);

  return Receipt(
    header: header,
    lines: lines,
    totals: totals,
  );
}
