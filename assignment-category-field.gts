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

export class AssignmentCategoryField extends FieldDef {
  static displayName = 'Assignment Category Field';
  
  @tracked stringValue = contains(StringField);
  
  // This array could be expanded with more academic categories
  static categoryColors = {
    'Science': { bg: '#e9f5fd', color: '#0075ca' },
    'Mathematics': { bg: '#f0f4ff', color: '#3b5bdb' },
    'Humanities': { bg: '#f3f0ff', color: '#6741d9' },
    'Social Sciences': { bg: '#fff0f6', color: '#c2255c' },
    'Computer Science': { bg: '#f8f9fa', color: '#495057' },
    'Languages': { bg: '#fff9db', color: '#e67700' },
    'Arts': { bg: '#f8f0fc', color: '#ae3ec9' },
    'Physical Education': { bg: '#ebfbee', color: '#2b8a3e' },
    'Other': { bg: '#f1f3f5', color: '#495057' }
  };
  
  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class='category-field'>
        <div class='category-indicator' style={{this.categoryStyle}}>
          {{this.categoryValue}}
        </div>
      </div>
      
      <style scoped>
        .category-field {
          display: flex;
          align-items: center;
        }
        
        .category-indicator {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 0.3rem 0.75rem;
          border-radius: 1rem;
          font-size: 0.9rem;
          font-weight: 500;
          line-height: 1;
        }
      </style>
    </template>
    
    get categoryValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get categoryStyle() {
      const category = this.categoryValue || 'Other';
      const colors = AssignmentCategoryField.categoryColors[category] || 
                    AssignmentCategoryField.categoryColors['Other'];
      
      return `background-color: ${colors.bg}; color: ${colors.color};`;
    }
  };
  
  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='category-field-embedded'>
        <div class='category-indicator' style={{this.categoryStyle}}>
          {{this.categoryValue}}
        </div>
      </div>
      
      <style scoped>
        .category-field-embedded {
          display: inline-flex;
        }
        
        .category-indicator {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 0.2rem 0.5rem;
          border-radius: 0.75rem;
          font-size: 0.75rem;
          font-weight: 500;
          line-height: 1;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          max-width: 10rem;
        }
        
        @container (max-width: 250px) {
          .category-indicator {
            max-width: 6rem;
            padding: 0.15rem 0.4rem;
            font-size: 0.7rem;
          }
        }
      </style>
    </template>
    
    get categoryValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get categoryStyle() {
      const category = this.categoryValue || 'Other';
      const colors = AssignmentCategoryField.categoryColors[category] || 
                    AssignmentCategoryField.categoryColors['Other'];
      
      return `background-color: ${colors.bg}; color: ${colors.color};`;
    }
  };
  
  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='category-field-fitted'>
        <div class='category-container'>
          {{#if this.showCategory}}
            <span class='category-text' style={{this.categoryTextStyle}}>
              {{#if this.showFirstLetterOnly}}
                {{this.firstLetter}}
              {{else}}
                {{this.categoryValue}}
              {{/if}}
            </span>
          {{/if}}
        </div>
      </div>
      
      <style scoped>
        .category-field-fitted {
          display: inline-flex;
          height: 100%;
        }
        
        .category-container {
          display: flex;
          align-items: center;
        }
        
        .category-text {
          font-size: 0.75rem;
          font-weight: 500;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          max-width: 100%;
        }
        
        /* Badge size - show first letter only or omit */
        @container (max-width: 150px) {
          .category-text {
            max-width: 1rem;
            font-size: 0.7rem;
          }
        }
        
        /* Strip size - show truncated text */
        @container (min-width: 151px) and (max-width: 250px) {
          .category-text {
            max-width: 5rem;
            font-size: 0.7rem;
          }
        }
        
        /* Larger sizes */
        @container (min-width: 251px) {
          .category-text {
            max-width: 8rem;
          }
        }
      </style>
    </template>
    
    get categoryValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    get showCategory() {
      // Always show category unless we're at an extremely small size
      return true;
    }
    
    get showFirstLetterOnly() {
      // Show just the first letter when space is very limited
      return false; // This could be adjusted based on container queries
    }
    
    get firstLetter() {
      return (this.categoryValue || '')[0] || '';
    }
    
    get categoryTextStyle() {
      const category = this.categoryValue || 'Other';
      const colors = AssignmentCategoryField.categoryColors[category] || 
                    AssignmentCategoryField.categoryColors['Other'];
      
      return `color: ${colors.color};`;
    }
  };
  
  static edit = class Edit extends Component<typeof this> {
    commonCategories = [
      'Science',
      'Mathematics',
      'Humanities',
      'Social Sciences',
      'Computer Science',
      'Languages',
      'Arts',
      'Physical Education',
      'Other'
    ];
    
    @tracked showCommonCategories = true;
    @tracked customCategory = '';
    
    <template>
      <div class='category-field-edit'>
        <label class='category-label'>Subject/Category</label>
        
        {{#if this.showCommonCategories}}
          <div class='category-options'>
            {{#each this.commonCategories as |category|}}
              <button 
                class='category-option {{if (eq this.categoryValue category) "selected"}}' 
                style={{this.getCategoryStyle category}}
                {{on "click" (fn this.setCategory category)}}
              >
                {{category}}
              </button>
            {{/each}}
            <button 
              class='category-custom-btn'
              {{on "click" this.toggleCustomCategory}}
            >
              Custom...
            </button>
          </div>
        
          <div class='category-custom'>
            <input 
              class='category-input'
              type='text'
              value={{this.customCategory}}
              placeholder='Enter custom category'
              {{on "input" this.updateCustomCategory}}
            />
            <div class='category-custom-actions'>
              <button 
                class='category-btn cancel'
                {{on "click" this.toggleCustomCategory}}
              >
                Cancel
              </button>
              <button 
                class='category-btn apply'
                {{on "click" this.applyCustomCategory}}
                disabled={{not this.customCategory}}
              >
                Apply
              </button>
            </div>
          </div>
        {{/if}}
      </div>
      
      <style scoped>
        .category-field-edit {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        
        .category-label {
          font-size: 0.9rem;
          font-weight: 500;
          color: #555;
        }
        
        .category-options {
          display: flex;
          flex-wrap: wrap;
          gap: 0.5rem;
        }
        
        .category-option {
          padding: 0.3rem 0.7rem;
          border-radius: 1rem;
          font-size: 0.85rem;
          font-weight: 500;
          border: 1px solid transparent;
          cursor: pointer;
          transition: all 0.2s;
        }
        
        .category-option:hover {
          filter: brightness(0.95);
        }
        
        .category-option.selected {
          box-shadow: 0 0 0 2px currentColor;
        }
        
        .category-custom-btn {
          padding: 0.3rem 0.7rem;
          border-radius: 1rem;
          font-size: 0.85rem;
          background-color: #f1f3f5;
          color: #495057;
          border: 1px solid #dee2e6;
          cursor: pointer;
        }
        
        .category-custom-btn:hover {
          background-color: #e9ecef;
        }
        
        .category-custom {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }
        
        .category-input {
          padding: 0.5rem;
          border: 1px solid #dee2e6;
          border-radius: 0.25rem;
          font-size: 0.85rem;
        }
        
        .category-custom-actions {
          display: flex;
          justify-content: flex-end;
          gap: 0.5rem;
        }
        
        .category-btn {
          padding: 0.3rem 0.7rem;
          border-radius: 0.25rem;
          font-size: 0.85rem;
          cursor: pointer;
          background: none;
          border: 1px solid #dee2e6;
        }
        
        .category-btn.cancel {
          color: #495057;
        }
        
        .category-btn.apply {
          background-color: #228be6;
          color: white;
          border-color: #228be6;
        }
        
        .category-btn.apply:disabled {
          background-color: #adb5bd;
          border-color: #adb5bd;
          cursor: not-allowed;
        }
      </style>
    </template>
    
    get categoryValue() {
      // Access the actual string value
      return this.args.model.stringValue;
    }
    
    @action setCategory(value: string) {
      this.args.model.stringValue = value;
    }
    
    @action toggleCustomCategory() {
      this.showCommonCategories = !this.showCommonCategories;
      if (!this.showCommonCategories) {
        this.customCategory = this.categoryValue || '';
      }
    }
    
    @action updateCustomCategory(event: InputEvent) {
      this.customCategory = (event.target as HTMLInputElement).value;
    }
    
    @action applyCustomCategory() {
      if (this.customCategory) {
        this.args.model.stringValue = this.customCategory;
        this.showCommonCategories = true;
      }
    }
    
    getCategoryStyle(category: string) {
      const colors = AssignmentCategoryField.categoryColors[category] || 
                    AssignmentCategoryField.categoryColors['Other'];
      
      return `background-color: ${colors.bg}; color: ${colors.color};`;
    }
  };
} 