import { 
  FieldDef, 
  field, 
  contains, 
  linksTo,
  Component 
} from 'https://cardstack.com/base/card-api';
import TextAreaField from 'https://cardstack.com/base/text-area';
import NumberField from 'https://cardstack.com/base/number';
import StringField from 'https://cardstack.com/base/string';
import DateField from 'https://cardstack.com/base/date';
import { DomainArea } from './domain-area';
import { TimePeriod } from './time-period';
import TargetIcon from '@cardstack/boxel-icons/target';
import { fn } from '@ember/helper';
import { and, or } from '@ember/helper';

export class EducationalGoalField extends FieldDef {
  static displayName = "Educational Goal Field";
  static icon = TargetIcon;

  @field domainArea = linksTo(() => DomainArea);
  @field goalSummary = contains(TextAreaField);
  @field rating = contains(NumberField);
  @field ratingDescription = contains(StringField, {
    computeVia: function (this: EducationalGoalField) {
      switch (this.rating) {
        case 1:
          return 'Not Applicable';
        case 2:
          return 'Emerging Skill';
        case 3:
          return 'Progress Made with Moderate Support';
        case 4:
          return 'Progress Made with Minimal Support';
        case 5:
          return 'Mastery of Skill';
        default:
          return '';
      }
    }
  });

  @field period = contains(TimePeriod);
  @field customStartDate = contains(DateField);
  @field customEndDate = contains(DateField);
  
  @field startDate = contains(DateField, {
    computeVia: function(this: EducationalGoalField) {
      // Custom date takes precedence if set
      if (this.customStartDate) {
        return this.customStartDate;
      }
      // Otherwise use period start date if available
      return this.period?.startDate;
    }
  });

  @field endDate = contains(DateField, {
    computeVia: function(this: EducationalGoalField) {
      // Custom date takes precedence if set
      if (this.customEndDate) {
        return this.customEndDate;
      }
      // Otherwise use period end date if available
      return this.period?.endDate;
    }
  });


static embedded = class Embedded extends Component<typeof this> {
  <template>
    <article class='goal {{this.ratingClass}}'>
      <div class='rating-line'></div>
      
      <div class='content'>
        <div class='summary'>{{@model.goalSummary}}</div>
        
        {{#if @model.rating}}
          <div class='meta'>
            <span class='rating'>
              {{@model.rating}}
            </span>
            <span class='rating-description'>{{@model.ratingDescription}}</span>
          </div>
        {{/if}}

        <div class='dates'>
          <div class='date-line'>
            {{#if @model.period}}
              <span class='period-pill'><@fields.period /></span>
            {{/if}}
            {{#if @model.startDate}}
              <span class='date-range'>
                {{this.formattedDateRange}}
              </span>
            {{/if}}
          </div>
        </div>
      </div>
    </article>

    <style scoped>
      .goal {
        position: relative;
        font-family: var(--boxel-font-family);
        color: var(--boxel-dark);
        padding: 0.75rem 0.75rem 0.75rem 1rem;
        border-radius: 0.375rem;
        background: var(--boxel-light);
        display: flex;
        gap: 0.5rem;
        min-height: 3.5rem;
        margin-top: 2px;
        margin-bottom: 0.50rem;
        background-color: rgba(0, 0, 0, 0.02);
      }

      .goal:first-child {
        margin-top: 0;
      }

      .rating-line {
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 0.375rem;
        border-top-left-radius: 0.5rem;
        border-bottom-left-radius: 0.5rem;
      }

      /* Rating color classes */
      .rating-1 .rating-line { background-color: #9E9E9E; }
      .rating-2 .rating-line { background-color: #FFB74D; }
      .rating-3 .rating-line { background-color: #81C784; }
      .rating-4 .rating-line { background-color: #2196F3; }
      .rating-5 .rating-line { background-color: #4527A0; }

      .content {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 0.375rem;
      }

      .summary {
        font-size: 14px;
        line-height: 1.4;
        color: var(--boxel-dark);
        font-weight: 500;
        margin-bottom: 0.125rem;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 4;
        overflow: hidden;
      }

      /* First line */
      .summary::first-line {
        font-size: 14px;
        line-height: 1.4;
        font-weight: 500;
      }

      /* Subsequent lines */
      .summary {
        font-size: 11px;
        font-weight: 400;
      }

      .meta {
        display: flex;
        align-items: center;
        gap: 0.25rem;
      }

      .rating {
        font-weight: 600;
        padding: 0.1875rem 0.25rem;
        border-radius: 0.25rem;
        font-size: 11px;
        line-height: 1;
        color: white;
        min-width: 1.25rem;
        text-align: center;
      }

      .rating-description {
        font-size: 10px;
        opacity: 0.85;
      }

      /* Rating colors */
      .rating-1 .rating { 
        background-color: #757575;
      }
      .rating-2 .rating { 
        background-color: #F57C00;
      }
      .rating-3 .rating { 
        background-color: #388E3C;
      }
      .rating-4 .rating { 
        background-color: #1976D2;
      }
      .rating-5 .rating { 
        background-color: #4527A0;
      }

      /* Description colors */
      .rating-1 .rating-description { color: #757575; }
      .rating-2 .rating-description { color: #F57C00; }
      .rating-3 .rating-description { color: #388E3C; }
      .rating-4 .rating-description { color: #1976D2; }
      .rating-5 .rating-description { color: #4527A0; }

      /* Remove tooltip styles */
      .rating[data-tooltip],
      .rating[data-tooltip]::after,
      .rating:hover[data-tooltip]::after {
        display: none;
      }

      .dates {
        margin-top: 0.25rem;
      }

      .date-line {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.5rem;
      }

      .period-pill {
        display: inline-flex;
        font-size: 13px;
        flex-shrink: 0;
      }

      .date-range {
        color: var(--boxel-dark-purple);
        opacity: 0.7;
        font-size: 13px;
        text-align: right;
        margin-left: auto;
      }
    </style>
  </template>

  get ratingClass() {
    return `rating-${this.args.model.rating}`;
  }

  get formattedDateRange() {
    const startDate = this.args.model.startDate;
    const endDate = this.args.model.endDate;
    
    if (!startDate || !endDate) return '';

    const formatDate = (date: Date) => {
      return date.toLocaleDateString('en-US', {
        month: 'numeric',
        day: 'numeric'
      });
    };

    return `${formatDate(startDate)} - ${formatDate(endDate)}`;
  }
};


  /*


  static atom = class Atom extends Component<typeof this> {
    <template></template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template></template>
  }

  static fitted = class Fitted extends Component<typeof this> {
    <template></template>
  }
  */
}