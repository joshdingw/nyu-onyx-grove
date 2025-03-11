import {
  CardDef,
  Component,
  field,
  contains,
  linksTo
} from 'https://cardstack.com/base/card-api';
import MarkdownField from 'https://cardstack.com/base/markdown';
import { Staff } from './staff';
import GroupIcon from '@cardstack/boxel-icons/group';
import { Offering } from './offering';

export class Club extends Offering {
  static displayName = "Club";
  static icon = GroupIcon;

  @field summary = contains(MarkdownField);
  @field clubLeader = linksTo(() => Staff);

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class="club-container">
        <div class="club-header">
          {{#if @model.thumbnailURL}}
            <div class="header-image">
              <img src={{@model.thumbnailURL}} alt="" />
            </div>
          {{/if}}
          
          <div class="header-content">
            <div class="title-section">
              <GroupIcon class="club-icon" />
              <h1>{{@model.name}}</h1>
            </div>
            
            <div class="status-section">
              <div class="status-badge {{if @model.active 'active' 'inactive'}}">
                {{if @model.active 'Active Club' 'Currently Inactive'}}
              </div>
              {{#if @model.schoolYear.periodLabel}}
                <div class="time-period">{{@model.schoolYear.periodLabel}}</div>
              {{/if}}
            </div>
          </div>
        </div>

        <div class="content-wrapper">
          <div class="main-content">
            {{#if @model.description}}
              <div class="description-card">
                <h2>About Our Club</h2>
                <p class="description">{{@model.description}}</p>
              </div>
            {{/if}}

            {{#if @model.summary}}
              <div class="summary-card">
                <h2>What We Do</h2>
                <div class="markdown-content">
                  <@fields.summary />
                </div>
              </div>
            {{/if}}
          </div>

          <div class="side-content">
            {{#if @model.clubLeader}}
              <div class="leader-card">
                <h2>Club Leader</h2>
                <div class="leader-container">
                  {{#let @fields.clubLeader as |LeaderComponent|}}
                    <LeaderComponent @format="fitted" />
                  {{/let}}
                </div>
              </div>
            {{/if}}

            <div class="info-card">
              {{#if @model.meetingDays.length}}
                <div class="meeting-times">
                  <h3>We Meet On</h3>
                  <div class="days-grid">
                    {{#each @model.meetingDays as |day|}}
                      <span class="day-badge">{{day}}</span>
                    {{/each}}
                  </div>
                </div>
              {{/if}}

              {{#if @model.location}}
                <div class="location-section">
                  <h3>Find Us Here</h3>
                  {{#let @fields.location as |LocationComponent|}}
                    <LocationComponent @format="fitted" />
                  {{/let}}
                </div>
              {{/if}}

              {{#if @model.startTime}}
                <div class="time-section">
                  <h3>Club Hours</h3>
                  <p>{{@model.startTime}} - {{@model.endTime}}</p>
                </div>
              {{/if}}
            </div>
          </div>
        </div>
      </div>

      <style scoped>
        .club-container {
          min-height: 100vh;
          background: #f8f9ff;
          font-family: system-ui, -apple-system, sans-serif;
          padding-bottom: 2rem;
        }

        .club-header {
          position: relative;
          height: 450px;
          overflow: hidden;
          background: linear-gradient(135deg, #6366f1, #8b5cf6);
        }

        .header-image {
          position: absolute;
          inset: 0;
          opacity: 0.3;
        }

        .header-image img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }

        .header-content {
          position: relative;
          max-width: 1200px;
          margin: 0 auto;
          padding: 3rem 2rem;
          color: white;
        }

        .title-section {
          display: flex;
          align-items: flex-start;
          gap: 1rem;
          margin-bottom: 1rem;
        }

        .title-info {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }

        .status-section {
          display: flex;
          align-items: center;
          gap: 0.75rem;
          flex-wrap: wrap;
        }

        .time-period {
          display: inline-block;
          background: rgba(255, 255, 255, 0.1);
          padding: 0.5rem 1rem;
          border-radius: 20px;
          font-size: 0.875rem;
          font-weight: 500;
          color: rgba(255, 255, 255, 0.8);
          backdrop-filter: blur(8px);
        }

        .club-icon {
          width: 48px;
          height: 48px;
          padding: 0.75rem;
          background: rgba(255, 255, 255, 0.2);
          border-radius: 12px;
          backdrop-filter: blur(8px);
        }

        h1 {
          font-size: 2.5rem;
          font-weight: 700;
          margin: 0;
          text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
          line-height: 1.2;
        }

        .status-badge {
          display: inline-block;
          padding: 0.5rem 1rem;
          border-radius: 20px;
          font-weight: 500;
          font-size: 0.875rem;
          backdrop-filter: blur(8px);
        }

        .status-badge.active {
          background: rgba(34, 197, 94, 0.2);
          color: #dcfce7;
        }

        .status-badge.inactive {
          background: rgba(239, 68, 68, 0.2);
          color: #fecaca;
        }

        .content-wrapper {
          max-width: 1200px;
          margin: -4rem auto 0;
          padding: 0 2rem;
          display: grid;
          grid-template-columns: 1fr 350px;
          gap: var(--boxel-sp-lg);
          position: relative;
        }

        .main-content {
          display: grid;
          gap: var(--boxel-sp-lg);
        }

        .side-content {
          display: grid;
          gap: var(--boxel-sp-lg);
        }

        .description-card,
        .summary-card,
        .leader-card,
        .info-card {
          background: white;
          border-radius: 16px;
          padding: var(--boxel-sp-lg);
          box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
          border: 1px solid rgba(0, 0, 0, 0.05);
          transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .description-card:hover,
        .summary-card:hover,
        .leader-card:hover,
        .info-card:hover {
          transform: translateY(-2px);
          box-shadow: 0 8px 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
          font-size: 1.5rem;
          font-weight: 600;
          margin: 0 0 1rem;
          color: #1f2937;
          position: relative;
          padding-bottom: 0.5rem;
        }

        h2::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 0;
          width: 40px;
          height: 3px;
          background: linear-gradient(90deg, #6366f1, #8b5cf6);
          border-radius: 2px;
        }

        h3 {
          font-size: 1.1rem;
          font-weight: 600;
          margin: 0 0 0.75rem;
          color: #374151;
        }

        .description {
          font-size: 1.1rem;
          line-height: 1.6;
          color: #4b5563;
        }

        .markdown-content {
          color: #4b5563;
          line-height: 1.6;
        }

        .leader-container {
          margin-top: 1rem;
        }

        .leader-container :deep(.fitted-card) {
          height: auto;
          min-height: 100px;
          background: #f9fafb;
          border-radius: 12px;
          padding: 1rem;
          transition: transform 0.2s ease;
        }

        .leader-container :deep(.fitted-card:hover) {
          transform: translateY(-2px);
        }

        .info-card > * + * {
          margin-top: var(--boxel-sp-lg);
          padding-top: var(--boxel-sp-lg);
          border-top: 1px solid #e5e7eb;
        }

        .days-grid {
          display: flex;
          flex-wrap: wrap;
          gap: 0.5rem;
        }

        .day-badge {
          background: #f3f4f6;
          color: #4b5563;
          padding: 0.5rem 1rem;
          border-radius: 20px;
          font-size: 0.875rem;
          font-weight: 500;
          transition: all 0.2s ease;
          cursor: pointer;
        }

        .day-badge:hover {
          background: #6366f1;
          color: white;
          transform: translateY(-1px);
        }

        .time-section p {
          color: #4b5563;
          font-size: 1.1rem;
          padding: 0.75rem 1rem;
          background: #f3f4f6;
          border-radius: 10px;
          display: inline-block;
        }

        @media (max-width: 1024px) {
          .content-wrapper {
            grid-template-columns: 1fr;
          }

          .side-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: var(--boxel-sp-lg);
          }
        }

        @media (max-width: 640px) {
          .club-header {
            height: 250px;
          }

          .header-content {
            padding: 2rem 1rem;
          }

          h1 {
            font-size: 2rem;
          }

          .content-wrapper {
            padding: 0 1rem;
          }
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