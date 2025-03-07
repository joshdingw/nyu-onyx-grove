import { 
  CardDef, 
  Component,
  field,
  contains,
  containsMany 
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';

class WeeklyPlan extends CardDef {
  @field weekNumber = contains(StringField);
  @field topic = contains(StringField);
  @field objectives = containsMany(StringField);
  @field activities = containsMany(StringField);
}

export class LearningObjectives extends CardDef {
  static displayName = "Learning Objectives";

  @field courseName = contains(StringField);
  @field semester = contains(StringField);
  @field academicYear = contains(StringField);
  @field courseDescription = contains(StringField);
  
  @field courseObjectives = containsMany(StringField);
  @field weeklyPlans = containsMany(WeeklyPlan);

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <style scoped>
        .learning-objectives {
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
        }
        .header {
          margin-bottom: 30px;
        }
        .course-title {
          font-size: 24px;
          font-weight: bold;
          color: #2c3e50;
          margin-bottom: 10px;
        }
        .semester-info {
          color: #7f8c8d;
          font-size: 16px;
          margin-bottom: 20px;
        }
        .description {
          background: #f8f9fa;
          padding: 15px;
          border-radius: 8px;
          margin-bottom: 30px;
        }
        .section-title {
          font-size: 20px;
          color: #34495e;
          margin-bottom: 15px;
          border-bottom: 2px solid #3498db;
          padding-bottom: 5px;
        }
        .weekly-plan {
          background: white;
          border: 1px solid #e1e1e1;
          border-radius: 8px;
          padding: 15px;
          margin-bottom: 15px;
        }
        .week-header {
          font-weight: bold;
          color: #2980b9;
          margin-bottom: 10px;
        }
        .objectives-list {
          list-style-type: disc;
          padding-left: 20px;
        }
        .activities-list {
          list-style-type: circle;
          padding-left: 20px;
          color: #666;
        }
      </style>

      <div class='learning-objectives'>
        <div class='header'>
          <div class='course-title'>{{@model.courseName}}</div>
          <div class='semester-info'>
            {{@model.semester}} - {{@model.academicYear}}
          </div>
        </div>

        <div class='description'>
          {{@model.courseDescription}}
        </div>

        <div class='objectives-section'>
          <h2 class='section-title'>Course Objectives</h2>
          <ul class='objectives-list'>
            {{#each @model.courseObjectives as |objective|}}
              <li>{{objective}}</li>
            {{/each}}
          </ul>
        </div>

        <div class='weekly-plans'>
          <h2 class='section-title'>Weekly Learning Plans</h2>
          {{#each @model.weeklyPlans as |week|}}
            <div class='weekly-plan'>
              <div class='week-header'>Week {{week.weekNumber}}: {{week.topic}}</div>
              
              <h4>Objectives:</h4>
              <ul class='objectives-list'>
                {{#each week.objectives as |objective|}}
                  <li>{{objective}}</li>
                {{/each}}
              </ul>

              <h4>Activities:</h4>
              <ul class='activities-list'>
                {{#each week.activities as |activity|}}
                  <li>{{activity}}</li>
                {{/each}}
              </ul>
            </div>
          {{/each}}
        </div>
      </div>
    </template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <style scoped>
        .edit-form {
          max-width: 800px;
          margin: 0 auto;
          padding: 20px;
        }
        .form-section {
          margin-bottom: 20px;
        }
        .section-label {
          font-weight: bold;
          margin-bottom: 10px;
          color: #2c3e50;
        }
      </style>

      <div class='edit-form'>
        <div class='form-section'>
          <div class='section-label'>Course Name</div>
          <@fields.courseName />
        </div>

        <div class='form-section'>
          <div class='section-label'>Semester</div>
          <@fields.semester />
        </div>

        <div class='form-section'>
          <div class='section-label'>Academic Year</div>
          <@fields.academicYear />
        </div>

        <div class='form-section'>
          <div class='section-label'>Course Description</div>
          <@fields.courseDescription />
        </div>

        <div class='form-section'>
          <div class='section-label'>Course Objectives</div>
          <@fields.courseObjectives />
        </div>

        <div class='form-section'>
          <div class='section-label'>Weekly Plans</div>
          <@fields.weeklyPlans />
        </div>
      </div>
    </template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <style scoped>
        .embedded-view {
          padding: 15px;
        }
        .course-header {
          font-size: 18px;
          font-weight: bold;
          margin-bottom: 10px;
        }
        .semester-info {
          color: #666;
          font-size: 14px;
        }
      </style>

      <div class='embedded-view'>
        <div class='course-header'>{{@model.courseName}}</div>
        <div class='semester-info'>{{@model.semester}} - {{@model.academicYear}}</div>
      </div>
    </template>
  }
}
