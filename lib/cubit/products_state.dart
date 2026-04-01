import 'package:equatable/equatable.dart';
import '../models/product_model.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductsState {
  final String message;
  final dynamic exception;

  const ProductsError(this.message, {this.exception});

  @override
  List<Object?> get props => [message, exception];
}

class ProductsRefreshing extends ProductsState {
  final List<ProductModel> products;

  const ProductsRefreshing(this.products);

  @override
  List<Object?> get props => [products];
}