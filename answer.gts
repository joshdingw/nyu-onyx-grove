import { CardDef, field, contains } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import MarkdownField from 'https://cardstack.com/base/markdown';

export class Answer extends CardDef {
  static displayName = "Answer";
  @field content = contains(MarkdownField);

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