import {
  CardDef,
  Component,
  field,
  contains,
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import DatetimeField from 'https://cardstack.com/base/datetime';
import BooleanField from 'https://cardstack.com/base/boolean';
import MarkdownField from 'https://cardstack.com/base/markdown';
import UserIcon from '@cardstack/boxel-icons/user-circle';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

export class Staff extends CardDef {
  static displayName = "Staff";
  static icon = UserIcon;

  @field fullName = contains(StringField);
  @field role = contains(StringField);
  @field workEmail = contains(StringField);
  @field phone = contains(StringField);
  @field startDate = contains(DatetimeField);
  @field active = contains(BooleanField);
  @field profile = contains(MarkdownField);
  @field thumbnailURL = contains(StringField);

  get formattedStartDate() {
    if (!this.startDate) return 'Not specified';
    
    const date = new Date(this.startDate);
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return date.toLocaleDateString(undefined, options);
  }

  get tenure() {
    if (!this.startDate) return 'Unknown';
    
    const start = new Date(this.startDate);
    const now = new Date();
    const years = now.getFullYear() - start.getFullYear();
    const months = now.getMonth() - start.getMonth();
    
    if (years === 0) {
      return months <= 0 ? 'Just started' : `${months} month${months !== 1 ? 's' : ''}`;
    } else if (years === 1 && months < 0) {
      return `${12 + months} months`;
    } else {
      return `${years} year${years !== 1 ? 's' : ''}${months > 0 ? ` and ${months} month${months !== 1 ? 's' : ''}` : ''}`;
    }
  }

  static isolated = class Isolated extends Component<typeof this> {
    @tracked showContact = false;

    @action toggleContact() {
      this.showContact = !this.showContact;
    }

    get avatarStyle() {
      if (this.args.model.thumbnailURL) {
        return `background-image: url('${this.args.model.thumbnailURL}')`;
      }
      return '';
    }

    <template>
      <div class='staff-profile {{if @model.active "active" "inactive"}}'>
        <div class='profile-header'>
          <div class='avatar' style={{this.avatarStyle}}>
            {{#unless @model.thumbnailURL}}
              {{@model.fullName.[0]}}
            {{/unless}}
          </div>
          <div class='header-info'>
            <h1 class='name'><@fields.fullName /></h1>
            <div class='role'><@fields.role /></div>
            <div class='status-badge'>
              {{#if @model.active}}
                <span class='active-badge'>Active</span>
              {{else}}
                <span class='inactive-badge'>Inactive</span>
              {{/if}}
            </div>
          </div>
        </div>

        <div class='profile-body'>
          <div class='tenure-info'>
            <div class='tenure-label'>Member since:</div>
            <div class='tenure-value'>{{@model.formattedStartDate}}</div>
            <div class='tenure-duration'>{{@model.tenure}} with us</div>
          </div>

          <div class='profile-content'>
            <@fields.profile />
          </div>

          <button 
            class='contact-toggle' 
            {{on "click" this.toggleContact}}
          >
            {{if this.showContact "Hide Contact Info" "Show Contact Info"}}
          </button>

          {{#if this.showContact}}
            <div class='contact-info'>
              <div class='contact-item'>
                <span class='contact-label'>Email:</span>
                <a href='mailto:{{@model.workEmail}}' class='contact-value'>
                  <@fields.workEmail />
                </a>
              </div>
              <div class='contact-item'>
                <span class='contact-label'>Phone:</span>
                <a href='tel:{{@model.phone}}' class='contact-value'>
                  <@fields.phone />
                </a>
              </div>
            </div>
          {{/if}}
        </div>
      </div>
      <style scoped>
        .staff-profile {
          max-width: 800px;
          margin: 0 auto;
          padding: 1.5rem;
          border-radius: 0.75rem;
          background-color: #f8f9fa;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .inactive {
          opacity: 0.7;
          background-color: #f0f0f0;
        }

        .profile-header {
          display: flex;
          align-items: center;
          margin-bottom: 1.5rem;
          gap: 1rem;
        }

        .avatar {
          width: 100px;
          height: 100px;
          border-radius: 50%;
          background-color: #6366f1;
          color: white;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 2.5rem;
          font-weight: 600;
          flex-shrink: 0;
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
        }

        .header-info {
          flex-grow: 1;
        }

        .name {
          font-size: 1.875rem;
          margin: 0 0 0.5rem;
          color: #1f2937;
          font-weight: 600;
          line-height: 1.2;
        }

        .role {
          font-size: 1.125rem;
          color: #4b5563;
          margin-bottom: 0.5rem;
          font-weight: 500;
        }

        .status-badge {
          margin-top: 0.5rem;
        }

        .active-badge, .inactive-badge {
          display: inline-block;
          padding: 0.25rem 0.75rem;
          border-radius: 9999px;
          font-size: 0.875rem;
          font-weight: 500;
        }

        .active-badge {
          background-color: #ecfdf5;
          color: #065f46;
        }

        .inactive-badge {
          background-color: #fef2f2;
          color: #991b1b;
        }

        .profile-body {
          background-color: white;
          border-radius: 0.5rem;
          padding: 1.25rem;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        .tenure-info {
          display: flex;
          flex-wrap: wrap;
          align-items: center;
          margin-bottom: 1.25rem;
          padding-bottom: 0.75rem;
          border-bottom: 1px solid #e5e7eb;
          gap: 0.5rem;
        }

        .tenure-label {
          font-weight: 500;
          color: #4b5563;
        }

        .tenure-value {
          color: #1f2937;
          margin-right: 0.75rem;
        }

        .tenure-duration {
          background-color: #f5f3ff;
          color: #5b21b6;
          padding: 0.125rem 0.625rem;
          border-radius: 9999px;
          font-size: 0.875rem;
          font-weight: 500;
        }

        .profile-content {
          margin-bottom: 1.5rem;
          line-height: 1.6;
          color: #374151;
        }

        .contact-toggle {
          background-color: #6366f1;
          color: white;
          border: none;
          padding: 0.5rem 1rem;
          border-radius: 0.375rem;
          font-weight: 500;
          cursor: pointer;
          transition: all 0.2s ease;
          margin-bottom: 0.75rem;
        }

        .contact-toggle:hover {
          background-color: #4f46e5;
          transform: translateY(-1px);
        }

        .contact-info {
          background-color: #f9fafb;
          border-radius: 0.375rem;
          padding: 1rem;
          margin-top: 0.75rem;
        }

        .contact-item {
          display: flex;
          margin-bottom: 0.5rem;
        }

        .contact-item:last-child {
          margin-bottom: 0;
        }

        .contact-label {
          font-weight: 500;
          width: 80px;
          color: #4b5563;
        }

        .contact-value {
          color: #6366f1;
          text-decoration: none;
        }

        .contact-value:hover {
          text-decoration: underline;
        }
      </style>
    </template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    get avatarStyle() {
      if (this.args.model.thumbnailURL) {
        return `background-image: url('${this.args.model.thumbnailURL}')`;
      }
      return '';
    }

    <template>
      <div class='staff-card {{if @model.active "active" "inactive"}}'>
        <div class='avatar' style={{this.avatarStyle}}>
          {{#unless @model.thumbnailURL}}
            {{@model.fullName.[0]}}
          {{/unless}}
        </div>
        <div class='info'>
          <h3 class='name'><@fields.fullName /></h3>
          <div class='role'><@fields.role /></div>
          <div class='contact'>
            <a href='mailto:{{@model.workEmail}}' class='email'>
              {{@model.workEmail}}
            </a>
          </div>
        </div>
        {{#if @model.active}}
          <div class='status active'></div>
        {{else}}
          <div class='status inactive'></div>
        {{/if}}
      </div>
      <style scoped>
        .staff-card {
          display: flex;
          align-items: center;
          padding: 0.75rem;
          border-radius: 0.5rem;
          background-color: white;
          box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
          position: relative;
          overflow: hidden;
          gap: 0.75rem;
        }

        .inactive {
          opacity: 0.7;
          background-color: #f9fafb;
        }

        .avatar {
          width: 48px;
          height: 48px;
          border-radius: 50%;
          background-color: #6366f1;
          color: white;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1.25rem;
          font-weight: 600;
          flex-shrink: 0;
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
        }

        .info {
          flex-grow: 1;
          min-width: 0;
        }

        .name {
          font-size: 1rem;
          font-weight: 600;
          margin: 0 0 0.25rem;
          color: #1f2937;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        .role {
          font-size: 0.875rem;
          color: #4b5563;
          margin-bottom: 0.25rem;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        .contact {
          font-size: 0.75rem;
        }

        .email {
          color: #6366f1;
          text-decoration: none;
        }

        .email:hover {
          text-decoration: underline;
        }

        .status {
          width: 8px;
          height: 8px;
          border-radius: 50%;
        }

        .status.active {
          background-color: #10b981;
        }

        .status.inactive {
          background-color: #ef4444;
        }
      </style>
    </template>
  }

  static atom = class Atom extends Component<typeof this> {
    get avatarStyle() {
      if (this.args.model.thumbnailURL) {
        return `background-image: url('${this.args.model.thumbnailURL}')`;
      }
      return '';
    }

    <template>
      <div class='staff-atom {{if @model.active "active" "inactive"}}'>
        <div class='avatar' style={{this.avatarStyle}}>
          {{#unless @model.thumbnailURL}}
            {{@model.fullName.[0]}}
          {{/unless}}
        </div>
        <div class='name'><@fields.fullName /></div>
      </div>
      <style scoped>
        .staff-atom {
          display: inline-flex;
          align-items: center;
          padding: 0.25rem 0.5rem;
          border-radius: 9999px;
          background-color: #f3f4f6;
          max-width: 100%;
          gap: 0.375rem;
        }

        .inactive {
          opacity: 0.7;
        }

        .avatar {
          width: 24px;
          height: 24px;
          border-radius: 50%;
          background-color: #6366f1;
          color: white;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 0.75rem;
          font-weight: 600;
          flex-shrink: 0;
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
        }

        .name {
          font-size: 0.875rem;
          font-weight: 500;
          color: #1f2937;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      </style>
    </template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='staff-edit'>
        <div class='edit-section'>
          <h3 class='section-title'>Personal Information</h3>
          <div class='field-group'>
            <label class='field'>
              <span class='field-label'>Full Name</span>
              <@fields.fullName />
            </label>
            
            <label class='field'>
              <span class='field-label'>Role</span>
              <@fields.role />
            </label>
          </div>
        </div>
        
        <div class='edit-section'>
          <h3 class='section-title'>Contact Information</h3>
          <div class='field-group'>
            <label class='field'>
              <span class='field-label'>Work Email</span>
              <@fields.workEmail />
            </label>
            
            <label class='field'>
              <span class='field-label'>Phone</span>
              <@fields.phone />
            </label>
          </div>
        </div>
        
        <div class='edit-section'>
          <h3 class='section-title'>Employment Details</h3>
          <div class='field-group'>
            <label class='field'>
              <span class='field-label'>Start Date</span>
              <@fields.startDate />
            </label>
            
            <label class='field checkbox-field'>
              <span class='field-label'>Active Status</span>
              <@fields.active />
            </label>
          </div>
        </div>
        
        <div class='edit-section'>
          <h3 class='section-title'>Profile</h3>
          <label class='field full-width'>
            <span class='field-label'>Staff Profile</span>
            <@fields.profile />
          </label>
        </div>
      </div>
      <style scoped>
        .staff-edit {
          max-width: 800px;
          margin: 0 auto;
          padding: 1.25rem;
        }

        .edit-section {
          margin-bottom: 1.5rem;
          padding: 1.25rem;
          background-color: #f9fafb;
          border-radius: 0.5rem;
          border: 1px solid #e5e7eb;
        }

        .section-title {
          margin-top: 0;
          margin-bottom: 1rem;
          font-size: 1.125rem;
          color: #111827;
          border-bottom: 1px solid #e5e7eb;
          padding-bottom: 0.5rem;
          font-weight: 600;
        }

        .field-group {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 1rem;
        }

        .field {
          display: flex;
          flex-direction: column;
          gap: 0.375rem;
        }

        .full-width {
          grid-column: 1 / -1;
        }

        .field-label {
          font-weight: 500;
          color: #374151;
          font-size: 0.875rem;
        }

        .checkbox-field {
          flex-direction: row;
          align-items: center;
          gap: 0.5rem;
        }

        @media (max-width: 640px) {
          .field-group {
            grid-template-columns: 1fr;
          }
        }
      </style>
    </template>
  }

  static fitted = class Fitted extends Component<typeof this> {
    get avatarStyle() {
      if (this.args.model.thumbnailURL) {
        return `background-image: url('${this.args.model.thumbnailURL}')`;
      }
      return '';
    }

    <template>
      <div class='staff-fitted {{if @model.active "active" "inactive"}}'>
        <div class='avatar' style={{this.avatarStyle}}>
          {{#unless @model.thumbnailURL}}
            {{@model.fullName.[0]}}
          {{/unless}}
        </div>
        <div class='content'>
          <h3 class='name'><@fields.fullName /></h3>
          <div class='role'><@fields.role /></div>
          <div class='tenure'>{{@model.tenure}}</div>
        </div>
      </div>
      <style scoped>
        .staff-fitted {
          display: grid;
          height: 100%;
          width: 100%;
          overflow: hidden;
          background-color: white;
          border-radius: 0.5rem;
          box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }

        .inactive {
          opacity: 0.7;
          background-color: #f9fafb;
        }

        .avatar {
          background-color: #6366f1;
          color: white;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 600;
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
        }

        .content {
          padding: 0.75rem;
          overflow: hidden;
        }

        .name {
          margin: 0 0 0.25rem;
          font-weight: 600;
          color: #1f2937;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .role {
          color: #4b5563;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          font-size: 0.875rem;
        }

        .tenure {
          font-size: 0.75rem;
          color: #6366f1;
          margin-top: 0.375rem;
        }

        /* Small square */
        @container fitted-card (width <= 100px) and (height <= 100px) {
          .staff-fitted {
            grid-template: 'avatar' 1fr / 1fr;
          }
          .avatar {
            font-size: 2rem;
          }
          .content {
            display: none;
          }
        }

        /* Medium square */
        @container fitted-card (100px < width <= 200px) and (100px < height <= 200px) {
          .staff-fitted {
            grid-template: 
              'avatar' 60%
              'content' 40% / 1fr;
          }
          .avatar {
            font-size: 2.25rem;
          }
          .tenure {
            display: none;
          }
        }

        /* Large square */
        @container fitted-card (width > 200px) and (height > 200px) {
          .staff-fitted {
            grid-template: 
              'avatar' 70%
              'content' 30% / 1fr;
          }
          .avatar {
            font-size: 3rem;
          }
        }

        /* Horizontal rectangle */
        @container fitted-card (width > height) {
          .staff-fitted {
            grid-template: 'avatar content' 1fr / auto 1fr;
          }
          .avatar {
            aspect-ratio: 1;
            font-size: 1.5rem;
          }
        }

        /* Vertical rectangle */
        @container fitted-card (height > width * 1.5) {
          .staff-fitted {
            grid-template: 
              'avatar' auto
              'content' 1fr / 1fr;
          }
          .avatar {
            aspect-ratio: 1;
            font-size: 2rem;
          }
        }
      </style>
    </template>
  }
}