 import {
  contains,
  containsMany,
  field,
  CardDef,
  Component,
  FieldDef
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import DateTimeField from 'https://cardstack.com/base/datetime';
import MarkdownField from 'https://cardstack.com/base/markdown';
import NumberField from 'https://cardstack.com/base/number';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

// Custom Fields
class ActivityField extends FieldDef {
  static displayName = 'Activity';
  @field type = contains(StringField);
  @field title = contains(StringField);
  @field subject = contains(StringField);
  @field completion = contains(StringField);
  @field performance = contains(NumberField);

  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='activity-item'>
        <div class='activity-header'>
          <div class='activity-type'>{{@model.type}}</div>
          <div class='activity-subject'>{{@model.subject}}</div>
        </div>
        <div class='activity-title'>{{@model.title}}</div>
        <div class='activity-metrics'>
          <div class='completion'>{{@model.completion}}</div>
          {{#if @model.performance}}
            <div class='performance'>{{@model.performance}}%</div>
          {{/if}}
        </div>
      </div>
      <style scoped>
        .activity-item {
          padding: var(--boxel-sp-xs);
          display: grid;
          gap: var(--boxel-sp-xxxs);
        }
        .activity-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          font-size: var(--boxel-font-size-sm);
        }
        .activity-type {
          color: var(--boxel-purple-600);
          font-weight: 500;
        }
        .activity-subject {
          color: var(--boxel-blue-600);
        }
        .activity-title {
          font-weight: 600;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
        .activity-metrics {
          display: flex;
          justify-content: space-between;
          font-size: var(--boxel-font-size-sm);
        }
        .performance {
          color: var(--boxel-green-600);
          font-weight: 500;
        }
      </style>
    </template>
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='activity-badge'>
        <div class='activity-icon'>
          {{#if (eq @model.type "Homework")}}📚{{/if}}
          {{#if (eq @model.type "Quiz")}}📝{{/if}}
          {{#if (eq @model.type "Sport")}}⚽{{/if}}
        </div>
        <div class='activity-info'>
          <div class='activity-title'>{{@model.title}}</div>
          <div class='activity-subject'>{{@model.subject}}</div>
        </div>
      </div>
      <style scoped>
        .activity-badge {
          display: flex;
          gap: var(--boxel-sp-xs);
          align-items: center;
          padding: var(--boxel-sp-xxs);
        }
        .activity-icon {
          font-size: 1.2em;
        }
        .activity-info {
          display: grid;
          gap: var(--boxel-sp-4xs);
        }
        .activity-title {
          font-weight: 500;
        }
        .activity-subject {
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-blue-600);
        }
      </style>
    </template>
  }
}

export class WeeklyStudentReport extends CardDef {
  static displayName = 'Weekly Student Report';
  
  @field studentName = contains(StringField);
  @field weekEnding = contains(DateTimeField);
  @field activities = containsMany(ActivityField);
  @field behaviorNotes = contains(MarkdownField);
  @field teacherFeedback = contains(MarkdownField);
  @field parentComments = contains(MarkdownField);
  @field overallProgress = contains(StringField);

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <article class='weekly-report'>
        <header class='report-header'>
          <div class='student-info'>
            <h1><@fields.studentName /></h1>
            <time class='week-ending'>Week Ending: <@fields.weekEnding /></time>
          </div>
          <div class='overall-progress'>
            <@fields.overallProgress />
          </div>
        </header>

        <div class='report-content'>
          <section class='activities-section'>
            <h2>Activities</h2>
            <div class='activities-grid'>
              {{#each @fields.activities as |ActivityComponent|}}
                <ActivityComponent />
              {{/each}}
            </div>
          </section>

          <section class='feedback-section'>
            <div class='feedback-item'>
              <h3>Behavior Notes</h3>
              <@fields.behaviorNotes />
            </div>
            
            <div class='feedback-item'>
              <h3>Teacher Feedback</h3>
              <@fields.teacherFeedback />
            </div>

            <div class='feedback-item'>
              <h3>Parent Comments</h3>
              <@fields.parentComments />
            </div>
          </section>
        </div>
      </article>

      <style scoped>
        .weekly-report {
          max-width: 1200px;
          margin: 0 auto;
          padding: var(--boxel-sp-lg);
          background-color: var(--boxel-light);
        }

        .report-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: var(--boxel-sp-lg);
          padding-bottom: var(--boxel-sp);
          border-bottom: 1px solid var(--boxel-border);
        }

        h1 {
          font-size: var(--boxel-font-size-xl);
          margin: 0;
        }

        .week-ending {
          color: var(--boxel-purple-600);
          font-size: var(--boxel-font-size-sm);
        }

        .overall-progress {
          padding: var(--boxel-sp-xs) var(--boxel-sp-sm);
          background-color: var(--boxel-highlight-background);
          border-radius: var(--boxel-border-radius);
          font-weight: 500;
        }

        .report-content {
          display: grid;
          grid-template-columns: 3fr 2fr;
          gap: var(--boxel-sp-lg);
        }

        h2 {
          font-size: var(--boxel-font-size-lg);
          margin: 0 0 var(--boxel-sp);
        }

        h3 {
          font-size: var(--boxel-font-size);
          margin: 0 0 var(--boxel-sp-xs);
        }

        .activities-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
          gap: var(--boxel-sp);
        }

        .feedback-section {
          display: grid;
          gap: var(--boxel-sp-lg);
        }

        .feedback-item {
          padding: var(--boxel-sp);
          background-color: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
          border: 1px solid var(--boxel-border);
        }

        @container (max-width: 768px) {
          .report-content {
            grid-template-columns: 1fr;
          }
        }
      </style>
    </template>
  }
}