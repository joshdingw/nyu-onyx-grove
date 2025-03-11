import { CardDef, field, contains } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import CloudSun from '@cardstack/boxel-icons/cloud-sun';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import RefreshIcon from '@cardstack/boxel-icons/refresh';
import { WeatherConditionsField } from './weather-conditions';

export class WeatherReport extends CardDef {
  static displayName = "Weather Report";
  static icon = CloudSun;

  @field currentConditions = contains(WeatherConditionsField);


}