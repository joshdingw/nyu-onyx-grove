import { ParentInfo as ParentInfoCard } from "./parent-info";
import DateField from "https://cardstack.com/base/date";
import { CardDef, Component, field, contains, linksTo } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import BooleanField from 'https://cardstack.com/base/boolean';
import GraduationCapIcon from '@cardstack/boxel-icons/graduation-cap';

export class Student extends CardDef {
  static displayName = "Student";
  static icon = GraduationCapIcon;

  @field fullName = contains(StringField);
  @field dateOfBirth = contains(DateField);
  @field staffingRatio = contains(StringField);
  @field active = contains(BooleanField);
  @field parentInfo = linksTo(ParentInfoCard);

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