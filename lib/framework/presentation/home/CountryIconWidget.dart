import 'package:flutter/material.dart';

import '../utility/Countries.dart';
import 'CountrySelectorWidget.dart';

class CountryIconWidget extends StatelessWidget {

  const CountryIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.emoji_flags),
      onPressed: () {
        _navigateCountryPickerPage(context);
      },
    );
  }

  // A method that launches the Country picker screen and awaits the result from
// Navigator.pop.
  void _navigateCountryPickerPage(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CountrySelectorWidget()),
    );

    Country country = result as Country;

    // After the Selection of the country returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(country.name)));
  }

}