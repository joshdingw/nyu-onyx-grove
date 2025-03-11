import { CardDef, contains, containsMany, field, linksToMany } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import { Faculty as FacultyCard} from './faculty';

export class Department extends CardDef {
  static displayName = "Department";

  @field name = contains(StringField);
  @field description = contains(StringField);
  @field headOfDepartment = contains(StringField);
  @field facultyCount = contains(StringField);
  @field website = contains(StringField);
  @field facultyMembers = linksToMany(() => FacultyCard);
  @field title = contains(StringField, {
    computeVia: function (this: Department) {
      return `${this.name} Department`;
    }
  });

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <style scoped>
        .department-card {
          padding: 2rem;
          max-width: 800px;
          margin: 0 auto;
          background: white;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .department-header {
          margin-bottom: 2rem;
          border-bottom: 2px solid #eee;
          padding-bottom: 1rem;
        }
        .department-name {
          font-size: 2rem;
          font-weight: bold;
          color: #2c3e50;
        }
        .department-info {
          margin-top: 1.5rem;
        }
        .info-item {
          margin: 1rem 0;
        }
        .label {
          font-weight: 600;
          color: #666;
          margin-right: 0.5rem;
        }
        .faculty-list {
          margin-top: 2rem;
          border-top: 2px solid #eee;
          padding-top: 1rem;
        }
        .faculty-list-title {
          font-size: 1.5rem;
          color: #2c3e50;
          margin-bottom: 1rem;
        }
        .faculty-item {
          padding: 0.5rem;
          margin: 0.5rem 0;
          border-radius: 4px;
          transition: background-color 0.2s;
        }
        .faculty-item:hover {
          background-color: #f5f5f5;
        }
        .faculty-link {
          color: #3498db;
          text-decoration: none;
          cursor: pointer;
        }
        .faculty-link:hover {
          text-decoration: underline;
        }
      </style>

      <div class='department-card'>
        <div class='department-header'>
          <h1 class='department-name'>{{@model.name}}</h1>
        </div>
        
        <div class='department-info'>
          <div class='info-item'>
            <span class='label'>Description:</span>
            {{@model.description}}
          </div>
          
          <div class='info-item'>
            <span class='label'>Head of Department:</span>
            {{@model.headOfDepartment}}
          </div>

          <div class='info-item'>
            <span class='label'>Faculty Count:</span>
            {{@model.facultyCount}}
          </div>

          <div class='info-item'>
            <span class='label'>Website:</span>
            <a href={{@model.website}} target="_blank">{{@model.website}}</a>
          </div>
        </div>

        <div class='faculty-list'>
          <h2 class='faculty-list-title'>Faculty Members</h2>
          <@fields.facultyMembers/>
        </div>
      </div>
    </template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <style scoped>
        .department-card-embedded {
          padding: 1rem;
          background: white;
          border-radius: 6px;
          border: 1px solid #eee;
          margin: 0.5rem 0;
        }
        .department-name {
          font-size: 1.2rem;
          font-weight: bold;
          color: #2c3e50;
        }
        .department-brief {
          color: #666;
          margin-top: 0.5rem;
          font-size: 0.9rem;
        }
      </style>

      <div class='department-card-embedded'>
        <div class='department-name'>{{@model.name}}</div>
        <div class='department-brief'>{{@model.description}}</div>
      </div>
    </template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <style scoped>
        .edit-form {
          padding: 1rem;
        }
        .field-container {
          margin: 1rem 0;
        }
        .field-label {
          font-weight: 600;
          margin-bottom: 0.5rem;
          display: block;
        }
      </style>

      <div class='edit-form'>
        <div class='field-container'>
          <label class='field-label'>Department Name</label>
          <@fields.name />
        </div>

        <div class='field-container'>
          <label class='field-label'>Description</label>
          <@fields.description />
        </div>

        <div class='field-container'>
          <label class='field-label'>Head of Department</label>
          <@fields.headOfDepartment />
        </div>

        <div class='field-container'>
          <label class='field-label'>Faculty Count</label>
          <@fields.facultyCount />
        </div>

        <div class='field-container'>
          <label class='field-label'>Website</label>
          <@fields.website />
        </div>

        <div class='field-container'>
          <label class='field-label'>Faculty Members</label>
          <@fields.facultyMembers />
        </div>
      </div>
    </template>
  }
}