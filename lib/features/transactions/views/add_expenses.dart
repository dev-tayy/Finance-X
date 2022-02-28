import 'package:date_time_picker/date_time_picker.dart';
import 'package:finance_x/components/custom_button.dart';
import 'package:finance_x/components/custom_textfield.dart';
import 'package:finance_x/features/transactions/view-model/expenses_provider.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:finance_x/utils/extensions.dart';
import 'package:finance_x/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: must_be_immutable
class AddExpensesScreen extends HookConsumerWidget {
  static const String id = 'add_expenses_screen';
  AddExpensesScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String? dateTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _amountController = useTextEditingController();
    final _descriptionController = useTextEditingController();
    final _categoryController = useTextEditingController();

    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: const Text('Add Expenses',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            )),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.grey.shade50,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              CustomTextField(
                  textCapitalization: TextCapitalization.none,
                  hintText: 'Amount in Naira',
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  validator: (val) {
                    if (val == null) {
                      return 'Please enter an amount';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              CustomTextField(
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Description',
                keyboardType: TextInputType.text,
                controller: _descriptionController,
                validator: (val) => Validator.validateText(val ?? ""),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Category',
                keyboardType: TextInputType.text,
                controller: _categoryController,
                validator: (val) => Validator.validateText(val ?? ""),
              ),
              const SizedBox(height: 20),
              DateTimePicker(
                use24HourFormat: true,
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                icon: const Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                validator: (val) {
                  if (val == null) {
                    return 'Please select a date and time';
                  }
                  return null;
                },
                onSaved: (val) => dateTime = val,
              ),
              const SizedBox(height: 40),
              CustomButton(
                  label: 'Save',
                  color: AppColors.tertiaryColor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      var amount = int.parse(_amountController.text);
                      var parsedDateTime = DateTime.parse(dateTime ?? '');
                      ref.read(expensesNotifierProvider.notifier).addExpense(
                            amount: amount,
                            description: _descriptionController.text,
                            category: _categoryController.text,
                            dateTime: parsedDateTime,
                            context: context,
                          );
                    }
                  },
                  size: size,
                  textColor: AppColors.white,
                  borderSide: BorderSide.none),
              const SizedBox(height: 20),
            ],
          ).paddingSymmetric(h: 20),
        ),
      ),
    );
  }
}
