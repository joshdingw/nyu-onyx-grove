import {
  CardDef,
  Component,
  field,
  contains,
  linksTo,
  linksToMany,
  containsMany
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import BooleanField from 'https://cardstack.com/base/boolean';
import { Location } from './location';
import { StudentCohort } from './student-cohort';
import { Staff } from './staff';
import { TimePeriod } from './time-period';

export class Offering extends CardDef {
  static displayName = "Offering";

  @field name = contains(StringField);
  @field schoolYear = contains(TimePeriod);
  @field active = contains(BooleanField);
  @field location = linksTo(() => Location);
  @field cohort = linksTo(() => StudentCohort);
  @field staff = linksToMany(() => Staff);
  @field startTime = contains(StringField);
  @field endTime = contains(StringField);
  @field meetingDays = containsMany(StringField);

  /*
  static isolated = class Isolated extends Component<typeof this> {
    <template></template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template></template>
  }

  static atom = class Atom extends Component<typeof this> {
    <template></template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template></template>
  }

  static fitted = class Fitted extends Component<typeof this> {
    <template></template>
  }
  */
}