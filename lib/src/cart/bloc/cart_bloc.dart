// cart_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_pos/src/cart/bloc/cart_events.dart';
import 'package:mini_pos/src/cart/bloc/cart_states.dart';
import 'package:mini_pos/src/cart/cart_model.dart';
import 'package:mini_pos/src/catalog/model/item_model.dart';
import 'package:replay_bloc/replay_bloc.dart';

class CartBloc extends HydratedBloc<CartEvent, CartState> with ReplayBlocMixin {
  CartBloc() : super(CartLoaded.empty) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ChangeQty>(_onChangeQty);
    on<ChangeDiscount>(_onChangeDiscount);
    on<ClearCart>(_onClearCart);
    on<UndoAction>(_onUndo);
    on<RedoAction>(_onRedo);
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    // Create new list instead of mutating existing
    final newLines = List<CartLine>.from(currentState.lines);
    final existingIndex =
        newLines.indexWhere((line) => line.item.id == event.item.id);

    if (existingIndex >= 0) {
      final existingLine = newLines[existingIndex];
      newLines[existingIndex] = existingLine.copyWith(
        quantity: existingLine.quantity + 1,
      );
    } else {
      newLines.add(CartLine(item: event.item, quantity: 1));
    }

    // Always create new state with new instances
    emit(CartLoaded.fromLines(newLines));
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    // Create filtered list instead of mutating
    final newLines = currentState.lines
        .where((line) => line.item.id != event.itemId)
        .toList();

    emit(CartLoaded.fromLines(newLines));
  }

  void _onChangeQty(ChangeQty event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    if (event.newQuantity <= 0) {
      add(RemoveItem(event.itemId));
      return;
    }

    // Create new list with updated quantity
    final newLines = currentState.lines.map((line) {
      return line.item.id == event.itemId
          ? line.copyWith(quantity: event.newQuantity)
          : line;
    }).toList();

    emit(CartLoaded.fromLines(newLines));
  }

  void _onChangeDiscount(ChangeDiscount event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    final clampedDiscount = event.newDiscount.clamp(0.0, 1.0);

    // Create new list with updated discount
    final newLines = currentState.lines.map((line) {
      return line.item.id == event.itemId
          ? line.copyWith(discount: clampedDiscount)
          : line;
    }).toList();

    emit(CartLoaded.fromLines(newLines));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartLoaded.empty);
  }

  void _onUndo(UndoAction event, Emitter<CartState> emit) => undo();
  void _onRedo(RedoAction event, Emitter<CartState> emit) => redo();

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      final linesJson = json['lines'] as List<dynamic>?;
      if (linesJson == null) return CartLoaded.empty;

      final lines = linesJson.map((lineJson) {
        final itemJson = lineJson['item'] as Map<String, dynamic>;
        return CartLine(
          item: Item.fromJson(itemJson),
          quantity: lineJson['quantity'] as int,
          discount: (lineJson['discount'] as num).toDouble(),
        );
      }).toList();

      return CartLoaded.fromLines(lines);
    } catch (e) {
      return CartLoaded.empty;
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    if (state is CartLoaded) {
      return {
        'lines': state.lines.map((line) => line.toJson()).toList(),
      };
    }
    return null;
  }
}
