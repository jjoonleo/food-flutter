import 'package:flutter/material.dart';
import 'package:flutter_application_hello_world/main.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key, required this.title});

  final String title;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  //int _selectedIndex = 1;
  final _formKey = GlobalKey<FormBuilderState>();
  final double pickerHeight = 150;
  var spicyOptions = ["불닭 이상", "신라면 이상", "매운 맛이 존재", "매운맛이 없음"];
  var temperatureOptions = ["뜨거움", "보통", "차가움"];
  var countryOptions = ["한식", "양식", "중식", "일식", "동남아시아", "기타"];
  var ingreOptions = ["밥", "면", "빵", "떡", "육류"];
  String? gender = "man";

  Future<void> addFood(Map<String, dynamic> value) async {
    final response = await http.post(Uri.parse('http://ejun.kro.kr/api/food/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(value));

    print(response.statusCode);
    final result = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      Navigator.of(context).pop();
    } else {
      //throw Exception("Failed to add restaurantto database");
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    Map<String, dynamic> inputValues = Map.of(_formKey.currentState!.value);

    inputValues["restaurant"] = widget.title;
    print(_formKey.currentState?.value);
    addFood(inputValues);
  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            Text("이름", style: TextStyle(fontSize: 20)),
            FormBuilderTextField(
              name: "name",
              autovalidateMode: AutovalidateMode.always,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            FormBuilderField(
              name: "spicy",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              builder: (FormFieldState<dynamic> field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: "맵기",
                    labelStyle: const TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                    ),
                    contentPadding:
                        const EdgeInsets.only(top: 10.0, bottom: 0.0),
                    border: InputBorder.none,
                    errorText: field.errorText,
                  ),
                  child: SizedBox(
                    height: pickerHeight,
                    child: CupertinoPicker(
                      itemExtent: 30,
                      children: spicyOptions.map((c) => Text(c)).toList(),
                      onSelectedItemChanged: (index) {
                        field.didChange(index);
                      },
                    ),
                  ),
                );
              },
            ),
            FormBuilderField(
              name: "temperature",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              builder: (FormFieldState<dynamic> field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: "온도",
                    labelStyle: const TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                    ),
                    contentPadding:
                        const EdgeInsets.only(top: 10.0, bottom: 0.0),
                    border: InputBorder.none,
                    errorText: field.errorText,
                  ),
                  child: SizedBox(
                    height: pickerHeight,
                    child: CupertinoPicker(
                      itemExtent: 30,
                      children: temperatureOptions.map((c) => Text(c)).toList(),
                      onSelectedItemChanged: (index) {
                        field.didChange(index);
                      },
                    ),
                  ),
                );
              },
            ),
            FormBuilderField(
              name: "country",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              builder: (FormFieldState<dynamic> field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: "나라",
                    labelStyle: const TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                    ),
                    contentPadding:
                        const EdgeInsets.only(top: 10.0, bottom: 0.0),
                    border: InputBorder.none,
                    errorText: field.errorText,
                  ),
                  child: SizedBox(
                    height: pickerHeight,
                    child: CupertinoPicker(
                      itemExtent: 30,
                      children: countryOptions.map((c) => Text(c)).toList(),
                      onSelectedItemChanged: (index) {
                        field.didChange(index);
                      },
                    ),
                  ),
                );
              },
            ),
            FormBuilderField(
              name: "main_ingredient",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
              builder: (FormFieldState<dynamic> field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: "주재료",
                    labelStyle: const TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                    ),
                    contentPadding:
                        const EdgeInsets.only(top: 10.0, bottom: 0.0),
                    border: InputBorder.none,
                    errorText: field.errorText,
                  ),
                  child: SizedBox(
                    height: pickerHeight,
                    child: CupertinoPicker(
                      itemExtent: 30,
                      children: ingreOptions.map((c) => Text(c)).toList(),
                      onSelectedItemChanged: (index) {
                        field.didChange(index);
                      },
                    ),
                  ),
                );
              },
            ),
            FormBuilderCheckbox(
              initialValue: false,
              name: "isSweet",
              title: Text("달아요"),
            ),
            FormBuilderCheckbox(
              initialValue: false,
              name: "isSalty",
              title: Text("짜요"),
            ),
            FormBuilderCheckbox(
              initialValue: false,
              name: "togo",
              title: Text("포장가능"),
            ),
            FormBuilderCheckbox(
              initialValue: false,
              name: "delivery",
              title: Text("배달가능"),
            ),
            FormBuilderCheckbox(
              initialValue: false,
              name: "store",
              title: Text("매장가능"),
            ),
            FormBuilderCheckbox(
              initialValue: false,
              name: "cal",
              title: Text("칼로리 900 이상"),
            ),
            CupertinoButton(
              onPressed: _submit,
              child: const Text("submit"),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
