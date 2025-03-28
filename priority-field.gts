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

export class PriorityField extends FieldDef {
  static displayName = 'Priority Field';
  
  @tracked stringValue = contains(StringField);
  
  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class='priority-field'>
        <div class='priority-indicator {{this.priorityClass}}'>
          {{this.priorityValue}}
        </div>
      </div>
      
      <style scoped>
        .priority-field {
          display: flex;
          align-items: center;
        }
        
        .priority-indicator {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 0.4rem 0.8rem;
          border-radius: 0.25rem;
          font-size: 0.9rem;
          font-weight: 500;
          line-height: 1;
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
      </style>
    </template>
    
    get priorityValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get priorityClass() {
      const value = this.priorityValue?.toLowerCase() || '';
      return `priority-${value}`;
    }
  };
  
  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='priority-field-embedded'>
        <div class='priority-indicator {{this.priorityClass}}'>
          {{this.priorityValue}}
        </div>
      </div>
      
      <style scoped>
        .priority-field-embedded {
          display: inline-flex;
        }
        
        .priority-indicator {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 0.2rem 0.5rem;
          border-radius: 0.25rem;
          font-size: 0.75rem;
          font-weight: 500;
          line-height: 1;
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
        
        @container (max-width: 250px) {
          .priority-indicator {
            padding: 0.15rem 0.4rem;
            font-size: 0.7rem;
          }
        }
      </style>
    </template>
    
    get priorityValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get priorityClass() {
      const value = this.priorityValue?.toLowerCase() || '';
      return `priority-${value}`;
    }
  };
  
  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='priority-field-fitted'>
        <div class='priority-container'>
          <div class='priority-dot {{this.priorityClass}}'></div>
          <span class='priority-text'>{{this.priorityValue}}</span>
        </div>
      </div>
      
      <style scoped>
        .priority-field-fitted {
          display: inline-flex;
          height: 100%;
        }
        
        .priority-container {
          display: flex;
          align-items: center;
          gap: 0.25rem;
        }
        
        .priority-dot {
          width: 0.5rem;
          height: 0.5rem;
          border-radius: 50%;
          flex-shrink: 0;
        }
        
        .priority-text {
          font-size: 0.75rem;
          font-weight: 500;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        
        .priority-high {
          background-color: #dc2626;
        }
        
        .priority-medium {
          background-color: #f59e0b;
        }
        
        .priority-low {
          background-color: #14b8a6;
        }
        
        /* Badge size - just show the dot */
        @container (max-width: 150px) {
          .priority-text {
            display: none;
          }
          
          .priority-dot {
            width: 0.6rem;
            height: 0.6rem;
          }
        }
        
        /* Strip size - show dot and text if fits */
        @container (min-width: 151px) and (max-width: 400px) {
          .priority-text {
            font-size: 0.7rem;
            max-width: 3.5rem;
          }
        }
      </style>
    </template>
    
    get priorityValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get priorityClass() {
      const value = this.priorityValue?.toLowerCase() || '';
      return `priority-${value}`;
    }
  };
  
  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='priority-field-edit'>
        <label class='priority-label'>Priority</label>
        <div class='priority-options'>
          <button 
            class='priority-option {{if (eq this.priorityValue "High") "selected"}} high' 
            {{on "click" (fn this.setPriority "High")}}
          >
            High
          </button>
          <button 
            class='priority-option {{if (eq this.priorityValue "Medium") "selected"}} medium' 
            {{on "click" (fn this.setPriority "Medium")}}
          >
            Medium
          </button>
          <button 
            class='priority-option {{if (eq this.priorityValue "Low") "selected"}} low' 
            {{on "click" (fn this.setPriority "Low")}}
          >
            Low
          </button>
        </div>
      </div>
      
      <style scoped>
        .priority-field-edit {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        
        .priority-label {
          font-size: 0.9rem;
          font-weight: 500;
          color: #555;
        }
        
        .priority-options {
          display: flex;
          gap: 0.5rem;
        }
        
        .priority-option {
          padding: 0.4rem 0.8rem;
          border-radius: 0.25rem;
          font-size: 0.85rem;
          font-weight: 500;
          border: 1px solid #e5e5e5;
          background: white;
          cursor: pointer;
          transition: all 0.2s;
        }
        
        .priority-option:hover {
          background-color: #f8f9fa;
        }
        
        .priority-option.selected {
          border-color: currentColor;
        }
        
        .priority-option.high {
          color: #dc2626;
        }
        
        .priority-option.high.selected {
          background-color: rgba(220, 38, 38, 0.1);
        }
        
        .priority-option.medium {
          color: #f59e0b;
        }
        
        .priority-option.medium.selected {
          background-color: rgba(245, 158, 11, 0.1);
        }
        
        .priority-option.low {
          color: #14b8a6;
        }
        
        .priority-option.low.selected {
          background-color: rgba(20, 184, 166, 0.1);
        }
      </style>
    </template>
    
    get priorityValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    @action setPriority(value: string) {
      this.args.model.stringValue = value;
    }
  };
} 