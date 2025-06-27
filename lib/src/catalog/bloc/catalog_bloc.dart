import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_events.dart';
import 'package:mini_pos/src/catalog/bloc/catalog_states.dart';

import '../model/item_model.dart';

/// BLoC for managing catalog state
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  /// Creates a CatalogBloc with optional [catalogPath]
  CatalogBloc({this.catalogPath = 'assets/catalog.json'})
      : super(const CatalogInitial()) {
    on<LoadCatalog>(_onLoadCatalog);
  }

  /// Path to the catalog JSON file
   String catalogPath;

  Future<void> _onLoadCatalog(
      LoadCatalog event, Emitter<CatalogState> emit) async {
    emit(const CatalogLoading());

    try {
      final jsonString = await rootBundle.loadString(catalogPath);
      if (jsonString.isEmpty) {
        emit(CatalogError("Catalog Is Empty"));
        return;
      }
      final jsonList = json.decode(jsonString) as List<dynamic>;

      final items = jsonList
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();

      emit(CatalogLoaded(items));
    } catch (error) {
      emit(CatalogError('Failed to load catalog: $error'));
    }
  }
}
