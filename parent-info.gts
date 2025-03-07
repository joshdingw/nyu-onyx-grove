import { CardDef, field, contains, StringField } from 'https://cardstack.com/base/card-api';
import { Address } from './address';
import { Component } from 'https://cardstack.com/base/card-api';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

export class ParentInfo extends CardDef {
  static displayName = "Parent Info";

  @field parentFirstName = contains(StringField);
  @field parentLastName = contains(StringField);
  @field relationshipToStudent = contains(StringField);
  @field primaryEmail = contains(StringField);
  @field secondaryEmail = contains(StringField);
  @field primaryPhone = contains(StringField);
  @field secondaryPhone = contains(StringField);
  @field homeAddress = contains(Address);
  @field employerName = contains(StringField);
  @field workPhone = contains(StringField);
  @field preferredContactMethod = contains(StringField);
  @field emergencyContactPriority = contains(StringField);
  @field preferredLanguage = contains(StringField);
  @field communicationPreferences = contains(StringField);
  @field accessPortalUsername = contains(StringField);

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class='parent-dashboard'>
        <header class='dashboard-header'>
          <div class='profile-section'>
            <div class='avatar' style='background-image: url({{@model.thumbnailURL}})' />
            <div class='profile-info'>
              <h1>{{@model.parentFirstName}} {{@model.parentLastName}}</h1>
              <p class='relationship'>{{@model.relationshipToStudent}}</p>
            </div>
          </div>
        </header>

        <main class='dashboard-content'>
          <div class='metrics-grid'>
            <div class='metric-card contact-info'>
              <h2>Contact Information</h2>
              <div class='metric-content'>
                <div class='metric-item'>
                  <span class='label'>Primary Email</span>
                  <span class='value'>{{@model.primaryEmail}}</span>
                </div>
                <div class='metric-item'>
                  <span class='label'>Primary Phone</span>
                  <span class='value'>{{@model.primaryPhone}}</span>
                </div>
                <div class='metric-item'>
                  <span class='label'>Work Phone</span>
                  <span class='value'>{{@model.workPhone}}</span>
                </div>
              </div>
            </div>

            <div class='metric-card address'>
              <h2>Home Address</h2>
              <div class='metric-content'>
                <div class='metric-item'>
                  <span class='value address-value'>
                    {{@model.homeAddress.street1}}
                    {{#if @model.homeAddress.street2}}
                      <br>{{@model.homeAddress.street2}}
                    {{/if}}
                    <br>{{@model.homeAddress.city}}, {{@model.homeAddress.state}} {{@model.homeAddress.zipCode}}
                  </span>
                </div>
              </div>
            </div>

            <div class='metric-card preferences'>
              <h2>Preferences</h2>
              <div class='metric-content'>
                <div class='metric-item'>
                  <span class='label'>Preferred Contact</span>
                  <span class='value'>{{@model.preferredContactMethod}}</span>
                </div>
                <div class='metric-item'>
                  <span class='label'>Language</span>
                  <span class='value'>{{@model.preferredLanguage}}</span>
                </div>
                <div class='metric-item'>
                  <span class='label'>Emergency Priority</span>
                  <span class='value'>{{@model.emergencyContactPriority}}</span>
                </div>
              </div>
            </div>

            <div class='metric-card employment'>
              <h2>Employment</h2>
              <div class='metric-content'>
                <div class='metric-item'>
                  <span class='label'>Employer</span>
                  <span class='value'>{{@model.employerName}}</span>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>

      <style scoped>
        .parent-dashboard {
          background-color: var(--boxel-background);
          min-height: 100vh;
          padding: var(--boxel-sp-lg);
        }

        .dashboard-header {
          margin-bottom: var(--boxel-sp-xl);
          padding: var(--boxel-sp-lg);
          background: white;
          border-radius: var(--boxel-border-radius);
          box-shadow: var(--boxel-shadow-sm);
        }

        .profile-section {
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-lg);
        }

        .avatar {
          width: 80px;
          height: 80px;
          border-radius: 50%;
          background-size: cover;
          background-position: center;
          border: 3px solid var(--boxel-highlight);
        }

        .profile-info h1 {
          margin: 0;
          font-size: var(--boxel-font-size-xl);
          color: var(--boxel-dark);
        }

        .relationship {
          margin: var(--boxel-sp-xxs) 0 0;
          color: var(--boxel-purple);
          font-size: var(--boxel-font-size-sm);
        }

        .metrics-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
          gap: var(--boxel-sp-lg);
        }

        .metric-card {
          background: white;
          border-radius: var(--boxel-border-radius);
          padding: var(--boxel-sp-lg);
          box-shadow: var(--boxel-shadow-sm);
        }

        .metric-card h2 {
          margin: 0 0 var(--boxel-sp-lg);
          font-size: var(--boxel-font-size-lg);
          color: var(--boxel-dark);
          border-bottom: 1px solid var(--boxel-border);
          padding-bottom: var(--boxel-sp-sm);
        }

        .metric-content {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-sm);
        }

        .metric-item {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-xxs);
        }

        .label {
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-purple);
          font-weight: 500;
        }

        .value {
          font-size: var(--boxel-font-size);
          color: var(--boxel-dark);
        }

        .address-value {
          line-height: 1.5;
        }
      </style>
    </template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='parent-card'>
        <div class='parent-avatar' style='background-image: url({{@model.thumbnailURL}})' />
        <div class='parent-info'>
          <h3>{{@model.parentFirstName}} {{@model.parentLastName}}</h3>
          <p class='relationship'>{{@model.relationshipToStudent}}</p>
          <div class='contact'>
            <p>{{@model.primaryEmail}}</p>
            <p>{{@model.primaryPhone}}</p>
          </div>
        </div>
      </div>

      <style scoped>
        .parent-card {
          display: flex;
          gap: var(--boxel-sp-sm);
          padding: var(--boxel-sp-sm);
          background: white;
          border-radius: var(--boxel-border-radius);
          box-shadow: var(--boxel-shadow-sm);
        }

        .parent-avatar {
          width: 50px;
          height: 50px;
          border-radius: 50%;
          background-size: cover;
          background-position: center;
          flex-shrink: 0;
        }

        .parent-info {
          flex-grow: 1;
        }

        .parent-info h3 {
          margin: 0;
          font-size: var(--boxel-font-size);
          color: var(--boxel-dark);
        }

        .relationship {
          margin: var(--boxel-sp-xxs) 0;
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-purple);
        }

        .contact {
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-dark);
        }

        .contact p {
          margin: var(--boxel-sp-xxs) 0;
        }
      </style>
    </template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='edit-form'>
        <div class='form-section'>
          <h2>Personal Information</h2>
          <div class='field-group'>
            <@fields.parentFirstName />
            <@fields.parentLastName />
            <@fields.relationshipToStudent />
          </div>
        </div>

        <div class='form-section'>
          <h2>Contact Information</h2>
          <div class='field-group'>
            <@fields.primaryEmail />
            <@fields.secondaryEmail />
            <@fields.primaryPhone />
            <@fields.secondaryPhone />
            <@fields.workPhone />
          </div>
        </div>

        <div class='form-section'>
          <h2>Address</h2>
          <@fields.homeAddress />
        </div>

        <div class='form-section'>
          <h2>Preferences</h2>
          <div class='field-group'>
            <@fields.preferredContactMethod />
            <@fields.preferredLanguage />
            <@fields.communicationPreferences />
          </div>
        </div>
      </div>

      <style scoped>
        .edit-form {
          max-width: 800px;
          margin: 0 auto;
          padding: var(--boxel-sp-lg);
        }

        .form-section {
          margin-bottom: var(--boxel-sp-xl);
        }

        .form-section h2 {
          margin: 0 0 var(--boxel-sp-lg);
          font-size: var(--boxel-font-size-lg);
          color: var(--boxel-dark);
          border-bottom: 1px solid var(--boxel-border);
          padding-bottom: var(--boxel-sp-sm);
        }

        .field-group {
          display: grid;
          gap: var(--boxel-sp-sm);
        }
      </style>
    </template>
  }
}