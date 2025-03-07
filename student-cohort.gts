import {
  CardDef,
  Component,
  field,
  contains,
  linksToMany
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import BooleanField from 'https://cardstack.com/base/boolean';
import { Student } from './student';
import UsersIcon from '@cardstack/boxel-icons/users';

export class StudentCohort extends CardDef {
  static displayName = "Student Cohort";
  static icon = UsersIcon;

  @field type = contains(StringField);
  @field name = contains(StringField);
  @field active = contains(BooleanField);
  @field students = linksToMany(() => Student);

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