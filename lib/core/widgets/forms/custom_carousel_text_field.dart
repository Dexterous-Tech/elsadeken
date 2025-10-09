import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/localization_service.dart';
import '../../theme/app_color.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/spacing.dart';
import 'custom_text_form_field.dart';

class CustomCarouselTextField extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String) onChanged;
  final String? initialValue;
  final String? Function(String?)? validator;
  final String? hintText;
  final double? carouselHeight;

  const CustomCarouselTextField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.hintText,
    this.carouselHeight,
  });

  @override
  State<CustomCarouselTextField> createState() =>
      _CustomCarouselTextFieldState();
}

class _CustomCarouselTextFieldState extends State<CustomCarouselTextField> {
  late CarouselSliderController _carouselController;
  late int _currentIndex;
  late String _selectedValue;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    _textController = TextEditingController();

    // Find initial index
    if (widget.initialValue != null &&
        widget.items.contains(widget.initialValue)) {
      _currentIndex = widget.items.indexOf(widget.initialValue!);
      _selectedValue = widget.initialValue!;
      _textController.text = widget.initialValue!;
    } else {
      // Don't set any initial value - let hint text show
      _currentIndex = 0;
      _selectedValue = '';
      _textController.text = '';
    }
  }

  @override
  void didUpdateWidget(CustomCarouselTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue ||
        oldWidget.items != widget.items) {
      if (widget.initialValue != null &&
          widget.items.contains(widget.initialValue)) {
        _currentIndex = widget.items.indexOf(widget.initialValue!);
        _selectedValue = widget.initialValue!;
        _textController.text = widget.initialValue!;
      } else {
        // Don't set any initial value - let hint text show
        _currentIndex = 0;
        _selectedValue = '';
        _textController.text = '';
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showCarouselBottomSheet() {
    // Calculate flexible height based on carousel options
    final carouselHeight = widget.carouselHeight ?? 300.h;
    final bottomSheetHeight =
        carouselHeight + 120.h; // Extra space for handle, title, and margins

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: bottomSheetHeight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            verticalSpace(20),
            // Title
            Text(
              widget.label,
              style: AppTextStyles.font20JetRegularLamaSans,
              textDirection: LocalizationService.instance.textDirection,
            ),
            verticalSpace(20),
            // Carousel
            Expanded(
              child: Container(
                height: carouselHeight,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.brown, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Selection indicator (highlighted middle item) - positioned exactly in center
                    Positioned(
                      top: (carouselHeight - 50.h) /
                          2, // Center vertically using dynamic height
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.brown.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // Carousel
                    CarouselSlider.builder(
                      carouselController: _carouselController,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = widget.items[index];
                        final isSelected = index == _currentIndex;

                        return GestureDetector(
                          onTap: () {
                            // Select item and close modal immediately
                            setState(() {
                              _textController.text = item;
                              _selectedValue = item;
                            });
                            widget.onChanged(item);
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              item,
                              style: isSelected
                                  ? AppTextStyles.font20JetRegularLamaSans
                                  : AppTextStyles
                                      .font16ChineseBlackMediumLamaSans,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        scrollDirection: Axis.vertical,
                        height: carouselHeight,
                        viewportFraction: 0.25,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                            _selectedValue = widget.items[index];
                          });
                        },
                        initialPage: _currentIndex,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.font23ChineseBlackBoldLamaSans,
          textDirection: LocalizationService.instance.textDirection,
        ),
        verticalSpace(16),
        CustomTextFormField(
          controller: _textController,
          hintText: widget.hintText ?? '',
          validator: widget.validator ?? (value) => null,
          readOnly: true,
          onTap: _showCarouselBottomSheet,
          suffixIcon: Container(
            padding: EdgeInsets.all(12.w),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.brown,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  // Method to get current selected value
  String get selectedValue => _selectedValue;

  // Method to set value programmatically
  void setValue(String value) {
    if (widget.items.contains(value)) {
      final index = widget.items.indexOf(value);
      _carouselController.animateToPage(index);
      setState(() {
        _currentIndex = index;
        _selectedValue = value;
        _textController.text = value;
      });
    }
  }
}
