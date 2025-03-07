import {
  CardDef,
  Component,
  field,
  contains,
  containsMany
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import NumberField from 'https://cardstack.com/base/number';
import MarkdownField from 'https://cardstack.com/base/markdown';
import LocationIcon from '@cardstack/boxel-icons/location';

export class Location extends CardDef {
  static displayName = 'Location';
  static icon = LocationIcon;

  @field building = contains(StringField);
  @field floor = contains(StringField);
  @field room = contains(StringField);
  @field capacity = contains(NumberField);
  @field designatedUse = contains(MarkdownField);
  @field equipment = containsMany(StringField);

  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='location-fitted'>
        {{#if @model.thumbnailURL}}
          <div class='thumbnail' style={{this.backgroundImageStyle}}></div>
        {{/if}}
        <div class='content'>
          {{#unless @model.thumbnailURL}}
            <div class='location-visual'>
              <div class='location-icon'>
                <LocationIcon />
              </div>
            </div>
          {{/unless}}
          <div class='location-info'>
            <div class='header'>
              {{#if @model.building}}
                <div class='building'>{{@model.building}}</div>
              {{/if}}
              <div class='details'>
                {{#if @model.floor}}
                  <div class='floor'>Floor {{@model.floor}}</div>
                {{/if}}
                {{#if @model.room}}
                  <div class='room'>Room {{@model.room}}</div>
                {{/if}}
              </div>
            </div>
            {{#if @model.capacity}}
              <div class='capacity'>
                Capacity: {{@model.capacity}}
              </div>
            {{/if}}
            {{#if @model.equipment.length}}
              <div class='equipment'>
                <h4>Equipment:</h4>
                <ul>
                  {{#each @model.equipment as |item|}}
                    <li>{{item}}</li>
                  {{/each}}
                </ul>
              </div>
            {{/if}}
          </div>
        </div>
      </div>
      <style scoped>
        .location-fitted {
          width: 100%;
          height: 100%;
          min-width: 100px;
          min-height: 29px;
          display: grid;
        }

        .content {
          padding: var(--boxel-sp-sm);
          display: flex;
          gap: var(--boxel-sp-sm);
        }

        .location-visual {
          flex-shrink: 0;
          width: 24px;
          height: 24px;
        }

        .location-icon {
          width: 100%;
          height: 100%;
          color: var(--boxel-dark);
        }

        .thumbnail {
          width: 100%;
          height: 24px;
          background-color: var(--boxel-light);
          background-position: center;
          background-size: cover;
          background-repeat: no-repeat;
          display: none;
        }

        .location-info {
          display: grid;
          gap: var(--boxel-sp-xs);
          overflow: hidden;
          width: 100%;
        }

        .header {
          display: grid;
          gap: var(--boxel-sp-xs);
        }

        .building {
          font: 600 var(--boxel-font-sm);
          color: var(--boxel-dark);
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .details {
          display: flex;
          gap: var(--boxel-sp-sm);
          align-items: center;
        }

        .floor, .room {
          font: var(--boxel-font-xs);
          color: var(--boxel-dark-secondary);
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .capacity {
          font: var(--boxel-font-xs);
          color: var(--boxel-dark);
          margin-top: var(--boxel-sp-xs);
        }

        .equipment {
          margin-top: var(--boxel-sp-sm);
          font: var(--boxel-font-xs);
        }

        .equipment h4 {
          font: 600 var(--boxel-font-xs);
          color: var(--boxel-dark);
          margin: 0 0 var(--boxel-sp-xxxs);
        }

        .equipment ul {
          margin: 0;
          padding-left: var(--boxel-sp-sm);
          color: var(--boxel-dark-secondary);
        }

        .equipment li {
          margin-bottom: var(--boxel-sp-xxxs);
        }

        @container fitted-card (width <= 150px) {
          .location-info {
            gap: 0;
          }
          .details {
            display: none;
          }
          .capacity, .equipment {
            display: none;
          }
        }

        @container fitted-card (150px < width <= 200px) {
          .location-info {
            gap: var(--boxel-sp-xxxs);
          }
          .details {
            gap: var(--boxel-sp-xs);
          }
          .equipment {
            display: none;
          }
        }

        @container fitted-card (height <= 100px) {
          .content {
            padding: var(--boxel-sp-xxxs);
            align-items: center;
          }

          .location-visual {
            width: 20px;
            height: 20px;
          }

          .location-info {
            gap: var(--boxel-sp-xxxs);
          }

          .header {
            display: flex;
            gap: var(--boxel-sp-xs);
            align-items: center;
            margin: 0;
          }

          .building {
            font-size: var(--boxel-font-xs);
            max-width: 35%;
            margin: 0;
          }

          .details {
            gap: var(--boxel-sp-xs);
            margin: 0;
            flex: 1;
          }

          .floor, .room {
            font-size: var(--boxel-font-xs);
          }

          .capacity {
            margin: 0;
            font-size: var(--boxel-font-xs);
          }

          .equipment {
            display: none;
          }
        }

        @container fitted-card ((aspect-ratio <= 0.8) and (height > 170px)) {
          .location-fitted {
            grid-template-rows: auto 1fr;
          }

          .thumbnail {
            display: block;
            height: 120px;
          }

          .content {
            padding: 0;
          }

          .location-info {
            gap: var(--boxel-sp-sm);
          }

          .header {
            padding: var(--boxel-sp-sm) var(--boxel-sp-sm) 0;
            display: grid;
          }

          .capacity,
          .equipment {
            padding: 0 var(--boxel-sp-sm);
          }

          .details {
            flex-direction: column;
            align-items: flex-start;
            gap: var(--boxel-sp-xxxs);
          }
        }
      </style>
    </template>

    get backgroundImageStyle() {
      return `background-image: url('${this.args.model.thumbnailURL}')`;
    }
  }

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class="location-isolated">
        <div class="location-header">
          {{#if @model.thumbnailURL}}
            <div class="location-image" style={{this.backgroundImageStyle}}></div>
          {{/if}}
          <div class="location-title-container">
            <h1 class="location-title">{{@model.title}}</h1>
            {{#if @model.description}}
              <p class="location-description">{{@model.description}}</p>
            {{/if}}
          </div>
        </div>

        <div class="location-content">
          <div class="location-details">
            <div class="card detail-section">
              <h2 class="section-title">Location Details</h2>
              <div class="detail-grid">
                {{#if @model.building}}
                  <div class="detail-item">
                    <span class="detail-label">Building</span>
                    <span class="detail-value">{{@model.building}}</span>
                  </div>
                {{/if}}
                
                {{#if @model.floor}}
                  <div class="detail-item">
                    <span class="detail-label">Floor</span>
                    <span class="detail-value">{{@model.floor}}</span>
                  </div>
                {{/if}}
                
                {{#if @model.room}}
                  <div class="detail-item">
                    <span class="detail-label">Room</span>
                    <span class="detail-value">{{@model.room}}</span>
                  </div>
                {{/if}}
                
                {{#if @model.capacity}}
                  <div class="detail-item">
                    <span class="detail-label">Capacity</span>
                    <div class="capacity-badge">{{@model.capacity}} people</div>
                  </div>
                {{/if}}
              </div>
            </div>

            {{#if @model.designatedUse}}
              <div class="card detail-section">
                <h2 class="section-title">Designated Use</h2>
                <div class="designated-use">
                  {{@model.designatedUse}}
                </div>
              </div>
            {{/if}}

            {{#if @model.equipment.length}}
              <div class="card detail-section">
                <h2 class="section-title">Equipment</h2>
                <ul class="equipment-list">
                  {{#each @model.equipment as |item|}}
                    <li class="equipment-item">{{item}}</li>
                  {{/each}}
                </ul>
              </div>
            {{/if}}
          </div>
        </div>
      </div>

      <style scoped>
        .location-isolated {
          display: flex;
          flex-direction: column;
          width: 100%;
          min-height: 100%;
          background-color: hsl(0, 0%, 98%);
          color: hsl(240, 10%, 3.9%);
          font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
          overflow-y: auto;
        }

        .location-header {
          position: relative;
          width: 100%;
        }

        .location-image {
          width: 100%;
          height: 300px;
          background-position: center;
          background-size: cover;
          background-repeat: no-repeat;
          border-radius: 0 0 8px 8px;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .location-title-container {
          padding: 24px;
          background-color: white;
          margin: 0 24px;
          margin-top: -40px;
          position: relative;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .location-title {
          font-size: 28px;
          font-weight: 700;
          color: hsl(240, 10%, 3.9%);
          margin: 0 0 12px;
          line-height: 1.2;
        }

        .location-description {
          font-size: 16px;
          color: hsl(240, 3.8%, 46.1%);
          margin: 0;
          line-height: 1.6;
        }

        .location-content {
          flex: 1;
          padding: 24px;
        }

        .location-details {
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

        .capacity-badge {
          display: inline-flex;
          align-items: center;
          background-color: hsl(215, 20.2%, 65.1%, 0.2);
          color: hsl(215, 20.2%, 35.1%);
          font-size: 14px;
          font-weight: 500;
          padding: 4px 10px;
          border-radius: 16px;
        }

        .designated-use {
          font-size: 16px;
          color: hsl(240, 10%, 3.9%);
          line-height: 1.6;
        }

        .equipment-list {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
          gap: 12px;
          margin: 0;
          padding: 0;
          list-style-type: none;
        }

        .equipment-item {
          font-size: 15px;
          color: hsl(240, 10%, 3.9%);
          padding: 10px 14px;
          background-color: hsl(240, 4.8%, 95.9%);
          border-radius: 6px;
          text-transform: capitalize;
          transition: background-color 0.2s ease;
        }

        .equipment-item:hover {
          background-color: hsl(240, 4.8%, 93%);
        }

        @media (max-width: 768px) {
          .location-title-container {
            margin: 0;
            margin-top: 0;
            border-radius: 0;
          }
          
          .location-image {
            border-radius: 0;
          }
          
          .location-content {
            padding: 16px;
          }
          
          .detail-grid {
            grid-template-columns: 1fr;
          }
          
          .equipment-list {
            grid-template-columns: 1fr;
          }
        }
      </style>
    </template>

    get backgroundImageStyle() {
      return `background-image: url('${this.args.model.thumbnailURL}')`;
    }
  }

  /*
  static embedded = class Embedded extends Component<typeof this> {
    <template></template>
  }

  static atom = class Atom extends Component<typeof this> {
    <template></template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template></template>
  }
  */
}