import { contains, containsMany, field, CardDef, Component } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import NumberField from 'https://cardstack.com/base/number';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn, get } from '@ember/helper';
import { on } from '@ember/modifier';

export class CourseSchdule extends CardDef{
  static displayName = "Course Schedule";

  @field courseName = contains(StringField);
  @field courseCode = contains(StringField);
  @field instructor = contains(StringField);
  @field room = contains(StringField);
  
  // We'll store the schedule as daily entries
  @field mondayTime = contains(StringField);
  @field tuesdayTime = contains(StringField);
  @field wednesdayTime = contains(StringField);
  @field thursdayTime = contains(StringField);
  @field fridayTime = contains(StringField);

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class='schedule-container'>
        <div class='schedule-header'>
          <h1>{{this.args.model.courseName}}</h1>
          <div class='course-details'>
            <p>Course Code: {{this.args.model.courseCode}}</p>
            <p>Instructor: {{this.args.model.instructor}}</p>
            <p>Room: {{this.args.model.room}}</p>
          </div>
        </div>
        
        <div class='schedule-grid'>
          <div class='day-column'>
            <div class='day-header'>Monday</div>
            <div class='time-slot'>{{this.args.model.mondayTime}}</div>
          </div>
          <div class='day-column'>
            <div class='day-header'>Tuesday</div>
            <div class='time-slot'>{{this.args.model.tuesdayTime}}</div>
          </div>
          <div class='day-column'>
            <div class='day-header'>Wednesday</div>
            <div class='time-slot'>{{this.args.model.wednesdayTime}}</div>
          </div>
          <div class='day-column'>
            <div class='day-header'>Thursday</div>
            <div class='time-slot'>{{this.args.model.thursdayTime}}</div>
          </div>
          <div class='day-column'>
            <div class='day-header'>Friday</div>
            <div class='time-slot'>{{this.args.model.fridayTime}}</div>
          </div>
        </div>
      </div>
      <style scoped>
        .schedule-container {
          padding: 20px;
          max-width: 1000px;
          margin: 0 auto;
        }
        
        .schedule-header {
          text-align: center;
          margin-bottom: 30px;
        }
        
        .schedule-header h1 {
          color: #2c3e50;
          font-size: 2em;
          margin-bottom: 10px;
        }
        
        .course-details {
          color: #34495e;
          font-size: 1.1em;
        }
        
        .schedule-grid {
          display: grid;
          grid-template-columns: repeat(5, 1fr);
          gap: 10px;
          background-color: #f8f9fa;
          border-radius: 8px;
          padding: 15px;
        }
        
        .day-column {
          background: white;
          border-radius: 6px;
          padding: 10px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .day-header {
          font-weight: bold;
          color: #2c3e50;
          padding: 8px;
          text-align: center;
          background: #e9ecef;
          border-radius: 4px;
          margin-bottom: 10px;
        }
        
        .time-slot {
          padding: 10px;
          text-align: center;
          color: #495057;
        }
      </style>
    </template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='schedule-edit'>
        <div class='basic-info'>
          <div class='field-group'>
            <label>Course Name</label>
            <@fields.courseName />
          </div>
          <div class='field-group'>
            <label>Course Code</label>
            <@fields.courseCode />
          </div>
          <div class='field-group'>
            <label>Instructor</label>
            <@fields.instructor />
          </div>
          <div class='field-group'>
            <label>Room</label>
            <@fields.room />
          </div>
        </div>
        
        <div class='schedule-times'>
          <h3>Weekly Schedule</h3>
          <div class='time-inputs'>
            <div class='day-input'>
              <label>Monday</label>
              <@fields.mondayTime />
            </div>
            <div class='day-input'>
              <label>Tuesday</label>
              <@fields.tuesdayTime />
            </div>
            <div class='day-input'>
              <label>Wednesday</label>
              <@fields.wednesdayTime />
            </div>
            <div class='day-input'>
              <label>Thursday</label>
              <@fields.thursdayTime />
            </div>
            <div class='day-input'>
              <label>Friday</label>
              <@fields.fridayTime />
            </div>
          </div>
        </div>
      </div>
      <style scoped>
        .schedule-edit {
          padding: 20px;
          max-width: 800px;
          margin: 0 auto;
        }
        
        .basic-info {
          margin-bottom: 30px;
        }
        
        .field-group {
          margin-bottom: 15px;
        }
        
        .field-group label {
          display: block;
          margin-bottom: 5px;
          color: #495057;
          font-weight: bold;
        }
        
        .schedule-times h3 {
          color: #2c3e50;
          margin-bottom: 20px;
        }
        
        .time-inputs {
          display: grid;
          gap: 15px;
        }
        
        .day-input {
          margin-bottom: 15px;
        }
        
        .day-input label {
          display: block;
          margin-bottom: 5px;
          color: #495057;
          font-weight: bold;
        }
      </style>
    </template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='embedded-schedule'>
        <h3>{{this.args.model.courseName}} ({{this.args.model.courseCode}})</h3>
        <p class='schedule-info'>Instructor: {{this.args.model.instructor}}</p>
        <p class='schedule-info'>Room: {{this.args.model.room}}</p>
      </div>
      <style scoped>
        .embedded-schedule {
          padding: 10px;
          border: 1px solid #dee2e6;
          border-radius: 4px;
        }
        
        .embedded-schedule h3 {
          margin: 0 0 10px 0;
          color: #2c3e50;
        }
        
        .schedule-info {
          margin: 5px 0;
          color: #495057;
        }
      </style>
    </template>
  }
}