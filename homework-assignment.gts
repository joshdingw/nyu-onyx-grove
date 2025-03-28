import {
  CardDef,
  Component,
  field,
  contains,
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import DateTimeField from 'https://cardstack.com/base/datetime';
import { PriorityField } from './priority-field';
import { ProgressField } from './progress-field';
import { AssignmentCategoryField } from './assignment-category-field';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn, get } from '@ember/helper';
import { on } from '@ember/modifier';
import { and, eq, not } from '@cardstack/boxel-ui/helpers';

export class HomeworkAssignment extends CardDef {
  static displayName = 'Homework Assignment';

  @field name = contains(StringField);
  @field description = contains(StringField);
  @field category = contains(AssignmentCategoryField);
  @field priority = contains(PriorityField);
  @field progress = contains(ProgressField);
  @field dueDate = contains(DateTimeField);

  static isolated = class Isolated extends Component<typeof this> {
    @tracked showUpdateOptions = false;
    
    @action toggleUpdateOptions() {
      this.showUpdateOptions = !this.showUpdateOptions;
    }
    
    @action updateProgress(newStatus: string) {
      // In a real implementation, this would update the progress field
      // but for now just toggle the options panel closed
      this.showUpdateOptions = false;
    }
    
    <template>
      <div class='assignment-container'>
        <header class='assignment-header'>
          <h1 class='assignment-title'>{{@model.name}}</h1>
          <div class='assignment-meta'>
            <@fields.category />
            <div class='due-date'>
              <span class='due-date-label'>Due:</span>
              <span class='due-date-value'>{{@model.dueDate}}</span>
            </div>
          </div>
        </header>
        
        <div class='assignment-details'>
          <div class='assignment-description'>
            <h2>Description</h2>
            <p>{{@model.description}}</p>
          </div>
          
          <div class='assignment-status'>
            <div class='status-section'>
              <h3>Priority</h3>
              <@fields.priority />
            </div>
            
            <div class='status-section'>
              <h3>Progress</h3>
              <@fields.progress />
            </div>
          </div>
        </div>
        
        <div class='assignment-actions'>
          <button class='action-button update-progress' {{on "click" this.toggleUpdateOptions}}>
            Update Progress
          </button>
          
          {{#if this.showUpdateOptions}}
            <div class='progress-options'>
              <button class='progress-option not-started' {{on "click" (fn this.updateProgress "Not Started")}}>
                Not Started
              </button>
              <button class='progress-option in-progress' {{on "click" (fn this.updateProgress "In Progress")}}>
                In Progress
              </button>
              <button class='progress-option completed' {{on "click" (fn this.updateProgress "Completed")}}>
                Completed
              </button>
            </div>
          {{/if}}
        </div>
      </div>
      
      <style scoped>
        .assignment-container {
          display: flex;
          flex-direction: column;
          gap: 1.5rem;
          padding: 1.5rem;
          font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
          color: #333;
        }
        
        .assignment-header {
          border-bottom: 1px solid #e5e5e5;
          padding-bottom: 1rem;
        }
        
        .assignment-title {
          font-size: 1.5rem;
          font-weight: 600;
          margin: 0 0 0.75rem 0;
        }
        
        .assignment-meta {
          display: flex;
          justify-content: space-between;
          align-items: center;
          font-size: 0.9rem;
        }
        
        .assignment-category {
          background-color: #e9f5fd;
          color: #0075ca;
          padding: 0.25rem 0.75rem;
          border-radius: 1rem;
          font-weight: 500;
        }
        
        .due-date {
          color: #666;
        }
        
        .due-date-label {
          font-weight: 500;
          margin-right: 0.25rem;
        }
        
        .assignment-details {
          display: grid;
          grid-template-columns: 2fr 1fr;
          gap: 1.5rem;
        }
        
        .assignment-description h2 {
          font-size: 1.1rem;
          margin: 0 0 0.75rem 0;
          color: #555;
        }
        
        .assignment-description p {
          font-size: 1rem;
          line-height: 1.5;
          margin: 0;
        }
        
        .assignment-status {
          display: flex;
          flex-direction: column;
          gap: 1rem;
          padding-left: 1rem;
          border-left: 1px solid #e5e5e5;
        }
        
        .status-section h3 {
          font-size: 0.9rem;
          font-weight: 500;
          color: #666;
          margin: 0 0 0.5rem 0;
        }
        
        .priority-indicator, .progress-indicator {
          display: inline-block;
          padding: 0.3rem 0.75rem;
          border-radius: 0.25rem;
          font-size: 0.9rem;
          font-weight: 500;
        }
        
        .priority-high {
          background-color: rgba(220, 38, 38, 0.1);
          color: #dc2626;
        }
        
        .priority-medium {
          background-color: rgba(245, 158, 11, 0.1);
          color: #f59e0b;
        }
        
        .priority-low {
          background-color: rgba(20, 184, 166, 0.1);
          color: #14b8a6;
        }
        
        .progress-not-started {
          background-color: rgba(107, 114, 128, 0.1);
          color: #6b7280;
        }
        
        .progress-in-progress {
          background-color: rgba(59, 130, 246, 0.1);
          color: #3b82f6;
        }
        
        .progress-completed {
          background-color: rgba(22, 163, 74, 0.1);
          color: #16a34a;
        }
        
        .assignment-actions {
          margin-top: 1rem;
          display: flex;
          flex-direction: column;
          align-items: flex-end;
          position: relative;
        }
        
        .action-button {
          background-color: #3b82f6;
          color: white;
          border: none;
          border-radius: 0.25rem;
          padding: 0.5rem 1rem;
          font-size: 0.9rem;
          font-weight: 500;
          cursor: pointer;
          transition: background-color 0.2s;
        }
        
        .action-button:hover {
          background-color: #2563eb;
        }
        
        .progress-options {
          position: absolute;
          top: 100%;
          right: 0;
          margin-top: 0.5rem;
          background: white;
          border: 1px solid #e5e5e5;
          border-radius: 0.25rem;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
          display: flex;
          flex-direction: column;
          width: 150px;
          z-index: 10;
        }
        
        .progress-option {
          padding: 0.5rem;
          text-align: left;
          background: none;
          border: none;
          cursor: pointer;
          font-size: 0.9rem;
        }
        
        .progress-option:hover {
          background-color: #f5f5f5;
        }
        
        .progress-option.not-started:hover {
          color: #6b7280;
        }
        
        .progress-option.in-progress:hover {
          color: #3b82f6;
        }
        
        .progress-option.completed:hover {
          color: #16a34a;
        }
      </style>
    </template>
  };
  
  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='embedded-assignment'>
        <div class='assignment-title'>{{@model.name}}</div>
        <div class='assignment-info'>
          <@fields.category />
          <div class='assignment-due'>Due: {{@model.dueDate}}</div>
        </div>
        <div class='assignment-indicators'>
          <@fields.priority />
          <@fields.progress />
        </div>
      </div>
      
      <style scoped>
        .embedded-assignment {
          padding: 1rem;
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        
        .assignment-title {
          font-size: 1rem;
          font-weight: 600;
          color: #333;
        }
        
        .assignment-info {
          display: flex;
          justify-content: space-between;
          font-size: 0.8rem;
        }
        
        .assignment-due {
          color: #666;
        }
        
        .assignment-indicators {
          display: flex;
          gap: 0.5rem;
          margin-top: 0.25rem;
        }
      </style>
    </template>
  };
  
  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='fitted-assignment'>
        <div class='assignment-header'>
          <div class='assignment-title'>{{@model.name}}</div>
          <div class='assignment-indicators'>
            <@fields.priority />
            <@fields.progress />
          </div>
        </div>
        <div class='assignment-meta'>
          <@fields.category />
          <div class='assignment-due'>{{@model.dueDate}}</div>
        </div>
      </div>
      
      <style scoped>
        .fitted-assignment {
          padding: 0.75rem;
          display: flex;
          flex-direction: column;
          gap: 0.4rem;
          height: 100%;
        }
        
        .assignment-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        
        .assignment-title {
          font-size: 0.9rem;
          font-weight: 600;
          color: #333;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          margin-right: 0.5rem;
          flex: 1;
        }
        
        .assignment-indicators {
          display: flex;
          gap: 0.25rem;
          flex-shrink: 0;
        }
        
        .assignment-meta {
          display: flex;
          justify-content: space-between;
          align-items: center;
          font-size: 0.75rem;
          color: #666;
        }
        
        .assignment-due {
          white-space: nowrap;
        }
      </style>
    </template>
  };
  
  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='edit-assignment'>
        <@fields.name />
        <@fields.description />
        <@fields.category />
        <@fields.priority />
        <@fields.progress />
        <@fields.dueDate />
      </div>
      
      <style>
        .edit-assignment {
          display: flex;
          flex-direction: column;
          gap: 1rem;
          padding: 1rem;
        }
      </style>
    </template>
  };
} 