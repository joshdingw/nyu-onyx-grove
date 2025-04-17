import { CardDef, field, contains, linksTo } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { eq, fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { SchoolCalendar } from './school-calendar';

export class StudentDashboard extends CardDef {
  static displayName = "StudentDashboard";

  @field currentSection = contains(StringField);
  @field calendar = linksTo(() => SchoolCalendar);

  static isolated = class Isolated extends Component<typeof this> {
    @tracked isHovered = "";
    @tracked currentNav = "Home";

    @action
    setHovered(id: string): void {
      this.isHovered = id;
    }

    @action
    clearHovered(): void {
      this.isHovered = "";
    }

    @action
    setCurrentNav(label: string): void {
      this.currentNav = label;
    }

    <template>
      <div class='dashboard-container'>
        <nav class='side-nav'>
          <div class='nav-header'>
            <img src='https://cdn.creazilla.com/icons/3230116/dashboard-icon-md.png' class='logo' />
          </div>
          
          <div class='nav-links'>
            <a href='#' class='nav-item active'>
              <span class="icon">🏠</span>
              <span>Home</span>
            </a>
            <a href='#' class='nav-item'>
              <span class="icon">📚</span>
              <span>Course</span>
            </a>
            <@fields.calendar>
              <:default as |calendar|>
                <div class='calendar-link'>
                  <a href={{calendar}} class='nav-item'>
                    <span class="icon">📅</span>
                    <span>Calendar</span>
                  </a>
                </div>
              </:default>
            </@fields.calendar>
            <a href='#' class='nav-item'>
              <span class="icon">✍️</span>
              <span>Assignment</span>
            </a>
            <a href='#' class='nav-item'>
              <span class="icon">📊</span>
              <span>Grade</span>
            </a>
            <a href='#' class='nav-item'>
              <span class="icon">⚙️</span>
              <span>Settings</span>
            </a>
          </div>
        </nav>

        <div class='dashboard'>
          <header class='dashboard-header'>
            <div class='school-info'>
              <h1>Student Dashboard</h1>
              <p class='term'>Spring Term 2024 • Week 7 of 15</p>
            </div>
            <div class='quick-stats'>
              <div class='stat-card'>
                <span class='stat-number'>7</span>
                <span class='stat-label'>Active Courses</span>
              </div>
              <div class='stat-card'>
                <span class='stat-number'>12</span>
                <span class='stat-label'>Pending Assignments</span>
              </div>
              <div class='stat-card'>
                <span class='stat-number'>94%</span>
                <span class='stat-label'>Attendance Rate</span>
              </div>
              <div class='stat-card'>
                <span class='stat-number'>3.8</span>
                <span class='stat-label'>GPA</span>
              </div>
            </div>
          </header>

          <main class='dashboard-content'>
            <div class='main-content'>
              <section class='current-assignments'>
                <h2>Current Assignments</h2>
                <div class='assignment-list'>
                  <div class='assignment-item overdue'>
                    <div class='assignment-status'>
                      <span class='status-indicator'></span>
                      <span class='status-text'>Overdue</span>
                    </div>
                    <div class='assignment-details'>
                      <h3>PHYS301: Quantum Mechanics Problem Set</h3>
                      <p>Due: April 12, 2024 • 3 days overdue</p>
                    </div>
                    <div class='assignment-actions'>
                      <button class='button button-primary'>Submit</button>
                    </div>
                  </div>
                  <div class='assignment-item due-soon'>
                    <div class='assignment-status'>
                      <span class='status-indicator'></span>
                      <span class='status-text'>Due Soon</span>
                    </div>
                    <div class='assignment-details'>
                      <h3>MATH405: Complex Analysis Assignment</h3>
                      <p>Due: April 18, 2024 • 3 days remaining</p>
                    </div>
                    <div class='assignment-actions'>
                      <button class='button button-primary'>Start</button>
                    </div>
                  </div>
                </div>
              </section>

              <section class='today-schedule'>
                <div class='section-header'>
                  <h2>Today's Schedule</h2>
                  <span class='date'>Monday, April 15</span>
                </div>
                <div class='schedule-timeline'>
                  <div class='schedule-item past'>
                    <div class='time'>08:30 - 10:00</div>
                    <div class='class advanced'>
                      <h3>Advanced Mathematics</h3>
                      <p>Room 305 • Prof. Chen</p>
                    </div>
                  </div>
                  <div class='schedule-item current'>
                    <div class='time'>10:15 - 11:45</div>
                    <div class='class sciences'>
                      <h3>Physics</h3>
                      <p>Lab 201 • Prof. Zhang</p>
                    </div>
                  </div>
                </div>
              </section>
            </div>

            <aside class='dashboard-sidebar'>
              <section class='user-profile'>
                <div class='user-info'>
                  <img src='https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=80&h=80&auto=format&fit=crop&crop=face' alt='User Avatar' class='user-avatar' />
                  <div>
                    <h3>Alex Johnson</h3>
                    <p>Student ID: #293857</p>
                  </div>
                </div>
              </section>

              <section class='upcoming-events'>
                <h2>Upcoming Deadlines</h2>
                <div class='event-list'>
                  <div class='event-item'>
                    <div class='event-date'>
                      <span class='day'>15</span>
                      <span class='month'>APR</span>
                    </div>
                    <div class='event-details'>
                      <h3>Physics Lab Report</h3>
                      <p>PHYS301 • Wave Mechanics Analysis</p>
                    </div>
                  </div>
                  <div class='event-item'>
                    <div class='event-date'>
                      <span class='day'>18</span>
                      <span class='month'>APR</span>
                    </div>
                    <div class='event-details'>
                      <h3>Math Quiz</h3>
                      <p>MATH405 • Complex Analysis</p>
                    </div>
                  </div>
                </div>
              </section>
            </aside>
          </main>
        </div>
      </div>

      <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap');
        
        .dashboard-container {
          display: flex;
          min-height: 100vh;
          font-family: 'Inter', system-ui, -apple-system, sans-serif;
          background-color: #f5f5f5;
        }

        .side-nav {
          width: 220px;
          background-color: #ffffff;
          border-right: 1px solid #e5e7eb;
          padding: 1rem 0;
          display: flex;
          flex-direction: column;
          height: 100vh;
          position: sticky;
          top: 0;
        }

        .nav-header {
          padding: 0 1rem;
          margin-bottom: 1.5rem;
          display: flex;
          align-items: center;
          gap: 0.625rem;
        }

        .logo {
          width: 36px;
          height: 36px;
          border-radius: 6px;
        }

        .logo-text {
          font-size: 1.125rem;
          font-weight: 500;
        }

        .nav-links {
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 0.125rem;
          padding: 0 0.5rem;
        }

        .nav-item {
          display: flex;
          align-items: center;
          gap: 0.625rem;
          padding: 0.625rem 1rem;
          color: #4b5563;
          text-decoration: none;
          border-radius: 6px;
          transition: all 0.2s ease;
          position: relative;
          font-size: 0.875rem;
        }

        .nav-item:hover {
          background-color: #f3f4f6;
        }

        .nav-item.active {
          background-color: #4A90E2;
          color: #ffffff;
        }

        .badge {
          position: absolute;
          right: 12px;
          background-color: #ef4444;
          color: #ffffff;
          font-size: 0.75rem;
          padding: 0.125rem 0.375rem;
          border-radius: 9999px;
        }

        .dashboard {
          flex: 1;
          padding: 1.5rem;
        }

        .dashboard-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 2rem;
        }

        .school-info h1 {
          font-size: 1.875rem;
          font-weight: 600;
          margin: 0;
        }

        .term {
          color: #6b7280;
          margin-top: 0.25rem;
        }

        .quick-stats {
          display: flex;
          gap: 1rem;
        }

        .stat-card {
          background: #ffffff;
          padding: 1rem;
          border-radius: 8px;
          box-shadow: 0 1px 3px rgba(0,0,0,0.1);
          min-width: 120px;
        }

        .stat-number {
          display: block;
          font-size: 1.5rem;
          font-weight: 600;
          color: #111827;
        }

        .stat-label {
          color: #6b7280;
          font-size: 0.875rem;
        }

        .dashboard-content {
          display: grid;
          grid-template-columns: 1fr 300px;
          gap: 1.5rem;
        }

        section {
          background: #ffffff;
          border-radius: 8px;
          padding: 1.5rem;
          margin-bottom: 1.5rem;
          box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        h2 {
          font-size: 1.25rem;
          font-weight: 600;
          margin: 0 0 1rem;
        }

        .assignment-item {
          display: flex;
          align-items: center;
          padding: 1rem;
          border: 1px solid #e5e7eb;
          border-radius: 6px;
          margin-bottom: 0.75rem;
        }

        .assignment-item.overdue {
          border-left: 4px solid #ef4444;
        }

        .assignment-item.due-soon {
          border-left: 4px solid #f59e0b;
        }

        .assignment-status {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          width: 100px;
        }

        .status-indicator {
          width: 8px;
          height: 8px;
          border-radius: 50%;
        }

        .overdue .status-indicator {
          background-color: #ef4444;
        }

        .due-soon .status-indicator {
          background-color: #f59e0b;
        }

        .assignment-details {
          flex: 1;
        }

        .assignment-details h3 {
          font-size: 0.875rem;
          font-weight: 500;
          margin: 0;
        }

        .assignment-details p {
          color: #6b7280;
          font-size: 0.75rem;
          margin: 0.25rem 0 0;
        }

        .button {
          padding: 0.5rem 1rem;
          border-radius: 6px;
          font-size: 0.875rem;
          font-weight: 500;
          border: none;
          cursor: pointer;
        }

        .button-primary {
          background-color: #4A90E2;
          color: #ffffff;
        }

        .button-primary:hover {
          background-color: #357abd;
        }

        .schedule-timeline {
          display: flex;
          flex-direction: column;
          gap: 1rem;
        }

        .schedule-item {
          display: flex;
          gap: 1rem;
          padding: 0.75rem;
          border-radius: 6px;
          background: #f9fafb;
        }

        .schedule-item.current {
          background: #f3f9ff;
          border-left: 4px solid #4A90E2;
        }

        .time {
          color: #6b7280;
          font-size: 0.875rem;
          width: 120px;
        }

        .class h3 {
          font-size: 0.875rem;
          font-weight: 500;
          margin: 0;
        }

        .class p {
          color: #6b7280;
          font-size: 0.75rem;
          margin: 0.25rem 0 0;
        }

        .user-info {
          display: flex;
          align-items: center;
          gap: 1rem;
        }

        .user-avatar {
          width: 48px;
          height: 48px;
          border-radius: 24px;
        }

        .user-info h3 {
          font-size: 1rem;
          font-weight: 500;
          margin: 0;
        }

        .user-info p {
          color: #6b7280;
          font-size: 0.875rem;
          margin: 0.25rem 0 0;
        }

        .event-list {
          display: flex;
          flex-direction: column;
          gap: 0.75rem;
        }

        .event-item {
          display: flex;
          gap: 1rem;
          padding: 0.75rem;
          background: #f9fafb;
          border-radius: 6px;
        }

        .event-date {
          text-align: center;
          min-width: 48px;
        }

        .event-date .day {
          font-size: 1.25rem;
          font-weight: 600;
          color: #111827;
        }

        .event-date .month {
          font-size: 0.75rem;
          color: #6b7280;
        }

        .event-details h3 {
          font-size: 0.875rem;
          font-weight: 500;
          margin: 0;
        }

        .event-details p {
          color: #6b7280;
          font-size: 0.75rem;
          margin: 0.25rem 0 0;
        }

        .calendar-link {
          margin: 0.5rem 0;
        }

        .calendar-year {
          font-size: 0.75rem;
          color: #6b7280;
          margin-left: 0.25rem;
        }
      </style>
    </template>
  }

  /*
  static embedded = class Embedded extends Component<typeof this> {
    <template></template>
  }

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