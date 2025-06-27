import 'package:equatable/equatable.dart';
import '../cart_model.dart';

/// Base class for cart states
abstract class CartState extends Equatable {
  const CartState();
}

/// Loading state for cart operations
class CartLoading extends CartState {
  const CartLoading();

  @override
  List<Object?> get props => [];
}

/// Error state for cart operations
class CartError extends CartState {
  const CartError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Loaded state containing cart data
class CartLoaded extends CartState {
  const CartLoaded({
    required this.lines,
    required this.totals,
  });

  final List<CartLine> lines;
  final CartTotals totals;

  static CartLoaded get empty => const CartLoaded(
        lines: <CartLine>[],
        totals: CartTotals.empty,
      );

  factory CartLoaded.fromLines(List<CartLine> lines) {
    return CartLoaded(
      lines: lines,
      totals: CartTotals.fromLines(lines),
    );
  }

  CartLoaded copyWith({
    List<CartLine>? lines,
    CartTotals? totals,
  }) {
    return CartLoaded(
      lines: lines ?? this.lines,
      totals: totals ?? this.totals,
    );
  }

  @override
  List<Object?> get props => [lines, totals];
}
