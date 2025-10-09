import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/localization_service.dart';
import '../../theme/app_color.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/spacing.dart';

class CustomCarouselDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String) onChanged;
  final String? initialValue;
  final int? minValue;
  final int? maxValue;
  final bool showDropdownMenu;

  const CustomCarouselDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.minValue,
    this.maxValue,
    this.showDropdownMenu = true,
  });

  @override
  State<CustomCarouselDropdown> createState() => _CustomCarouselDropdownState();
}

class _CustomCarouselDropdownState extends State<CustomCarouselDropdown> {
  late CarouselSliderController _carouselController;
  late int _currentIndex;
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();

    // Find initial index
    if (widget.initialValue != null &&
        widget.items.contains(widget.initialValue)) {
      _currentIndex = widget.items.indexOf(widget.initialValue!);
      _selectedValue = widget.initialValue!;
    } else {
      _currentIndex = 0;
      _selectedValue = widget.items[0];
    }
  }

  @override
  void didUpdateWidget(CustomCarouselDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue ||
        oldWidget.items != widget.items) {
      if (widget.initialValue != null &&
          widget.items.contains(widget.initialValue)) {
        _currentIndex = widget.items.indexOf(widget.initialValue!);
        _selectedValue = widget.initialValue!;
      } else {
        _currentIndex = 0;
        _selectedValue = widget.items[0];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: LocalizationService.instance.textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          textDirection: LocalizationService.instance.textDirection,
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: AppTextStyles.font23ChineseBlackBoldLamaSans,
                textDirection: LocalizationService.instance.textDirection,
              ),
            ),
            if (widget.showDropdownMenu)
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.brown,
                  size: 24.sp,
                ),
                onSelected: (String value) {
                  setValue(value);
                },
                itemBuilder: (BuildContext context) {
                  return widget.items.map((String item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: AppTextStyles.font16ChineseBlackMediumLamaSans,
                      ),
                    );
                  }).toList();
                },
              ),
          ],
        ),
        verticalSpace(16),
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.brown, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Selection indicator (highlighted middle item)
              Center(
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

                  return Center(
                    child: Text(
                      item,
                      style: isSelected
                          ? AppTextStyles.font20JetRegularLamaSans
                          : AppTextStyles.font16ChineseBlackMediumLamaSans,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                options: CarouselOptions(
                  scrollDirection: Axis.vertical,
                  height: 200.h,
                  viewportFraction: 0.25,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                      _selectedValue = widget.items[index];
                    });
                    widget.onChanged(_selectedValue);
                  },
                  initialPage: _currentIndex,
                ),
              ),
            ],
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
      });
    }
  }
}
