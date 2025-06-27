import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_pos/src/cart/bloc/cart_bloc.dart';
import 'package:mini_pos/src/cart/bloc/cart_events.dart';
import 'package:mini_pos/src/cart/bloc/cart_states.dart';
import 'package:mini_pos/src/catalog/model/item_model.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

late Storage hydratedStorage;

void initHydratedStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  hydratedStorage = MockStorage();
  when(
    () => hydratedStorage.write(any(), any<dynamic>()),
  ).thenAnswer((_) async {});
  HydratedBloc.storage = hydratedStorage;
}

void main() async {
  setUp(() async {
    initHydratedStorage();
  });

  // Use two items from catalog.json
  final coffee = Item(
      id: 'p01', name: 'Coffee', price: 2.5, category: 'Beverages', emoji: '☕');
  final bagel = Item(
      id: 'p02', name: 'Bagel', price: 3.2, category: 'Bakery', emoji: '🥯');

  CartBloc buildBloc() => CartBloc();

  group('CartBloc with HydratedBloc', () {
    blocTest<CartBloc, CartState>(
      '4. HydratedBloc restores state',
      build: () => CartBloc(),
      act: (bloc) => bloc
        ..add(AddItem(coffee))
        ..add(AddItem(bagel)),
      expect: () => [
        isA<CartLoaded>().having((s) => s.lines.length, 'after add 1', 1),
        isA<CartLoaded>().having((s) => s.lines.length, 'after add 2', 2),
      ],
    );
  });
  group('CartBloc', () {
    blocTest<CartBloc, CartState>(
      '1. Two different items → correct totals',
      build: buildBloc,
      act: (bloc) => bloc
        ..add(AddItem(coffee))
        ..add(AddItem(bagel)),
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.totals.grandTotal, 'total after coffee', 2.88),
        isA<CartLoaded>().having(
            (s) => s.totals.grandTotal, 'total after coffee+bagel', 6.55),
      ],
    );

    blocTest<CartBloc, CartState>(
      '2. Qty + discount changes update totals',
      build: buildBloc,
      act: (bloc) => bloc
        ..add(AddItem(coffee))
        ..add(ChangeQty(coffee.id, 3)) // 3 coffees
        ..add(ChangeDiscount(coffee.id, 0.2)), // 20% discount
      expect: () => [
        isA<CartLoaded>().having((s) => s.totals.grandTotal, 'after add', 2.88),
        isA<CartLoaded>()
            .having((s) => s.totals.grandTotal, 'after qty 3', 8.63),
        isA<CartLoaded>()
            .having((s) => s.totals.grandTotal, 'after 20% discount', 6.9),
      ],
    );

    blocTest<CartBloc, CartState>(
      '3. Clearing cart resets state',
      build: buildBloc,
      act: (bloc) => bloc
        ..add(AddItem(coffee))
        ..add(AddItem(bagel))
        ..add(ClearCart()),
      expect: () => [
        isA<CartLoaded>().having((s) => s.lines.length, 'after add 1', 1),
        isA<CartLoaded>().having((s) => s.lines.length, 'after add 2', 2),
        isA<CartLoaded>().having((s) => s.lines.length, 'after clear', 0),
      ],
    );
  });
}
