import { TimePeriod as TimePeriodField } from "./time-period";
import { CardDef, field, contains, StringField, Component, containsMany, linksTo, linksToMany } from 'https://cardstack.com/base/card-api';
import CalendarIcon from '@cardstack/boxel-icons/calendar';
import CategoryIcon from '@cardstack/boxel-icons/tag';
import EventIcon from '@cardstack/boxel-icons/calendar-event';
import DatetimeField from 'https://cardstack.com/base/datetime';
import BooleanField from 'https://cardstack.com/base/boolean';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

const eq = (a, b) => {
    if (Array.isArray(a) && Array.isArray(b)) {
        return a.length === b.length && a.every((item, index) => eq(item, b[index]));
    }
    if (typeof a === 'object' && a !== null && typeof b === 'object' && b !== null) {
        const keysA = Object.keys(a);
        const keysB = Object.keys(b);
        return keysA.length === keysB.length && keysA.every(key => eq(a[key], b[key]));
    }
    return a === b;
};

// School Calendar Category Card
export class SchoolCalendarCategory extends CardDef {
  static displayName = "Calendar Category";
  static icon = CategoryIcon;
  
  @field name = contains(StringField);
  @field color = contains(StringField, {
    computeVia: function(this: SchoolCalendarCategory) {
      // Default colors based on common category names
      const colorMap: Record<string, string> = {
        'Holiday': '#e53935',
        'No School': '#e53935',
        'Early Dismissal': '#f39c12',
        'Special Event': '#8e44ad',
        'Teacher Day': '#27ae60',
        'Exam': '#2980b9',
        'Field Trip': '#16a085',
        'Parent Event': '#d35400',
        'Family Event': '#8e44ad'
      };
      
      return this.name && colorMap[this.name] ? colorMap[this.name] : '#3498db';
    }
  });
}

// School Calendar Event Field
export class SchoolCalendarEvent extends CardDef {
  static displayName = "Calendar Event";
  static icon = EventIcon;
  
  @field date = contains(DatetimeField);
  @field name = contains(StringField);
  @field category = linksTo(() => SchoolCalendarCategory);
  @field isNoSchool = contains(BooleanField);
  @field isEarlyDismissal = contains(BooleanField);
  @field isSchoolClosed = contains(BooleanField);
  
  get eventDate() {
    return this.date ? new Date(this.date) : null;
  }
  
  get dayOfMonth() {
    return this.eventDate ? this.eventDate.getDate() : null;
  }
  
  get month() {
    return this.eventDate ? this.eventDate.getMonth() : null;
  }
  
  get year() {
    return this.eventDate ? this.eventDate.getFullYear() : null;
  }
  
  get cssClass() {
    if (this.isNoSchool || this.isSchoolClosed) return 'holiday';
    if (this.isEarlyDismissal) return 'early-dismissal';
    if (this.category?.name === 'Exam') return 'exam-day';
    if (this.category?.name === 'Teacher Day') return 'teacher-day';
    return 'special-event';
  }
}

export class SchoolCalendar extends CardDef {
  @field academicYear = contains(TimePeriodField);
  @field schoolName = contains(StringField);
  @field events = linksToMany(() => SchoolCalendarEvent);
  @field categories = linksToMany(() => SchoolCalendarCategory);
  
  // Adding important date fields
  @field firstDayOfSchool = contains(DatetimeField);
  @field lastDayOfSchool = contains(DatetimeField);
  @field winterBreakStart = contains(DatetimeField);
  @field winterBreakEnd = contains(DatetimeField);
  @field springBreakStart = contains(DatetimeField);
  @field springBreakEnd = contains(DatetimeField);
  @field graduationDay = contains(DatetimeField);
  
  // Contact information fields
  @field mainOfficePhone = contains(StringField);
  @field emailDomain = contains(StringField);
  @field websiteDomain = contains(StringField);
  
  static displayName = "School Calendar";
  static icon = CalendarIcon;

  // Helper method to format date
  formatDate(date: Date | null | undefined) {
    if (!date) return '';
    return date.toLocaleDateString('en-US', {
      month: 'long',
      day: 'numeric',
      year: 'numeric'
    });
  }
  
  // Helper method to format date range
  formatDateRange(startDate: Date | null | undefined, endDate: Date | null | undefined) {
    if (!startDate || !endDate) return '';
    
    const start = startDate.toLocaleDateString('en-US', {
      month: 'long',
      day: 'numeric'
    });
    
    const end = endDate.toLocaleDateString('en-US', {
      month: 'long',
      day: 'numeric'
    });
    
    return `${start} - ${end}`;
  }

  static isolated = class Isolated extends Component<typeof this> {
    @tracked selectedMonth = 0;
    @tracked activePopupDay: any = null;
    @tracked isPopupVisible = false;
    
    // Get the current academic year from the model
    get academicYear() {
      return this.args.model.academicYear.periodLabel || '';
    }
    
    // Parse the academic year to get start and end years
    get yearRange() {
      const yearMatch = this.academicYear.match(/(\d{4})[^\d]*(\d{2,4})?/);
      if (!yearMatch) return { startYear: new Date().getFullYear(), endYear: new Date().getFullYear() + 1 };
      
      const startYear = parseInt(yearMatch[1]);
      let endYear = yearMatch[2] ? parseInt(yearMatch[2]) : startYear + 1;
      
      // If end year is provided as 2 digits (e.g., "24" in "2023-24")
      if (endYear < 100) {
        endYear = Math.floor(startYear / 100) * 100 + endYear;
      }
      
      return { startYear, endYear };
    }
    
    // Generate months for the academic year
    get calendarMonths() {
      const { startYear, endYear } = this.yearRange;
      const months = [];
      
      // Typical academic year runs from August/September to May/June
      const startMonth = 8; // September (0-indexed would be 8)
      const endMonth = 5;   // June (0-indexed would be 5)
      
      // Generate months for the academic year
      for (let year = startYear; year <= endYear; year++) {
        const monthStart = year === startYear ? startMonth : 0;
        const monthEnd = year === endYear ? endMonth : 11;
        
        for (let month = monthStart; month <= monthEnd; month++) {
          months.push(this.generateMonth(year, month));
        }
      }
      
      return months;
    }
    
    // Generate a month's calendar data
    generateMonth(year, month) {
      const firstDay = new Date(year, month, 1);
      const lastDay = new Date(year, month + 1, 0);
      const daysInMonth = lastDay.getDate();
      
      // Get day of week for the first day (0 = Sunday, 1 = Monday, etc.)
      const firstDayOfWeek = firstDay.getDay();
      
      const monthName = new Date(year, month).toLocaleString('default', { month: 'long' });
      
      const days = [];
      
      // Add empty cells for days before the first day of the month
      for (let i = 0; i < firstDayOfWeek; i++) {
        days.push({ day: null, classes: 'empty' });
      }
      
      // Add cells for each day of the month
      for (let day = 1; day <= daysInMonth; day++) {
        const date = new Date(year, month, day);
        const dayOfWeek = date.getDay();
        
        const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;
        let classes = isWeekend ? 'day weekend' : 'day';
        
        // Find events for this day
        const eventsForDay = this.args.model.events.filter(event => {
          if (!event.eventDate) return false;
          return event.dayOfMonth === day && event.month === month && event.year === year;
        });
        
        let title = '';
        if (eventsForDay.length > 0) {
          classes += ` ${eventsForDay[0].cssClass}`;
          // Create tooltip content with all events
          title = eventsForDay.map(event => event.name).join('\n');
        }
        
        days.push({ 
          day, 
          classes, 
          title,
          events: eventsForDay 
        });
      }
      
      return {
        name: monthName,
        year: year,
        days
      };
    }
    
    // Helper method to get school domain for email
    get schoolDomain() {
      if (!this.args.model.schoolName) return '';
      return this.args.model.schoolName.toLowerCase().replace(/\s+/g, '');
    }
    
    // Get upcoming events for display
    get upcomingEvents() {
      const today = new Date();
      return this.args.model.events
        .filter(event => event.eventDate && event.eventDate >= today)
        .sort((a, b) => a.eventDate!.getTime() - b.eventDate!.getTime())
        .slice(0, 5); // Get the next 5 events
    }
    
    // Get the formatted important dates
    get formattedFirstDay() {
      return this.args.model.formatDate(this.args.model.firstDayOfSchool);
    }
    
    get formattedLastDay() {
      return this.args.model.formatDate(this.args.model.lastDayOfSchool);
    }
    
    get formattedWinterBreak() {
      return this.args.model.formatDateRange(
        this.args.model.winterBreakStart,
        this.args.model.winterBreakEnd
      );
    }
    
    get formattedSpringBreak() {
      return this.args.model.formatDateRange(
        this.args.model.springBreakStart,
        this.args.model.springBreakEnd
      );
    }
    
    get formattedGraduation() {
      return this.args.model.formatDate(this.args.model.graduationDay);
    }
    
    // Get email and website domains
    get emailAddress() {
      return this.args.model.emailDomain ? 
        `info@${this.args.model.emailDomain}` : 
        `info@${this.schoolDomain}.edu`;
    }
    
    get websiteUrl() {
      return this.args.model.websiteDomain ? 
        `www.${this.args.model.websiteDomain}` : 
        `www.${this.schoolDomain}.edu`;
    }
    
    @action
    showPopup(dayInfo: any, event: MouseEvent) {
      if (dayInfo.events?.length) {
        this.activePopupDay = dayInfo;
        this.isPopupVisible = true;
        
        // Wait for the popup to be rendered
        setTimeout(() => {
          const popup = document.querySelector('.event-popup') as HTMLElement;
          const target = event.currentTarget as HTMLElement;
          
          if (popup && target) {
            const rect = target.getBoundingClientRect();
            
            // Position the popup directly below the day cell
            popup.style.top = `${rect.bottom + window.scrollY + 5}px`;
            popup.style.left = `${rect.left + window.scrollX + (rect.width / 2)}px`;
            popup.style.transform = 'translateX(-50%)';
          }
        }, 10);
      }
    }
    
    @action
    hidePopup() {
      this.isPopupVisible = false;
      this.activePopupDay = null;
    }
    
    @action
    setupDayEventListeners(element: HTMLElement) {
      element.addEventListener('mouseenter', (event) => {
        const dayInfo = element.dataset.dayInfo;
        if (dayInfo) {
          this.showPopup(JSON.parse(dayInfo), event);
        }
      });
      
      element.addEventListener('mouseleave', () => {
        this.hidePopup();
      });
    }
    
    <template>
      <div class="school-calendar">
        <div class="calendar-header">
          <div class="school-logo"></div>
          <div class="header-text">
            <h1>{{@model.schoolName}}</h1>
            <h2>Academic Calendar {{@model.academicYear.periodLabel}}</h2>
          </div>
        </div>
        
        <div class="calendar-grid">
          {{#each this.calendarMonths as |month index|}}
            <div class="month-container">
              <div class="month-header">
                <h3>{{month.name}} {{month.year}}</h3>
              </div>
              <div class="month-grid">
                <div class="weekday-headers">
                  <span>S</span>
                  <span>M</span>
                  <span>T</span>
                  <span>W</span>
                  <span>T</span>
                  <span>F</span>
                  <span>S</span>
                </div>
                <div class="days">
                  {{#each month.days as |dayInfo|}}
                    <div class="{{dayInfo.classes}}" 
                         title="{{dayInfo.title}}"
                         {{on "mouseenter" (fn this.showPopup dayInfo)}}
                         {{on "mouseleave" this.hidePopup}}>
                      {{#if dayInfo.day}}
                        <span class="day-number">{{dayInfo.day}}</span>
                        {{#if dayInfo.events.length}}
                          <span class="day-marker"></span>
                        {{/if}}
                      {{/if}}
                    </div>
                  {{/each}}
                </div>
              </div>
            </div>
          {{/each}}
        </div>
        
        <div class="calendar-footer">
          <div class="calendar-legend">
            <h4>Event Legend</h4>
            <ul>
              <li><span class="legend-color holiday"></span> Holiday/No School</li>
              <li><span class="legend-color special-event"></span> Special Event</li>
              <li><span class="legend-color early-dismissal"></span> Early Dismissal</li>
              <li><span class="legend-color teacher-day"></span> Teacher In-Service</li>
              <li><span class="legend-color exam-day"></span> Exam Days</li>
            </ul>
          </div>
          
          <div class="important-dates">
            <h4>Important Dates</h4>
            <ul>
              <li><strong>First Day of School:</strong> {{this.formattedFirstDay}}</li>
              <li><strong>Last Day of School:</strong> {{this.formattedLastDay}}</li>
              <li><strong>Winter Break:</strong> {{this.formattedWinterBreak}}</li>
              <li><strong>Spring Break:</strong> {{this.formattedSpringBreak}}</li>
              <li><strong>Graduation:</strong> {{this.formattedGraduation}}</li>
            </ul>
          </div>
          
          <div class="contact-info">
            <h4>Contact Information</h4>
            <p>Main Office: {{@model.mainOfficePhone}}</p>
            <p>Email: {{this.emailAddress}}</p>
            <p>Website: {{this.websiteUrl}}</p>
          </div>
        </div>
      </div>
      
      {{#if this.activePopupDay}}
        <div class="event-popup {{if this.isPopupVisible 'visible'}}">
          <div class="event-popup-content">
            {{#each this.activePopupDay.events as |event|}}
              <div class="event-item {{event.cssClass}}">
                <span class="event-name">{{event.name}}</span>
                {{#if event.category}}
                  <span class="event-category">{{event.category.name}}</span>
                {{/if}}
              </div>
            {{/each}}
          </div>
        </div>
      {{/if}}
      
      <style scoped>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Montserrat:wght@300;400;500;600;700&display=swap');
        
        .school-calendar {
          font-family: 'Montserrat', sans-serif;
          max-width: 1100px;
          margin: 0 auto;
          background-color: #ffffff;
          color: #2c3e50;
          box-shadow: 0 15px 40px rgba(0,0,0,0.15);
          border-radius: 0;
          overflow: hidden;
          position: relative;
        }
        
        .calendar-header {
          background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
          color: white;
          padding: 35px 40px;
          display: flex;
          align-items: center;
          gap: 30px;
        }
        
        .school-logo {
          width: 90px;
          height: 90px;
          background-color: rgba(255, 255, 255, 0.9);
          border-radius: 50%;
          position: relative;
          box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .school-logo:before {
          content: '';
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          width: 78px;
          height: 78px;
          background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
          border-radius: 50%;
        }
        
        .header-text {
          flex: 1;
        }
        
        .calendar-header h1 {
          margin: 0;
          font-family: 'Playfair Display', serif;
          font-size: 2.8rem;
          font-weight: 700;
          letter-spacing: -0.5px;
          text-shadow: 1px 2px 3px rgba(0,0,0,0.3);
        }
        
        .calendar-header h2 {
          margin: 8px 0 0;
          font-size: 1.4rem;
          font-weight: 400;
          opacity: 0.9;
          letter-spacing: 0.5px;
        }
        
        .calendar-grid {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 25px;
          padding: 35px;
          background-color: #f5f7fa;
        }
        
        .month-container {
          background-color: white;
          border-radius: 10px;
          overflow: hidden;
          box-shadow: 0 5px 15px rgba(0,0,0,0.05);
          transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .month-container:hover {
          transform: translateY(-5px);
          box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        
        .month-header {
          background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
          color: white;
          padding: 12px;
          text-align: center;
        }
        
        .month-header h3 {
          margin: 0;
          font-family: 'Playfair Display', serif;
          font-size: 1.3rem;
          font-weight: 600;
        }
        
        .month-grid {
          padding: 12px;
        }
        
        .weekday-headers {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          text-align: center;
          font-weight: 600;
          margin-bottom: 8px;
          color: #34495e;
          font-size: 0.85rem;
        }
        
        .days {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          gap: 2px;
        }
        
        .day {
          min-height: 30px;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: flex-start;
          border-radius: 6px;
          font-size: 0.85rem;
          position: relative;
          background-color: #f8f9fa;
          padding: 4px 0;
          transition: transform 0.2s ease;
        }
        
        .day:hover {
          transform: scale(1.05);
          z-index: 2;
        }
        
        .day-number {
          font-weight: 600;
          font-size: 0.8rem;
        }
        
        .day-marker {
          width: 5px;
          height: 5px;
          border-radius: 50%;
          background-color: currentColor;
          margin-top: 2px;
          box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }
        
        .empty {
          background-color: transparent;
        }
        
        .weekend {
          background-color: #f1f3f6;
          color: #7f8c8d;
        }
        
        .day.holiday {
          background-color: #e53935;
          color: white;
          box-shadow: 0 2px 5px rgba(229, 57, 53, 0.3);
        }
        
        .day.special-event {
          background-color: #8e44ad;
          color: white;
          box-shadow: 0 2px 5px rgba(142, 68, 173, 0.3);
        }
        
        .day.early-dismissal {
          background-color: #f39c12;
          color: white;
          box-shadow: 0 2px 5px rgba(243, 156, 18, 0.3);
        }
        
        .day.teacher-day {
          background-color: #27ae60;
          color: white;
          box-shadow: 0 2px 5px rgba(39, 174, 96, 0.3);
        }
        
        .day.exam-day {
          background-color: #2980b9;
          color: white;
          box-shadow: 0 2px 5px rgba(41, 128, 185, 0.3);
        }
        
        .calendar-footer {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 30px;
          padding: 30px 35px 40px;
          background-color: #f5f7fa;
          border-top: 1px solid #e6e9ec;
        }
        
        .calendar-legend h4,
        .important-dates h4,
        .contact-info h4 {
          color: #1e3c72;
          margin-top: 0;
          margin-bottom: 15px;
          font-size: 1.2rem;
          font-family: 'Playfair Display', serif;
          border-bottom: 2px solid #1e3c72;
          padding-bottom: 8px;
          display: inline-block;
        }
        
        .calendar-legend ul,
        .important-dates ul {
          list-style: none;
          padding: 0;
          margin: 0;
        }
        
        .calendar-legend li {
          display: flex;
          align-items: center;
          margin-bottom: 10px;
          font-size: 0.95rem;
        }
        
        .important-dates li {
          margin-bottom: 12px;
          font-size: 0.95rem;
          line-height: 1.5;
        }
        
        .legend-color {
          display: inline-block;
          width: 18px;
          height: 18px;
          margin-right: 10px;
          border-radius: 4px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .holiday { background-color: #e53935; }
        .special-event { background-color: #8e44ad; }
        .early-dismissal { background-color: #f39c12; }
        .teacher-day { background-color: #27ae60; }
        .exam-day { background-color: #2980b9; }
        
        .contact-info p {
          margin: 8px 0;
          font-size: 0.95rem;
          line-height: 1.6;
        }
        
        /* Glossy effect */
        .school-calendar:before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          height: 40%;
          background: linear-gradient(
            to bottom,
            rgba(255,255,255,0.1) 0%,
            rgba(255,255,255,0) 100%
          );
          pointer-events: none;
          z-index: 1;
        }
        
        @media (max-width: 1000px) {
          .calendar-grid {
            grid-template-columns: repeat(2, 1fr);
          }
          
          .calendar-footer {
            grid-template-columns: 1fr;
          }
        }
        
        @media (max-width: 700px) {
          .calendar-grid {
            grid-template-columns: 1fr;
          }
          
          .calendar-header {
            flex-direction: column;
            text-align: center;
            gap: 15px;
          }
        }
        
        .event-popup {
          position: fixed;
          z-index: 9999;
          background: white;
          border-radius: 8px;
          box-shadow: 0 4px 15px rgba(0,0,0,0.2);
          padding: 12px;
          min-width: 200px;
          display: none;
          pointer-events: none;
        }
        
        .event-popup.visible {
          display: block;
        }
        
        .event-popup::before {
          content: '';
          position: absolute;
          top: -8px;
          left: 50%;
          transform: translateX(-50%);
          border-left: 8px solid transparent;
          border-right: 8px solid transparent;
          border-bottom: 8px solid white;
        }
        
        .event-item {
          padding: 8px 12px;
          margin-bottom: 6px;
          border-radius: 6px;
          font-size: 0.9rem;
        }
        
        .event-item:last-child {
          margin-bottom: 0;
        }
        
        .event-name {
          display: block;
          font-weight: 600;
          color: white;
        }
        
        .event-category {
          display: block;
          font-size: 0.8rem;
          opacity: 0.9;
          color: white;
          margin-top: 2px;
        }
        
        .day {
          position: relative;
          cursor: pointer;
        }
      </style>
    </template>
  }

  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class="fitted-calendar">
        <div class="calendar-header">
          <h1>{{@model.schoolName}}</h1>
          <h2>{{@model.academicYear.periodLabel}}</h2>
        </div>
        
        <div class="calendar-preview">
          <div class="month-grid">
            <div class="weekday-headers">
              <span>S</span>
              <span>M</span>
              <span>T</span>
              <span>W</span>
              <span>T</span>
              <span>F</span>
              <span>S</span>
            </div>
            <div class="days">
              {{#each this.currentMonthDays as |day|}}
                <div class="{{day.class}}" title="{{day.title}}">{{day.number}}</div>
              {{/each}}
            </div>
          </div>
        </div>
      </div>
      
      <style scoped>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Montserrat:wght@300;400;500;600;700&display=swap');
        
        .fitted-calendar {
          width: 100%;
          height: 100%;
          display: flex;
          flex-direction: column;
          background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
          color: white;
          border-radius: 10px;
          overflow: hidden;
          box-shadow: 0 5px 15px rgba(0,0,0,0.2);
          position: relative;
          font-family: 'Montserrat', sans-serif;
        }
        
        .calendar-header {
          padding: 12px;
          text-align: center;
        }
        
        .calendar-header h1 {
          margin: 0;
          font-family: 'Playfair Display', serif;
          font-size: 1.1rem;
          font-weight: 600;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        
        .calendar-header h2 {
          margin: 4px 0 0;
          font-size: 0.85rem;
          font-weight: 400;
          opacity: 0.9;
        }
        
        .calendar-preview {
          flex: 1;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 8px;
        }
        
        .month-grid {
          width: 100%;
          background-color: rgba(255, 255, 255, 0.12);
          border-radius: 6px;
          padding: 6px;
        }
        
        .weekday-headers {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          text-align: center;
          font-weight: 600;
          font-size: 0.65rem;
          margin-bottom: 4px;
        }
        
        .days {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          gap: 2px;
        }
        
        .day {
          min-height: 20px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 0.65rem;
          background-color: rgba(255, 255, 255, 0.2);
          border-radius: 4px;
          transition: transform 0.2s ease;
          padding: 2px 0;
        }
        
        .day:hover {
          transform: scale(1.1);
          background-color: rgba(255, 255, 255, 0.3);
        }
        
        .highlight {
          background-color: #e53935;
          font-weight: bold;
          box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .empty {
          background-color: transparent;
        }

        
        .fitted-calendar:before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          height: 100%;
          background: linear-gradient(
            to bottom,
            rgba(255,255,255,0.15) 0%,
            rgba(255,255,255,0.05) 30%,
            rgba(255,255,255,0) 100%
          );
          pointer-events: none;
        }
        
        @container fitted-card (width < 120px) {
          .weekday-headers {
            display: none;
          }
          
          .calendar-header h2 {
            display: none;
          }
          
          .day {
            font-size: 0.6rem;
            min-height: 16px;
          }
        }
        
        .holiday { 
          background-color: #e53935; 
          color: white;
        }
        
        .special-event { 
          background-color: #8e44ad; 
          color: white;
        }
        
        .early-dismissal { 
          background-color: #f39c12; 
          color: white;
        }
        
        .teacher-day { 
          background-color: #27ae60; 
          color: white;
        }
        
        .exam-day { 
          background-color: #2980b9; 
          color: white;
        }
      </style>
    </template>
    
    get currentMonthDays() {
      // Generate a calendar for the current month
      const days = [];
      const today = new Date();
      const currentMonth = today.getMonth();
      const currentYear = today.getFullYear();
      
      const firstDay = new Date(currentYear, currentMonth, 1);
      const lastDay = new Date(currentYear, currentMonth + 1, 0);
      const daysInMonth = lastDay.getDate();
      const firstDayOfWeek = firstDay.getDay();
      
      // Add empty days
      for (let i = 0; i < firstDayOfWeek; i++) {
        days.push({ number: '', class: 'day empty', title: '' });
      }
      
      // Add numbered days
      for (let i = 1; i <= daysInMonth; i++) {
        let dayClass = 'day';
        let title = '';
        
        // Highlight today
        if (i === today.getDate()) {
          dayClass += ' highlight';
        }
        
        // Find events for this day
        const currentDate = new Date(currentYear, currentMonth, i);
        const eventsForDay = this.args.model.events.filter(event => {
          if (!event.eventDate) return false;
          const eventDate = new Date(event.eventDate);
          return eventDate.getDate() === i && 
                 eventDate.getMonth() === currentMonth && 
                 eventDate.getFullYear() === currentYear;
        });
        
        if (eventsForDay.length > 0) {
          const event = eventsForDay[0]; // Use the first event if multiple exist
          dayClass += ` ${event.cssClass}`;
          title = event.name;
        }
        
        days.push({ number: i, class: dayClass, title });
      }
      
      return days;
    }
  }

  static embedded = class Embedded extends Component<typeof this> {
    // Helper method to get school domain for email
    get schoolDomain() {
      if (!this.args.model.schoolName) return '';
      return this.args.model.schoolName.toLowerCase().replace(/\s+/g, '');
    }
    
    // Get upcoming events for display
    get upcomingEvents() {
      const today = new Date();
      return this.args.model.events
        .filter(event => event.eventDate && event.eventDate >= today)
        .sort((a, b) => a.eventDate!.getTime() - b.eventDate!.getTime())
        .slice(0, 5); // Get the next 5 events
    }
    
    // Format event date
    formatEventDate(date: Date | null) {
      if (!date) return '';
      return date.toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric'
      });
    }
    
    <template>
      <div class="embedded-calendar">
        <div class="calendar-header">
          <h1>{{@model.schoolName}}</h1>
          <h2>{{@model.academicYear.periodLabel}}</h2>
        </div>
        
        <div class="calendar-content">
          <div class="month-preview">
            <div class="month-header">
              <h3>Current Month</h3>
            </div>
            <div class="month-grid">
              <div class="weekday-headers">
                <span>S</span>
                <span>M</span>
                <span>T</span>
                <span>W</span>
                <span>T</span>
                <span>F</span>
                <span>S</span>
              </div>
              <div class="days">
                {{#each this.currentMonthDays as |day|}}
                  <div class="{{day.class}}" title="{{day.title}}">{{day.number}}</div>
                {{/each}}
              </div>
            </div>
          </div>
          
          <div class="upcoming-events">
            <h3>Upcoming Events</h3>
            {{#if this.upcomingEvents.length}}
              <ul>
                {{#each this.upcomingEvents as |event|}}
                  <li>
                    <span class="event-date">
                      {{this.formatEventDate event.eventDate}}
                    </span>
                    {{event.name}}
                  </li>
                {{/each}}
              </ul>
            {{else}}
              <p class="no-events">No upcoming events scheduled</p>
            {{/if}}
          </div>
        </div>
      </div>
      
      <style scoped>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Montserrat:wght@300;400;500;600;700&display=swap');
        
        .embedded-calendar {
          width: 100%;
          height: 100%;
          display: flex;
          flex-direction: column;
          background-color: white;
          border-radius: 10px;
          overflow: hidden;
          box-shadow: 0 5px 15px rgba(0,0,0,0.1);
          font-family: 'Montserrat', sans-serif;
        }
        
        .calendar-header {
          background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
          color: white;
          padding: 18px;
          text-align: center;
        }
        
        .calendar-header h1 {
          margin: 0;
          font-family: 'Playfair Display', serif;
          font-size: 1.4rem;
          font-weight: 600;
        }
        
        .calendar-header h2 {
          margin: 6px 0 0;
          font-size: 0.95rem;
          font-weight: 400;
          opacity: 0.9;
        }
        
        .calendar-content {
          flex: 1;
          display: flex;
          padding: 18px;
          gap: 20px;
        }
        
        .month-preview {
          flex: 1;
          background-color: #f5f7fa;
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 3px 8px rgba(0,0,0,0.05);
        }
        
        .month-header {
          background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
          color: white;
          padding: 10px;
          text-align: center;
        }
        
        .month-header h3 {
          margin: 0;
          font-family: 'Playfair Display', serif;
          font-size: 1.1rem;
          font-weight: 500;
        }
        
        .month-grid {
          padding: 10px;
        }
        
        .weekday-headers {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          text-align: center;
          font-weight: 600;
          font-size: 0.75rem;
          margin-bottom: 6px;
          color: #34495e;
        }
        
        .days {
          display: grid;
          grid-template-columns: repeat(7, 1fr);
          gap: 2px;
        }
        
        .day {
          min-height: 24px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 0.75rem;
          background-color: #f1f3f6;
          border-radius: 4px;
          transition: transform 0.2s ease;
          padding: 2px 0;
        }
        
        .day:hover {
          transform: scale(1.1);
          z-index: 1;
        }
        
        .highlight {
          background-color: #e53935;
          color: white;
          font-weight: bold;
          box-shadow: 0 2px 4px rgba(229, 57, 53, 0.3);
        }
        
        .holiday {
          background-color: #e53935;
          color: white;
          box-shadow: 0 2px 4px rgba(229, 57, 53, 0.3);
        }
        
        .special-event {
          background-color: #8e44ad;
          color: white;
          box-shadow: 0 2px 4px rgba(142, 68, 173, 0.3);
        }
        
        .empty {
          background-color: transparent;
        }
        
        .upcoming-events {
          flex: 1;
          display: flex;
          flex-direction: column;
        }
        
        .upcoming-events h3 {
          margin: 0 0 12px;
          font-family: 'Playfair Display', serif;
          font-size: 1.1rem;
          color: #1e3c72;
          padding-bottom: 8px;
          border-bottom: 2px solid #1e3c72;
        }
        
        .upcoming-events ul {
          list-style: none;
          padding: 0;
          margin: 0;
          flex: 1;
        }
        
        .upcoming-events li {
          padding: 10px 0;
          border-bottom: 1px solid #e6e9ec;
          font-size: 0.95rem;
        }
        
        .event-date {
          font-weight: 600;
          color: #1e3c72;
          margin-right: 8px;
        }
        
        .no-events {
          font-style: italic;
          color: #7f8c8d;
          padding: 10px 0;
        }
        
        @media (max-width: 500px) {
          .calendar-content {
            flex-direction: column;
          }
          
          .day {
            min-height: 20px;
            font-size: 0.7rem;
          }
        }
      </style>
    </template>
    
    get currentMonthDays() {
      // Generate a calendar for the current month
      const days = [];
      const today = new Date();
      const currentMonth = today.getMonth();
      const currentYear = today.getFullYear();
      
      const firstDay = new Date(currentYear, currentMonth, 1);
      const lastDay = new Date(currentYear, currentMonth + 1, 0);
      const daysInMonth = lastDay.getDate();
      const firstDayOfWeek = firstDay.getDay();
      
      // Add empty days
      for (let i = 0; i < firstDayOfWeek; i++) {
        days.push({ number: '', class: 'day empty', title: '' });
      }
      
      // Add numbered days
      for (let i = 1; i <= daysInMonth; i++) {
        let dayClass = 'day';
        let title = '';
        
        // Highlight today
        if (i === today.getDate()) {
          dayClass += ' highlight';
        }
        
        // Find events for this day
        const currentDate = new Date(currentYear, currentMonth, i);
        const eventsForDay = this.args.model.events.filter(event => {
          if (!event.eventDate) return false;
          const eventDate = new Date(event.eventDate);
          return eventDate.getDate() === i && 
                 eventDate.getMonth() === currentMonth && 
                 eventDate.getFullYear() === currentYear;
        });
        
        if (eventsForDay.length > 0) {
          const event = eventsForDay[0]; // Use the first event if multiple exist
          dayClass += ` ${event.cssClass}`;
          title = event.name;
        }
        
        days.push({ number: i, class: dayClass, title });
      }
      
      return days;
    }
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class="calendar-edit">
        <div class="edit-section">
          <h3>Basic Information</h3>
          <div class="edit-field">
            <label>School Name</label>
            <@fields.schoolName />
          </div>
          <div class="edit-field">
            <label>Academic Year</label>
            <@fields.academicYear />
          </div>
        </div>
        
        <div class="edit-section">
          <h3>Important Dates</h3>
          <div class="edit-field">
            <label>First Day of School</label>
            <@fields.firstDayOfSchool />
          </div>
          <div class="edit-field">
            <label>Last Day of School</label>
            <@fields.lastDayOfSchool />
          </div>
          <div class="edit-field">
            <label>Winter Break Start</label>
            <@fields.winterBreakStart />
          </div>
          <div class="edit-field">
            <label>Winter Break End</label>
            <@fields.winterBreakEnd />
          </div>
          <div class="edit-field">
            <label>Spring Break Start</label>
            <@fields.springBreakStart />
          </div>
          <div class="edit-field">
            <label>Spring Break End</label>
            <@fields.springBreakEnd />
          </div>
          <div class="edit-field">
            <label>Graduation Day</label>
            <@fields.graduationDay />
          </div>
        </div>
        
        <div class="edit-section">
          <h3>Contact Information</h3>
          <div class="edit-field">
            <label>Main Office Phone</label>
            <@fields.mainOfficePhone />
          </div>
          <div class="edit-field">
            <label>Email Domain</label>
            <@fields.emailDomain />
          </div>
          <div class="edit-field">
            <label>Website Domain</label>
            <@fields.websiteDomain />
          </div>
        </div>
        
        <div class="edit-section">
          <h3>Calendar Events</h3>
          <@fields.events />
        </div>
        
        <div class="edit-section">
          <h3>Event Categories</h3>
          <@fields.categories />
        </div>
      </div>
      
      <style scoped>
        .calendar-edit {
          padding: 20px;
          font-family: var(--boxel-font-family);
        }
        
        .edit-section {
          margin-bottom: 30px;
          padding-bottom: 20px;
          border-bottom: 1px solid var(--boxel-light);
        }
        
        .edit-section h3 {
          margin-top: 0;
          margin-bottom: 15px;
          color: var(--boxel-dark);
          font-size: var(--boxel-font-size-lg);
        }
        
        .edit-field {
          margin-bottom: 15px;
        }
        
        .edit-field label {
          display: block;
          margin-bottom: 5px;
          font-weight: 500;
          color: var(--boxel-dark);
        }
      </style>
    </template>
  }
}