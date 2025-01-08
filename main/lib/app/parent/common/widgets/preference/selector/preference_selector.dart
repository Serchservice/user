import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:user/library.dart';
import 'package:flutter/material.dart';

class PreferenceSelector extends StatelessWidget {
  final bool isTheme;
  final bool isScheduleTime;
  final bool isGender;
  final bool isSecurity;
  final Gender selectedGender;
  final ThemeType selectedTheme;
  final ScheduleTime selectedSchedule;
  final PreferenceOption selectedPreference;
  final SecurityType selectedSecurity;
  final String header;
  final Function(Gender, ThemeType, PreferenceOption, ScheduleTime, SecurityType) onChanged;

  const PreferenceSelector({
    super.key,
    this.isTheme = false,
    this.isScheduleTime = false,
    this.isGender = false,
    this.isSecurity = false,
    this.selectedSchedule = ScheduleTime.thirtyMinutes,
    this.selectedGender = Gender.none,
    this.selectedTheme = ThemeType.light,
    this.selectedPreference = PreferenceOption.none,
    this.selectedSecurity = SecurityType.none,
    required this.header,
    required this.onChanged
  });

  static void open({
    bool isTheme = false,
    bool isScheduleTime = false,
    bool isGender = false,
    bool isSecurity = false,
    Gender selectedGender = Gender.none,
    ThemeType selectedTheme = ThemeType.light,
    ScheduleTime selectedSchedule = ScheduleTime.thirtyMinutes,
    PreferenceOption selectedPreference = PreferenceOption.none,
    SecurityType selectedSecurity = SecurityType.none,
    required String header,
    required Function(Gender, ThemeType, PreferenceOption, ScheduleTime, SecurityType) onChanged
  }) {
    String route = "/centre/preference/${header.toLowerCase()}";

    Navigate.bottomSheet(
      sheet: PreferenceSelector(
        isGender: isGender,
        isTheme: isTheme,
        isScheduleTime: isScheduleTime,
        isSecurity: isSecurity,
        selectedSecurity: selectedSecurity,
        selectedGender: selectedGender,
        selectedSchedule: selectedSchedule,
        selectedPreference: selectedPreference,
        selectedTheme: selectedTheme,
        header: header,
        onChanged: onChanged,
      ),
      route: Database.isUserActive ? route : "/guest/$route",
      background: Colors.transparent,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: SingleChildScrollView(
        child: GetX<PreferenceSelectorController>(
          init: PreferenceSelectorController(
            selectedSchedule: selectedSchedule,
            selectedGender: selectedGender,
            selectedTheme: selectedTheme,
            selectedPreference: selectedPreference,
            selectedSecurity: selectedSecurity,
            onChanged: onChanged
          ),
          builder: (controller) {
            bool showPreference = !isGender && !isScheduleTime && !isTheme & !isSecurity;

            bool showButton = controller.state.gender.value != selectedGender
                || controller.state.preference.value != selectedPreference
                || controller.state.schedule.value != selectedSchedule
                || controller.state.theme.value != selectedTheme
                || controller.state.security.value != selectedSecurity;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(Sizing.space(2)),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SText(
                    text: header,
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(24),
                    weight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                if(isTheme) ...[
                  PreferenceSelectorThemeType(controller: controller)
                ],
                if(isGender) ...[
                  PreferenceSelectorGender(controller: controller)
                ],
                if(isSecurity) ...[
                  PreferenceSelectorSecurityType(controller: controller)
                ],
                if(isScheduleTime) ...[
                  PreferenceSelectorScheduleTime(controller: controller)
                ],
                if(showPreference) ...[
                  PreferenceSelectorOption(controller: controller)
                ],
                if(showButton) ...[
                  const SizedBox(height: 10),
                  LoadingButton(
                    text: "Save",
                    borderRadius: 24,
                    width: MediaQuery.sizeOf(context).width,
                    textSize: Sizing.font(14),
                    buttonColor: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).scaffoldBackgroundColor,
                    loading: controller.state.isSaving.value,
                    onClick: () => controller.onSave(context),
                  )
                ]
              ],
            );
          },
        ),
      )
    );
  }
}