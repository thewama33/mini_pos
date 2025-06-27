import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_bloc.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_events.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_states.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

late Storage hydratedStorage;

void initHydratedStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  hydratedStorage = MockStorage();
  when(() => hydratedStorage.write(any(), any<dynamic>()))
      .thenAnswer((_) async {});
  HydratedBloc.storage = hydratedStorage;
}

void main() {
  setUp(() async {
    initHydratedStorage();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  group('CatalogBloc', () {
    blocTest<CatalogBloc, CatalogState>(
      '1. Initial state is CatalogInitial',
      build: () => CatalogBloc(),
      verify: (bloc) => expect(bloc.state, isA<CatalogInitial>()),
    );

    blocTest<CatalogBloc, CatalogState>(
      '2. Loading catalog emits CatalogLoading then CatalogLoaded',
      build: () {
        // Mock the asset bundle to return the catalog.json string
        const catalogJson = '''
        [
          {"id":"p01","name":"Coffee","price":2.5,"category":"Beverages","emoji":"☕"},
          {"id":"p02","name":"Bagel","price":3.2,"category":"Bakery","emoji":"🥯"}
        ]
        ''';
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler(
          'flutter/assets',
          (message) async => ByteData.view(
              Uint8List.fromList(utf8.encode(catalogJson)).buffer),
        );
        return CatalogBloc();
      },
      act: (bloc) => bloc.add(LoadCatalog()),
      expect: () => [
        isA<CatalogLoading>(),
        isA<CatalogLoaded>().having((s) => s.items.length, 'items length', 2),
      ],
    );
  });
}
