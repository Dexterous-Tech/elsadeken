import 'package:flutter/material.dart';
import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTable extends StatelessWidget {
  const DetailsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildLogTable(),
          SizedBox(height: 30.h),
          _buildDataTable(),
        ],
      ),
    );
  }

  Widget _buildLogTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.yellowrec,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Center(
              child: Text(
                'تاريخ السجل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8),
                ..._buildLogData(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.yellowrec,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            alignment: Alignment.centerRight,
            child: const Text(
              'المعلومات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8.h),
                ..._buildDataRows(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLogData() {
    final data = [
      {'label': 'مسجل منذ', 'value': 'منذ يوم'},
      {'label': 'تاريخ آخر زيارة', 'value': 'متواجد حاليا'},
    ];

    return data.map((item) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.orangeHighLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                textAlign: TextAlign.center,
                item['value']!,
                style: TextStyle(
                  color: const Color.fromARGB(255, 46, 34, 30),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              item['label']!,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildDataRows() {
    final data = [
      {'label': 'الجنسيه', 'value': 'سعودي'},
      {'label': 'الاقامه', 'value': 'الرياض'},
      {'label': 'المدينه', 'value': 'الرياض'},
      {'label': 'نوع الزواج', 'value': 'زوجه اولي'},
      {'label': 'الحاله الاجتماعيه', 'value': 'مطلق'},
      {'label': 'عدد الاطفال', 'value': 'لا يوجد'},
      {'label': 'لون البشره', 'value': 'حنطي مايل للبياض'},
      {'label': 'الطول', 'value': '190 سنتي'},
      {'label': 'الوزن', 'value': '80 كيلو'},
    ];

    return data.map((item) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.orangeHighLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                textAlign: TextAlign.center,
                item['value']!,
                style: TextStyle(
                  color: const Color.fromARGB(255, 46, 34, 30),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              item['label']!,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
