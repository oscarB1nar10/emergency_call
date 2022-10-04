import 'package:country_picker/country_picker.dart' as country_picker;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utility/Countries.dart';
import '../utility/Strings.dart';
import 'HomeBloc.dart';
import 'HomeEvents.dart';
import 'HomeState.dart';

class CountryIconWidget extends StatefulWidget {
  const CountryIconWidget({Key? key}) : super(key: key);

  @override
  _CountryIconWidget createState() => _CountryIconWidget();
}

class _CountryIconWidget extends State<CountryIconWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.emoji_flags),
      onPressed: () {
        _showCountryPicker();
      },
    );
  }

  void _showCountryPicker() {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    List phoneCodeAndIsoCode = _getDefaultPhoneAndIsoCode(homeBloc.state);

    country_picker.showCountryPicker(
        context: context,
        showPhoneCode: true,
        searchAutofocus: true,
        onSelect: (countryCode) => {_onCountryChange(countryCode)},
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        favorite: [phoneCodeAndIsoCode[0]],
        countryFilter: CountryHelper.getSupportedCountries(),
        countryListTheme: const country_picker.CountryListThemeData(
            bottomSheetHeight: 500, // Optional. Country list modal height
            //Optional. Sets the border radius for the bottomsheet.
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            )));
  }

  _onCountryChange(country_picker.Country countryPicker) {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    String countryNameSelected = "";

    for (var country in CountryHelper.countryList) {
      if (country.phoneCode == countryPicker.phoneCode) {
        // Launch event to save the country.
        homeBloc.add(EventSaveCountryDealCode(country));
        countryNameSelected = country.name;
        break;
      }
    }

    // After the Selection of the country returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(countryNameSelected)));
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
}
