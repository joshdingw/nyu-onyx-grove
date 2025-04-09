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
import { gt } from '@cardstack/boxel-ui/helpers'

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
  @field thumbnailURL = contains(StringField, {
    computeVia: function (this: Equipment) {
      const name = this.name?.toLowerCase() ?? '';
      
      // Default equipment images based on keywords
      if (name.includes('chair')) {
        return 'https://images.unsplash.com/photo-1505797149-0b7e17ec6c7e?auto=format&fit=crop&q=80&w=800';
      }
      if (name.includes('monitor') || name.includes('display')) {
        return 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&q=80&w=800';
      }
      if (name.includes('keyboard')) {
        return 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&q=80&w=800';
      }
      if (name.includes('workstation')) {
        return 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=800';
      }
      if (name.includes('dock') || name.includes('docking')) {
        return 'https://images.unsplash.com/photo-1591405351990-4726e331f141?auto=format&fit=crop&q=80&w=800';
      }
      if (name.includes('webcam')) {
        return 'https://images.unsplash.com/photo-1596742578443-7682ef7b7c72?auto=format&fit=crop&q=80&w=800';
      }
      if (name.includes('desk')) {
        return 'https://images.unsplash.com/photo-1579503841516-e0bd7fca5faa?auto=format&fit=crop&q=80&w=800';
      }
      if (name.includes('headphone')) {
        return 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80&w=800';
      }
      
      // Default image for unmatched equipment
      return 'https://images.unsplash.com/photo-1531492746076-161ca9bcad58?auto=format&fit=crop&q=80&w=800';
    }
  });

  static isolated = class Isolated extends Component<typeof Equipment> {
    @tracked isEditing = false;

    @action toggleEdit() {
      this.isEditing = !this.isEditing;
    }

    get backgroundImageStyle() {
      return this.args.model.thumbnailURL ? `background-image: url('${this.args.model.thumbnailURL}')` : '';
    }

    <template>
      <div class='equipment-isolated'>
        <div class='equipment-header'>
          {{#if @model.thumbnailURL}}
            <div class='equipment-image {{if @model.thumbnailURL "has-image"}}' style={{this.backgroundImageStyle}}></div>
          {{/if}}
          <div class='equipment-title-container'>
            <h1 class='equipment-title'>{{@model.name}}</h1>
            {{#if @model.description}}
              <p class='equipment-description'>{{@model.description}}</p>
            {{/if}}
          </div>
        </div>

        <div class='equipment-content'>
          <div class='equipment-details'>
            <div class='card detail-section'>
              <h2 class='section-title'>Equipment Details</h2>
              <div class='detail-grid'>
                <div class='detail-item'>
                  <span class='detail-label'>Equipment ID</span>
                  <span class='detail-value'>{{@model.equipmentId}}</span>
                </div>
                
                <div class='detail-item'>
                  <span class='detail-label'>Name</span>
                  <span class='detail-value'>{{@model.name}}</span>
                </div>
                
                <div class='detail-item'>
                  <span class='detail-label'>Quantity</span>
                  <div class='quantity-badge'>
                    <@fields.quantity @format="embedded" />
                  </div>
                </div>
              </div>
            </div>

            <div class='card detail-section'>
              <h2 class='section-title'>Status</h2>
              <div class='status-badge {{if (gt @model.quantity.value 0) "in-stock" "out-of-stock"}}'>
                {{if (gt @model.quantity.value 0) "In Stock" "Out of Stock"}}
              </div>
            </div>
          </div>
        </div>

      </div>

      <style scoped>
        .equipment-isolated {
          display: flex;
          flex-direction: column;
          width: 100%;
          background-color: hsl(0, 0%, 98%);
          color: hsl(240, 10%, 3.9%);
          font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
          overflow-y: auto;
          position: relative;
        }

        .equipment-header {
          position: relative;
          width: 100%;
        }

        .equipment-image {
          width: 100%;
          height: 300px;
          background-position: center;
          background-size: cover;
          background-repeat: no-repeat;
          border-radius: 0 0 8px 8px;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
          display: none; /* Hide by default */
        }

        .equipment-image.has-image {
          display: block; /* Show only when there's an image */
        }

        .equipment-title-container {
          padding: 24px;
          background-color: white;
          margin: 0 24px;
          position: relative;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
          margin-top: var(--boxel-sp-sm); /* Add some spacing from top when no image */
        }

        .equipment-title {
          font-size: 28px;
          font-weight: 700;
          color: hsl(240, 10%, 3.9%);
          margin: 0 0 12px;
          line-height: 1.2;
        }

        .equipment-description {
          font-size: 16px;
          color: hsl(240, 3.8%, 46.1%);
          margin: 0;
          line-height: 1.6;
        }

        .equipment-content {
          flex: 1;
          padding: 24px;
        }

        .equipment-details {
          display: flex;
          flex-direction: column;
          gap: 24px;
          max-width: 900px;
          margin: 0 auto;
        }

        .card {
          background-color: white;
          border-radius: 8px;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
          padding: 24px;
          transition: box-shadow 0.2s ease-in-out;
        }

        .card:hover {
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .detail-section {
          display: flex;
          flex-direction: column;
          gap: 16px;
        }

        .section-title {
          font-size: 18px;
          font-weight: 600;
          color: hsl(240, 10%, 3.9%);
          margin: 0;
          padding-bottom: 12px;
          border-bottom: 1px solid hsl(240, 5.9%, 90%);
        }

        .detail-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
          gap: 20px;
        }

        .detail-item {
          display: flex;
          flex-direction: column;
          gap: 6px;
        }

        .detail-label {
          font-size: 14px;
          font-weight: 500;
          color: hsl(240, 3.8%, 46.1%);
        }

        .detail-value {
          font-size: 16px;
          color: hsl(240, 10%, 3.9%);
        }

        .quantity-badge {
          display: inline-flex;
          align-items: center;
        }

        .status-badge {
          display: inline-flex;
          align-items: center;
          padding: 8px 16px;
          border-radius: 20px;
          font-size: 14px;
          font-weight: 500;
        }

        .in-stock {
          background-color: hsl(142, 76%, 96%);
          color: hsl(142, 76%, 36%);
        }

        .out-of-stock {
          background-color: hsl(0, 76%, 96%);
          color: hsl(0, 76%, 36%);
        }

        @media (max-width: 768px) {
          .equipment-title-container {
            margin: 0;
            margin-top: 0;
            border-radius: 0;
          }
          
          .equipment-image {
            border-radius: 0;
          }
          
          .equipment-content {
            padding: 16px;
          }
          
          .detail-grid {
            grid-template-columns: 1fr;
          }
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
    get backgroundImageStyle() {
      return this.args.model.thumbnailURL ? `background-image: url('${this.args.model.thumbnailURL}')` : '';
    }

    <template>
      <div class='equipment-fitted'>
        <div class='thumbnail' style={{this.backgroundImageStyle}}></div>
        <div class='content-wrapper'>
          <div class='equipment-name'>{{@model.name}}</div>
          <div class='details-row'>
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
          min-width: 120px;
          background: white;
          border-radius: var(--boxel-border-radius);
          transition: all 0.2s ease;
          overflow: hidden;
          display: flex;
          flex-direction: column;
        }

        .equipment-fitted:hover {
          box-shadow: 0 4px 12px rgba(0,0,0,0.1);
          transform: translateY(-1px);
        }

        .thumbnail {
          width: 100%;
          height: 120px;
          background-size: cover;
          background-position: center;
          background-color: var(--boxel-light);
          border-bottom: 1px solid var(--boxel-border);
        }

        .content-wrapper {
          padding: var(--boxel-sp-sm);
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-xs);
        }

        .equipment-name {
          font-weight: 600;
          font-size: var(--boxel-font-size);
          color: var(--boxel-dark);
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .details-row {
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: var(--boxel-sp-sm);
        }

        .equipment-id {
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-dark-muted);
        }

        /* Badge size */
        @container (max-width: 150px) {
          .thumbnail {
            height: 80px;
          }

          .content-wrapper {
            padding: var(--boxel-sp-xs);
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
          .thumbnail {
            height: 100px;
          }
        }

        /* Card size */
        @container (min-width: 400px) {
          .thumbnail {
            height: 160px;
          }

          .content-wrapper {
            padding: var(--boxel-sp);
          }

          .equipment-name {
            font-size: var(--boxel-font-size-lg);
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