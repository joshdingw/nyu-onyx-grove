import {
  FieldDef,
  Component,
  contains,
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { and, eq, not } from '@cardstack/boxel-ui/helpers';

export class ProgressField extends FieldDef {
  static displayName = 'Progress Field';
  
  @tracked stringValue = contains(StringField);
  
  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class='progress-field'>
        <div class='progress-indicator {{this.progressClass}}'>
          {{this.progressValue}}
        </div>
      </div>
      
      <style scoped>
        .progress-field {
          display: flex;
          align-items: center;
        }
        
        .progress-indicator {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 0.4rem 0.8rem;
          border-radius: 0.25rem;
          font-size: 0.9rem;
          font-weight: 500;
          line-height: 1;
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
      </style>
    </template>
    
    get progressValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get progressClass() {
      // Convert "In Progress" to "progress-in-progress"
      const value = this.progressValue?.toLowerCase().replace(/\s+/g, '-') || '';
      return `progress-${value}`;
    }
  };
  
  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='progress-field-embedded'>
        <div class='progress-indicator {{this.progressClass}}'>
          {{this.progressValue}}
        </div>
      </div>
      
      <style scoped>
        .progress-field-embedded {
          display: inline-flex;
        }
        
        .progress-indicator {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 0.2rem 0.5rem;
          border-radius: 0.25rem;
          font-size: 0.75rem;
          font-weight: 500;
          line-height: 1;
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
        
        @container (max-width: 250px) {
          .progress-indicator {
            padding: 0.15rem 0.4rem;
            font-size: 0.7rem;
          }
        }
      </style>
    </template>
    
    get progressValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get progressClass() {
      const value = this.progressValue?.toLowerCase().replace(/\s+/g, '-') || '';
      return `progress-${value}`;
    }
  };
  
  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='progress-field-fitted'>
        <div class='progress-container'>
          <div class='progress-dot {{this.progressClass}}'></div>
          <span class='progress-text'>
            {{#if this.useInitials}}
              {{this.initials}}
            {{else}}
              {{this.progressValue}}
            {{/if}}
          </span>
        </div>
      </div>
      
      <style scoped>
        .progress-field-fitted {
          display: inline-flex;
          height: 100%;
        }
        
        .progress-container {
          display: flex;
          align-items: center;
          gap: 0.25rem;
        }
        
        .progress-dot {
          width: 0.5rem;
          height: 0.5rem;
          border-radius: 50%;
          flex-shrink: 0;
        }
        
        .progress-text {
          font-size: 0.75rem;
          font-weight: 500;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        
        .progress-not-started {
          background-color: #6b7280;
        }
        
        .progress-in-progress {
          background-color: #3b82f6;
        }
        
        .progress-completed {
          background-color: #16a34a;
        }
        
        /* Badge size - just show the dot */
        @container (max-width: 150px) {
          .progress-text {
            display: none;
          }
          
          .progress-dot {
            width: 0.6rem;
            height: 0.6rem;
          }
        }
        
        /* Strip size - use initials for "In Progress" and show full text for others when space permits */
        @container (min-width: 151px) and (max-width: 250px) {
          .progress-text {
            font-size: 0.7rem;
            max-width: 3rem;
          }
        }
      </style>
    </template>
    
    get progressValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get progressClass() {
      const value = this.progressValue?.toLowerCase().replace(/\s+/g, '-') || '';
      return `progress-${value}`;
    }
    
    get useInitials() {
      // Use initials for "In Progress" in smaller views
      return this.progressValue === "In Progress";
    }
    
    get initials() {
      // Convert "In Progress" to "IP", etc.
      const value = this.progressValue || '';
      return value.split(' ').map(word => word[0]).join('');
    }
  };
  
  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='progress-field-edit'>
        <label class='progress-label'>Progress</label>
        <div class='progress-options'>
          <button 
            class='progress-option {{if (eq this.progressValue "Not Started") "selected"}} not-started' 
            {{on "click" (fn this.setProgress "Not Started")}}
          >
            Not Started
          </button>
          <button 
            class='progress-option {{if (eq this.progressValue "In Progress") "selected"}} in-progress' 
            {{on "click" (fn this.setProgress "In Progress")}}
          >
            In Progress
          </button>
          <button 
            class='progress-option {{if (eq this.progressValue "Completed") "selected"}} completed' 
            {{on "click" (fn this.setProgress "Completed")}}
          >
            Completed
          </button>
        </div>
      </div>
      
      <style scoped>
        .progress-field-edit {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        
        .progress-label {
          font-size: 0.9rem;
          font-weight: 500;
          color: #555;
        }
        
        .progress-options {
          display: flex;
          flex-wrap: wrap;
          gap: 0.5rem;
        }
        
        .progress-option {
          padding: 0.4rem 0.8rem;
          border-radius: 0.25rem;
          font-size: 0.85rem;
          font-weight: 500;
          border: 1px solid #e5e5e5;
          background: white;
          cursor: pointer;
          transition: all 0.2s;
        }
        
        .progress-option:hover {
          background-color: #f8f9fa;
        }
        
        .progress-option.selected {
          border-color: currentColor;
        }
        
        .progress-option.not-started {
          color: #6b7280;
        }
        
        .progress-option.not-started.selected {
          background-color: rgba(107, 114, 128, 0.1);
        }
        
        .progress-option.in-progress {
          color: #3b82f6;
        }
        
        .progress-option.in-progress.selected {
          background-color: rgba(59, 130, 246, 0.1);
        }
        
        .progress-option.completed {
          color: #16a34a;
        }
        
        .progress-option.completed.selected {
          background-color: rgba(22, 163, 74, 0.1);
        }
      </style>
    </template>
    
    get progressValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    @action setProgress(value: string) {
      this.args.model.stringValue = value;
    }
  };
} 