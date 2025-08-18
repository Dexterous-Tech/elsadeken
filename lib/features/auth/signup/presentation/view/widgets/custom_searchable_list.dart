import 'package:elsadeken/core/helper/app_svg.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/core/theme/app_text_styles.dart';
import 'package:elsadeken/core/theme/font_weight_helper.dart';
import 'package:elsadeken/core/theme/spacing.dart';
import 'package:elsadeken/core/widgets/forms/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../manager/sign_up_lists_cubit.dart';

enum ListType { nationality, country, city }

// Generic interface for items that can be displayed in the list
mixin ListItemModel {
  int? get id;
  String? get name;
}

class CustomSearchableList extends StatefulWidget {
  const CustomSearchableList({
    super.key,
    required this.listType,
    required this.onItemSelected,
    this.selectedItem,
    this.countryId, // Required for cities
  });

  final ListType listType;
  final Function(ListItemModel) onItemSelected;
  final ListItemModel? selectedItem;
  final String? countryId; // Country ID needed for cities

  @override
  State<CustomSearchableList> createState() => _CustomSearchableListState();
}

class _CustomSearchableListState extends State<CustomSearchableList> {
  final TextEditingController _searchController = TextEditingController();
  List<ListItemModel> _filteredItems = [];
  List<ListItemModel> _allItems = [];

  @override
  void initState() {
    super.initState();
    // Trigger loading based on list type
    if (widget.listType == ListType.nationality) {
      context.read<SignUpListsCubit>().getNationalities();
    } else if (widget.listType == ListType.country) {
      context.read<SignUpListsCubit>().getCountries();
    } else if (widget.listType == ListType.city) {
      // Cities require a country ID
      if (widget.countryId != null && widget.countryId!.isNotEmpty) {
        context.read<SignUpListsCubit>().getCites(widget.countryId!);
      }
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems
            .where((item) =>
                item.name
                    ?.toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  void _onItemSelected(ListItemModel item) {
    // Clear the search field when an item is selected
    setState(() {
      _searchController.clear();
      _filteredItems = _allItems;
    });
    // Call the callback to notify parent widget
    widget.onItemSelected(item);
  }

  String get _title {
    switch (widget.listType) {
      case ListType.nationality:
        return 'ما هي جنسيتك ؟';
      case ListType.country:
        return 'ما هي دولتك ؟';
      case ListType.city:
        return 'ما هي مديتنك ؟';
    }
  }

  String get _noResultsMessage {
    return 'لا توجد نتائج للبحث "${_searchController.text}"';
  }

  String get _noItemsMessage {
    switch (widget.listType) {
      case ListType.nationality:
        return 'لا توجد جنسيات متاحة';
      case ListType.country:
        return 'لا توجد دول متاحة';
      case ListType.city:
        return 'لا توجد مدن متاحة';
    }
  }

  String get _retryButtonText => 'إعادة المحاولة';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpListsCubit, SignUpListsState>(
      listener: (context, state) {
        if ((widget.listType == ListType.nationality &&
                state is NationalitiesSuccess) ||
            (widget.listType == ListType.country &&
                state is CountriesSuccess) ||
            (widget.listType == ListType.city && state is CitiesSuccess)) {
          setState(() {
            if (state is NationalitiesSuccess) {
              _allItems = state.nationalitiesList.cast<ListItemModel>();
            } else if (state is CountriesSuccess) {
              _allItems = state.countriesList.cast<ListItemModel>();
            } else if (state is CitiesSuccess) {
              _allItems = state.citiesList.cast<ListItemModel>();
            }
            _filteredItems = _allItems;
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Title
            Text(
              _title,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.font23ChineseBlackBoldLamaSans,
            ),
            verticalSpace(16),
            // Search Field
            CustomTextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              hintText: 'بحث..',
              validator: (value) {},
              suffixIcon: Icon(
                Icons.search,
                size: 25,
                color: AppColors.paleBrown,
              ),
              hintStyle: AppTextStyles.font16PaleBrownRegularLamaSans,
            ),
            verticalSpace(18),
            // Items List
            Expanded(
              child: _buildItemsList(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemsList(SignUpListsState state) {
    // Check loading state based on list type
    bool isLoading = (widget.listType == ListType.nationality &&
            state is NationalitiesLoading) ||
        (widget.listType == ListType.country && state is CountriesLoading) ||
        (widget.listType == ListType.city && state is CitiesLoading);

    // Check failure state based on list type
    bool isFailure = (widget.listType == ListType.nationality &&
            state is NationalitiesFailure) ||
        (widget.listType == ListType.country && state is CountriesFailure) ||
        (widget.listType == ListType.city && state is CitiesFailure);

    String? errorMessage;
    if (state is NationalitiesFailure) {
      errorMessage = state.error;
    } else if (state is CountriesFailure) {
      errorMessage = state.error;
    } else if (state is CitiesFailure) {
      errorMessage = state.error;
    }

    // Check success state based on list type
    bool isSuccess = (widget.listType == ListType.nationality &&
            state is NationalitiesSuccess) ||
        (widget.listType == ListType.country && state is CountriesSuccess) ||
        (widget.listType == ListType.city && state is CitiesSuccess);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.paleBrown,
        ),
      );
    }

    if (isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.paleBrown,
              size: 48,
            ),
            verticalSpace(8),
            Text(
              errorMessage ?? 'حدث خطأ',
              style: AppTextStyles.font16PaleBrownRegularLamaSans,
              textAlign: TextAlign.center,
            ),
            verticalSpace(8),
            TextButton(
              onPressed: () {
                if (widget.listType == ListType.nationality) {
                  context.read<SignUpListsCubit>().getNationalities();
                } else if (widget.listType == ListType.country) {
                  context.read<SignUpListsCubit>().getCountries();
                } else if (widget.listType == ListType.city) {
                  if (widget.countryId != null &&
                      widget.countryId!.isNotEmpty) {
                    context
                        .read<SignUpListsCubit>()
                        .getCites(widget.countryId!);
                  }
                }
              },
              child: Text(
                _retryButtonText,
                style: AppTextStyles.font16PaleBrownRegularLamaSans,
              ),
            ),
          ],
        ),
      );
    }

    if (isSuccess && _filteredItems.isNotEmpty) {
      return ListView.separated(
        itemCount: _filteredItems.length,
        separatorBuilder: (context, index) => verticalSpace(15),
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          final isSelected = widget.selectedItem?.id == item.id;

          return Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.sunsetOrange.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: Text(
                  item.name ?? '',
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.font18WhiteSemiBoldLamaSans.copyWith(
                    color: AppColors.chineseBlack,
                    fontWeight: FontWeightHelper.bold,
                  ),
                ),
                trailing: isSelected
                    ? SvgPicture.asset(
                        AppSvg.checkCircle,
                        width: 16.w,
                        height: 16.h,
                      )
                    : null,
                onTap: () => _onItemSelected(item),
              ),
            ),
          );
        },
      );
    }

    if (isSuccess &&
        _filteredItems.isEmpty &&
        _searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          _noResultsMessage,
          style: AppTextStyles.font16PaleBrownRegularLamaSans,
          textDirection: TextDirection.rtl,
        ),
      );
    }

    return Center(
      child: Text(
        _noItemsMessage,
        style: AppTextStyles.font16PaleBrownRegularLamaSans,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
