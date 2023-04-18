import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uber_mobile/utils/colors.dart';
import 'package:uber_mobile/utils/typography.dart';

class DatepickerField extends StatefulWidget {
  DatepickerField({super.key, this.hintText, required this.onChanged, required this.date});

  final String? hintText;
  final Function(DateTime date) onChanged;
  DateTime? date;

  @override
  State<DatepickerField> createState() => _DatepickerFieldState();
}

class _DatepickerFieldState extends State<DatepickerField> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }
  late TextEditingController controller = TextEditingController(
      text: widget.date == null ? null : DateFormat("EEE  d MMM, yyy").format(widget.date!));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextFormField(
      // readOnly: true,
      keyboardType: TextInputType.none,
      controller: controller,
      style: UberTypography.buttonStyle(color: Colors.white),
      onTap: () async {
        final result = await showCalendarDatePicker2Dialog(
            context: context,
            config: CalendarDatePicker2WithActionButtonsConfig(
              firstDate: DateTime(1930),
              lastDate: DateTime(DateTime.now().year - 15),
            ),
            dialogSize: Size(0.8 * size.width, 0.8 * size.width));

        if (result == null) return;
        widget.date = result[0];
        controller.text = DateFormat("EEE  d MMM, yyy").format(widget.date!);
        widget.onChanged(widget.date!);
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
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
    );
  }
}
