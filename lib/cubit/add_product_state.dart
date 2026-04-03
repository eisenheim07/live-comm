import '../models/product_model.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final ProductModel product;

  AddProductSuccess(this.product);
}

class AddProductError extends AddProductState {
  final String message;
  final dynamic exception;

  AddProductError(this.message, {this.exception});
}
