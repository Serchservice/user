import 'package:flutter/material.dart';
import 'package:user/library.dart';

class PreferenceSelector extends StatefulWidget {
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
  }) => Navigate.bottomSheet(
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
    route: "/centre/preference/${header.toLowerCase()}",
    background: Colors.transparent
  );

  @override
  State<PreferenceSelector> createState() => _PreferenceSelectorState();
}

class _PreferenceSelectorState extends State<PreferenceSelector> {
  final Connect _connect = Connect();
  bool isSaving = false;

  Gender selectedGender = Gender.any;
  SecurityType selectedSecurity = SecurityType.none;
  ThemeType selectedTheme = ThemeType.light;
  ScheduleTime selectedSchedule = ScheduleTime.thirtyMinutes;
  PreferenceOption selectedPreference = PreferenceOption.none;

  @override
  void initState() {
    selectedGender = widget.selectedGender;
    selectedTheme = widget.selectedTheme;
    selectedSchedule = widget.selectedSchedule;
    selectedPreference = widget.selectedPreference;
    selectedSecurity = widget.selectedSecurity;
    super.initState();
  }

  void saveGender() async {
    try {
      setState(() {
        isSaving = true;
      });
      var res = await _connect.patch(
        endpoint: "/account/settings/change/trip/gender?gender=${selectedGender.key}",
        body: {}
      );
      setState(() {
        isSaving = false;
      });
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        Navigate.back();
        widget.onChanged.call(selectedGender, selectedTheme, selectedPreference, selectedSchedule, selectedSecurity);
      } else {
        return;
      }
    } on Exception catch (e) {
      Logger.log(e);
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: SingleChildScrollView(
        child: Column(
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
                text: widget.header,
                color: Theme.of(context).primaryColor,
                size: Sizing.font(24),
                weight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            if(widget.isTheme) ...[
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 300
                ),
                itemCount: ThemeType.values.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final theme = ThemeType.values[index];
                  return PreferenceBox(
                    isSelected: selectedTheme == theme,
                    onTap: () {
                      setState(() {
                        selectedTheme = theme;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              theme == ThemeType.light
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                              color: Theme.of(context).primaryColor
                            ),
                            const SizedBox(width: 10),
                            SText(
                              text: theme == ThemeType.light
                                ? "Light Theme"
                                : "Dark Theme",
                              size: Sizing.font(16),
                              weight: FontWeight.bold,
                              color: Theme.of(context).primaryColorLight
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Image.asset(
                            theme == ThemeType.light
                              ? Media.lightMode
                              : Media.darkMode,
                            width: MediaQuery.of(context).size.width
                          )
                        ),
                        const SizedBox(height: 10),
                        SText(
                          text: theme.type,
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColorLight
                        ),
                        SText(
                          text: theme == ThemeType.light
                            ? "Active when you want something brighter"
                            : "Eye-friendly design for low-light environment",
                          size: Sizing.font(14),
                          color: Theme.of(context).primaryColorLight
                        ),
                      ],
                    )
                  );
                }
              )
            ],
            if(widget.isGender) ...[
              ...Gender.values.map((gender) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PreferenceBox(
                    isSelected: selectedGender == gender,
                    onTap: () {
                      setState(() {
                        selectedGender = gender;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText(
                            text: gender.value,
                            size: Sizing.font(14),
                            weight: selectedGender == gender
                              ? FontWeight.bold
                              : FontWeight.normal,
                            color: Theme.of(context).primaryColorLight
                          ),
                        ),
                        if(selectedGender == gender) ...[
                          const SizedBox(width: 20),
                          Icon(
                            Icons.playlist_add_check_circle_rounded,
                            color: Theme.of(context).primaryColor
                          )
                        ]
                      ],
                    )
                  ),
                );
              }).toList()
            ],
            if(widget.isSecurity) ...[
              ...SecurityType.values.map((security) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PreferenceBox(
                    isSelected: selectedSecurity == security,
                    onTap: () {
                      setState(() {
                        selectedSecurity = security;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText(
                            text: security.type,
                            size: Sizing.font(14),
                            weight: selectedSecurity == security
                              ? FontWeight.bold
                              : FontWeight.normal,
                            color: Theme.of(context).primaryColorLight
                          ),
                        ),
                        if(selectedSecurity == security) ...[
                          const SizedBox(width: 20),
                          Icon(
                            Icons.playlist_add_check_circle_rounded,
                            color: Theme.of(context).primaryColor
                          )
                        ]
                      ],
                    )
                  ),
                );
              }).toList()
            ],
            if(widget.isScheduleTime) ...[
              ...ScheduleTime.values.map((schedule) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: PreferenceBox(
                  isSelected: selectedSchedule == schedule,
                  onTap: () {
                    setState(() {
                      selectedSchedule = schedule;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SText(
                          text: schedule.type,
                          size: Sizing.font(14),
                          weight: selectedSchedule == schedule
                            ? FontWeight.bold
                            : FontWeight.normal,
                          color: Theme.of(context).primaryColorLight
                        ),
                      ),
                      if(selectedSchedule == schedule) ...[
                        const SizedBox(width: 20),
                        Icon(
                          Icons.playlist_add_check_circle_rounded,
                          color: Theme.of(context).primaryColor
                        )
                      ]
                    ],
                  )
                ),
              )).toList()
            ],
            if(!widget.isGender && !widget.isScheduleTime && !widget.isTheme & !widget.isSecurity) ...[
              ...PreferenceOption.values.map((preference) {
                if(preference == PreferenceOption.none) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PreferenceBox(
                    isSelected: selectedPreference == preference,
                    onTap: () {
                      setState(() {
                        selectedPreference = preference;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SText(
                            text: preference.type,
                            size: Sizing.font(14),
                            weight: selectedPreference == preference
                              ? FontWeight.bold
                              : FontWeight.normal,
                            color: Theme.of(context).primaryColorLight
                          ),
                        ),
                        if(selectedPreference == preference) ...[
                          const SizedBox(width: 20),
                          Icon(
                            Icons.playlist_add_check_circle_rounded,
                            color: Theme.of(context).primaryColor
                          )
                        ]
                      ],
                    )
                  ),
                );
              }).toList(),
            ],
            if(selectedGender != widget.selectedGender || selectedPreference != widget.selectedPreference
            || selectedSchedule != widget.selectedSchedule || selectedTheme != widget.selectedTheme
            || selectedSecurity != widget.selectedSecurity) ...[
              const SizedBox(height: 10),
              LoadingButton(
                text: "Save",
                borderRadius: 24,
                width: MediaQuery.of(context).size.width,
                textSize: Sizing.font(14),
                buttonColor: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).scaffoldBackgroundColor,
                loading: isSaving,
                onClick: () {
                  if(selectedGender != widget.selectedGender) {
                    saveGender();
                  } else {
                    Navigator.pop(context);
                    widget.onChanged.call(selectedGender, selectedTheme, selectedPreference, selectedSchedule, selectedSecurity);
                  }
                },
              )
            ]
          ],
        ),
      )
    );
  }
}

class PreferenceBox extends StatelessWidget {
  const PreferenceBox({
    super.key,
    required this.isSelected,
    required this.child,
    this.onTap
  });

  final bool isSelected;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          side: isSelected
            ? BorderSide(
              color: Theme.of(context).primaryColor,
              width: 3
            ) : BorderSide.none,
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(Sizing.space(16)),
            child: child
          ),
        ),
      ),
    );
  }
}