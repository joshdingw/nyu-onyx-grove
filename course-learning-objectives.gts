import { contains, containsMany, field, CardDef, Component } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { add, and, bool, eq, gt, lt, not, or } from '@cardstack/boxel-ui/helpers';

export class CourseLearningObjectives extends CardDef {
  static displayName = 'Course Learning Objectives';

  @field courseTitle = contains(StringField);
  @field semester = contains(StringField);
  @field overallObjectives = contains(StringField);
  @field classObjectives = containsMany(StringField);
  @field courseImage = contains(StringField);
  @field departmentIcon = contains(StringField);
  @field progressPercentage = contains(StringField);
  @field lastUpdated = contains(StringField);

  static isolated = class Isolated extends Component {
    @tracked expanded = false;
    @tracked selectedIndex = -1;

    @action
    toggleView() {
      this.expanded = !this.expanded;
    }

    @action
    selectObjective(idx) {
      if (this.selectedIndex === idx) {
        this.selectedIndex = -1;
      } else {
        this.selectedIndex = idx;
      }
    }

    <template>
      <style scoped>
        .course-objectives-container {
          max-width: 1200px;
          margin: 0 auto;
          padding: 0;
          font-family: system-ui, -apple-system, sans-serif;
          background: #f9fafb;
          border-radius: 20px;
          transition: all 0.3s ease;
        }

        .course-objectives-container.expanded {
          max-width: 100%;
          min-height: 100vh;
          border-radius: 0;
        }

        .content-wrapper {
          padding: 2rem;
        }

        .hero-section {
          height: 400px;
          background-size: cover;
          background-position: center;
          position: relative;
          border-radius: 15px 15px 0 0;
          margin-bottom: 3rem;
          box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
          transition: height 0.3s ease;
        }

        .expanded .hero-section {
          height: 500px;
          border-radius: 0;
        }

        .overlay {
          position: absolute;
          inset: 0;
          background: linear-gradient(to bottom, rgba(0,0,0,0.3), rgba(0,0,0,0.7));
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
          color: white;
          padding: 2rem;
        }

        .expand-btn {
          position: absolute;
          top: 1rem;
          right: 1rem;
          padding: 0.5rem 1rem;
          background: rgba(255,255,255,0.2);
          border: 1px solid rgba(255,255,255,0.4);
          color: white;
          border-radius: 20px;
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .expand-btn:hover {
          background: rgba(255,255,255,0.3);
        }

        .progress-section {
          margin: 2rem 0;
        }

        .progress-bar {
          height: 12px;
          background: #e2e8f0;
          border-radius: 6px;
          overflow: hidden;
        }

        .progress-fill {
          height: 100%;
          background: linear-gradient(90deg, #48bb78, #38a169);
          transition: width 0.5s ease;
          position: relative;
        }

        .progress-label {
          position: absolute;
          right: 8px;
          top: -18px;
          font-size: 0.875rem;
          color: #2d3748;
          font-weight: 500;
        }

        .objective-card {
          cursor: pointer;
          transform-origin: center;
          transition: all 0.3s ease;
          padding: 1rem;
          background: white;
          border-radius: 8px;
          margin-bottom: 1rem;
        }

        .objective-card.active {
          transform: scale(1.02);
          box-shadow: 0 8px 16px rgba(0,0,0,0.1);
          border-left: 4px solid #48bb78;
        }

        .last-updated {
          text-align: center;
          color: #718096;
          font-size: 0.875rem;
          margin-top: 2rem;
        }

        .objective-content {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }

        .objective-title {
          font-weight: 600;
          color: #2d3748;
        }

        .objective-details {
          color: #4a5568;
          font-size: 0.9rem;
        }

        .card-content {
          white-space: pre-wrap;
          line-height: 1.6;
          color: #2d3748;
          padding: 1rem;
          background: #f8fafc;
          border-radius: 8px;
        }

        .objectives-grid {
          display: grid;
          gap: 1.5rem;
          margin-top: 2rem;
        }

        .department-icon img {
          width: 48px;
          height: 48px;
          border-radius: 50%;
          background: rgba(255, 255, 255, 0.9);
          padding: 8px;
        }

        .semester-badge {
          background: rgba(255, 255, 255, 0.15);
          padding: 0.5rem 1rem;
          border-radius: 20px;
          font-size: 0.875rem;
          margin-top: 1rem;
        }

        @media (max-width: 768px) {
          .course-title {
            font-size: 2rem;
          }

          .objectives-grid {
            grid-template-columns: 1fr;
          }

          .hero-section {
            height: 300px;
          }
        }
      </style>

      <div class='course-objectives-container {{if this.expanded "expanded"}}'>
        <div class='hero-section' style="background-image: url('{{@model.courseImage}}')">
          <div class='overlay'>
            <div class='department-icon'>
              <img src='{{@model.departmentIcon}}' alt='Department Icon' />
            </div>
            <h1 class='course-title'>{{@model.courseTitle}}</h1>
            <div class='semester-badge'>{{@model.semester}}</div>
            <button class='expand-btn' type='button' {{on 'click' this.toggleView}}>
              {{if this.expanded "Collapse View" "Expand View"}}
            </button>
          </div>
        </div>

        <div class='content-wrapper'>
          <div class='progress-section'>
            <div class='progress-bar'>
              <div class='progress-fill' style="width: {{@model.progressPercentage}}">
                <span class='progress-label'>{{@model.progressPercentage}}</span>
              </div>
            </div>
          </div>

          <div class='objectives-card'>
            <div class='card-header'>
              <div class='icon'>📋</div>
              <h2>Overall Course Objectives</h2>
            </div>
            <div class='card-content'>
              {{@model.overallObjectives}}
            </div>
          </div>

          <div class='objectives-grid'>
            {{#each @model.classObjectives as |objective index|}}
              <div 
                class='objective-card {{if (eq this.selectedIndex index) "active"}}'
                {{on "click" (fn this.selectObjective index)}}
              >
                <div class='objective-number'>{{add index 1}}</div>
                <div class='objective-content'>{{objective}}</div>
              </div>
            {{/each}}
          </div>

          {{#if @model.lastUpdated}}
            <div class='last-updated'>
              Last updated: {{@model.lastUpdated}}
            </div>
          {{/if}}
        </div>
      </div>
    </template>
  }

  static edit = class Edit extends Component {
    <template>
      <style scoped>
        .edit-form {
          max-width: 800px;
          margin: 0 auto;
          padding: 2rem;
          background: #fff;
          border-radius: 10px;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .edit-section {
          margin-bottom: 2rem;
        }

        .section-label {
          font-weight: 600;
          color: #2d3748;
          margin-bottom: 0.5rem;
        }
      </style>

      <div class='edit-form'>
        <div class='edit-section'>
          <div class='section-label'>Course Title</div>
          <@fields.courseTitle />
        </div>

        <div class='edit-section'>
          <div class='section-label'>Semester</div>
          <@fields.semester />
        </div>

        <div class='edit-section'>
          <div class='section-label'>Course Image URL</div>
          <@fields.courseImage />
        </div>

        <div class='edit-section'>
          <div class='section-label'>Department Icon URL</div>
          <@fields.departmentIcon />
        </div>

        <div class='edit-section'>
          <div class='section-label'>Progress Percentage (e.g., "75%")</div>
          <@fields.progressPercentage />
        </div>

        <div class='edit-section'>
          <div class='section-label'>Overall Course Objectives</div>
          <@fields.overallObjectives />
        </div>

        <div class='edit-section'>
          <div class='section-label'>Class-specific Learning Objectives</div>
          <@fields.classObjectives />
        </div>

        <div class='edit-section'>
          <div class='section-label'>Last Updated</div>
          <@fields.lastUpdated />
        </div>
      </div>
    </template>
  }

  static embedded = class Embedded extends Component {
    <template>
      <style scoped>
        .embedded-view {
          padding: 1.5rem;
          background: #ffffff;
          border-radius: 12px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.05);
          transition: all 0.2s ease;
        }

        .embedded-view:hover {
          transform: translateY(-2px);
          box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .embedded-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 1rem;
        }

        .progress-pill {
          display: flex;
          align-items: center;
          gap: 0.5rem;
          background: #f7fafc;
          padding: 0.5rem 1rem;
          border-radius: 20px;
        }

        .progress-bar {
          width: 60px;
          height: 6px;
          background: #e2e8f0;
          border-radius: 3px;
          overflow: hidden;
        }

        .progress-fill {
          height: 100%;
          background: #48bb78;
          transition: width 0.3s ease;
        }

        .progress-text {
          font-size: 0.875rem;
          color: #4a5568;
          font-weight: 500;
        }
      </style>

      <div class='embedded-view'>
        <div class='embedded-header'>
          <div class='course-info'>
            <h3>{{@model.courseTitle}}</h3>
            <span class='semester'>{{@model.semester}}</span>
          </div>
          <div class='progress-pill'>
            <div class='progress-bar'>
              <div class='progress-fill' style="width: {{@model.progressPercentage}}"></div>
            </div>
            <span class='progress-text'>{{@model.progressPercentage}}</span>
          </div>
        </div>
      </div>
    </template>
  }
}
