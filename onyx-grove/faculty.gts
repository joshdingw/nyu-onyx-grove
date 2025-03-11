import { 
  CardDef, 
  Component,
  contains,
  field,
  linksTo,
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import { Department as DepartmentCard } from './department';

export class Faculty extends CardDef {
  static displayName = "Faculty";

  @field name = contains(StringField);
  @field department = linksTo(() => DepartmentCard);
  @field email = contains(StringField);
  @field phone = contains(StringField);
  @field officeLocation = contains(StringField);

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <style scoped>
        .faculty-card {
          padding: 20px;
          border-radius: 8px;
          background-color: #ffffff;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
          max-width: 600px;
          margin: 0 auto;
        }
        .header {
          border-bottom: 2px solid #f0f0f0;
          padding-bottom: 15px;
          margin-bottom: 15px;
          display: flex;
          align-items: center;
          gap: 20px;
        }
        .photo {
          width: 120px;
          height: 120px;
          border-radius: 60px;
          object-fit: cover;
          border: 3px solid #f0f0f0;
        }
        .header-info {
          flex: 1;
        }
        .name {
          font-size: 24px;
          font-weight: bold;
          color: #2c3e50;
        }
        .title {
          color: #7f8c8d;
          font-size: 18px;
        }
        .info-section {
          margin: 15px 0;
        }
        .info-label {
          font-weight: 600;
          color: #34495e;
          width: 140px;
          display: inline-block;
        }
        .info-value {
          color: #2c3e50;
        }
      </style>

      <div class='faculty-card'>
        <div class='header'>
          <img class='photo' src={{@model.thumbnailURL}} alt={{@model.name}} />
          <div class='header-info'>
            <div class='name'>{{@model.name}}</div>
            <div class='title'>{{@model.title}}</div>
          </div>
        </div>

        <div class='info-section'>
          <div>
            <span class='info-label'>Department:</span>
            <span class='info-value'>{{@model.department.name}}</span>
          </div>

        <span class='info-value'><@fields.department @format='atom' /></span>


          <div>
            <span class='info-label'>Email:</span>
            <span class='info-value'>{{@model.email}}</span>
          </div>
          <div>
            <span class='info-label'>Phone:</span>
            <span class='info-value'>{{@model.phone}}</span>
          </div>
          <div>
            <span class='info-label'>Office:</span>
            <span class='info-value'>{{@model.officeLocation}}</span>
          </div>
        </div>
      </div>
    </template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <style scoped>
        .edit-form {
          display: flex;
          flex-direction: column;
          gap: 15px;
          padding: 20px;
          max-width: 500px;
        }
        .field-label {
          font-weight: 600;
          margin-bottom: 5px;
          color: #34495e;
        }
        .photo-preview {
          width: 120px;
          height: 120px;
          border-radius: 60px;
          object-fit: cover;
          border: 3px solid #f0f0f0;
          margin-bottom: 10px;
        }
      </style>

      <div class='edit-form'>
        <div>
          <div class='field-label'>Name</div>
          <@fields.name />
        </div>
        <div>
          <div class='field-label'>Title</div>
          <@fields.title />
        </div>
        <div>
          <div class='field-label'>Department</div>
          <@fields.department />
        </div>
        <div>
          <div class='field-label'>Email</div>
          <@fields.email />
        </div>
        <div>
          <div class='field-label'>Phone</div>
          <@fields.phone />
        </div>
        <div>
          <div class='field-label'>Office</div>
          <@fields.officeLocation />
        </div>
      </div>
    </template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <style scoped>
        .faculty-card-embedded {
          padding: 10px;
          border: 1px solid #e0e0e0;
          border-radius: 4px;
          margin: 5px;
          display: flex;
          align-items: center;
          gap: 10px;
        }
        .photo-small {
          width: 40px;
          height: 40px;
          border-radius: 20px;
          object-fit: cover;
        }
        .info {
          flex: 1;
        }
        .name-title {
          font-weight: bold;
        }
        .department {
          color: #666;
          font-size: 0.9em;
        }
      </style>

      <div class='faculty-card-embedded'>
        <img class='photo-small' src={{@model.thumbnailURL}} alt={{@model.name}} />
        <div class='info'>
          <div class='name-title'>{{@model.name}} - {{@model.title}}</div>
          <div class='department'>{{@model.department.name}}</div>
        </div>
      </div>
    </template>
  }
}