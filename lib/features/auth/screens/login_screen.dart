import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wpclonemn/colors.dart';
import 'package:wpclonemn/common/utils/utils.dart';
import 'package:wpclonemn/common/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';

import '../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneEditingController = TextEditingController();
  Country? country;

  bool isLoading = false;

  @override
  void dispose() {
    phoneEditingController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        // print('Select country: ${_country.displayName}');
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneEditingController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: "Fill out all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your phone number'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text('WhatsApp will need to verify your phone number'),
              SizedBox(height: 20),
              TextButton(
                onPressed: pickCountry,
                child: Text(
                  'Pick Country',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (country != null)
                Text(
                  '+${country!.phoneCode}',
                  style: TextStyle(
                    // color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneEditingController,
                  decoration: InputDecoration(hintText: 'Phone number'),
                ),
              )
            ],
          ),
          isLoading
              ? CircularProgressIndicator(
                  color: tabColor,
                )
              : SizedBox(
                  width: 80,
                  child: CustomButoon(text: 'NEXT', onPressed: sendPhoneNumber),
                )
        ],
      ),
    );
  }
}
