import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarFactory.create(title: 'Add Products', showBackButton: true),
    );
  }
}
