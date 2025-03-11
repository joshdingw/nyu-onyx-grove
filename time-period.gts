import {
  FieldDef,
  Component,
  field,
  contains,
} from 'https://cardstack.com/base/card-api';
import DateField from 'https://cardstack.com/base/date';
import StringField from 'https://cardstack.com/base/string';
import CalendarRange from '@cardstack/boxel-icons/calendar-range';

export class TimePeriod extends FieldDef {
  static displayName = "Time Period Field";
  static icon = CalendarRange;

  @field periodLabel = contains(StringField);
  
  @field periodType = contains(StringField, {
    computeVia: function(this: TimePeriod) {
      if (!this.periodLabel) return undefined;
      
      // Calendar Year: "2024"
      if (/^\d{4}$/.test(this.periodLabel)) {
        return 'Calendar Year';
      }
      
      // Academic Year: "2023-2024" or "2023-24"
      if (/^\d{4}-(\d{4}|\d{2})$/.test(this.periodLabel)) {
        return 'Academic Year';
      }
      
      // Week: "Week 12 2025" or "2025 Wk12" or "Wk12 2025"
      if (/^(Week ([1-9]|[1-4][0-9]|5[0-3]) \d{4}|\d{4} Wk([1-9]|[1-4][0-9]|5[0-3])|Wk([1-9]|[1-4][0-9]|5[0-3]) \d{4})$/.test(this.periodLabel)) {
        return 'Week';
      }
      
      // Quarter: "Q1 2024" or "2024 Q1"
      if (/^(Q[1-4] \d{4}|\d{4} Q[1-4])$/.test(this.periodLabel)) {
        return 'Quarter';
      }
      
      // Session: "Fall 2024", "Spring 2024", "Summer 2024"
      if (/^(Fall|Spring|Summer) \d{4}$/.test(this.periodLabel)) {
        return 'Session';
      }
      
      // Session Week: "Wk4 Spring 2025"
      if (/^Wk([1-9]|[1-4][0-9]|5[0-3]) (Fall|Spring|Summer) \d{4}$/.test(this.periodLabel)) {
        return 'Session Week';
      }
      
      // Month: Support various formats
      const months = {
        full: ['January', 'February', 'March', 'April', 'May', 'June', 
               'July', 'August', 'September', 'October', 'November', 'December'],
        short: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
               'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        variants: {
          'September': ['Sept', 'Sep.'],
          'October': ['Octo', 'Oct.'],
          'August': ['Aug.'],
          'December': ['Dec.'],
          'November': ['Nov.'],
          'January': ['Jan.'],
          'February': ['Feb.'],
          'March': ['Mar.'],
          'April': ['Apr.'],
          'July': ['Jul.'],
          'June': ['Jun.']
        }
      };

      // Build regex pattern including all variants
      const allMonthFormats = [
        ...months.full,
        ...months.short,
        ...Object.values(months.variants).flat()
      ];
      const monthPattern = new RegExp(
        `^(${allMonthFormats.join('|')}) \\d{4}$`
      );
      if (monthPattern.test(this.periodLabel)) {
        return 'Month';
      }
      
      return undefined;
    }
  });

  @field startDate = contains(DateField, {
    computeVia: function(this: TimePeriod) {
      return this.computeDateRange()?.start;
    }
  });

  @field endDate = contains(DateField, {
    computeVia: function(this: TimePeriod) {
      return this.computeDateRange()?.end;
    }
  });

  private computeDateRange(): { start: Date, end: Date } | undefined {
    if (!this.periodLabel) return undefined;

    const type = this.periodType;
    if (!type) return undefined;

    switch (type) {
      case 'Calendar Year': {
        const year = parseInt(this.periodLabel);
        return {
          start: new Date(year, 0, 1), // January 1st
          end: new Date(year, 11, 31), // December 31st
        };
      }

      case 'Academic Year': {
        const [startYearStr, endYearStr] = this.periodLabel.split('-');
        const startYear = parseInt(startYearStr);
        // Handle both 4-digit and 2-digit end year
        const endYear = endYearStr.length === 2 
          ? parseInt('20' + endYearStr)  // Assume 20xx for 2-digit years
          : parseInt(endYearStr);
        
        return {
          start: new Date(startYear, 6, 1),  // July 1st
          end: new Date(endYear, 5, 30), // June 30th next year
        };
      }

      case 'Week': {
        // Try all week formats
        let match = this.periodLabel.match(/Week (\d+) (\d{4})/);
        if (!match) {
          match = this.periodLabel.match(/(\d{4}) Wk(\d+)/);
          if (!match) {
            match = this.periodLabel.match(/Wk(\d+) (\d{4})/);
            if (!match) return undefined;
          } else {
            // Swap year and week positions for consistent processing
            [match[0], match[2], match[1]] = [match[0], match[1], match[2]];
          }
        }
        
        const weekNum = parseInt(match[1]);
        const year = parseInt(match[2]);

        // Create date for January 1st of the year
        const firstDay = new Date(year, 0, 1);
        
        // Get to first Monday of the year
        let dayOffset = 1 - firstDay.getDay(); // 1 = Monday
        if (dayOffset > 1) dayOffset -= 7; // Ensure we don't skip a week
        
        // Add weeks and days to get to target week
        const startDate = new Date(year, 0, 1 + dayOffset + (weekNum - 1) * 7);
        const endDate = new Date(startDate);
        endDate.setDate(startDate.getDate() + 6); // Add 6 days for end of week
        
        return {
          start: startDate,
          end: endDate
        };
      }

      case 'Quarter': {
        let match = this.periodLabel.match(/Q(\d) (\d{4})/);
        if (!match) {
          // Try alternate format "2024 Q1"
          match = this.periodLabel.match(/(\d{4}) Q(\d)/);
          if (!match) return undefined;
          // Swap year and quarter positions for consistent processing
          [match[0], match[2], match[1]] = [match[0], match[1], match[2]];
        }
        const quarter = parseInt(match[1]);
        const year = parseInt(match[2]);
        const startMonth = (quarter - 1) * 3;
        return {
          start: new Date(year, startMonth, 1),
          end: new Date(year, startMonth + 3, 0), // 0th day of next month = last day of current
        };
      }

      case 'Session': {
        const [session, year] = this.periodLabel.split(' ');
        const numYear = parseInt(year);
        switch (session.toLowerCase()) {
          case 'fall':
            return {
              start: new Date(numYear, 8, 1), // Sep 1
              end: new Date(numYear, 11, 31), // Dec 31
            };
          case 'spring':
            return {
              start: new Date(numYear, 0, 1), // Jan 1
              end: new Date(numYear, 5, 30), // June 30
            };
          case 'summer':
            return {
              start: new Date(numYear, 6, 1), // July 1
              end: new Date(numYear, 7, 31), // Aug 31
            };
        }
        return undefined;
      }

      case 'Session Week': {
        const match = this.periodLabel.match(/^Wk(\d+) (Fall|Spring|Summer) (\d{4})$/);
        if (!match) return undefined;

        const weekNum = parseInt(match[1]);
        const session = match[2];
        const year = parseInt(match[3]);

        // Get session start and end dates
        let sessionStart: Date, sessionEnd: Date;
        switch (session.toLowerCase()) {
          case 'fall':
            sessionStart = new Date(year, 8, 1); // Sep 1
            sessionEnd = new Date(year, 11, 31); // Dec 31
            break;
          case 'spring':
            sessionStart = new Date(year, 0, 1); // Jan 1
            sessionEnd = new Date(year, 5, 30); // June 30
            break;
          case 'summer':
            sessionStart = new Date(year, 6, 1); // July 1
            sessionEnd = new Date(year, 7, 31); // Aug 31
            break;
          default:
            return undefined;
        }

        // Find the first Monday that falls within the session
        let firstMonday = new Date(sessionStart);
        while (firstMonday.getDay() !== 1 || firstMonday < sessionStart) {
          firstMonday.setDate(firstMonday.getDate() + 1);
        }
        
        // Calculate the target week's dates
        const startDate = new Date(firstMonday);
        startDate.setDate(firstMonday.getDate() + (weekNum - 1) * 7);
        const endDate = new Date(startDate);
        endDate.setDate(startDate.getDate() + 6);

        // Ensure the week falls within the session
        if (startDate > sessionEnd || endDate < sessionStart) {
          return undefined;
        }

        return {
          start: startDate,
          end: endDate
        };
      }

      case 'Month': {
        const [monthStr, yearStr] = this.periodLabel.split(' ');
        const numYear = parseInt(yearStr);
        
        // Map of all month formats to their index
        const monthMap = {
          'Jan': 0, 'Jan.': 0, 'January': 0,
          'Feb': 1, 'Feb.': 1, 'February': 1,
          'Mar': 2, 'Mar.': 2, 'March': 2,
          'Apr': 3, 'Apr.': 3, 'April': 3,
          'May': 4,
          'Jun': 5, 'Jun.': 5, 'June': 5,
          'Jul': 6, 'Jul.': 6, 'July': 6,
          'Aug': 7, 'Aug.': 7, 'August': 7,
          'Sep': 8, 'Sep.': 8, 'Sept': 8, 'September': 8,
          'Oct': 9, 'Oct.': 9, 'Octo': 9, 'October': 9,
          'Nov': 10, 'Nov.': 10, 'November': 10,
          'Dec': 11, 'Dec.': 11, 'December': 11
        };
        
        const monthIndex = monthMap[monthStr as keyof typeof monthMap];
        if (monthIndex === undefined) return undefined;

        return {
          start: new Date(numYear, monthIndex, 1),
          end: new Date(numYear, monthIndex + 1, 0), // Last day of month
        };
      }

      default:
        return undefined;
    }
  }

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='time-period'>
        <CalendarRange class='icon' />
        <span class='period-text'>
          {{@model.periodLabel}}
        </span>
      </div>
      <style scoped>
        .time-period {
          display: inline-flex;
          align-items: center;
          gap: var(--boxel-sp-xs);
          font: var(--boxel-font);
          color: var(--boxel-dark);
          padding: var(--boxel-sp-xxxs) var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius);
          background-color: var(--boxel-light);
          border: 1px solid rgba(0, 0, 0, 0.1);
        }

        .icon {
          width: 16px;
          height: 16px;
          color: var(--boxel-purple-400);
          flex-shrink: 0;
        }

        .period-text {
          font-size: var(--boxel-font-size-sm);
          letter-spacing: var(--boxel-lsp-sm);
        }
      </style>
    </template>

    get formattedPeriod() {
      const model = this.args.model;
      
      // Handle special cases first
      switch (model.periodType) {
        case 'Calendar Year':
          return model.periodLabel;
        case 'Academic Year':
          return `Academic Year ${model.periodLabel}`;
        case 'Quarter':
          return model.periodLabel;
        case 'Week':
          return model.periodLabel;
      }

      // Format dates for other period types
      const startDate = model.startDate;
      const endDate = model.endDate;
      
      if (!startDate || !endDate) return '';

      const formatDate = (date: Date) => {
        return date.toLocaleDateString('en-US', {
          month: 'short',
          day: 'numeric',
          year: startDate.getFullYear() !== endDate.getFullYear() ? 'numeric' : undefined
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