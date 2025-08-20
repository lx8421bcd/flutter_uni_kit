import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/form/app_form.dart';
import 'package:flutter_uni_kit/form/date_select_form_field.dart';
import 'package:flutter_uni_kit/form/email_input_form_field.dart';
import 'package:flutter_uni_kit/form/field_option.dart';
import 'package:flutter_uni_kit/form/multi_select_form_field.dart';
import 'package:flutter_uni_kit/form/phone_number_input_form_field.dart';
import 'package:flutter_uni_kit/form/single_select_form_field.dart';
import 'package:flutter_uni_kit/form/text_input_form_field.dart';
import 'package:flutter_uni_kit/form/validators.dart';
import 'package:flutter_uni_kit/widgets/auto_hide_keyboard.dart';
import 'package:flutter_uni_kit/widgets/color_button.dart';
import 'package:get/get.dart';


class FormTestPage extends StatefulWidget {
  const FormTestPage({super.key});

  @override
  State<FormTestPage> createState() => _FormTestPageState();
}

class _FormTestPageState extends State<FormTestPage> {

  final formKey = GlobalKey<FormState>();
  final form = AppForm();

  final formValues = "".obs;

  @override
  Widget build(BuildContext context) {
    return AutoHideKeyboard(
      child: Form(
        key: form.formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            TextInputFormField(
              form: form,
              fieldName: "text",
              // controller: TextEditingController(),
              labelText: "Gameabc",
              hintText: "asdkfl",
              // inputConfigs: InputConfigs(
              //
              // ),
              showClearButton: true,
              validator: combineValidator(validators: [
                nonEmptyValidator(),
              ]),
              initialValue: 'gdlskd',
              autovalidateMode: AutovalidateMode.always,
            ),
            const SizedBox(height: 12),
            PhoneNumberInputFormField(
              labelText: "Phone Number Input",
              form: form,
              fieldName: "phone",
              initialValue: "6808881234",
              initialLocaleCode: "1",
              localeFieldName: "phoneLocale",
              locales: [
                PhoneLocaleInfo(
                  code: "1",
                  isoCode: "US",
                  name: () => "United States"
                ),
                PhoneLocaleInfo(
                  code: "63",
                  isoCode: "PH",
                  name: () => "Philippines"
                ),
                PhoneLocaleInfo(
                  code: "86",
                  isoCode: "CN",
                  name: () => "China"
                ),
              ],
            ),
            const SizedBox(height: 12),
            EmailInputInputFormField(
              labelText: "Email Input",
              form: form,
              fieldName: "email",
              initialValue: "asldkfl@123.com",
            ),
            const SizedBox(height: 12),
            SingleSelectFormField<String>(
              labelText: "Purpose(Single Select)",
              form: form,
              fieldName: "purpose",
              initialValue: "Construction",
              options: [
                "Agriculture/Manufacturing",
                "Information Technology",
                "Construction",
                "Education/Teaching",
                "Retail/Sales",
                "Administration/Clerical",
                "Hotel/Restaurant",
                "Banking/Finance/Insurance",
                "Medical&Health",
                "Transportation/Shipping",
                "Advertising/Media/Communications",
                "Tourism/Airlines/Maritime",
                "Arts/Entertainment and Recreation",
                "Domestic Helper/Child Care",
                "Personal Care Services",
                "Government/Civil Servant",
                "Real Estate/Property",
                "Automotive Repairs and Sales",
              ]
              .map((item) => Options(label: item, value: item))
              .toList(),
            ),
            const SizedBox(height: 12),
            SingleSelectFormField<String>(
              labelText: "Gender(Single Select Radio Style)",
              displayStyle: SingleSelectFormFieldDisplayStyle.radio,
              form: form,
              fieldName: "gender",
              options: [
                Options(label: "Female", value: "female"),
                Options(label: "Male", value: "male"),
              ],
              validator: combineValidator(validators: [
                nonEmptyValidator()
              ]),
            ),
            const SizedBox(height: 12),
            MultiSelectFormField<String>(
              labelText: "Support Currency(Multi Select)",
              displayStyle: MultiSelectFormFieldDisplayStyle.checkbox,
              form: form,
              fieldName: "currencies",
              options: [
                Options(label: "PHP", value: "PHP"),
                Options(label: "USD", value: "USD"),
                Options(label: "CNY", value: "CNY"),
                Options(label: "NTD", value: "NTD"),
              ],
              validator: combineValidator(validators: [
                nonEmptyValidator()
              ]),
            ),
            const SizedBox(height: 12),
            DateSelectFormField(
              labelText: "Date Select",
              form: form,
              fieldName: "date",
              initialValue: DateTime.now(),
            ),
            const SizedBox(height: 12),
            DateSelectFormField(
              labelText: "Birthday Select",
              form: form,
              fieldName: "birthday",
              maxDate: DateTime.now(),
              validator: combineValidator(validators: [
                nonEmptyValidator(),
                ageValidator(18),
              ]),
              initialValue: DateTime.now(),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ColorButton(
                onPressed: () {
                  if (!form.validate()) {
                    return;
                  }
                  var values = form.getFieldsValue();
                  values["phoneLocale"] = values["phoneLocale"].toString();
                  formValues.value = values.toString();
                },
                child: const Text("Submit")
              ),
            ),
            Obx(() => Text(
                formValues.value
            ))
          ],
        )
      ),
    );
  }

}
