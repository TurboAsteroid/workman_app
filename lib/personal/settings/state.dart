abstract class SettingsState {}

class SettingsInit extends SettingsState {
  @override
  String toString() => 'SettingsInit';
}

class SettingsPinSetted extends SettingsState {
  @override
  String toString() => 'SettingsPinSetted';
}
