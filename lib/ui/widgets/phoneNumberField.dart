import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uber_mobile/utils/colors.dart';
import 'package:uber_mobile/utils/typography.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.onChanged,
  });

  final Function(PhoneNumber number) onChanged;

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useEmoji: true,
      ),
      selectorTextStyle: UberTypography.buttonStyle(),
      formatInput: true,
      onInputValidated: (v) {},
      spaceBetweenSelectorAndTextField: 5,
      initialValue: PhoneNumber(isoCode: "GH"),
      inputDecoration: InputDecoration(
        hintText: "eg. 244444444",
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: UberColors.primary, width: 1),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: UberColors.primary, width: 1),
        ),
        hintStyle: UberTypography.buttonStyle(color: Colors.white.withOpacity(0.5)),
      ),
      textStyle: UberTypography.buttonStyle(color: Colors.white),
      // initialValue: PhoneNumber(dialCode: "+233", isoCode: "+233"),
      onInputChanged: onChanged,
      onSaved: (value) => onChanged(value),
    );
  }
}
