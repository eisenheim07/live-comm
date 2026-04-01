import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';
import '../utils/size_utils.dart';
import '../utils/configs.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/error_bottom_sheet.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel? product;
  final String? productId;

  const ProductDetailsScreen({super.key, this.product, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _discountPriceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  bool _isPriceEnabled = false;
  bool _isDiscountPriceEnabled = false;
  bool _isDescriptionEnabled = false;
  bool _isCategoryEnabled = false;

  String? _selectedCategory;
  bool? _isLiveProduct;

  bool _isFieldsPopulated = false;

  String? _priceError;
  String? _discountPriceError;
  String? _descriptionError;

  final List<String> _categories = ['Electronics', 'Beauty', 'Hardware'];

  @override
  void initState() {
    super.initState();
    // Initialize with product data if available
    if (widget.product != null) {
      _populateFields(widget.product!);
      _isFieldsPopulated = true;
    }

    // Add listeners to validate on change
    _priceController.addListener(_validatePrice);
    _discountPriceController.addListener(_validateDiscountPrice);
    _descriptionController.addListener(_validateDescription);
  }

  @override
  void dispose() {
    _priceController.removeListener(_validatePrice);
    _discountPriceController.removeListener(_validateDiscountPrice);
    _descriptionController.removeListener(_validateDescription);
    _priceController.dispose();
    _discountPriceController.dispose();
    _descriptionController.dispose();
    _priceFocusNode.dispose();
    _discountPriceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _validatePrice() {
    setState(() {
      if (!_isPriceEnabled) return;

      final value = _priceController.text.trim();

      if (value.isEmpty) {
        _priceError = 'Price is required';
        return;
      }

      final price = double.tryParse(value);
      if (price == null) {
        _priceError = 'Price must be a valid number';
        return;
      }

      if (price <= 0) {
        _priceError = 'Price must be greater than 0';
        return;
      }

      // Check format: max 8 digits before decimal, 2 after
      final parts = value.split('.');
      if (parts[0].length > 8) {
        _priceError = 'Price can have maximum 8 digits before decimal';
        return;
      }

      if (parts.length > 1 && parts[1].length > 2) {
        _priceError = 'Price can have maximum 2 digits after decimal';
        return;
      }

      // Check if price is greater than discount price
      final discountPrice = double.tryParse(_discountPriceController.text.trim());
      if (discountPrice != null && discountPrice > 0 && price <= discountPrice) {
        _priceError = 'Price must be greater than discount price';
        return;
      }

      _priceError = null;
    });
  }

  void _validateDiscountPrice() {
    setState(() {
      if (!_isDiscountPriceEnabled && _discountPriceController.text.trim().isNotEmpty) {
        // If not editing but has value, still validate for display
        final value = _discountPriceController.text.trim();
        final discountPrice = double.tryParse(value);
        final price = double.tryParse(_priceController.text.trim());

        if (discountPrice != null && price != null && discountPrice > 0 && discountPrice >= price) {
          _discountPriceError = 'Discount price must be less than price';
          return;
        }
      }

      if (!_isDiscountPriceEnabled) return;

      final value = _discountPriceController.text.trim();

      if (value.isEmpty) {
        _discountPriceError = null; // Discount price is optional
        // Re-validate price field as discount price changed
        _revalidatePriceField();
        return;
      }

      final discountPrice = double.tryParse(value);
      if (discountPrice == null) {
        _discountPriceError = 'Discount price must be a valid number';
        return;
      }

      if (discountPrice < 0) {
        _discountPriceError = 'Discount price cannot be negative';
        return;
      }

      // Check format: max 8 digits before decimal, 2 after
      final parts = value.split('.');
      if (parts[0].length > 8) {
        _discountPriceError = 'Discount price can have maximum 8 digits before decimal';
        return;
      }

      if (parts.length > 1 && parts[1].length > 2) {
        _discountPriceError = 'Discount price can have maximum 2 digits after decimal';
        return;
      }

      // Check if discount price is less than price
      final price = double.tryParse(_priceController.text.trim());
      if (price != null && discountPrice > 0 && discountPrice >= price) {
        _discountPriceError = 'Discount price must be less than price';
        return;
      }

      _discountPriceError = null;

      // Re-validate price field as discount price changed
      _revalidatePriceField();
    });
  }

  void _revalidatePriceField() {
    // Re-validate price field without requiring it to be enabled
    final value = _priceController.text.trim();

    if (value.isEmpty) {
      _priceError = null;
      return;
    }

    final price = double.tryParse(value);
    if (price == null) {
      return; // Keep existing error or no error
    }

    if (price <= 0) {
      return; // Keep existing error
    }

    // Check if price is greater than discount price
    final discountPrice = double.tryParse(_discountPriceController.text.trim());
    if (discountPrice != null && discountPrice > 0 && price <= discountPrice) {
      _priceError = 'Price must be greater than discount price';
      return;
    }

    // Clear price error if discount price is now valid
    if (_priceError == 'Price must be greater than discount price') {
      _priceError = null;
    }
  }

  void _validateDescription() {
    setState(() {
      if (!_isDescriptionEnabled) return;

      final value = _descriptionController.text.trim();

      if (value.isEmpty) {
        _descriptionError = 'Description is required';
        return;
      }

      if (value.length < 100) {
        _descriptionError = 'Description must be at least 100 characters';
        return;
      }

      if (value.length > 1000) {
        _descriptionError = 'Description cannot exceed 1000 characters';
        return;
      }

      // Check for emojis using regex
      final emojiRegex = RegExp(
        r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA70}-\u{1FAFF}]|[\u{1F018}-\u{1F270}]|[\u{238C}-\u{2454}]|[\u{20D0}-\u{20FF}]',
        unicode: true,
      );

      if (emojiRegex.hasMatch(value)) {
        _descriptionError = 'Description cannot contain emojis';
        return;
      }

      _descriptionError = null;
    });
  }

  String _formatPrice(String value) {
    if (value.isEmpty) return value;

    final price = double.tryParse(value);
    if (price == null) return value;

    // Format to always include .0 if no decimal
    if (!value.contains('.')) {
      return '${price.toStringAsFixed(0)}.0';
    }

    // Ensure 2 decimal places max
    final parts = value.split('.');
    if (parts.length > 1) {
      if (parts[1].isEmpty) {
        return '${parts[0]}.0';
      } else if (parts[1].length == 1) {
        return value; // Keep single decimal as is
      } else {
        return price.toStringAsFixed(2);
      }
    }

    return value;
  }

  void _populateFields(ProductModel product) {
    _priceController.text = product.price?.toString() ?? '';
    _discountPriceController.text = product.discountPrice?.toString() ?? '';
    _descriptionController.text = product.description ?? '';

    // Capitalize first letter of category to match dropdown items
    if (product.categoryId != null && product.categoryId!.isNotEmpty) {
      final categoryLower = product.categoryId!.toLowerCase();
      _selectedCategory = _categories.firstWhere((cat) => cat.toLowerCase() == categoryLower, orElse: () => _categories.first);
    }

    _isLiveProduct = product.isLiveProduct;
    _isFieldsPopulated = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProductDetailsCubit();
        if (widget.product != null) {
          cubit.loadProduct(widget.product!);
        } else if (widget.productId != null) {
          cubit.fetchProductDetails(widget.productId!);
        }
        return cubit;
      },
      child: ProductDetailsView(
        priceController: _priceController,
        discountPriceController: _discountPriceController,
        descriptionController: _descriptionController,
        priceFocusNode: _priceFocusNode,
        discountPriceFocusNode: _discountPriceFocusNode,
        descriptionFocusNode: _descriptionFocusNode,
        isPriceEnabled: _isPriceEnabled,
        isDiscountPriceEnabled: _isDiscountPriceEnabled,
        isDescriptionEnabled: _isDescriptionEnabled,
        isCategoryEnabled: _isCategoryEnabled,
        selectedCategory: _selectedCategory,
        isLiveProduct: _isLiveProduct,
        categories: _categories,
        priceError: _priceError,
        discountPriceError: _discountPriceError,
        descriptionError: _descriptionError,
        onPriceEditToggle: () => setState(() {
          if (!_isPriceEnabled) {
            // Before enabling price field, format other fields if they were being edited
            if (_isDiscountPriceEnabled) {
              final value = _discountPriceController.text.trim();
              if (value.isNotEmpty) {
                _discountPriceController.text = _formatPrice(value);
              }
              _validateDiscountPrice();
              if (_discountPriceError != null) {
                // Don't switch if there's an error
                return;
              }
            }

            // Enabling price field, disable others
            _isDiscountPriceEnabled = false;
            _isDescriptionEnabled = false;
            _isCategoryEnabled = false;
            _priceError = null;
            // Request focus after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _priceFocusNode.requestFocus();
            });
          } else {
            // Disabling price field - format and validate
            final value = _priceController.text.trim();
            if (value.isNotEmpty) {
              _priceController.text = _formatPrice(value);
            }
            _validatePrice();
            if (_priceError != null) {
              // Don't disable if there's an error
              return;
            }
          }
          _isPriceEnabled = !_isPriceEnabled;
        }),
        onDiscountPriceEditToggle: () => setState(() {
          if (!_isDiscountPriceEnabled) {
            // Before enabling discount price field, format other fields if they were being edited
            if (_isPriceEnabled) {
              final value = _priceController.text.trim();
              if (value.isNotEmpty) {
                _priceController.text = _formatPrice(value);
              }
              _validatePrice();
              if (_priceError != null) {
                // Don't switch if there's an error
                return;
              }
            }

            // Enabling discount price field, disable others
            _isPriceEnabled = false;
            _isDescriptionEnabled = false;
            _isCategoryEnabled = false;
            _discountPriceError = null;
            // Request focus after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _discountPriceFocusNode.requestFocus();
            });
          } else {
            // Disabling discount price field - format and validate
            final value = _discountPriceController.text.trim();
            if (value.isNotEmpty) {
              _discountPriceController.text = _formatPrice(value);
            }
            _validateDiscountPrice();
            if (_discountPriceError != null) {
              // Don't disable if there's an error
              return;
            }
          }
          _isDiscountPriceEnabled = !_isDiscountPriceEnabled;
        }),
        onDescriptionEditToggle: () => setState(() {
          if (!_isDescriptionEnabled) {
            // Before enabling description field, format price fields if they were being edited
            if (_isPriceEnabled) {
              final value = _priceController.text.trim();
              if (value.isNotEmpty) {
                _priceController.text = _formatPrice(value);
              }
              _validatePrice();
              if (_priceError != null) {
                // Don't switch if there's an error
                return;
              }
            }

            if (_isDiscountPriceEnabled) {
              final value = _discountPriceController.text.trim();
              if (value.isNotEmpty) {
                _discountPriceController.text = _formatPrice(value);
              }
              _validateDiscountPrice();
              if (_discountPriceError != null) {
                // Don't switch if there's an error
                return;
              }
            }

            // Enabling description field, disable others
            _isPriceEnabled = false;
            _isDiscountPriceEnabled = false;
            _isCategoryEnabled = false;
            _descriptionError = null;
            // Request focus after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _descriptionFocusNode.requestFocus();
            });
          } else {
            // Disabling description field - validate
            _validateDescription();
            if (_descriptionError != null) {
              // Don't disable if there's an error
              return;
            }
          }
          _isDescriptionEnabled = !_isDescriptionEnabled;
        }),
        onCategoryEditToggle: () => setState(() {
          if (!_isCategoryEnabled) {
            // Before enabling category field, format price fields if they were being edited
            if (_isPriceEnabled) {
              final value = _priceController.text.trim();
              if (value.isNotEmpty) {
                _priceController.text = _formatPrice(value);
              }
              _validatePrice();
              if (_priceError != null) {
                // Don't switch if there's an error
                return;
              }
            }

            if (_isDiscountPriceEnabled) {
              final value = _discountPriceController.text.trim();
              if (value.isNotEmpty) {
                _discountPriceController.text = _formatPrice(value);
              }
              _validateDiscountPrice();
              if (_discountPriceError != null) {
                // Don't switch if there's an error
                return;
              }
            }

            // Enabling category field, disable others
            _isPriceEnabled = false;
            _isDiscountPriceEnabled = false;
            _isDescriptionEnabled = false;
          }
          _isCategoryEnabled = !_isCategoryEnabled;
        }),
        onCategoryChanged: (value) => setState(() => _selectedCategory = value),
        onStatusChanged: (value) => setState(() => _isLiveProduct = value),
        onPopulateFields: (product) {
          if (!_isFieldsPopulated) {
            setState(() {
              _populateFields(product);
            });
          }
        },
      ),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController discountPriceController;
  final TextEditingController descriptionController;
  final FocusNode priceFocusNode;
  final FocusNode discountPriceFocusNode;
  final FocusNode descriptionFocusNode;
  final bool isPriceEnabled;
  final bool isDiscountPriceEnabled;
  final bool isDescriptionEnabled;
  final bool isCategoryEnabled;
  final String? selectedCategory;
  final bool? isLiveProduct;
  final List<String> categories;
  final String? priceError;
  final String? discountPriceError;
  final String? descriptionError;
  final VoidCallback onPriceEditToggle;
  final VoidCallback onDiscountPriceEditToggle;
  final VoidCallback onDescriptionEditToggle;
  final VoidCallback onCategoryEditToggle;
  final Function(String?) onCategoryChanged;
  final Function(bool?) onStatusChanged;
  final Function(ProductModel) onPopulateFields;

  const ProductDetailsView({
    super.key,
    required this.priceController,
    required this.discountPriceController,
    required this.descriptionController,
    required this.priceFocusNode,
    required this.discountPriceFocusNode,
    required this.descriptionFocusNode,
    required this.isPriceEnabled,
    required this.isDiscountPriceEnabled,
    required this.isDescriptionEnabled,
    required this.isCategoryEnabled,
    required this.selectedCategory,
    required this.isLiveProduct,
    required this.categories,
    required this.priceError,
    required this.discountPriceError,
    required this.descriptionError,
    required this.onPriceEditToggle,
    required this.onDiscountPriceEditToggle,
    required this.onDescriptionEditToggle,
    required this.onCategoryEditToggle,
    required this.onCategoryChanged,
    required this.onStatusChanged,
    required this.onPopulateFields,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        if (state is ProductDetailsError) {
          final exception = state.exception;
          if (exception is ApiException) {
            ErrorBottomSheet.showError(context: context, title: exception.errorTitle, message: exception.displayMessage, buttonText: 'Got it');
          } else {
            ErrorBottomSheet.showError(context: context, title: 'Error!', message: state.message, buttonText: 'Got it');
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            toolbarHeight: SizeUtils.getHeight(50),
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(SizeUtils.spacing8),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius8)),
                    child: Icon(Icons.arrow_back, color: AppColors.primary, size: SizeUtils.getWidth(16)),
                  ),
                ),
                AppConstants.mediumHorizontalSpace,
                Expanded(
                  child: Text(
                    'Product Details',
                    style: AppTextStyles.bodyMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600).copyWith(fontSize: SizeUtils.font14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(child: _buildBody(context, state)),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailsState state) {
    if (state is ProductDetailsLoading) {
      return _buildLoadingState();
    } else if (state is ProductDetailsLoaded) {
      // Populate fields when data is loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onPopulateFields(state.product);
      });
      return _buildProductDetails(state.product);
    } else if (state is ProductDetailsError) {
      return _buildErrorState(context);
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: SizeUtils.scaffoldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(250)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: SizeUtils.getWidth(120), height: SizeUtils.getHeight(20)),
          AppConstants.smallVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(16)),
          AppConstants.smallVerticalSpace,
          _ShimmerBox(width: SizeUtils.getWidth(150), height: SizeUtils.getHeight(28)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
        ],
      ),
    );
  }

  Widget _buildProductDetails(ProductModel product) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => AppConstants.getCloseKeyboard(context),
        child: SingleChildScrollView(
          padding: SizeUtils.scaffoldPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product),
              AppConstants.mediumVerticalSpace,
              _buildProductHeader(product),
              AppConstants.mediumVerticalSpace,
              _buildStatusField(),
              AppConstants.mediumVerticalSpace,
              _buildPriceFields(),
              AppConstants.mediumVerticalSpace,
              _buildDescriptionField(),
              AppConstants.mediumVerticalSpace,
              _buildCategoryField(),
              AppConstants.mediumVerticalSpace,
              _buildAdditionalInfo(product),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    return Container(
      height: SizeUtils.getHeight(250),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.border.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius4)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeUtils.radius4),
        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
            ? Image.network(
                product.imageUrl!,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.border.withOpacity(0.1),
      child: Center(
        child: Icon(Icons.image_outlined, size: SizeUtils.getWidth(64), color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      color: AppColors.border.withOpacity(0.1),
      child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
    );
  }

  Widget _buildProductHeader(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.store_outlined, size: SizeUtils.getWidth(16), color: AppColors.textSecondary),
            AppConstants.smallHorizontalSpace,
            Expanded(
              child: Text(
                product.shopName ?? 'Unknown Shop',
                style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (product.isLiveProduct == true) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing8, vertical: SizeUtils.spacing4),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius4)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: SizeUtils.getWidth(6),
                      height: SizeUtils.getWidth(6),
                      decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    ),
                    AppConstants.smallHorizontalSpace,
                    Text(
                      'LIVE',
                      style: AppTextStyles.bodySmall(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: SizeUtils.getFontSize(10)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        AppConstants.smallVerticalSpace,
        Text(
          product.title ?? 'Untitled Product',
          style: AppTextStyles.titleLarge(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return Container(
      padding: SizeUtils.cardPaddingSmall,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status',
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
          ),
          AppConstants.smallVerticalSpace,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onStatusChanged(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: SizeUtils.spacing12),
                    decoration: BoxDecoration(
                      color: isLiveProduct == true ? AppColors.success.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(SizeUtils.radius6),
                      border: Border.all(color: isLiveProduct == true ? AppColors.success : AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeUtils.getWidth(8),
                          height: SizeUtils.getWidth(8),
                          decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                        ),
                        AppConstants.smallHorizontalSpace,
                        Text(
                          'LIVE',
                          style: AppTextStyles.bodySmall(color: AppColors.success, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppConstants.smallHorizontalSpace,
              Expanded(
                child: GestureDetector(
                  onTap: () => onStatusChanged(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: SizeUtils.spacing12),
                    decoration: BoxDecoration(
                      color: isLiveProduct == false ? AppColors.error.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(SizeUtils.radius6),
                      border: Border.all(color: isLiveProduct == false ? AppColors.error : AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        'CLOSED',
                        style: AppTextStyles.bodySmall(color: AppColors.error, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceFields() {
    return Container(
      padding: SizeUtils.cardPaddingSmall,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField(
            label: 'Price',
            controller: priceController,
            focusNode: priceFocusNode,
            isEnabled: isPriceEnabled,
            onEditToggle: onPriceEditToggle,
            keyboardType: TextInputType.number,
            prefixText: '₹ ',
            errorText: priceError,
          ),
          AppConstants.smallVerticalSpace,
          _buildEditableField(
            label: 'Discount Price',
            controller: discountPriceController,
            focusNode: discountPriceFocusNode,
            isEnabled: isDiscountPriceEnabled,
            onEditToggle: onDiscountPriceEditToggle,
            keyboardType: TextInputType.number,
            prefixText: '₹ ',
            errorText: discountPriceError,
          ),
          _buildDiscountBadge(),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    final originalPrice = double.tryParse(priceController.text) ?? 0;
    final discountedPrice = double.tryParse(discountPriceController.text) ?? 0;
    final hasDiscount = discountedPrice > 0 && discountedPrice < originalPrice;

    if (!hasDiscount) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppConstants.smallVerticalSpace,
        Container(
          margin: EdgeInsets.only(bottom: SizeUtils.spacing2, left: SizeUtils.spacing2),
          padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing4, vertical: SizeUtils.spacing2),
          decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(SizeUtils.radius4)),
          child: Text(
            '${_calculateDiscountPercentage(originalPrice, discountedPrice)}% OFF',
            style: AppTextStyles.bodySmall(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: SizeUtils.getFontSize(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: SizeUtils.cardPaddingSmall,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField(
            label: 'Description',
            controller: descriptionController,
            focusNode: descriptionFocusNode,
            isEnabled: isDescriptionEnabled,
            onEditToggle: onDescriptionEditToggle,
            maxLines: 5,
            errorText: descriptionError,
          ),
          if (isDescriptionEnabled) ...[
            AppConstants.smallVerticalSpace,
            Text(
              '${descriptionController.text.trim().length}/1000 characters (min: 100)',
              style: AppTextStyles.bodySmall(
                color: descriptionController.text.trim().length < 100
                    ? AppColors.error
                    : descriptionController.text.trim().length > 1000
                    ? AppColors.error
                    : AppColors.textSecondary,
                fontSize: SizeUtils.getFontSize(10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryField() {
    return Container(
      padding: SizeUtils.cardPaddingSmall,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Category',
                  style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
                ),
              ),
              GestureDetector(
                onTap: onCategoryEditToggle,
                child: Icon(isCategoryEnabled ? Icons.check : Icons.edit_outlined, size: SizeUtils.getWidth(16), color: AppColors.primary),
              ),
            ],
          ),
          AppConstants.smallVerticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(SizeUtils.radius6),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
              dropdownColor: AppColors.surface,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  enabled: isCategoryEnabled,
                  child: Text(category, style: AppTextStyles.bodyMedium(color: AppColors.textPrimary)),
                );
              }).toList(),
              onChanged: isCategoryEnabled ? onCategoryChanged : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isEnabled,
    required VoidCallback onEditToggle,
    TextInputType? keyboardType,
    String? prefixText,
    String? errorText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
              ),
            ),
            GestureDetector(
              onTap: onEditToggle,
              child: Icon(isEnabled ? Icons.check : Icons.edit_outlined, size: SizeUtils.getWidth(16), color: AppColors.primary),
            ),
          ],
        ),
        AppConstants.smallVerticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(SizeUtils.radius6),
            border: Border.all(color: errorText != null ? AppColors.error : AppColors.border),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            readOnly: !isEnabled,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: keyboardType == TextInputType.number
                ? [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    _DecimalTextInputFormatter(maxDigitsBeforeDecimal: 8, maxDigitsAfterDecimal: 2),
                  ]
                : maxLines > 1
                ? [
                    LengthLimitingTextInputFormatter(1000),
                    FilteringTextInputFormatter.deny(
                      RegExp(
                        r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA70}-\u{1FAFF}]|[\u{1F018}-\u{1F270}]|[\u{238C}-\u{2454}]|[\u{20D0}-\u{20FF}]',
                        unicode: true,
                      ),
                    ),
                  ]
                : null,
            style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              prefixText: prefixText,
              prefixStyle: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
            ),
          ),
        ),
        if (errorText != null) ...[
          AppConstants.smallVerticalSpace,
          Text(
            errorText,
            style: AppTextStyles.bodySmall(color: AppColors.error, fontSize: SizeUtils.getFontSize(10)),
          ),
        ],
      ],
    );
  }

  Widget _buildAdditionalInfo(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: AppTextStyles.titleSmall(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        AppConstants.smallVerticalSpace,
        Container(
          padding: SizeUtils.cardPaddingSmall,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(SizeUtils.radius8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              if (product.categoryId != null && product.categoryId!.isNotEmpty) ...[
                _buildInfoRow('Category', product.categoryId!, Icons.category_outlined),
                if (product.id != null || product.createdAt != null) Divider(color: AppColors.border, height: SizeUtils.spacing16),
              ],
              if (product.id != null) ...[
                _buildInfoRow('Product ID', product.id!, Icons.tag_outlined),
                if (product.createdAt != null) Divider(color: AppColors.border, height: SizeUtils.spacing16),
              ],
              if (product.createdAt != null) ...[_buildInfoRow('Listed', _formatDate(product.createdAt!), Icons.access_time_outlined)],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: SizeUtils.getWidth(16), color: AppColors.textSecondary),
        AppConstants.smallHorizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: SizeUtils.scaffoldPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: SizeUtils.getWidth(64), color: AppColors.error),
            AppConstants.mediumVerticalSpace,
            Text(
              'Failed to load product details',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            AppConstants.smallVerticalSpace,
            Text('Please try again', style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
            AppConstants.largeVerticalSpace,
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing24, vertical: SizeUtils.spacing12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius8)),
              ),
              child: Text(
                'Go Back',
                style: AppTextStyles.bodyMedium(color: AppColors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: SizeUtils.scaffoldPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: SizeUtils.getWidth(64), color: AppColors.textSecondary),
            AppConstants.mediumVerticalSpace,
            Text(
              'No Product Data',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            AppConstants.smallVerticalSpace,
            Text('Product information not available', style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatIndianPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return formatter.format(price);
  }

  int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice <= 0) return 0;
    final discount = ((originalPrice - discountPrice) / originalPrice) * 100;
    return discount.round();
  }
}

// Shimmer Widget for Loading State
class _ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const _ShimmerBox({this.width, required this.height, this.borderRadius});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(SizeUtils.radius8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.border.withOpacity(0.3), AppColors.border.withOpacity(0.5), AppColors.border.withOpacity(0.3)],
              stops: [_animation.value - 0.3, _animation.value, _animation.value + 0.3].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

// Custom TextInputFormatter for decimal numbers with digit limits
class _DecimalTextInputFormatter extends TextInputFormatter {
  final int maxDigitsBeforeDecimal;
  final int maxDigitsAfterDecimal;

  _DecimalTextInputFormatter({required this.maxDigitsBeforeDecimal, required this.maxDigitsAfterDecimal});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow empty string
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Check if the new value is a valid number format
    final text = newValue.text;

    // Split by decimal point
    final parts = text.split('.');

    // If there's more than one decimal point, reject
    if (parts.length > 2) {
      return oldValue;
    }

    // Check digits before decimal
    if (parts[0].length > maxDigitsBeforeDecimal) {
      return oldValue;
    }

    // Check digits after decimal
    if (parts.length == 2 && parts[1].length > maxDigitsAfterDecimal) {
      return oldValue;
    }

    return newValue;
  }
}
