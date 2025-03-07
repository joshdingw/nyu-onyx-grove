import { TimePeriod as TimePeriodField } from "./time-period";
import { EducationalGoalField } from "./educational-goal-field";
import { CardDef, field, containsMany } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
export class FieldExamples extends CardDef {
  @field goals = containsMany(EducationalGoalField);
  @field period = containsMany(TimePeriodField);
  static displayName = "Field Examples";

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