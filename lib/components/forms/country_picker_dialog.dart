import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as dialog;
import 'package:user/library.dart';

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;

  const CountryPickerDialog({
    super.key,
    required this.searchText,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
  });

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialog.Dialog(
      insetPadding: EdgeInsets.symmetric(
        vertical: Sizing.space(40),
        horizontal: Sizing.space(20)
      ),
      backgroundColor: Theme.of(context).splashColor,
      surfaceTintColor: Theme.of(context).splashColor,
      child: Container(
        padding: EdgeInsets.all(Sizing.space(10)),
        child: Column(
          children: <Widget>[
            Field(
              hintText: "Search Country",
              borderRadius: Sizing.space(20),
              suffixIcon: const Icon(Icons.search),
              onChanged: (value) {
                _filteredCountries = isNumeric(value)
                  ? widget.countryList.where((country) => country.dialCode.contains(value)).toList()
                  : widget.countryList.where((country) {
                    return country.name.toLowerCase().contains(value.toLowerCase());
                  }).toList();
                if (mounted) setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: Sizing.space(10)),
                    child: NavigatorButton(
                      radius: Sizing.space(12),
                      header: _filteredCountries[index].name,
                      prefixWidget: Image(
                        image: AssetUtility.image(_filteredCountries[index].image),
                        width: 32,
                      ),
                      suffixWidget: SText(
                        text: '+${_filteredCountries[index].dialCode}',
                        weight: FontWeight.w700,
                        color: Theme.of(context).primaryColor
                      ),
                      onPressed: () {
                        _selectedCountry = _filteredCountries[index];
                        widget.onCountryChanged(_selectedCountry);
                        Navigator.of(context).pop();
                      },
                    )
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isNumeric(String s) => s.isNotEmpty && double.tryParse(s) != null;
}
