import {
  CardDef,
  Component,
  field,
  contains,
  linksTo,
  linksToMany
} from 'https://cardstack.com/base/card-api';
import NumberField from 'https://cardstack.com/base/number';
import StringField from 'https://cardstack.com/base/string';
import { Staff } from './staff'; // Assuming there's a Staff card defined
import { StudentCohort } from './student-cohort';
import { Student } from './student';
import ChalkboardIcon from '@cardstack/boxel-icons/chalkboard';
import { Offering } from './offering';

export class Class extends Offering {
  static displayName = "Class";
  static icon = ChalkboardIcon;

  @field classNumber = contains(NumberField);
  @field leadTeacher = linksTo(() => Staff);
  @field students = linksToMany(() => Student, {
    computeVia: function(this: Class) {
      return this.cohort?.students ?? [];
    }
  });

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <style>
        .container {
          position: relative;
          max-width: 900px;
          margin: 0 auto;
          padding: 1.5rem;
          font-family: system-ui, -apple-system, sans-serif;
          min-height: 100vh;
          background: #f5f7fa;
        }

        .header-section {
          position: relative;
          margin-bottom: 2rem;
          border-radius: 12px;
          overflow: hidden;
          box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }

        .background-image {
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          z-index: 0;
        }

        .background-image::after {
          content: '';
          position: absolute;
          inset: 0;
          background: linear-gradient(
            to bottom,
            rgba(0, 0, 0, 0.4),
            rgba(0, 0, 0, 0.65)
          );
        }

        .background-image img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          filter: blur(8px) brightness(1.1) saturate(1.2);
        }

        .header {
          position: relative;
          z-index: 1;
          padding: 2.5rem 2rem;
        }

        .content-grid {
          display: grid;
          grid-template-columns: 1fr;
          gap: 1.5rem;
        }

        .card {
          background: white;
          padding: 1rem 1.5rem;
          border-radius: 12px;
          border: 1px solid rgba(0,0,0,0.08);
          box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .page-title {
          margin: 0 0 1rem;
          font-size: 2.5rem;
          font-weight: 600;
          color: white;
          line-height: 1.2;
        }

        .badge-container {
          display: flex;
          gap: 0.75rem;
          margin-bottom: 1.5rem;
          flex-wrap: wrap;
        }

        .badge {
          padding: 0.375rem 0.75rem;
          border-radius: 16px;
          font-size: 0.875rem;
          font-weight: 500;
          line-height: 1;
        }

        .badge-neutral {
          background: #f3f4f6;
          color: #374151;
        }

        .badge-success {
          background: #ecfdf5;
          color: #059669;
        }

        .badge-error {
          background: #fef2f2;
          color: #dc2626;
        }

        .badge-location {
          background: #f0f9ff;
          color: #0369a1;
        }

        .description {
          color: rgba(255, 255, 255, 0.95);
          line-height: 1.6;
          font-size: 1rem;
          max-width: 65ch;
        }

        .section-title {
          font-size: 1.125rem;
          font-weight: 600;
          color: #111827;
          margin-bottom: 0.75rem;
        }

        .label {
          font-size: 0.875rem;
          font-weight: 500;
          color: #6b7280;
          margin-bottom: 0.375rem;
        }

        .value {
          color: #111827;
          font-size: 0.9375rem;
        }

        .staff-list,
        .student-list {
          display: grid;
          gap: 0.5rem;
          align-content: start;
          margin-top: 0.25rem;
        }

        .staff-list :deep(.fitted-card),
        .student-list :deep(.fitted-card) {
          height: 75px;
          background: #ffffff;
          border-radius: 8px;
          overflow: hidden;
          border: 1px solid #eaeaea;
          transition: border-color 0.15s ease, transform 0.15s ease;
        }

        .staff-list :deep(.fitted-card:hover),
        .student-list :deep(.fitted-card:hover) {
          border-color: #d1d5db;
          transform: translateY(-1px);
        }

        .student-count {
          font-size: 0.875rem;
          color: #6b7280;
          margin-top: 1rem;
        }

        .details-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
          gap: 1.5rem;
          align-items: start;
        }

        .location-container {
          grid-column: span 2;
          container-type: size;
          container-name: fitted-card;
          width: 250px;
          height: 105px;
        }

        .location-container :deep(.fitted-card) {
          height: 100%;
          width: 100%;
        }

        @media (max-width: 767px) {
          .location-container {
            max-width: 100%;
            overflow-x: auto;
          }
        }

        @media (min-width: 768px) {
          .content-grid {
            grid-template-columns: repeat(2, 1fr);
          }

          .schedule-card {
            grid-column: span 2;
          }
        }
      </style>

      <div class="container">
        <div class="header-section">
          {{#if @model.thumbnailURL}}
            <div class="background-image">
              <img src={{@model.thumbnailURL}} alt="" />
            </div>
          {{/if}}
          
          <div class="header">
            <h1 class="page-title">{{@model.name}}</h1>
            <div class="badge-container">
              <span class="badge badge-neutral">Class #{{@model.classNumber}}</span>
              <span class="badge {{if @model.active 'badge-success' 'badge-error'}}">
                {{if @model.active 'Active' 'Inactive'}}
              </span>
            </div>
            
            {{#if @model.description}}
              <p class="description">{{@model.description}}</p>
            {{/if}}
          </div>
        </div>

        <div class="content-grid">
          <!-- Staff Section -->
          <div class="card">
            <h2 class="section-title">Staff</h2>
            {{#if @model.leadTeacher}}
              <div class="staff-list">
                <p class="label">Lead Teacher</p>
                {{#let @fields.leadTeacher as |TeacherComponent|}}
                  <TeacherComponent @format="fitted" />
                {{/let}}
              </div>
            {{/if}}
            {{#if @model.staff.length}}
              <div class="staff-list">
                <p class="label">Supporting Staff</p>
                {{#each @fields.staff as |StaffComponent|}}
                  <StaffComponent @format="fitted" />
                {{/each}}
              </div>
            {{/if}}
          </div>

          <!-- Students Section -->
          <div class="card">
            <h2 class="section-title">Students</h2>
            {{#if @model.students.length}}
              <div class="student-list">
                {{#each @fields.students as |StudentComponent|}}
                  <StudentComponent @format="fitted" />
                {{/each}}
              </div>
              <p class="student-count">Total Students: {{@model.students.length}}</p>
            {{else}}
              <p class="description">No students enrolled yet.</p>
            {{/if}}
          </div>

          <!-- Schedule & Details Section -->
          <div class="card schedule-card">
            <h2 class="section-title">Class Information</h2>
            <div class="details-grid">
              {{#if @model.schoolYear.periodLabel}}
                <div>
                  <p class="label">School Year</p>
                  <p class="value">{{@model.schoolYear.periodLabel}}</p>
                </div>
              {{/if}}
              {{#if @model.startTime}}
                <div>
                  <p class="label">Start Time</p>
                  <p class="value">{{@model.startTime}}</p>
                </div>
              {{/if}}
              {{#if @model.endTime}}
                <div>
                  <p class="label">End Time</p>
                  <p class="value">{{@model.endTime}}</p>
                </div>
              {{/if}}
              {{#if @model.location}}
                <div class="location-container">
                  <p class="label">Location</p>
                  <@fields.location @format="fitted" />
                </div>
              {{/if}}
            </div>
            {{#if @model.meetingDays.length}}
              <div class="section">
                <p class="label">Meeting Days</p>
                <div class="badge-container">
                  {{#each @model.meetingDays as |day|}}
                    <span class="badge badge-neutral">{{day}}</span>
                  {{/each}}
                </div>
              </div>
            {{/if}}
          </div>
        </div>
      </div>
    </template>
  }
  
}