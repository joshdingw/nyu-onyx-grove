import { FieldDef, field, contains } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import Location from '@cardstack/boxel-icons/location';

export class Address extends FieldDef {
  static displayName = "Address";
  static icon = Location;

  @field street1 = contains(StringField);
  @field street2 = contains(StringField);
  @field city = contains(StringField);
  @field state = contains(StringField);
  @field zipCode = contains(StringField);

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='address'>
        {{@model.street1}}{{#if @model.street2}}, {{@model.street2}}{{/if}}, {{@model.city}}, {{@model.state}} {{@model.zipCode}}
      </div>
      <style scoped>
        .address {
          font: var(--boxel-font);
          color: var(--boxel-dark);
          letter-spacing: var(--boxel-lsp);
        }
      </style>
    </template>
  }

  /*
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