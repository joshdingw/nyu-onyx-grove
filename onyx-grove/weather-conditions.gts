import { FieldDef, field, contains, containsMany } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import NumberField from 'https://cardstack.com/base/number';
import DatetimeField from 'https://cardstack.com/base/datetime';

export class ForecastDayField extends FieldDef {
  @field date = contains(DatetimeField);
  @field temperature = contains(NumberField);
  @field conditions = contains(StringField);
  @field highTemp = contains(NumberField);
  @field lowTemp = contains(NumberField);
}

export class WeatherConditionsField extends FieldDef {
  @field city = contains(StringField);
  @field timestamp = contains(DatetimeField);
  @field temperature = contains(NumberField);
  @field conditions = contains(StringField);
  @field humidity = contains(NumberField);
  @field windSpeed = contains(NumberField);
  @field windDirection = contains(StringField);
  @field pressure = contains(NumberField);
  @field visibility = contains(NumberField);
  @field forecast = containsMany(ForecastDayField);
}