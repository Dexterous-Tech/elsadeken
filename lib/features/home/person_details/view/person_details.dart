import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/home/person_details/data/data_source/person_service.dart';
import 'package:elsadeken/features/home/person_details/data/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'widgets/person_image.dart';
import 'widgets/person_info.dart';

class PersonDetailsView extends StatefulWidget {
  final int personId;
  final String imageUrl;

  const PersonDetailsView({
    Key? key,
    required this.personId,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<PersonDetailsView> createState() => _PersonDetailsViewState();
}

class _PersonDetailsViewState extends State<PersonDetailsView> {
  PersonModel? person;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print("PersonDetailsView initialized with:");
    print("  personId: ${widget.personId}");
    print("  imageUrl: ${widget.imageUrl}");
    print("  personId type: ${widget.personId.runtimeType}");

    // Validate inputs
    if (widget.personId <= 0) {
      setState(() {
        errorMessage = "Invalid person ID provided";
        isLoading = false;
      });
      return;
    }

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await PersonService.fetchPersonDetails(widget.personId);

      if (data != null) {
        setState(() {
          person = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "No data found for this user";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching person details: $e");
      setState(() {
        errorMessage = "Failed to load user details. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatListCubit>(),
      child: Scaffold(
        // backgroundColor: Colors.grey[800],
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: AppColors.beer,
              ))
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 80, color: Colors.red[300]),
                        SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchData,
                          child: Text('حاول مرة أخرى'),
                        ),
                      ],
                    ),
                  )
                : person == null
                    ? const Center(child: Text("No data found"))
                    : SafeArea(
                        child: Stack(
                          children: [
                            PersonImageHeader(imageUrl: person!.image),
                            PersonInfoSheet(person: person!),
                          ],
                        ),
                      ),
      ),
    );
  }
}
