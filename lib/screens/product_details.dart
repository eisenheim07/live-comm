import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:livecomm/widgets/custom_snackbar.dart';
import '../models/product_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';
import '../utils/size_utils.dart';
import '../utils/configs.dart';
import '../widgets/error_bottom_sheet.dart';
import '../widgets/button_widget.dart';
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
  late final ProductDetailsCubit _cubit;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _discountPriceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  bool _isTitleEnabled = false;
  bool _isPriceEnabled = false;
  bool _isDiscountPriceEnabled = false;
  bool _isDescriptionEnabled = false;
  bool _isCategoryEnabled = false;

  String? _selectedCategory;
  bool? _isLiveProduct;
  int _stockQuantity = 1;

  String? _titleError;
  String? _priceError;
  String? _discountPriceError;
  String? _descriptionError;

  bool _isFieldsPopulated = false;
  bool _hasShownSuccessDialog = false;
  bool _hasShownErrorDialog = false;

  final List<String> _categories = ['Electronics', 'Beauty', 'Hardware'];

  @override
  void initState() {
    super.initState();
    _cubit = ProductDetailsCubit();

    if (widget.product != null) {
      _cubit.loadProduct(widget.product!);
    } else if (widget.productId != null) {
      _cubit.fetchProductDetails(widget.productId!);
    }

    _titleController.addListener(_validateTitle);
    _priceController.addListener(_validatePrice);
    _discountPriceController.addListener(_validateDiscountPrice);
    _descriptionController.addListener(_validateDescription);
    _priceFocusNode.addListener(_onPriceFocusChange);
    _discountPriceFocusNode.addListener(_onDiscountPriceFocusChange);
  }

  @override
  void dispose() {
    _cubit.close();
    _titleController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _priceFocusNode.dispose();
    _discountPriceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _populateFields(ProductModel product) {
    if (_isFieldsPopulated) return;

    setState(() {
      _titleController.text = product.title ?? '';
      if (product.price != null) {
        _priceController.text = _formatPriceIndian(product.price.toString());
      }
      if (product.discountPrice != null) {
        _discountPriceController.text = _formatPriceIndian(product.discountPrice.toString());
      }
      _descriptionController.text = product.description ?? '';
      _stockQuantity = product.stock ?? 1;

      if (product.categoryId != null && product.categoryId!.isNotEmpty) {
        final categoryLower = product.categoryId!.toLowerCase();
        _selectedCategory = _categories.firstWhere((cat) => cat.toLowerCase() == categoryLower, orElse: () => _categories.first);
      }

      _isLiveProduct = product.isLiveProduct;
      _isFieldsPopulated = true;
    });
  }

  void _validateTitle() {
    if (!_isTitleEnabled) return;

    final value = _titleController.text.trim();
    if (value.isEmpty) {
      setState(() => _titleError = 'Title is required');
      return;
    }

    final words = value.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    if (words.length > 200) {
      setState(() => _titleError = 'Title cannot exceed 200 words');
      return;
    }

    setState(() => _titleError = null);
  }

  void _onPriceFocusChange() {
    if (!_priceFocusNode.hasFocus && _isPriceEnabled) {
      final value = _priceController.text.replaceAll(',', '').trim();
      if (value.isNotEmpty) {
        _priceController.text = _formatPriceIndian(value);
      }
    }
  }

  void _onDiscountPriceFocusChange() {
    if (!_discountPriceFocusNode.hasFocus && _isDiscountPriceEnabled) {
      final value = _discountPriceController.text.replaceAll(',', '').trim();
      if (value.isNotEmpty) {
        _discountPriceController.text = _formatPriceIndian(value);
      }
    }
  }

  void _validatePrice() {
    if (!_isPriceEnabled) return;

    final value = _priceController.text.replaceAll(',', '').trim();
    if (value.isEmpty) {
      setState(() => _priceError = 'Price is required');
      return;
    }

    final price = double.tryParse(value);
    if (price == null) {
      setState(() => _priceError = 'Price must be a valid number');
      return;
    }

    if (price <= 0) {
      setState(() => _priceError = 'Price must be greater than 0');
      return;
    }

    final parts = value.split('.');
    if (parts[0].length > 8) {
      setState(() => _priceError = 'Price can have maximum 8 digits before decimal');
      return;
    }

    if (parts.length > 1 && parts[1].length > 2) {
      setState(() => _priceError = 'Price can have maximum 2 digits after decimal');
      return;
    }

    final discountPriceText = _discountPriceController.text.replaceAll(',', '').trim();
    if (discountPriceText.isNotEmpty) {
      final discountPrice = double.tryParse(discountPriceText);
      if (discountPrice != null && discountPrice > 0 && price <= discountPrice) {
        setState(() => _priceError = 'Price must be greater than discount price');
        return;
      }
    }

    setState(() => _priceError = null);
  }

  void _validateDiscountPrice() {
    if (!_isDiscountPriceEnabled) return;

    final value = _discountPriceController.text.replaceAll(',', '').trim();
    if (value.isEmpty) {
      setState(() => _discountPriceError = null);
      return;
    }

    final discountPrice = double.tryParse(value);
    if (discountPrice == null) {
      setState(() => _discountPriceError = 'Discount price must be a valid number');
      return;
    }

    if (discountPrice < 0) {
      setState(() => _discountPriceError = 'Discount price cannot be negative');
      return;
    }

    final parts = value.split('.');
    if (parts[0].length > 8) {
      setState(() => _discountPriceError = 'Discount price can have maximum 8 digits before decimal');
      return;
    }

    if (parts.length > 1 && parts[1].length > 2) {
      setState(() => _discountPriceError = 'Discount price can have maximum 2 digits after decimal');
      return;
    }

    final priceText = _priceController.text.replaceAll(',', '').trim();
    if (priceText.isNotEmpty) {
      final price = double.tryParse(priceText);
      if (price != null && discountPrice > 0 && discountPrice >= price) {
        setState(() => _discountPriceError = 'Discount price must be less than price');
        return;
      }
    }

    setState(() => _discountPriceError = null);
  }

  void _validateDescription() {
    if (!_isDescriptionEnabled) return;

    final value = _descriptionController.text.trim();
    if (value.isEmpty) {
      setState(() => _descriptionError = 'Description is required');
      return;
    }

    if (value.length < 100) {
      setState(() => _descriptionError = 'Description must be at least 100 characters');
      return;
    }

    if (value.length > 1000) {
      setState(() => _descriptionError = 'Description cannot exceed 1000 characters');
      return;
    }

    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA70}-\u{1FAFF}]|[\u{1F018}-\u{1F270}]|[\u{238C}-\u{2454}]|[\u{20D0}-\u{20FF}]',
      unicode: true,
    );

    if (emojiRegex.hasMatch(value)) {
      setState(() => _descriptionError = 'Description cannot contain emojis');
      return;
    }

    setState(() => _descriptionError = null);
  }

  String _formatPriceIndian(String value) {
    if (value.isEmpty) return value;

    value = value.replaceAll(',', '');
    final price = double.tryParse(value);
    if (price == null) return value;

    final parts = value.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    if (decimalPart.isEmpty) {
      decimalPart = '0';
    } else if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    String formattedInteger = _formatIndianNumber(integerPart);
    return '$formattedInteger.$decimalPart';
  }

  String _formatIndianNumber(String number) {
    if (number.length <= 3) return number;

    String result = '';
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
        result = ',$result';
      }
      result = number[i] + result;
      count++;
    }

    return result;
  }

  bool _isUpdateButtonEnabled() {
    final titleText = _titleController.text.trim();
    final priceText = _priceController.text.replaceAll(',', '').trim();
    final descriptionText = _descriptionController.text.trim();

    final titleWords = titleText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;

    final isTitleValid = titleText.isNotEmpty && titleWords <= 200 && _titleError == null;
    final isPriceValid = priceText.isNotEmpty && _priceError == null;
    final isDescriptionValid =
        descriptionText.isNotEmpty && descriptionText.length >= 100 && descriptionText.length <= 1000 && _descriptionError == null;
    final isDiscountPriceValid = _discountPriceError == null;

    return isTitleValid && isPriceValid && isDescriptionValid && isDiscountPriceValid;
  }

  void _handleUpdate(String? productId) {
    // Reset dialog flags before attempting update
    _hasShownSuccessDialog = false;
    _hasShownErrorDialog = false;

    if (_isTitleEnabled) _validateTitle();
    if (_isPriceEnabled) _validatePrice();
    if (_isDiscountPriceEnabled) _validateDiscountPrice();
    if (_isDescriptionEnabled) _validateDescription();

    if (_titleError != null || _priceError != null || _discountPriceError != null || _descriptionError != null) {
      ErrorBottomSheet.showError(context: context, title: 'Validation Error', message: 'Please fix all errors before updating', buttonText: 'Got it');
      return;
    }

    if (productId == null || productId.isEmpty) {
      ErrorBottomSheet.showError(context: context, title: 'Error', message: 'Product ID not found', buttonText: 'Got it');
      return;
    }

    _cubit.updateProduct(
      productId: productId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.replaceAll(',', '').trim()),
      discountPrice: _discountPriceController.text.trim().isEmpty ? 0.0 : double.parse(_discountPriceController.text.replaceAll(',', '').trim()),
      stock: _stockQuantity,
      categoryId: _selectedCategory!.toLowerCase(),
      isLiveProduct: _isLiveProduct ?? true,
    );
  }

  void _toggleTitleEdit() {
    setState(() {
      if (!_isTitleEnabled) {
        _isPriceEnabled = false;
        _isDiscountPriceEnabled = false;
        _isDescriptionEnabled = false;
        _isCategoryEnabled = false;
        _titleError = null;
        _isTitleEnabled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _titleFocusNode.requestFocus();
        });
      } else {
        _validateTitle();
        if (_titleError == null) {
          _isTitleEnabled = false;
        }
      }
    });
  }

  void _togglePriceEdit() {
    setState(() {
      if (!_isPriceEnabled) {
        if (_isDiscountPriceEnabled) {
          final value = _discountPriceController.text.replaceAll(',', '').trim();
          if (value.isNotEmpty) {
            _discountPriceController.text = _formatPriceIndian(value);
          }
          _validateDiscountPrice();
          if (_discountPriceError != null) return;
        }

        _isTitleEnabled = false;
        _isDiscountPriceEnabled = false;
        _isDescriptionEnabled = false;
        _isCategoryEnabled = false;
        _priceError = null;
        _isPriceEnabled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _priceFocusNode.requestFocus();
        });
      } else {
        final value = _priceController.text.replaceAll(',', '').trim();
        if (value.isNotEmpty) {
          _priceController.text = _formatPriceIndian(value);
        }
        _validatePrice();
        if (_priceError == null) {
          _isPriceEnabled = false;
        }
      }
    });
  }

  void _toggleDiscountPriceEdit() {
    setState(() {
      if (!_isDiscountPriceEnabled) {
        if (_isPriceEnabled) {
          final value = _priceController.text.replaceAll(',', '').trim();
          if (value.isNotEmpty) {
            _priceController.text = _formatPriceIndian(value);
          }
          _validatePrice();
          if (_priceError != null) return;
        }

        _isTitleEnabled = false;
        _isPriceEnabled = false;
        _isDescriptionEnabled = false;
        _isCategoryEnabled = false;
        _discountPriceError = null;
        _isDiscountPriceEnabled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _discountPriceFocusNode.requestFocus();
        });
      } else {
        final value = _discountPriceController.text.replaceAll(',', '').trim();
        if (value.isNotEmpty) {
          _discountPriceController.text = _formatPriceIndian(value);
        }
        _validateDiscountPrice();
        if (_discountPriceError == null) {
          _isDiscountPriceEnabled = false;
        }
      }
    });
  }

  void _toggleDescriptionEdit() {
    setState(() {
      if (!_isDescriptionEnabled) {
        if (_isPriceEnabled) {
          final value = _priceController.text.replaceAll(',', '').trim();
          if (value.isNotEmpty) {
            _priceController.text = _formatPriceIndian(value);
          }
          _validatePrice();
          if (_priceError != null) return;
        }

        if (_isDiscountPriceEnabled) {
          final value = _discountPriceController.text.replaceAll(',', '').trim();
          if (value.isNotEmpty) {
            _discountPriceController.text = _formatPriceIndian(value);
          }
          _validateDiscountPrice();
          if (_discountPriceError != null) return;
        }

        _isTitleEnabled = false;
        _isPriceEnabled = false;
        _isDiscountPriceEnabled = false;
        _isCategoryEnabled = false;
        _descriptionError = null;
        _isDescriptionEnabled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _descriptionFocusNode.requestFocus();
        });
      } else {
        _validateDescription();
        if (_descriptionError == null) {
          _isDescriptionEnabled = false;
        }
      }
    });
  }

  void _toggleCategoryEdit() {
    setState(() {
      if (!_isCategoryEnabled) {
        if (_isPriceEnabled) {
          final value = _priceController.text.replaceAll(',', '').trim();
          if (value.isNotEmpty) {
            _priceController.text = _formatPriceIndian(value);
          }
          _validatePrice();
          if (_priceError != null) return;
        }

        if (_isDiscountPriceEnabled) {
          final value = _discountPriceController.text.replaceAll(',', '').trim();
          if (value.isNotEmpty) {
            _discountPriceController.text = _formatPriceIndian(value);
          }
          _validateDiscountPrice();
          if (_discountPriceError != null) return;
        }

        _isTitleEnabled = false;
        _isPriceEnabled = false;
        _isDiscountPriceEnabled = false;
        _isDescriptionEnabled = false;
      }
      _isCategoryEnabled = !_isCategoryEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProductDetailsState>(
      stream: _cubit.stream,
      initialData: _cubit.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? ProductDetailsInitial();

        if (state is ProductDetailsUpdateSuccess && !_hasShownSuccessDialog) {
          _hasShownSuccessDialog = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.flushBarSuccessMessage(message: "Product updated successfully");
          });
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        } else if (state is ProductDetailsUpdateError && !_hasShownErrorDialog) {
          _hasShownErrorDialog = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final exception = state.exception;
            if (exception is ApiException) {
              ErrorBottomSheet.showError(context: context, title: exception.errorTitle, message: exception.displayMessage, buttonText: 'Got it');
            } else {
              ErrorBottomSheet.showError(context: context, title: 'Update Failed', message: state.message, buttonText: 'Got it');
            }
          });
        } else if (state is ProductDetailsError && !_hasShownErrorDialog) {
          _hasShownErrorDialog = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final exception = state.exception;
            if (exception is ApiException) {
              ErrorBottomSheet.showError(context: context, title: exception.errorTitle, message: exception.displayMessage, buttonText: 'Got it');
            } else {
              ErrorBottomSheet.showError(context: context, title: 'Error!', message: state.message, buttonText: 'Got it');
            }
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(),
          body: SafeArea(child: _buildBody(state)),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildBody(ProductDetailsState state) {
    if (state is ProductDetailsLoading) {
      return _buildLoadingState();
    } else if (state is ProductDetailsUpdating || state is ProductDetailsUpdateSuccess) {
      return _buildUpdatingState();
    } else if (state is ProductDetailsLoaded || state is ProductDetailsUpdateError) {
      ProductModel product;
      if (state is ProductDetailsLoaded) {
        product = state.product;
      } else {
        product = (state as ProductDetailsUpdateError).product;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(product);
      });

      return Column(
        children: [
          Expanded(child: _buildProductDetails(product)),
          Padding(
            padding: SizeUtils.scaffoldPadding,
            child: PrimaryButton(
              text: 'Update',
              onPressed: _isUpdateButtonEnabled() ? () => _handleUpdate(product.id) : () {},
              isEnabled: _isUpdateButtonEnabled(),
              icon: Icons.check_circle_outline,
              iconPosition: IconPosition.right,
              iconSize: 20,
            ),
          ),
        ],
      );
    } else if (state is ProductDetailsError) {
      return _buildErrorState();
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

  Widget _buildUpdatingState() {
    return SingleChildScrollView(
      padding: SizeUtils.scaffoldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(250)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: SizeUtils.getWidth(120), height: SizeUtils.getHeight(20)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(100)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(120)),
          AppConstants.mediumVerticalSpace,
          _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(80)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
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

  Widget _buildProductDetails(ProductModel product) {
    return GestureDetector(
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
            _buildTitleField(),
            AppConstants.mediumVerticalSpace,
            _buildStatusField(),
            AppConstants.mediumVerticalSpace,
            _buildStockField(),
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
    return Row(
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
    );
  }

  Widget _buildTitleField() {
    final titleText = _titleController.text.trim();
    final words = titleText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    final wordCount = words.length;

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
                  'Product Title',
                  style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontSize: SizeUtils.getFontSize(11)),
                ),
              ),
              GestureDetector(
                onTap: _toggleTitleEdit,
                child: Icon(_isTitleEnabled ? Icons.check : Icons.edit_outlined, size: SizeUtils.getWidth(16), color: AppColors.primary),
              ),
            ],
          ),
          AppConstants.smallVerticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing12, vertical: SizeUtils.spacing8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(SizeUtils.radius6),
              border: Border.all(color: _titleError != null ? AppColors.error : AppColors.border),
            ),
            child: TextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              readOnly: !_isTitleEnabled,
              maxLines: 3,
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
              decoration: InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
            ),
          ),
          if (_titleError != null) ...[
            AppConstants.smallVerticalSpace,
            Text(
              _titleError!,
              style: AppTextStyles.bodySmall(color: AppColors.error, fontSize: SizeUtils.getFontSize(10)),
            ),
          ],
          if (_isTitleEnabled) ...[
            AppConstants.smallVerticalSpace,
            Text(
              '$wordCount/200 words',
              style: AppTextStyles.bodySmall(color: wordCount > 200 ? AppColors.error : AppColors.textSecondary, fontSize: SizeUtils.getFontSize(10)),
            ),
          ],
        ],
      ),
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
                  onTap: () => setState(() => _isLiveProduct = true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: SizeUtils.spacing12),
                    decoration: BoxDecoration(
                      color: _isLiveProduct == true ? AppColors.success.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(SizeUtils.radius6),
                      border: Border.all(color: _isLiveProduct == true ? AppColors.success : AppColors.border),
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
                      color: _isLiveProduct == false ? AppColors.error.withOpacity(0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(SizeUtils.radius6),
                      border: Border.all(color: _isLiveProduct == false ? AppColors.error : AppColors.border),
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
              GestureDetector(
                onTap: () {
                  if (_stockQuantity > 1) {
                    setState(() => _stockQuantity--);
                  }
                },
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
              GestureDetector(
                onTap: () {
                  if (_stockQuantity < 999999) {
                    setState(() => _stockQuantity++);
                  }
                },
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
            controller: _priceController,
            focusNode: _priceFocusNode,
            isEnabled: _isPriceEnabled,
            onEditToggle: _togglePriceEdit,
            keyboardType: TextInputType.number,
            prefixText: '₹ ',
            errorText: _priceError,
          ),
          AppConstants.smallVerticalSpace,
          _buildEditableField(
            label: 'Discount Price',
            controller: _discountPriceController,
            focusNode: _discountPriceFocusNode,
            isEnabled: _isDiscountPriceEnabled,
            onEditToggle: _toggleDiscountPriceEdit,
            keyboardType: TextInputType.number,
            prefixText: '₹ ',
            errorText: _discountPriceError,
          ),
          _buildDiscountBadge(),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge() {
    final originalPriceText = _priceController.text.replaceAll(',', '').trim();
    final discountPriceText = _discountPriceController.text.replaceAll(',', '').trim();

    final originalPrice = double.tryParse(originalPriceText) ?? 0;
    final discountedPrice = double.tryParse(discountPriceText) ?? 0;
    final hasDiscount = discountedPrice > 0 && discountedPrice < originalPrice;

    if (!hasDiscount) return const SizedBox.shrink();

    final discountPercentage = ((originalPrice - discountedPrice) / originalPrice * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppConstants.smallVerticalSpace,
        Container(
          margin: EdgeInsets.only(bottom: SizeUtils.spacing2, left: SizeUtils.spacing2),
          padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing4, vertical: SizeUtils.spacing2),
          decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(SizeUtils.radius4)),
          child: Text(
            '$discountPercentage% OFF',
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
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            isEnabled: _isDescriptionEnabled,
            onEditToggle: _toggleDescriptionEdit,
            maxLines: 5,
            errorText: _descriptionError,
          ),
          if (_isDescriptionEnabled) ...[
            AppConstants.smallVerticalSpace,
            Text(
              '${_descriptionController.text.trim().length}/1000 characters (min: 100)',
              style: AppTextStyles.bodySmall(
                color: _descriptionController.text.trim().length < 100
                    ? AppColors.error
                    : _descriptionController.text.trim().length > 1000
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
                onTap: _toggleCategoryEdit,
                child: Icon(_isCategoryEnabled ? Icons.check : Icons.edit_outlined, size: SizeUtils.getWidth(16), color: AppColors.primary),
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
              value: _selectedCategory,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
              dropdownColor: AppColors.surface,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  enabled: _isCategoryEnabled,
                  child: Text(category, style: AppTextStyles.bodyMedium(color: AppColors.textPrimary)),
                );
              }).toList(),
              onChanged: _isCategoryEnabled ? (value) => setState(() => _selectedCategory = value) : null,
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
                ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')), _IndianPriceFormatter(maxDigitsBeforeDecimal: 8, maxDigitsAfterDecimal: 2)]
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
              if (product.createdAt != null) ...[_buildInfoRow('Created', _formatDate(product.createdAt!), Icons.access_time_outlined)],
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
}

// Shimmer Widget
class _ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;

  const _ShimmerBox({this.width, required this.height});

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
            borderRadius: BorderRadius.circular(SizeUtils.radius8),
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

// Indian Price Formatter
class _IndianPriceFormatter extends TextInputFormatter {
  final int maxDigitsBeforeDecimal;
  final int maxDigitsAfterDecimal;

  _IndianPriceFormatter({required this.maxDigitsBeforeDecimal, required this.maxDigitsAfterDecimal});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final text = newValue.text;
    final textWithoutCommas = text.replaceAll(',', '');

    if (textWithoutCommas.startsWith('0') && textWithoutCommas.length > 1 && !textWithoutCommas.startsWith('0.')) {
      return oldValue;
    }

    final parts = textWithoutCommas.split('.');
    if (parts.length > 2) return oldValue;

    if (parts[0].length > maxDigitsBeforeDecimal) return oldValue;

    if (parts.length == 2 && parts[1].length > maxDigitsAfterDecimal) {
      return oldValue;
    }

    String formattedText = _formatIndianNumberRealtime(textWithoutCommas);
    int newCursorPosition = _calculateCursorPosition(oldValue.text, newValue.text, formattedText, newValue.selection.baseOffset);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  String _formatIndianNumberRealtime(String number) {
    if (number.isEmpty) return number;

    final parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    if (integerPart.length <= 3) {
      return integerPart + decimalPart;
    }

    String result = '';
    int count = 0;

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
    int digitsBeforeCursor = newText.substring(0, oldCursor.clamp(0, newText.length)).replaceAll(',', '').length;

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
