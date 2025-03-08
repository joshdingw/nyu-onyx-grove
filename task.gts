import {
  CardDef,
  Component,
  field,
  contains,
  containsMany,
  linksTo
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import DateField from 'https://cardstack.com/base/date';
import NumberField from 'https://cardstack.com/base/number';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn, get, eq } from '@ember/helper';
import CalendarIcon from '@cardstack/boxel-icons/calendar';
import AlertCircleIcon from '@cardstack/boxel-icons/alert-circle';
import ClockIcon from '@cardstack/boxel-icons/clock';
import { Student } from './student';

export class Task extends CardDef {
  static displayName = "Task";

  @field name = contains(StringField);
  @field description = contains(StringField);
  @field dueDate = contains(DateField);
  @field status = contains(StringField);
  @field completionPercentage = contains(NumberField);
  @field priority = contains(StringField);
  @field category = contains(StringField);
  @field estimatedHours = contains(NumberField);
  @field assignedTo = linksTo(() => Student);

  @field remainingTime = contains(StringField, {
    computeVia: function(this: Task) {
      if (!this.dueDate) return 'No due date set';
      
      const now = new Date();
      const dueDate = new Date(this.dueDate);
      
      if (isNaN(dueDate.getTime())) return 'Invalid date';
      
      // If due date is in the past
      if (dueDate < now) {
        return 'Overdue';
      }
      
      const diffTime = Math.abs(dueDate.getTime() - now.getTime());
      const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
      const diffHours = Math.floor((diffTime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      
      if (diffDays > 0) {
        return `${diffDays} day${diffDays > 1 ? 's' : ''} ${diffHours} hour${diffHours > 1 ? 's' : ''}`;
      } else if (diffHours > 0) {
        return `${diffHours} hour${diffHours > 1 ? 's' : ''}`;
      } else {
        const diffMinutes = Math.floor((diffTime % (1000 * 60 * 60)) / (1000 * 60));
        return `${diffMinutes} minute${diffMinutes > 1 ? 's' : ''}`;
      }
    }
  });

  static isolated = class Isolated extends Component {
    get statusClass() {
      return this.args.model.status?.toLowerCase().replace(/\s+/g, '_') || '';
    }

    get priorityClass() {
      return this.args.model.priority?.toLowerCase() || '';
    }

    get isCompleted() {
      return this.args.model.status === "Completed";
    }

    get isInProgress() {
      return this.args.model.status === "In Progress";
    }

    get isAtRisk() {
      return this.args.model.status === "At Risk";
    }

    get isOverdue() {
      return this.args.model.remainingTime === "Overdue";
    }

    get isComplete() {
      return (this.args.model.completionPercentage || 0) >= 100;
    }

    <template>
      <div class='task-card'>
        <div class='task-header'>
          <div class='task-title'>
            <h2>{{@model.name}}</h2>
          </div>
          <div class='task-meta'>
            {{#if @model.assignedTo}}
              <div class='assigned-to'>
                <span class='student-name'>{{@model.assignedTo.fullName}}</span>
              </div>
            {{/if}}
            <span class='priority-badge {{this.priorityClass}}'>
              {{@model.priority}}
            </span>
            <span class='category-badge'>
              {{@model.category}}
            </span>
          </div>
        </div>
        
        <div class='task-content'>
          <div class='task-info'>
            <p class='description'>{{@model.description}}</p>
            
            <div class='time-section'>
              <div class='time-header'>
                <span>Timeline</span>
              </div>
              <div class='time-details'>
                <div class='time-item'>
                  <CalendarIcon class='time-icon' />
                  <div class='time-info'>
                    <span class='time-label'>Due Date</span>
                    <span class='time-value'>{{@model.dueDate}}</span>
                  </div>
                </div>
                <div class='time-item'>
                  <ClockIcon class='time-icon' />
                  <div class='time-info'>
                    <span class='time-label'>Remaining</span>
                    <span class='time-value {{if this.isOverdue "overdue"}}'>
                      {{@model.remainingTime}}
                    </span>
                  </div>
                </div>
              </div>
            </div>
            
            <div class='meta-info'>
              <div class='info-item'>
                <div class='status-indicator {{this.statusClass}}'>
                  {{#if this.isInProgress}}
                    <ClockIcon class='status-icon' />
                  {{else if this.isAtRisk}}
                    <AlertCircleIcon class='status-icon' />
                  {{/if}}
                  {{@model.status}}
                </div>
              </div>
            </div>
          </div>
          
          <div class='progress-section'>
            <div class='progress-header'>
              <span class='progress-label'>Progress</span>
              <span class='progress-percentage'>{{@model.completionPercentage}}%</span>
            </div>
            <div class='progress-bar'>
              <div 
                class='progress-fill {{if this.isComplete "completed"}}'
                style='width: {{@model.completionPercentage}}%'
              ></div>
            </div>
          </div>
          
          {{#if @model.estimatedHours}}
            <div class='estimated-time'>
              <span class='estimated-label'>Estimated Time:</span>
              <span class='estimated-value'>{{@model.estimatedHours}} hours</span>
            </div>
          {{/if}}
        </div>
      </div>

      <style scoped>
        .task-card {
          background: white;
          border-radius: 12px;
          box-shadow: 0 4px 6px rgba(0,0,0,0.05), 0 1px 3px rgba(0,0,0,0.1);
          padding: 24px;
        }

        .task-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 20px;
        }

        .task-title {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .task-icon {
          width: 24px;
          height: 24px;
          color: #666;
        }

        h2 {
          margin: 0;
          color: #1a1a1a;
          font-size: 1.25rem;
          font-weight: 600;
        }

        .task-meta {
          display: flex;
          gap: 8px;
        }

        .priority-badge {
          padding: 4px 12px;
          border-radius: 20px;
          font-size: 0.75rem;
          font-weight: 500;
          text-transform: uppercase;
          background-color: #f5f5f5;
          color: #666;
        }
        
        .priority-badge.high {
          background-color: #ffebee;
          color: #d32f2f;
        }
        
        .priority-badge.medium {
          background-color: #fff8e1;
          color: #ff8f00;
        }
        
        .priority-badge.low {
          background-color: #e8f5e9;
          color: #388e3c;
        }

        .category-badge {
          padding: 4px 12px;
          border-radius: 20px;
          background-color: #f5f5f5;
          color: #666;
          font-size: 0.75rem;
        }

        .task-content {
          display: flex;
          flex-direction: column;
          gap: 20px;
        }

        .task-info {
          display: flex;
          flex-direction: column;
          gap: 16px;
        }

        .description {
          color: #4a4a4a;
          margin: 0;
          line-height: 1.6;
          font-size: 0.9375rem;
        }
        
        .time-section {
          background-color: #f9f9f9;
          border-radius: 8px;
          padding: 16px;
          margin-top: 8px;
        }
        
        .time-header {
          margin-bottom: 12px;
          font-weight: 500;
          color: #666;
          font-size: 0.875rem;
        }
        
        .time-details {
          display: flex;
          flex-direction: column;
          gap: 12px;
        }
        
        .time-item {
          display: flex;
          align-items: center;
          gap: 12px;
        }
        
        .time-icon {
          width: 20px;
          height: 20px;
          color: #666;
        }
        
        .time-info {
          display: flex;
          flex-direction: column;
          gap: 2px;
        }
        
        .time-label {
          font-size: 0.75rem;
          color: #666;
        }
        
        .time-value {
          font-weight: 500;
          color: #1a1a1a;
        }
        
        .time-value.overdue {
          color: #d32f2f;
          font-weight: 600;
        }

        .meta-info {
          display: flex;
          gap: 16px;
          flex-wrap: wrap;
        }

        .info-item {
          display: flex;
          align-items: center;
          gap: 8px;
          color: #666;
          font-size: 0.875rem;
        }

        .info-icon {
          width: 16px;
          height: 16px;
        }

        .status-indicator {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 6px 12px;
          border-radius: 20px;
          background-color: #2196F3;
          color: white;
          font-size: 0.875rem;
          font-weight: 500;
        }
        
        .status-indicator.completed {
          background-color: #4caf50;
        }
        
        .status-indicator.pending {
          background-color: #9e9e9e;
        }
        
        .status-indicator.blocked {
          background-color: #f44336;
        }
        
        .status-indicator.in_progress {
          background-color: #2196F3;
        }
        
        .status-indicator.at_risk {
          background-color: #ff9800;
        }

        .status-icon {
          width: 16px;
          height: 16px;
        }

        .progress-section {
          margin-top: 8px;
        }

        .progress-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 8px;
        }

        .progress-label {
          color: #666;
          font-size: 0.875rem;
          font-weight: 500;
        }

        .progress-percentage {
          color: #1a1a1a;
          font-size: 0.875rem;
          font-weight: 600;
        }

        .progress-bar {
          width: 100%;
          height: 8px;
          background: #f5f5f5;
          border-radius: 4px;
          overflow: hidden;
        }

        .progress-fill {
          height: 100%;
          background-color: #2196F3;
          transition: width 0.3s ease;
        }
        
        .progress-fill.completed {
          background-color: #4caf50;
        }
        
        .estimated-time {
          display: flex;
          justify-content: space-between;
          padding-top: 12px;
          border-top: 1px solid #f0f0f0;
          font-size: 0.875rem;
        }
        
        .estimated-label {
          color: #666;
        }
        
        .estimated-value {
          font-weight: 500;
          color: #1a1a1a;
        }

        .assigned-to {
          display: flex;
          align-items: center;
          padding: 4px 12px;
          border-radius: 20px;
          background-color: #e3f2fd;
          color: #1976d2;
        }

        .student-name {
          font-weight: 500;
          font-size: 0.875rem;
        }
      </style>
    </template>
  }

  static embedded = class Embedded extends Component {
    get statusClass() {
      return this.args.model.status?.toLowerCase().replace(/\s+/g, '_') || '';
    }

    get isCompleted() {
      return this.args.model.status === "Completed";
    }

    get isInProgress() {
      return this.args.model.status === "In Progress";
    }

    get isAtRisk() {
      return this.args.model.status === "At Risk";
    }

    get isOverdue() {
      return this.args.model.remainingTime === "Overdue";
    }

    get isComplete() {
      return (this.args.model.completionPercentage || 0) >= 100;
    }

    <template>
      <div class='task-item'>
        <div class='task-header'>
          <div class='task-main'>
            <div class='task-status {{this.statusClass}}'>
              {{#if this.isInProgress}}
                <ClockIcon class='status-icon' />
              {{else if this.isAtRisk}}
                <AlertCircleIcon class='status-icon' />
              {{/if}}
            </div>
            <div class='task-info'>
              <div class='task-top'>
                <span class='task-name'>{{@model.name}}</span>
                {{#if @model.assignedTo}}
                  <span class='assigned-student'>{{@model.assignedTo.fullName}}</span>
                {{/if}}
              </div>
              <div class='task-details'>
                <span class='due-date'>
                  <CalendarIcon class='calendar-icon' />
                  {{@model.dueDate}}
                </span>
                <span class='remaining-time {{if this.isOverdue "overdue"}}'>
                  <ClockIcon class='clock-icon' />
                  {{@model.remainingTime}}
                </span>
              </div>
            </div>
          </div>
          <div class='task-progress'>
            <span class='progress-text'>{{@model.completionPercentage}}%</span>
            <div class='progress-bar'>
              <div 
                class='progress-fill {{if this.isComplete "completed"}}'
                style='width: {{@model.completionPercentage}}%'
              ></div>
            </div>
          </div>
        </div>
      </div>

      <style scoped>
        .task-item {
          background: white;
          border-radius: 8px;
          padding: 16px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.04);
        }

        .task-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 16px;
        }

        .task-main {
          display: flex;
          align-items: center;
          gap: 12px;
          flex: 1;
        }

        .task-status {
          width: 32px;
          height: 32px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          background-color: #2196F3;
        }
        
        .task-status.completed {
          background-color: #4caf50;
        }
        
        .task-status.pending {
          background-color: #9e9e9e;
        }
        
        .task-status.blocked {
          background-color: #f44336;
        }
        
        .task-status.in_progress {
          background-color: #2196F3;
        }
        
        .task-status.at_risk {
          background-color: #ff9800;
        }

        .status-icon {
          width: 16px;
          height: 16px;
          color: white;
        }

        .task-info {
          display: flex;
          flex-direction: column;
          gap: 4px;
        }

        .task-name {
          font-weight: 500;
          color: #1a1a1a;
        }
        
        .task-details {
          display: flex;
          gap: 12px;
        }

        .due-date, .remaining-time {
          display: flex;
          align-items: center;
          gap: 4px;
          color: #666;
          font-size: 0.75rem;
        }
        
        .remaining-time.overdue {
          color: #d32f2f;
          font-weight: 600;
        }

        .calendar-icon, .clock-icon {
          width: 12px;
          height: 12px;
        }

        .task-progress {
          display: flex;
          align-items: center;
          gap: 12px;
          min-width: 120px;
        }

        .progress-text {
          color: #1a1a1a;
          font-size: 0.875rem;
          font-weight: 500;
          min-width: 40px;
        }

        .progress-bar {
          flex: 1;
          height: 6px;
          background: #f5f5f5;
          border-radius: 3px;
          overflow: hidden;
        }

        .progress-fill {
          height: 100%;
          background-color: #2196F3;
          transition: width 0.3s ease;
        }
        
        .progress-fill.completed {
          background-color: #4caf50;
        }

        .task-top {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .assigned-student {
          font-size: 0.75rem;
          padding: 2px 8px;
          background-color: #e3f2fd;
          color: #1976d2;
          border-radius: 12px;
          font-weight: 500;
        }
      </style>
    </template>
  }

  static edit = class Edit extends Component {
    @tracked isEditing = false;

    @action
    toggleEdit() {
      this.isEditing = !this.isEditing;
    }

    get statusClass() {
      return this.args.model.status?.toLowerCase().replace(/\s+/g, '_') || '';
    }

    get priorityClass() {
      return this.args.model.priority?.toLowerCase() || '';
    }

    get isCompleted() {
      return this.args.model.status === "Completed";
    }

    get isInProgress() {
      return this.args.model.status === "In Progress";
    }

    get isAtRisk() {
      return this.args.model.status === "At Risk";
    }

    get isOverdue() {
      return this.args.model.remainingTime === "Overdue";
    }

    get isComplete() {
      return (this.args.model.completionPercentage || 0) >= 100;
    }

    <template>
      <div class='task-edit'>
        <div class='edit-header'>
          <div class='header-main'>
            <h3>{{if this.isEditing 'Edit Task' 'Task Details'}}</h3>
          </div>
          <button {{on 'click' this.toggleEdit}} class='edit-toggle'>
            {{if this.isEditing 'Cancel' 'Edit'}}
          </button>
        </div>

        {{#if this.isEditing}}
          <div class='edit-form'>
            <div class='form-row'>
              <div class='form-group'>
                <label>Name</label>
                <@fields.name />
              </div>
              <div class='form-group'>
                <label>Assigned To</label>
                <@fields.assignedTo />
              </div>
            </div>
            
            <div class='form-group'>
              <label>Description</label>
              <@fields.description />
            </div>
            
            <div class='form-row'>
              <div class='form-group'>
                <label>Due Date</label>
                <@fields.dueDate />
              </div>
              <div class='form-group'>
                <label>Priority</label>
                <@fields.priority />
              </div>
            </div>
            
            <div class='form-row'>
              <div class='form-group'>
                <label>Status</label>
                <@fields.status />
              </div>
              <div class='form-group'>
                <label>Completion Percentage</label>
                <@fields.completionPercentage />
              </div>
            </div>
            
            <div class='form-group'>
              <label>Estimated Hours</label>
              <@fields.estimatedHours />
            </div>
          </div>
        {{else}}
          <div class='view-mode'>
            <div class='info-section'>
              <div class='info-header'>Basic Information</div>
              <div class='info-content'>
                <div class='info-group'>
                  <label>Name</label>
                  <span>{{@model.name}}</span>
                </div>
                {{#if @model.assignedTo}}
                  <div class='info-group'>
                    <label>Assigned To</label>
                    <div class='assigned-info'>
                      <span class='student-name'>{{@model.assignedTo.fullName}}</span>
                    </div>
                  </div>
                {{/if}}
                <div class='info-group'>
                  <label>Category</label>
                  <span class='category-badge'>{{@model.category}}</span>
                </div>
                <div class='info-group'>
                  <label>Priority</label>
                  <span class='priority-badge {{this.priorityClass}}'>
                    {{@model.priority}}
                  </span>
                </div>
                {{#if @model.estimatedHours}}
                  <div class='info-group'>
                    <label>Estimated</label>
                    <span>{{@model.estimatedHours}} hours</span>
                  </div>
                {{/if}}
              </div>
            </div>

            <div class='info-section'>
              <div class='info-header'>Description</div>
              <p class='description'>{{@model.description}}</p>
            </div>
            
            <div class='info-section'>
              <div class='info-header'>Progress</div>
              <div class='info-content'>
                <div class='info-group'>
                  <label>Status</label>
                  <div class='status-indicator {{this.statusClass}}'>
                    {{#if this.isInProgress}}
                      <ClockIcon class='status-icon' />
                    {{else if this.isAtRisk}}
                      <AlertCircleIcon class='status-icon' />
                    {{/if}}
                    {{@model.status}}
                  </div>
                </div>
                
                <div class='info-group'>
                  <label>Due Date</label>
                  <span>{{@model.dueDate}}</span>
                </div>
                
                <div class='info-group'>
                  <label>Remaining</label>
                  <span class='remaining-time {{if this.isOverdue "overdue"}}'>
                    {{@model.remainingTime}}
                  </span>
                </div>
                
                <div class='info-group'>
                  <label>Completion</label>
                  <div class='progress-container'>
                    <div class='progress-bar'>
                      <div 
                        class='progress-fill {{if this.isComplete "completed"}}'
                        style='width: {{@model.completionPercentage}}%'
                      ></div>
                    </div>
                    <span class='progress-text'>{{@model.completionPercentage}}%</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        {{/if}}
      </div>

      <style scoped>
        .task-edit {
          background: white;
          border-radius: 12px;
          box-shadow: 0 4px 6px rgba(0,0,0,0.05);
          padding: 24px;
        }

        .edit-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 24px;
          padding-bottom: 16px;
          border-bottom: 1px solid #eee;
        }

        .header-main {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .header-icon {
          width: 24px;
          height: 24px;
          color: #666;
        }

        h3 {
          margin: 0;
          color: #1a1a1a;
          font-size: 1.25rem;
          font-weight: 600;
        }

        .edit-toggle {
          padding: 8px 16px;
          border-radius: 6px;
          border: 1px solid #e0e0e0;
          background: white;
          color: #666;
          font-weight: 500;
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .edit-toggle:hover {
          background: #f5f5f5;
          border-color: #d0d0d0;
        }

        .edit-form {
          display: flex;
          flex-direction: column;
          gap: 20px;
        }

        .form-row {
          display: flex;
          gap: 20px;
        }

        .form-group {
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 8px;
        }

        label {
          color: #666;
          font-size: 0.875rem;
          font-weight: 500;
        }

        .view-mode {
          display: flex;
          flex-direction: column;
          gap: 24px;
        }

        .info-section {
          display: flex;
          flex-direction: column;
          gap: 12px;
        }

        .info-header {
          color: #666;
          font-size: 0.875rem;
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }

        .info-content {
          display: flex;
          flex-direction: column;
          gap: 16px;
        }

        .info-group {
          display: flex;
          align-items: center;
          gap: 16px;
        }

        .info-group label {
          min-width: 100px;
          color: #666;
          font-size: 0.875rem;
        }

        .description {
          color: #4a4a4a;
          line-height: 1.6;
          margin: 0;
          font-size: 0.9375rem;
        }

        .status-indicator {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 6px 12px;
          border-radius: 20px;
          background-color: #2196F3;
          color: white;
          font-size: 0.875rem;
          font-weight: 500;
        }
        
        .status-indicator.completed {
          background-color: #4caf50;
        }
        
        .status-indicator.pending {
          background-color: #9e9e9e;
        }
        
        .status-indicator.blocked {
          background-color: #f44336;
        }
        
        .status-indicator.in_progress {
          background-color: #2196F3;
        }
        
        .status-indicator.at_risk {
          background-color: #ff9800;
        }

        .status-icon {
          width: 16px;
          height: 16px;
        }

        .progress-container {
          flex: 1;
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .progress-bar {
          flex: 1;
          height: 8px;
          background: #f5f5f5;
          border-radius: 4px;
          overflow: hidden;
        }

        .progress-fill {
          height: 100%;
          background-color: #2196F3;
          transition: width 0.3s ease;
        }
        
        .progress-fill.completed {
          background-color: #4caf50;
        }

        .progress-text {
          min-width: 48px;
          text-align: right;
          font-weight: 500;
          color: #1a1a1a;
        }

        .priority-badge {
          padding: 4px 12px;
          border-radius: 20px;
          font-size: 0.75rem;
          font-weight: 500;
          text-transform: uppercase;
          background-color: #f5f5f5;
          color: #666;
        }
        
        .priority-badge.high {
          background-color: #ffebee;
          color: #d32f2f;
        }
        
        .priority-badge.medium {
          background-color: #fff8e1;
          color: #ff8f00;
        }
        
        .priority-badge.low {
          background-color: #e8f5e9;
          color: #388e3c;
        }

        .category-badge {
          padding: 4px 12px;
          border-radius: 20px;
          background-color: #f5f5f5;
          color: #666;
          font-size: 0.75rem;
        }
        
        .remaining-time {
          font-weight: 500;
        }
        
        .remaining-time.overdue {
          color: #d32f2f;
          font-weight: 600;
        }

        .assigned-info {
          display: flex;
          align-items: center;
        }

        .student-name {
          font-weight: 500;
        }
      </style>
    </template>
  }
}