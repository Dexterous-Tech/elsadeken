import 'package:elsadeken/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonInfoSheet extends StatefulWidget {
  
  final String personId;
  
  const PersonInfoSheet({
    Key? key,
    required this.personId,
  }) : super(key: key);

  @override
  State<PersonInfoSheet> createState() => _PersonInfoSheetState();
}
   
class _PersonInfoSheetState extends State<PersonInfoSheet> {
  final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.5, 0.6, 0.95],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildPersonHeader(),
                    const SizedBox(height: 20),
                    _buildAboutSection(),
                    const SizedBox(height: 30),
                    _buildLogTable(),
                    const SizedBox(height: 30),
                    _buildDataTable(),
                    const SizedBox(height: 30),
                    _buildActionButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final isExpanded = _controller.size > 0.7;
        _controller.animateTo(
          isExpanded ? 0.4 : 0.95,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      onPanUpdate: (details) {
        _controller.animateTo(
          (_controller.size - (details.delta.dy / MediaQuery.of(context).size.height))
            .clamp(0.4, 0.95),
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeOut,
        );
      },
      child: Center(
        child: Container(
          width: 60.w,
          height: 6.h,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Ammar muahmmed',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'السعودية,الرياض',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'عن الشخص',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 8),
        Text(
          'integer vulputate mi vel molestie rutrum. Duis faucibus lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris dignissim suscipit blandit mauris cursus. Vestibulum accumsan rhoncus bibendum. In mauris elit, tempor ut lorem ut, cursus lacinia phasellus sed dolor leo.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLogTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              color: AppColors.sunray, // تغيير اللون حسب احتياجاتك
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
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
        borderRadius: BorderRadius.circular(12),
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
              color: AppColors.sunray, // تغيير اللون حسب احتياجاتك
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
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
      {'label': 'تاريخ آخر زيادة', 'value': 'متواجد حاليا'},
    ];

    return data.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150.w,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.beer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                textAlign: TextAlign.center,
                item['value']!,
                style: const TextStyle(
                  color: Color.fromARGB(255, 46, 34, 30),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              item['label']!,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
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
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150.w,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.beer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                textAlign: TextAlign.center,
                item['value']!,
                style: const TextStyle(
                  color: Color.fromARGB(255, 46, 34, 30),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              item['label']!,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context, 'rejected');
          },
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/home/home_outline_message.png',
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: 16)
      ],
    );
  }
}