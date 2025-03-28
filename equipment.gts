 import {
  CardDef,
  Component,
  field,
  contains,
  FieldDef,
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import NumberField from 'https://cardstack.com/base/number';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

class EquipmentQuantityField extends FieldDef {
  static displayName = 'Equipment Quantity';
  @field value = contains(NumberField);

  static embedded = class Embedded extends Component<typeof EquipmentQuantityField> {
    <template>
      <div class='quantity-embedded'>
        <span class='quantity-value'>{{@model.value}}</span>
        <span class='quantity-status {{if (gt @model.value 0) "in-stock" "out-of-stock"}}'>
          {{if (gt @model.value 0) "有库存" "缺货"}}
        </span>
      </div>

      <style scoped>
        .quantity-embedded {
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-xs);
        }

        .quantity-value {
          font-weight: 600;
          font-size: var(--boxel-font-size);
        }

        .quantity-status {
          padding: var(--boxel-sp-xxs) var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          font-size: var(--boxel-font-size-sm);
          font-weight: 500;
        }

        .in-stock {
          background-color: var(--boxel-success-background);
          color: var(--boxel-success);
        }

        .out-of-stock {
          background-color: var(--boxel-danger-background);
          color: var(--boxel-danger);
        }
      </style>
    </template>
  };

  static fitted = class Fitted extends Component<typeof EquipmentQuantityField> {
    <template>
      <div class='quantity-fitted'>
        <span class='quantity-value'>{{@model.value}}</span>
        <span class='quantity-indicator {{if (gt @model.value 0) "in-stock" "out-of-stock"}}'></span>
      </div>

      <style scoped>
        .quantity-fitted {
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-xxs);
        }

        .quantity-value {
          font-weight: 600;
          font-size: var(--boxel-font-size);
        }

        .quantity-indicator {
          width: 8px;
          height: 8px;
          border-radius: 50%;
        }

        .in-stock {
          background-color: var(--boxel-success);
        }

        .out-of-stock {
          background-color: var(--boxel-danger);
        }

        @container (max-width: 150px) {
          .quantity-value {
            font-size: var(--boxel-font-size-sm);
          }
        }

        @container (min-width: 400px) {
          .quantity-indicator {
            width: 10px;
            height: 10px;
          }
        }
      </style>
    </template>
  };

  static edit = class Edit extends Component<typeof EquipmentQuantityField> {
    <template>
      <div class='quantity-edit'>
        <@fields.value />
      </div>

      <style scoped>
        .quantity-edit {
          width: 100%;
        }
      </style>
    </template>
  };
}

export class Equipment extends CardDef {
  static displayName = 'Equipment';

  @field equipmentId = contains(NumberField);
  @field name = contains(StringField);
  @field quantity = contains(EquipmentQuantityField);

  static isolated = class Isolated extends Component<typeof Equipment> {
    @tracked isEditing = false;

    @action toggleEdit() {
      this.isEditing = !this.isEditing;
    }

    <template>
      <div class='equipment-card'>
        <div class='equipment-header'>
          <h1 class='equipment-title'>
            {{#if this.isEditing}}
              <@fields.name />
            {{else}}
              {{@model.name}}
            {{/if}}
          </h1>
          <button 
            class='edit-button' 
            {{on "click" this.toggleEdit}}
          >
            {{if this.isEditing "保存" "编辑"}}
          </button>
        </div>

        <div class='equipment-content'>
          <div class='info-row'>
            <span class='label'>设备ID</span>
            <span class='value'>
              {{#if this.isEditing}}
                <@fields.equipmentId />
              {{else}}
                {{@model.equipmentId}}
              {{/if}}
            </span>
          </div>
          
          <div class='info-row'>
            <span class='label'>名称</span>
            <span class='value'>
              {{#if this.isEditing}}
                <@fields.name />
              {{else}}
                {{@model.name}}
              {{/if}}
            </span>
          </div>
          
          <div class='info-row'>
            <span class='label'>数量</span>
            <span class='value'>
              {{#if this.isEditing}}
                <@fields.quantity />
              {{else}}
                <@fields.quantity @format="embedded" />
              {{/if}}
            </span>
          </div>
        </div>

        <div class='equipment-footer'>
          <div class='status-badge {{if (gt @model.quantity.value 0) "in-stock" "out-of-stock"}}'>
            {{if (gt @model.quantity.value 0) "有库存" "缺货"}}
          </div>
        </div>
      </div>

      <style scoped>
        .equipment-card {
          background-color: var(--boxel-background);
          border-radius: var(--boxel-border-radius);
          padding: var(--boxel-sp);
          max-width: 600px;
          margin: 0 auto;
          font-family: var(--boxel-font-family);
        }

        .equipment-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: var(--boxel-sp);
          padding-bottom: var(--boxel-sp-sm);
          border-bottom: 1px solid var(--boxel-border-color);
        }

        .equipment-title {
          font-size: var(--boxel-font-size-xl);
          font-weight: 600;
          margin: 0;
          color: var(--boxel-dark);
        }

        .edit-button {
          background-color: var(--boxel-highlight);
          color: white;
          border: none;
          border-radius: var(--boxel-border-radius-sm);
          padding: var(--boxel-sp-xs) var(--boxel-sp-sm);
          font-size: var(--boxel-font-size);
          cursor: pointer;
          transition: background-color 0.2s;
        }

        .edit-button:hover {
          background-color: var(--boxel-highlight-dark);
        }

        .equipment-content {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-sm);
        }

        .info-row {
          display: flex;
          padding: var(--boxel-sp-xs) 0;
          border-bottom: 1px solid var(--boxel-border-color-muted);
        }

        .label {
          width: 100px;
          color: var(--boxel-dark-muted);
          font-weight: 500;
        }

        .value {
          flex: 1;
          color: var(--boxel-dark);
        }

        .equipment-footer {
          margin-top: var(--boxel-sp);
          display: flex;
          justify-content: flex-end;
        }

        .status-badge {
          display: inline-block;
          padding: var(--boxel-sp-xs) var(--boxel-sp-sm);
          border-radius: var(--boxel-border-radius-sm);
          font-size: var(--boxel-font-size-sm);
          font-weight: 500;
        }

        .in-stock {
          background-color: var(--boxel-success-background);
          color: var(--boxel-success);
        }

        .out-of-stock {
          background-color: var(--boxel-danger-background);
          color: var(--boxel-danger);
        }
      </style>
    </template>
  };

  static embedded = class Embedded extends Component<typeof Equipment> {
    <template>
      <div class='equipment-embedded'>
        <div class='equipment-main'>
          <div class='equipment-name'>{{@model.name}}</div>
          <div class='equipment-id'>ID: {{@model.equipmentId}}</div>
        </div>
        <@fields.quantity @format="embedded" />
      </div>

      <style scoped>
        .equipment-embedded {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: var(--boxel-sp-xs);
          height: 40px; /* Base unit height */
        }

        .equipment-main {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-xxs);
          min-width: 0;
        }

        .equipment-name {
          font-weight: 600;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          max-width: 200px;
          font-size: var(--boxel-font-size);
          line-height: 1.2;
        }

        .equipment-id {
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-dark-muted);
        }

        @container (min-width: 250px) {
          .equipment-embedded {
            height: 65px; /* Double Strip height */
          }

          .equipment-name {
            font-size: var(--boxel-font-size-lg);
          }
        }

        @container (min-width: 400px) {
          .equipment-name {
            max-width: 300px;
          }
        }
      </style>
    </template>
  };

  static fitted = class Fitted extends Component<typeof Equipment> {
    <template>
      <div class='equipment-fitted'>
        <div class='content-wrapper'>
          <div class='equipment-name'>{{@model.name}}</div>
          <div class='equipment-details'>
            <div class='equipment-id'>ID: {{@model.equipmentId}}</div>
            <@fields.quantity @format="fitted" />
          </div>
        </div>
      </div>

      <style scoped>
        .equipment-fitted {
          container-type: inline-size;
          width: 100%;
          height: 100%;
          min-width: 100px;
          min-height: 40px;
          padding: var(--boxel-sp-xs);
        }

        .content-wrapper {
          height: 100%;
          display: flex;
          flex-direction: column;
        }

        .equipment-name {
          font-weight: 600;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          font-size: var(--boxel-font-size);
        }

        .equipment-details {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-top: var(--boxel-sp-xs);
        }

        .equipment-id {
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-dark-muted);
        }

        /* Badge size */
        @container (max-width: 150px) {
          .equipment-fitted {
            padding: var(--boxel-sp-xxs);
          }

          .equipment-id {
            display: none;
          }

          .equipment-name {
            font-size: var(--boxel-font-size-sm);
          }
        }

        /* Strip size */
        @container (min-width: 151px) and (max-width: 399px) {
          .content-wrapper {
            flex-direction: row;
            align-items: center;
            gap: var(--boxel-sp-sm);
          }

          .equipment-name {
            max-width: 60%;
          }

          .equipment-details {
            margin-top: 0;
          }
        }

        /* Card size */
        @container (min-width: 400px) {
          .equipment-fitted {
            padding: var(--boxel-sp-sm);
          }

          .content-wrapper {
            flex-direction: row;
            align-items: center;
            gap: var(--boxel-sp);
          }

          .equipment-name {
            font-size: var(--boxel-font-size-lg);
            max-width: 70%;
          }

          .equipment-details {
            margin-top: 0;
            gap: var(--boxel-sp-sm);
          }
        }

        /* Height-based adjustments */
        @container (max-height: 65px) {
          .equipment-details {
            display: none;
          }
        }

        @container (min-height: 170px) {
          .equipment-fitted {
            padding: var(--boxel-sp);
          }

          .equipment-name {
            font-size: var(--boxel-font-size-xl);
          }
        }
      </style>
    </template>
  };

  static edit = class Edit extends Component<typeof Equipment> {
    <template>
      <div class='equipment-edit'>
        <div class='edit-field'>
          <label>设备ID</label>
          <@fields.equipmentId />
        </div>
        
        <div class='edit-field'>
          <label>设备名称</label>
          <@fields.name />
        </div>
        
        <div class='edit-field'>
          <label>数量</label>
          <@fields.quantity />
        </div>
      </div>

      <style scoped>
        .equipment-edit {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-sm);
        }

        .edit-field {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-xs);
        }

        label {
          font-weight: 500;
          color: var(--boxel-dark);
        }
      </style>
    </template>
  };
} 