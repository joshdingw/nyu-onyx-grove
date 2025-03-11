import { CardDef, field, contains, StringField } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import TagIcon from '@cardstack/boxel-icons/tag';

export class DomainArea extends CardDef {
  static displayName = "Domain Area";
  static icon = TagIcon;

  @field category = contains(StringField);
  @field subCategory = contains(StringField);
  @field tag = contains(StringField);
  @field title = contains(StringField, {
    computeVia: function (this: DomainArea) {
      if (!this.subCategory) {
        return 'Untitled Domain Area';
      }
      return this.tag ? `${this.subCategory} (${this.tag})` : this.subCategory;
    },
  });

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