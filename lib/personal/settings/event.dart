import 'package:flutter/material.dart';

abstract class SettingsEvent {}

class SetPin extends SettingsEvent {
  String pin;
  BuildContext context;

  SetPin(this.context, this.pin);

  @override
  String toString() => 'SetPin';
}

class Cancel extends SettingsEvent {
  BuildContext context;

  Cancel(this.context);

  @override
  String toString() => 'Cancel';
}

class SetPollsVisualisation extends SettingsEvent {
  bool pollsVisualisation;

  SetPollsVisualisation(this.pollsVisualisation);
}