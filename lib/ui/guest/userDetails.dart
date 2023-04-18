import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_mobile/core/providers/sessionManager.dart';
import 'package:uber_mobile/ui/widgets/backButton.dart';
import 'package:uber_mobile/ui/widgets/datePickerField.dart';
import 'package:uber_mobile/ui/widgets/phoneNumberField.dart';
import 'package:uber_mobile/ui/widgets/primaryButton.dart';
import 'package:uber_mobile/utils/colors.dart';
import 'package:uber_mobile/utils/typography.dart';

final viewModel = StateNotifierProvider<CreateUserMetaDataViewModel, bool>(
    (ref) => CreateUserMetaDataViewModel(false));

class UserDetailsPage extends ConsumerWidget {
  UserDetailsPage({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(viewModel.notifier);
    final ready = ref.watch(viewModel);
    final session = ref.read(sessionProvider.notifier);

    return Scaffold(
      backgroundColor: UberColors.bgColor,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [UberBackButton()],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    UberText.title("User Details"),
                    UberText.paragraphRegular("Provide necessary details in order to proceed..."),
                    const SizedBox(height: 30),
                    PhoneNumberField(
                      onChanged: (number) {
                        model.setPhone(number.phoneNumber!);
                      },
                    ),
                    const SizedBox(height: 15),
                    DatepickerField(
                        date: model.dateOfBirth,
                        hintText: "Date of Birth",
                        onChanged: (date) {
                          model.setDateTime(date);
                        })
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: PrimaryButton(
                      title: "Submit",
                      onPressed: ready
                          ? () {
                              final state = formKey.currentState!;
                              if (!state.validate()) return;
                              session.createUserMetaData(model);
                            }
                          : null),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
