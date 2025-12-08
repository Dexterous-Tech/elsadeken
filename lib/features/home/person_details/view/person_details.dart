import 'package:elsadeken/core/theme/app_color.dart';
import 'package:elsadeken/features/home/person_details/data/data_source/person_service.dart';
import 'package:elsadeken/features/home/person_details/data/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/di/injection_container.dart';
import 'package:elsadeken/features/chat/presentation/manager/chat_list_cubit/cubit/chat_list_cubit.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'widgets/person_image.dart';
import 'widgets/person_info.dart';

class PersonDetailsView extends StatefulWidget {
  final int personId;
  final String imageUrl;

  const PersonDetailsView({
    super.key,
    required this.personId,
    required this.imageUrl,
  });

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

    // Validate inputs
    if (widget.personId <= 0) {
      setState(() {
        errorMessage = AppLocalizations.of(context)!.invalidPersonId;
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
          errorMessage = AppLocalizations.of(context)!.noDataFound;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = AppLocalizations.of(context)!.failedToLoadUserDetails;
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
            ? Center(child: CircularProgressIndicator(color: AppColors.beer))
            : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                    SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: fetchData,
                      child: Text(AppLocalizations.of(context)!.tryAgain),
                    ),
                  ],
                ),
              )
            : person == null
            ? Center(
                child: Text(AppLocalizations.of(context)!.noDataFoundShort),
              )
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.cosmicLatte, AppColors.antiqueWhite],
                  ),
                ),
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
