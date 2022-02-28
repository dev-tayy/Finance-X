import 'package:date_time_picker/date_time_picker.dart';
import 'package:finance_x/components/custom_button.dart';
import 'package:finance_x/components/custom_textfield.dart';
import 'package:finance_x/features/transactions/view-model/debtors_provider.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:finance_x/utils/extensions.dart';
import 'package:finance_x/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: must_be_immutable
class AddDebtorsScreen extends HookConsumerWidget {
  static const String id = 'add_debtors_screen';
  AddDebtorsScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String? borrowedDate;
  late String? dueDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _amountController = useTextEditingController();
    final _debtorEmailController = useTextEditingController();
    final _debtorNameController = useTextEditingController();
    final _descriptionController = useTextEditingController();
    final _debtorPhoneController = useTextEditingController();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: const Text('Add Debtors',
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
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Name of Debtor',
                keyboardType: TextInputType.text,
                controller: _debtorNameController,
                validator: (val) => Validator.validateName(val ?? ""),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textCapitalization: TextCapitalization.none,
                hintText: 'Debt Amount',
                keyboardType: TextInputType.number,
                controller: _amountController,
                validator: (val) {
                  if (val == null) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Debt Description',
                keyboardType: TextInputType.text,
                controller: _descriptionController,
                validator: (val) => Validator.validateText(val ?? ""),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textCapitalization: TextCapitalization.none,
                hintText: 'Phone Number of Debtor',
                maxLength: 11,
                keyboardType: TextInputType.number,
                controller: _debtorPhoneController,
                validator: (val) => Validator.validatePhoneNumber(val ?? ""),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Email address of Debtor',
                keyboardType: TextInputType.emailAddress,
                controller: _debtorEmailController,
                validator: (val) => Validator.validateEmail(val ?? ""),
              ),
              const SizedBox(height: 20),
              DateTimePicker(
                use24HourFormat: true,
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                icon: const Icon(Icons.event),
                dateLabelText: 'Date Borrowed',
                timeLabelText: "Hour Borrowed",
                validator: (val) {
                  if (val == null) {
                    return 'Please select a date and time';
                  }
                  return null;
                },  
                onSaved: (val) => borrowedDate = val,
              ),
              const SizedBox(height: 20),
              DateTimePicker(
                use24HourFormat: true,
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: const Icon(Icons.event),
                dateLabelText: 'Due Date',
                timeLabelText: "Due Time",
                validator: (val) {
                  if (val == null) {
                    return 'Please select a date and time';
                  }
                  return null;
                },
                onSaved: (val) => dueDate = val,
              ),
              const SizedBox(height: 40),
              CustomButton(
                  label: 'Save',
                  color: AppColors.tertiaryColor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      var amount = int.parse(_amountController.text);
                      var parsedBorrowedDate =
                          DateTime.parse(borrowedDate ?? '');
                      var parsedDueDate = DateTime.parse(dueDate ?? '');

                      ref.read(debtorsNotifierProvider.notifier).addDebtor(
                            debtorName: _debtorNameController.text,
                            debtorPhone: _debtorPhoneController.text,
                            borrowedDate: parsedBorrowedDate,
                            dueDate: parsedDueDate,
                            debtorEmail: _debtorEmailController.text,
                            amount: amount,
                            description: _descriptionController.text,
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
