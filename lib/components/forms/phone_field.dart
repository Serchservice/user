import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user/library.dart';

class PhoneField extends StatefulWidget {
  final VoidCallback? onTap;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<Country>? onCountryChanged;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool disableLengthCheck;
  final String searchText;
  final String? invalidNumberMessage;
  final TextInputAction? textInputAction;
  final BoxConstraints? suffixIconConstraints;
  final Widget? suffixIcon;
  final String? isoCode;

  const PhoneField({
    super.key,
    this.onTap,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onCountryChanged,
    this.onSaved,
    this.textInputAction,
    this.searchText = "Search Country",
    this.disableLengthCheck = false,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.suffixIconConstraints,
    this.suffixIcon,
    this.isoCode
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late Country _selectedCountry;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    if(Database.countries.isNotEmpty) {
      _selectedCountry = Database.countries.firstWhere((country) {
        if(widget.isoCode != null) {
          return widget.isoCode!.toUpperCase() == country.code;
        } else {
          return Database.address.country == country.name;
        }
      },
        orElse: () => Database.countries.first
      );
    } else {
      final AppService appService = AppImplementation();
      appService.getCountries(onSuccess: (countries) {
        Database.saveCountries(countries);
        _selectedCountry = countries.firstWhere((country) {
          if(widget.isoCode != null) {
            return widget.isoCode!.toUpperCase() == country.code;
          } else {
            return Database.address.country == country.name;
          }
        },
          orElse: () => countries.first
        );
      });
    }
  }

  Future<void> _changeCountry() async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => CountryPickerDialog(
          filteredCountries: Country.countries,
          searchText: widget.searchText,
          countryList: Country.countries,
          selectedCountry: _selectedCountry,
          onCountryChanged: (Country country) {
            _selectedCountry = country;
            widget.onCountryChanged?.call(country);
            setState(() {});
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Field(
      hintText: "Phone Number",
      controller: widget.controller,
      onPressed: widget.onTap,
      focus: widget.focusNode,
      keyboard: TextInputType.phone,
      inputAction: widget.textInputAction ?? TextInputAction.next,
      prefixIcon: Database.countries.isNotEmpty
        ? Padding(
          padding: const EdgeInsets.only(right:3),
          child: _buildFlagsButton()
        )
        : null,
      suffixIcon: widget.suffixIcon,
      suffixIconConstraints: widget.suffixIconConstraints,
      onChanged: (value) async {
        final phoneNumber = PhoneNumber(
          countryISOCode: _selectedCountry.code,
          countryCode: '+${_selectedCountry.dialCode}',
          number: value,
        );
        validatorMessage = await widget.validator?.call(phoneNumber);
        widget.onChanged?.call(phoneNumber);
      },
      validate: (value) {
        if (!widget.disableLengthCheck && value != null) {
          return value.length >= _selectedCountry.minLength
            && value.length <= _selectedCountry.maxLength
              ? null : widget.invalidNumberMessage;
        }
        return validatorMessage;
      },
    );
  }

  Widget _buildFlagsButton() {
    BoxDecoration decoration = BoxDecoration(
      border: Border(
        right: BorderSide(color: Theme.of(context).primaryColor)
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10)
      )
    );

    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: decoration.borderRadius as BorderRadius?,
        child: InkWell(
          borderRadius: decoration.borderRadius as BorderRadius?,
          onTap: _changeCountry,
          child: DecoratedBox(
            decoration: decoration,
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(9)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetUtility.image(_selectedCountry.image),
                    width: 28,
                  ),
                  const SizedBox(width: 8),
                  SText(
                    text: '+${_selectedCountry.dialCode}',
                    size: Sizing.font(14),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}