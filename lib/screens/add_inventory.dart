import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';
import '../utils/size_utils.dart';
import '../utils/configs.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/error_bottom_sheet.dart';
import '../widgets/button_widget.dart';
import '../cubit/add_product_cubit.dart';
import '../cubit/add_product_state.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _discountPriceFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();

  String? _selectedCategory;
  bool _isLiveProduct = true;
  int _stockQuantity = 1;

  String? _titleError;
  String? _descriptionError;
  String? _priceError;
  String? _discountPriceError;
  String? _imageUrlError;

  bool _hasAttemptedSubmit = false;

  final List<String> _categories = ['Electronics', 'Beauty', 'Hardware'];

  String imgText = "https://m.media-amazon.com/images/I/715uCgjKjRL._SY741_.jpg";

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.first;

    String titleText =
        "Samsung 7 kg, 5 Star, AI Control, Wi-Fi, Digital Inverter, Motor, Fully-Automatic Front Load Washing Machine (WW70T502NAN1TL, Hygiene Steam, Inox)";
    String descText =
        "About this item \n 1.) Fully-automatic front load washing machine with AI Control and Wi-Fi Technology \n 2.) Capacity 7 kg \n 3.) Energy Star rating : 5 Star- Best in class efficiency \n 4.) Child Lock, Diamond Drum, Hygiene Steam, Inverter, Quick Wash";
    _titleController.text = titleText;
    _descriptionController.text = descText;
    _imageUrlController.text = imgText;

    _titleController.addListener(_validateTitle);
    _descriptionController.addListener(_validateDescription);
    _priceController.addListener(_validatePrice);
    _discountPriceController.addListener(_validateDiscountPrice);
    _imageUrlController.addListener(_validateImageUrl);

    // Add focus listeners to format prices when user finishes editing
    _priceFocusNode.addListener(_onPriceFocusChange);
    _discountPriceFocusNode.addListener(_onDiscountPriceFocusChange);
  }

  @override
  void dispose() {
    _titleController.removeListener(_validateTitle);
    _descriptionController.removeListener(_validateDescription);
    _priceController.removeListener(_validatePrice);
    _discountPriceController.removeListener(_validateDiscountPrice);
    _imageUrlController.removeListener(_validateImageUrl);

    _priceFocusNode.removeListener(_onPriceFocusChange);
    _discountPriceFocusNode.removeListener(_onDiscountPriceFocusChange);

    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _imageUrlController.dispose();

    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _discountPriceFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _validateTitle() {
    // Only validate if user has attempted to submit
    if (!_hasAttemptedSubmit) return;

    setState(() {
      final value = _titleController.text.trim();

      // Clear error when user starts typing
      if (_titleError != null && value.isNotEmpty) {
        _titleError = null;
        return;
      }

      if (value.isEmpty) {
        _titleError = 'Title is required';
        return;
      }

      if (value.length < 10) {
        _titleError = 'Title must be at least 10 characters';
        return;
      }

      if (value.length > 200) {
        _titleError = 'Title cannot exceed 200 characters';
        return;
      }

      _titleError = null;
    });
  }

  void _validateDescription() {
    // Only validate if user has attempted to submit
    if (!_hasAttemptedSubmit) return;

    setState(() {
      final value = _descriptionController.text.trim();

      // Clear error when user starts typing
      if (_descriptionError != null && value.isNotEmpty) {
        _descriptionError = null;
        return;
      }

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

  void _validatePrice() {
    // Always trigger UI update for discount percentage
    setState(() {
      final value = _priceController.text.replaceAll(',', '').trim();

      // Clear error when user starts typing (only if not a comparison error)
      if (_priceError != null && _priceError != 'Price must be greater than discount price' && value.isNotEmpty) {
        _priceError = null;
      }

      // Only show basic validation errors if user has attempted to submit
      if (_hasAttemptedSubmit) {
        if (value.isEmpty) {
          _priceError = 'Price is required';
          return;
        }

        final price = double.tryParse(value);
        if (price == null) {
          _priceError = 'Price must be a valid number';
          return;
        }

        if (price < 100) {
          _priceError = 'Price must be at least ₹100';
          return;
        }

        final parts = value.split('.');
        if (parts[0].length > 8) {
          _priceError = 'Price can have maximum 8 digits before decimal';
          return;
        }

        if (parts.length > 1 && parts[1].length > 2) {
          _priceError = 'Price can have maximum 2 digits after decimal';
          return;
        }
      }

      // Always check price vs discount price comparison (even before submit)
      if (value.isNotEmpty) {
        final price = double.tryParse(value);
        if (price != null && price > 0) {
          final discountPriceText = _discountPriceController.text.replaceAll(',', '').trim();
          if (discountPriceText.isNotEmpty) {
            final discountPrice = double.tryParse(discountPriceText);
            if (discountPrice != null && discountPrice > 0) {
              if (price <= discountPrice) {
                _priceError = 'Price must be greater than discount price';
                return;
              }
            }
          }
        }
      }

      // Clear comparison error if values are now valid
      if (_priceError == 'Price must be greater than discount price') {
        _priceError = null;
      }
    });
  }

  void _validateDiscountPrice() {
    // Always trigger UI update for discount percentage
    setState(() {
      final value = _discountPriceController.text.replaceAll(',', '').trim();

      // Clear error when user starts typing (only if not a comparison error)
      if (_discountPriceError != null && _discountPriceError != 'Discount price must be less than price' && value.isNotEmpty) {
        _discountPriceError = null;
      }

      // Only show basic validation errors if user has attempted to submit
      if (_hasAttemptedSubmit) {
        if (value.isEmpty) {
          _discountPriceError = null;
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

        final parts = value.split('.');
        if (parts[0].length > 8) {
          _discountPriceError = 'Discount price can have maximum 8 digits before decimal';
          return;
        }

        if (parts.length > 1 && parts[1].length > 2) {
          _discountPriceError = 'Discount price can have maximum 2 digits after decimal';
          return;
        }
      }

      // Always check discount price vs price comparison (even before submit)
      if (value.isNotEmpty) {
        final discountPrice = double.tryParse(value);
        if (discountPrice != null && discountPrice > 0) {
          final priceText = _priceController.text.replaceAll(',', '').trim();
          if (priceText.isNotEmpty) {
            final price = double.tryParse(priceText);
            if (price != null && price > 0) {
              if (discountPrice >= price) {
                _discountPriceError = 'Discount price must be less than price';
                return;
              }
            }
          }
        }
      }

      // Clear comparison error if values are now valid
      if (_discountPriceError == 'Discount price must be less than price') {
        _discountPriceError = null;
      }

      _revalidatePriceField();
    });
  }

  void _revalidatePriceField() {
    final value = _priceController.text.replaceAll(',', '').trim();

    if (value.isEmpty) {
      if (_priceError == 'Price must be greater than discount price') {
        _priceError = null;
      }
      return;
    }

    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return;
    }

    final discountPriceText = _discountPriceController.text.replaceAll(',', '').trim();
    if (discountPriceText.isNotEmpty) {
      final discountPrice = double.tryParse(discountPriceText);
      if (discountPrice != null && discountPrice > 0) {
        if (price <= discountPrice) {
          _priceError = 'Price must be greater than discount price';
          return;
        }
      }
    }

    // Clear the error if it was related to discount price comparison
    if (_priceError == 'Price must be greater than discount price') {
      _priceError = null;
    }
  }

  void _incrementStock() {
    _titleFocusNode.unfocus();
    _descriptionFocusNode.unfocus();
    _priceFocusNode.unfocus();
    _discountPriceFocusNode.unfocus();
    _imageUrlFocusNode.unfocus();
    AppConstants.getCloseKeyboard(context);

    setState(() {
      if (_stockQuantity < 999999) {
        _stockQuantity++;
      }
    });
  }

  void _decrementStock() {
    _titleFocusNode.unfocus();
    _descriptionFocusNode.unfocus();
    _priceFocusNode.unfocus();
    _discountPriceFocusNode.unfocus();
    _imageUrlFocusNode.unfocus();
    AppConstants.getCloseKeyboard(context);

    setState(() {
      if (_stockQuantity > 1) {
        _stockQuantity--;
      }
    });
  }

  void _onPriceFocusChange() {
    if (!_priceFocusNode.hasFocus) {
      // User finished editing price field - format with Indian format
      final value = _priceController.text.replaceAll(',', '').trim();
      if (value.isNotEmpty) {
        final formatted = _formatPriceIndian(value);
        if (formatted != _priceController.text) {
          _priceController.text = formatted;
        }
      }
    }
  }

  void _onDiscountPriceFocusChange() {
    if (!_discountPriceFocusNode.hasFocus) {
      // User finished editing discount price field - format with Indian format
      final value = _discountPriceController.text.replaceAll(',', '').trim();
      if (value.isNotEmpty) {
        final formatted = _formatPriceIndian(value);
        if (formatted != _discountPriceController.text) {
          _discountPriceController.text = formatted;
        }
      }
    }
  }

  void _validateImageUrl() {
    // Only validate if user has attempted to submit
    if (!_hasAttemptedSubmit) return;

    setState(() {
      final value = _imageUrlController.text.trim();

      // Clear error when user starts typing
      if (_imageUrlError != null && value.isNotEmpty) {
        _imageUrlError = null;
        return;
      }

      if (value.isEmpty) {
        _imageUrlError = 'Image URL is required';
        return;
      }

      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        _imageUrlError = 'Image URL must start with http:// or https://';
        return;
      }

      _imageUrlError = null;
    });
  }

  String _formatPriceIndian(String value) {
    if (value.isEmpty) return value;

    // Remove any existing commas
    value = value.replaceAll(',', '');

    final price = double.tryParse(value);
    if (price == null) return value;

    // Split into integer and decimal parts
    final parts = value.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Ensure decimal part
    if (decimalPart.isEmpty) {
      decimalPart = '0';
    } else if (decimalPart.length == 1) {
      // Keep as is
    } else if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    // Format integer part with Indian numbering system
    String formattedInteger = _formatIndianNumber(integerPart);

    return '$formattedInteger.$decimalPart';
  }

  String _formatIndianNumber(String number) {
    if (number.length <= 3) return number;

    String result = '';
    int count = 0;

    // Process from right to left
    for (int i = number.length - 1; i >= 0; i--) {
      if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
        result = ',$result';
      }
      result = number[i] + result;
      count++;
    }

    return result;
  }

  bool _validateAllFields() {
    // Validate all fields and show errors for empty/invalid fields
    setState(() {
      final titleValue = _titleController.text.trim();
      if (titleValue.isEmpty) {
        _titleError = 'Title is required';
      } else {
        _validateTitle();
      }

      final descValue = _descriptionController.text.trim();
      if (descValue.isEmpty) {
        _descriptionError = 'Description is required';
      } else {
        _validateDescription();
      }

      final priceValue = _priceController.text.replaceAll(',', '').trim();
      if (priceValue.isEmpty) {
        _priceError = 'Price is required';
      } else {
        final price = double.tryParse(priceValue);
        if (price != null && price < 100) {
          _priceError = 'Price must be at least ₹100';
        } else {
          _validatePrice();
        }
      }

      _validateDiscountPrice();

      final imageValue = _imageUrlController.text.trim();
      if (imageValue.isEmpty) {
        _imageUrlError = 'Image URL is required';
      } else {
        _validateImageUrl();
      }
    });

    return _titleError == null && _descriptionError == null && _priceError == null && _discountPriceError == null && _imageUrlError == null;
  }

  void _handleAddProduct() {
    // Mark that user has attempted to submit
    setState(() {
      _hasAttemptedSubmit = true;
    });

    if (!_validateAllFields()) {
      return;
    }

    final price = double.parse(_priceController.text.replaceAll(',', '').trim());
    final discountPrice = _discountPriceController.text.trim().isEmpty ? 0.0 : double.parse(_discountPriceController.text.replaceAll(',', '').trim());

    context.read<AddProductCubit>().addProduct(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      discountPrice: discountPrice,
      stock: _stockQuantity,
      imageUrl: _imageUrlController.text.trim(),
      categoryId: _selectedCategory!.toLowerCase(),
      isLiveProduct: _isLiveProduct,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          // Clear all fields on success
          _titleController.clear();
          _descriptionController.clear();
          _priceController.clear();
          _discountPriceController.clear();
          _imageUrlController.clear();

          // Reset other fields
          setState(() {
            _stockQuantity = 1;
            _isLiveProduct = true;
            _selectedCategory = _categories.first;
            _hasAttemptedSubmit = false;

            // Clear all errors
            _titleError = null;
            _descriptionError = null;
            _priceError = null;
            _discountPriceError = null;
            _imageUrlError = null;
          });

          ErrorBottomSheet.showError(context: context, title: 'Success!', message: 'Product added successfully', buttonText: 'Got it');

          // Reset the cubit state after showing success
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.read<AddProductCubit>().reset();
            }
          });
        } else if (state is AddProductError) {
          final exception = state.exception;
          if (exception is ApiException) {
            ErrorBottomSheet.showError(context: context, title: exception.errorTitle, message: exception.displayMessage, buttonText: 'Got it');
          } else {
            ErrorBottomSheet.showError(context: context, title: 'Error!', message: state.message, buttonText: 'Got it');
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is AddProductLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBarFactory.create(title: 'Add Product', showBackButton: true),
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Clear focus from all fields when tapping outside
                    _titleFocusNode.unfocus();
                    _descriptionFocusNode.unfocus();
                    _priceFocusNode.unfocus();
                    _discountPriceFocusNode.unfocus();
                    _imageUrlFocusNode.unfocus();
                    AppConstants.getCloseKeyboard(context);
                  },
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: SizeUtils.scaffoldPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProductImage(imgText),
                            AppConstants.mediumVerticalSpace,
                            _buildStatusField(),
                            AppConstants.mediumVerticalSpace,
                            _buildTextField(
                              label: 'Product Title',
                              controller: _titleController,
                              focusNode: _titleFocusNode,
                              errorText: _titleError,
                              maxLength: 200,
                              hint: 'Enter product title (min 10 characters)',
                            ),
                            AppConstants.mediumVerticalSpace,
                            _buildTextField(
                              label: 'Description',
                              controller: _descriptionController,
                              focusNode: _descriptionFocusNode,
                              errorText: _descriptionError,
                              maxLines: 5,
                              maxLength: 1000,
                              hint: 'Enter product description (min 100 characters)',
                              showCounter: true,
                            ),
                            AppConstants.mediumVerticalSpace,
                            _buildPriceFields(),
                            AppConstants.mediumVerticalSpace,
                            _buildStockField(),
                            AppConstants.mediumVerticalSpace,
                            _buildTextField(
                              label: 'Image URL',
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              errorText: _imageUrlError,
                              hint: 'Enter image URL (https://...)',
                            ),
                            AppConstants.mediumVerticalSpace,
                            _buildCategoryField(),
                            AppConstants.mediumVerticalSpace,
                          ],
                        ),
                      ),
                      if (isLoading) _buildShimmerOverlay(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: SizeUtils.scaffoldPadding,
                child: PrimaryButton(
                  text: 'Add Product',
                  onPressed: isLoading ? null : _handleAddProduct,
                  isLoading: isLoading,
                  isEnabled: _buildAddButton(isLoading),
                  icon: Icons.add,
                  iconPosition: IconPosition.right,
                  iconSize: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      height: SizeUtils.getHeight(250),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.border.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius4)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeUtils.radius4),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
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
            'Product Status',
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
          ),
          AppConstants.smallVerticalSpace,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isLiveProduct = true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: SizeUtils.spacing12),
                    decoration: BoxDecoration(
                      color: _isLiveProduct ? AppColors.success.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(SizeUtils.radius6),
                      border: Border.all(color: _isLiveProduct ? AppColors.success : AppColors.border),
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
                  onTap: () => setState(() => _isLiveProduct = false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: SizeUtils.spacing12),
                    decoration: BoxDecoration(
                      color: !_isLiveProduct ? AppColors.error.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(SizeUtils.radius6),
                      border: Border.all(color: !_isLiveProduct ? AppColors.error : AppColors.border),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? errorText,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? hint,
    bool showCounter = false,
  }) {
    return Container(
      padding: SizeUtils.cardPaddingSmall,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius8),
        border: Border.all(color: errorText != null ? AppColors.error : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
          ),
          AppConstants.smallVerticalSpace,
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            inputFormatters: keyboardType == TextInputType.number
                ? maxLines == 1 && label.contains('Price')
                      ? [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                          _IndianPriceFormatter(maxDigitsBeforeDecimal: 8, maxDigitsAfterDecimal: 2),
                        ]
                      : [FilteringTextInputFormatter.digitsOnly]
                : maxLines > 1
                ? [
                    LengthLimitingTextInputFormatter(maxLength),
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
              contentPadding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing8),
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondary.withOpacity(0.5)),
              counterText: showCounter ? null : '',
            ),
          ),
          if (showCounter && maxLength != null) ...[
            AppConstants.smallVerticalSpace,
            Text(
              '${controller.text.trim().length}/$maxLength characters (min: 100)',
              style: AppTextStyles.bodySmall(
                color: controller.text.trim().length < 100
                    ? AppColors.error
                    : controller.text.trim().length > maxLength
                    ? AppColors.error
                    : AppColors.textSecondary,
                fontSize: SizeUtils.getFontSize(10),
              ),
            ),
          ],
          if (errorText != null) ...[
            AppConstants.smallVerticalSpace,
            Text(
              errorText,
              style: AppTextStyles.bodySmall(color: AppColors.error, fontSize: SizeUtils.getFontSize(10)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceFields() {
    final originalPriceText = _priceController.text.replaceAll(',', '').trim();
    final discountPriceText = _discountPriceController.text.replaceAll(',', '').trim();

    final originalPrice = double.tryParse(originalPriceText) ?? 0;
    final discountedPrice = double.tryParse(discountPriceText) ?? 0;

    final hasDiscount = originalPriceText.isNotEmpty && discountPriceText.isNotEmpty && discountedPrice > 0 && discountedPrice < originalPrice;

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
          _buildPriceField(label: 'Price', controller: _priceController, focusNode: _priceFocusNode, errorText: _priceError),
          AppConstants.smallVerticalSpace,
          _buildPriceField(
            label: 'Discount Price (Optional)',
            controller: _discountPriceController,
            focusNode: _discountPriceFocusNode,
            errorText: _discountPriceError,
          ),
          if (hasDiscount) ...[
            AppConstants.smallVerticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing8, vertical: SizeUtils.spacing4),
              decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(SizeUtils.radius4)),
              child: Text(
                '${_calculateDiscountPercentage(originalPrice, discountedPrice)}% OFF',
                style: AppTextStyles.bodySmall(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: SizeUtils.getFontSize(10)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceField({required String label, required TextEditingController controller, required FocusNode focusNode, String? errorText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
        ),
        AppConstants.smallVerticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(SizeUtils.radius6),
            border: Border.all(color: errorText != null ? AppColors.error : AppColors.border),
          ),
          child: Row(
            children: [
              Text('₹ ', style: AppTextStyles.bodyMedium(color: AppColors.textPrimary)),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    _IndianPriceFormatter(maxDigitsBeforeDecimal: 8, maxDigitsAfterDecimal: 2),
                  ],
                  style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0.0',
                    hintStyle: AppTextStyles.bodyMedium(color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                ),
              ),
            ],
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

  Widget _buildStockField() {
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
            'Stock Quantity',
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
          ),
          AppConstants.smallVerticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement Button
              GestureDetector(
                onTap: _decrementStock,
                child: Container(
                  width: SizeUtils.getWidth(40),
                  height: SizeUtils.getWidth(40),
                  decoration: BoxDecoration(
                    color: _stockQuantity > 1 ? AppColors.primary.withOpacity(0.1) : AppColors.border.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(SizeUtils.radius6),
                    border: Border.all(color: _stockQuantity > 1 ? AppColors.primary : AppColors.border),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: _stockQuantity > 1 ? AppColors.primary : AppColors.textSecondary.withOpacity(0.5),
                    size: SizeUtils.getWidth(20),
                  ),
                ),
              ),

              // Stock Display
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16),
                  padding: EdgeInsets.symmetric(vertical: SizeUtils.spacing12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(SizeUtils.radius6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '$_stockQuantity',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              // Increment Button
              GestureDetector(
                onTap: _incrementStock,
                child: Container(
                  width: SizeUtils.getWidth(40),
                  height: SizeUtils.getWidth(40),
                  decoration: BoxDecoration(
                    color: _stockQuantity < 999999 ? AppColors.primary.withOpacity(0.1) : AppColors.border.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(SizeUtils.radius6),
                    border: Border.all(color: _stockQuantity < 999999 ? AppColors.primary : AppColors.border),
                  ),
                  child: Icon(
                    Icons.add,
                    color: _stockQuantity < 999999 ? AppColors.primary : AppColors.textSecondary.withOpacity(0.5),
                    size: SizeUtils.getWidth(20),
                  ),
                ),
              ),
            ],
          ),
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
          Text(
            'Category',
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
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
              value: _selectedCategory,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
              dropdownColor: AppColors.surface,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: AppTextStyles.bodyMedium(color: AppColors.textPrimary)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
          ),
        ],
      ),
    );
  }

  _buildAddButton(bool isLoading) {
    final isFormValid =
        _titleController.text.trim().length >= 10 &&
        _descriptionController.text.trim().length >= 100 &&
        _priceController.text.replaceAll(',', '').trim().isNotEmpty &&
        _imageUrlController.text.trim().isNotEmpty &&
        _titleError == null &&
        _descriptionError == null &&
        _priceError == null &&
        _discountPriceError == null &&
        _imageUrlError == null;
    return isFormValid;
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: AppColors.textPrimary.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(SizeUtils.spacing24),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(SizeUtils.radius12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              AppConstants.mediumVerticalSpace,
              Text(
                'Adding Product...',
                style: AppTextStyles.bodyMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerOverlay() {
    return Container(
      color: AppColors.background.withOpacity(0.95),
      child: SingleChildScrollView(
        padding: SizeUtils.scaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(250)),
            AppConstants.mediumVerticalSpace,
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
            AppConstants.mediumVerticalSpace,
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(60)),
            AppConstants.mediumVerticalSpace,
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(120)),
            AppConstants.mediumVerticalSpace,
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(100)),
            AppConstants.mediumVerticalSpace,
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
            AppConstants.mediumVerticalSpace,
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(60)),
            AppConstants.mediumVerticalSpace,
            _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
          ],
        ),
      ),
    );
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

// Indian price formatter with comma support and real-time formatting
class _IndianPriceFormatter extends TextInputFormatter {
  final int maxDigitsBeforeDecimal;
  final int maxDigitsAfterDecimal;

  _IndianPriceFormatter({required this.maxDigitsBeforeDecimal, required this.maxDigitsAfterDecimal});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text;

    // Remove commas for validation
    final textWithoutCommas = text.replaceAll(',', '');

    // Check for leading zeros (except 0.x)
    if (textWithoutCommas.startsWith('0') && textWithoutCommas.length > 1 && !textWithoutCommas.startsWith('0.')) {
      return oldValue;
    }

    // Split by decimal
    final parts = textWithoutCommas.split('.');

    // Only one decimal point allowed
    if (parts.length > 2) {
      return oldValue;
    }

    // Check max digits before decimal
    if (parts[0].length > maxDigitsBeforeDecimal) {
      return oldValue;
    }

    // Check max digits after decimal
    if (parts.length == 2 && parts[1].length > maxDigitsAfterDecimal) {
      return oldValue;
    }

    // Apply Indian formatting in real-time
    String formattedText = _formatIndianNumberRealtime(textWithoutCommas);
    
    // Calculate new cursor position
    int newCursorPosition = _calculateCursorPosition(
      oldValue.text,
      newValue.text,
      formattedText,
      newValue.selection.baseOffset,
    );

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  String _formatIndianNumberRealtime(String number) {
    if (number.isEmpty) return number;

    // Split into integer and decimal parts
    final parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Format integer part with Indian numbering system
    if (integerPart.length <= 3) {
      return integerPart + decimalPart;
    }

    String result = '';
    int count = 0;

    // Process from right to left
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
        result = ',$result';
      }
      result = integerPart[i] + result;
      count++;
    }

    return result + decimalPart;
  }

  int _calculateCursorPosition(String oldText, String newText, String formattedText, int oldCursor) {
    // Count commas before cursor in old text
    int commasBeforeOldCursor = oldText.substring(0, oldCursor.clamp(0, oldText.length)).split(',').length - 1;
    
    // Count commas before cursor in new text (without formatting)
    String newTextWithoutCommas = newText.replaceAll(',', '');
    int digitsBeforeCursor = newText.substring(0, oldCursor.clamp(0, newText.length)).replaceAll(',', '').length;
    
    // Find position in formatted text
    int digitCount = 0;
    int position = 0;
    
    for (int i = 0; i < formattedText.length && digitCount < digitsBeforeCursor; i++) {
      if (formattedText[i] != ',') {
        digitCount++;
      }
      position = i + 1;
    }
    
    return position.clamp(0, formattedText.length);
  }
}
