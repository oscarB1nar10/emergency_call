import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utility/Countries.dart';
import '../utility/Strings.dart';
import 'HomeBloc.dart';
import 'HomeEvents.dart';
import 'HomeState.dart';

class CountrySelectorWidget extends StatefulWidget {
  const CountrySelectorWidget({Key? key}) : super(key: key);

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelectorWidget> {
  @override
  void initState() {
    _onGetCountryDial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: (const Text(Strings.countryPicker)),
          centerTitle: true,
        ),
        body: Center(
          child: onCountryCode(context),
        ),
      );

  Widget onCountryCode(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      List phoneCodeAndIsoCode = _getDefaultPhoneAndIsoCode(state);
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CountryCodePicker(
              onChanged: (countryCode) => {_onCountryChange(countryCode)},
              initialSelection: phoneCodeAndIsoCode[1],
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              favorite: [phoneCodeAndIsoCode[0], phoneCodeAndIsoCode[1]],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
              showFlagDialog: true,
            ),
          ),
        ],
      );
    });
  }

  _onGetCountryDial() {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    // Launch event to get the country dial code.
    homeBloc.add(const EventGetCountryDealCode());
  }

  _onCountryChange(CountryCode countryCode) {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    var countryMatch = const Country();

    for (var country in CountryHelper.countryList) {
      if ("+${country.phoneCode}" == countryCode.dialCode) {
        countryMatch = country;
        // Launch event to save the country.
        homeBloc.add(EventSaveCountryDealCode(country));
        break;
      }
    }

    // Go back if a country is selected
    goBackWithSelectedCountry(countryMatch);
  }

  _getDefaultPhoneAndIsoCode(HomeState homeState) {
    String phoneCode = "";
    String isoCode = "";

    if (homeState.country.phoneCode.isNotEmpty) {
      phoneCode = homeState.country.phoneCode;
    } else {
      phoneCode = Strings.countryDialCode;
    }

    if (homeState.country.isoCode.isNotEmpty) {
      isoCode = homeState.country.isoCode;
    } else {
      isoCode = Strings.isoCode;
    }

    return [phoneCode, isoCode];
  }

  void goBackWithSelectedCountry(Country country) {
    Navigator.pop(context, country);
  }
}
