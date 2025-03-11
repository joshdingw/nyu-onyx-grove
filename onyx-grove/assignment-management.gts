import {
  CardDef,
  Component,
  field,
  contains,
  containsMany,
  linksTo,
  linksToMany,
  getCard
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import DateField from 'https://cardstack.com/base/date';
import NumberField from 'https://cardstack.com/base/number';
import { Student } from './student';
import { StudentCohort } from './student-cohort';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn, get, eq } from '@ember/helper';
import { on } from '@ember/modifier';

export class AssignmentManagement extends CardDef {
  static displayName = "Assignment Management";

  // Task related fields
  @field taskName = contains(StringField);
  @field taskDescription = contains(StringField);
  @field dueDate = contains(DateField);
  @field taskType = contains(StringField);
  @field taskStatus = contains(StringField);
  @field completionPercentage = contains(NumberField);

  // Student and class related fields
  @field student = linksTo(() => Student);
  @field cohort = linksTo(() => StudentCohort);

  // Computed field for task status color
  @field statusColor = contains(StringField, {
    computeVia: function(this: AssignmentManagement) {
      switch (this.taskStatus) {
        case 'completed':
          return '#4CAF50';
        case 'in_progress':
          return '#FFC107';
        case 'overdue':
          return '#F44336';
        default:
          return '#9E9E9E';
      }
    }
  });

  static isolated = class Isolated extends Component<typeof this> {
    @tracked selectedDate = new Date();
    @tracked searchQuery = '';
    @tracked selectedClass = '';
    @tracked selectedTaskType = '';
    @tracked searchStatus = '';
    @tracked searchResults = [];

    @action
    updateDate(event: Event) {
      const input = event.target as HTMLInputElement;
      this.selectedDate = new Date(input.value);
    }

    @action
    updateSearch(event: Event) {
      const input = event.target as HTMLInputElement;
      this.searchQuery = input.value;
    }

    @action
    updateClassFilter(event: Event) {
      const select = event.target as HTMLSelectElement;
      this.selectedClass = select.value;
    }

    @action
    updateTaskTypeFilter(event: Event) {
      const select = event.target as HTMLSelectElement;
      this.selectedTaskType = select.value;
    }

    @action
    async searchStudent(event: Event) {
      const input = event.target as HTMLInputElement;
      this.searchQuery = input.value;
      
      try {
        if (!this.searchQuery.trim()) {
          this.searchStatus = '';
          this.searchResults = [];
          return;
        }

        // 使用 getCard 获取学生数据
        try {
          const studentCard = await getCard('Student', this.searchQuery);
          if (studentCard) {
            this.searchResults = [studentCard];
            this.searchStatus = 'success';
          } else {
            this.searchResults = [];
            this.searchStatus = 'failed';
          }
        } catch (error) {
          console.error('Failed to get student:', error);
          this.searchResults = [];
          this.searchStatus = 'error';
        }

      } catch (error) {
        console.error('Search error:', error);
        this.searchStatus = 'error';
        this.searchResults = [];
      }
    }

    <template>
      <div class='assignment-management'>
        <!-- Control Bar -->
        <div class='control-bar'>
          <div class='control-group'>
            <input 
              type='date'
              value={{this.selectedDate}}
              {{on 'change' this.updateDate}}
              class='date-picker'
            />
          </div>
          
          <div class='control-group'>
            <div class='search-container'>
              <input 
                type='text'
                placeholder='Search students...'
                value={{this.searchQuery}}
                {{on 'input' this.searchStudent}}
                class='search-input'
              />
              {{#if this.searchStatus}}
                <div class='search-status {{this.searchStatus}}'>
                  {{#if (eq this.searchStatus "success")}}
                    Success ({{this.searchResults.length}} found)
                  {{else if (eq this.searchStatus "failed")}}
                    No matches
                  {{else}}
                    Error
                  {{/if}}
                </div>
              {{/if}}
            </div>
          </div>
          
          <div class='control-group'>
            <select 
              {{on 'change' this.updateClassFilter}}
              class='filter-select'
            >
              <option value=''>All Classes</option>
              <option value='class-a'>Class A</option>
              <option value='class-b'>Class B</option>
              <option value='class-c'>Class C</option>
            </select>
          </div>
          
          <div class='control-group'>
            <select 
              {{on 'change' this.updateTaskTypeFilter}}
              class='filter-select'
            >
              <option value=''>All Tasks</option>
              <option value='homework'>Homework</option>
              <option value='project'>Project</option>
              <option value='quiz'>Quiz</option>
            </select>
          </div>
          
          <div class='completion-rate'>
            Overall Completion: 75%
          </div>
        </div>

        <!-- Content Table -->
        <div class='content-table'>
          <table>
            <thead>
              <tr>
                <th>Student</th>
                <th>Class</th>
                <th>Progress</th>
                <th>Status</th>
                <th>Tasks</th>
              </tr>
            </thead>
            <tbody>
              {{#each this.searchResults as |student|}}
                <tr class='student-row'>
                  <td class='student-info'>
                    <div class='avatar'>
                      <img src={{student.avatarUrl}} alt='Student avatar' />
                    </div>
                    <div class='student-details'>
                      <div class='student-name'>{{student.fullName}}</div>
                      <div class='student-class'>{{student.cohort.name}}</div>
                    </div>
                  </td>
                  <td>{{student.cohort.name}}</td>
                  <td>
                    <div class='progress-bar'>
                      <div 
                        class='progress-fill'
                        style='width: {{student.completionPercentage}}%'
                      ></div>
                    </div>
                  </td>
                  <td>
                    <span class='status-badge' style='background-color: {{student.statusColor}}'>
                      {{student.taskStatus}}
                    </span>
                  </td>
                  <td class='task-list'>
                    {{#each student.tasks as |task|}}
                      <div class='task-item'>
                        <span class='task-name'>{{task.name}}</span>
                        <span class='task-due-date'>Due: {{task.dueDate}}</span>
                      </div>
                    {{/each}}
                  </td>
                </tr>
              {{/each}}
            </tbody>
          </table>
        </div>
      </div>

      <style scoped>
        .assignment-management {
          padding: 20px;
          background: #f5f5f5;
          min-height: 100vh;
        }

        .control-bar {
          display: flex;
          gap: 20px;
          background: white;
          padding: 20px;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          margin-bottom: 20px;
        }

        .control-group {
          flex: 1;
        }

        .date-picker,
        .search-input,
        .filter-select {
          width: 100%;
          padding: 10px;
          border: 1px solid #ddd;
          border-radius: 4px;
          font-size: 14px;
        }

        .completion-rate {
          padding: 10px 20px;
          background: #4CAF50;
          color: white;
          border-radius: 4px;
          font-weight: 500;
        }

        .content-table {
          background: white;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          overflow: hidden;
        }

        table {
          width: 100%;
          border-collapse: collapse;
        }

        th {
          background: #f8f9fa;
          padding: 15px;
          text-align: left;
          font-weight: 500;
          color: #444;
          border-bottom: 2px solid #eee;
        }

        td {
          padding: 15px;
          border-bottom: 1px solid #eee;
        }

        .student-info {
          display: flex;
          align-items: center;
          gap: 15px;
        }

        .avatar {
          width: 40px;
          height: 40px;
          border-radius: 50%;
          overflow: hidden;
        }

        .avatar img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }

        .student-details {
          display: flex;
          flex-direction: column;
        }

        .student-name {
          font-weight: 500;
          color: #333;
        }

        .student-class {
          font-size: 12px;
          color: #666;
        }

        .progress-bar {
          width: 100%;
          height: 8px;
          background: #eee;
          border-radius: 4px;
          overflow: hidden;
        }

        .progress-fill {
          height: 100%;
          background: #4CAF50;
          transition: width 0.3s ease;
        }

        .status-badge {
          padding: 6px 12px;
          border-radius: 12px;
          color: white;
          font-size: 12px;
          font-weight: 500;
        }

        .task-list {
          display: flex;
          flex-direction: column;
          gap: 8px;
        }

        .task-item {
          display: flex;
          justify-content: space-between;
          padding: 8px;
          background: #f8f9fa;
          border-radius: 4px;
          font-size: 12px;
        }

        .task-name {
          color: #333;
          font-weight: 500;
        }

        .task-due-date {
          color: #666;
        }

        .student-row:hover {
          background: #f8f9fa;
        }

        .search-container {
          position: relative;
          width: 100%;
        }

        .search-status {
          position: absolute;
          right: 10px;
          top: 50%;
          transform: translateY(-50%);
          padding: 4px 8px;
          border-radius: 4px;
          font-size: 12px;
          font-weight: 500;
        }

        .search-status.success {
          background-color: #4CAF50;
          color: white;
        }

        .search-status.failed {
          background-color: #F44336;
          color: white;
        }

        .search-status.error {
          background-color: #FF9800;
          color: white;
        }

        .search-input {
          padding-right: 80px;
        }
      </style>
    </template>
  }
}