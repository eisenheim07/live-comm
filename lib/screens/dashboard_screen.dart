import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarFactory.create(title: 'BazaarLive', showBackButton: false),
      body: Padding(
        padding: SizeUtils.scaffoldPaddingSmall,
        child: Column(
          children: [
            AppConstants.mediumVerticalSpace,
            Text('Welcome to BazaarLive Dashboard', style: AppTextStyles.bodyLarge(color: AppColors.textSecondary)),
            AppConstants.largeVerticalSpace,
            // You can add more dashboard content here
            Expanded(
              child: Center(
                child: Text('Dashboard Content Goes Here', style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
