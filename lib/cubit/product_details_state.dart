import '../models/product_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;

  ProductDetailsLoaded(this.product);
}

class ProductDetailsUpdating extends ProductDetailsState {}

class ProductDetailsUpdateSuccess extends ProductDetailsState {
  final ProductModel product;

  ProductDetailsUpdateSuccess(this.product);
}

class ProductDetailsUpdateError extends ProductDetailsState {
  final ProductModel product;
  final String message;
  final dynamic exception;

  ProductDetailsUpdateError(this.product, this.message, {this.exception});
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  final dynamic exception;

  ProductDetailsError(this.message, {this.exception});
}
