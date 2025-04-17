import { 
  CardDef,
  field,
  contains,
  Component,
  containsMany,
  FieldDef,
  linksTo,
  linksToMany
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import NumberField from 'https://cardstack.com/base/number';
import { LearningObjectives } from './learning-objectives';
import { WeeklyStudentReport } from './weekly-student-report';

class ActivityField extends FieldDef {
    @field type = contains(StringField)
    @field subject = contains(StringField)
    @field completion =  contains(StringField)
    @field performance = contains(NumberField)
}

class TopicMasteryField extends FieldDef {
  @field topic = contains(StringField)
  @field masteryLevel = contains(StringField)
  @field lastAssessed = contains(StringField)
  @field nextAssessment = contains(StringField)
  @field progress = contains(NumberField)
  @field notes = contains(StringField)
}

class OverallFeedbackField extends FieldDef {
  @field summary = contains(StringField)
  @field strengths = containsMany(StringField)
  @field areasForImprovement = containsMany(StringField)
}

class NextWeekRecommendationField extends FieldDef {
  @field topic = contains(StringField)
  @field recommendations = containsMany(StringField)
  @field preparationSteps = containsMany(StringField)
}

class ProgressField extends FieldDef {
    @field courseCompletionPercentage = contains(NumberField)
    @field currentWeek = contains(NumberField)
    @field totalWeeks = contains(NumberField)
    @field overallGrade = contains(NumberField)
    @field strengthAreas = containsMany(StringField)
    @field improvementAreas =  containsMany(StringField)
}

export class ProgressTracking extends CardDef {
  static displayName = 'Progress Tracking';

  @field studentName = contains(StringField);
  @field courseId = contains(StringField);
  @field courseName = contains(StringField);
  @field semester = contains(StringField);
  @field academicYear = contains(StringField);
  @field learningObjectives = linksTo(() => LearningObjectives);
  @field weeklyReports = linksToMany(() => WeeklyStudentReport);

  @field topicMastery = containsMany(TopicMasteryField)
  @field overallFeedback = contains(OverallFeedbackField)
  @field nextWeekLearningRecommendations = containsMany(NextWeekRecommendationField)
  @field courseProgress = contains(ProgressField);

  @field lastUpdated = contains(StringField);
  @field nextAssessmentDate = contains(StringField);
  @field title = contains(StringField);
  @field description = contains(StringField);

  static isolated = class Isolated extends Component<typeof this> {
    formatDate(dateString: string) {
      const date = new Date(dateString);
      return date.toLocaleDateString('en-US', {
        weekday: 'short',
        month: 'short',
        day: 'numeric',
        year: 'numeric'
      });
    }

    <template>
      <article class='progress-tracking-isolated'>
        <header>
          <h1>{{@model.courseName}} - Progress Report</h1>
          <p class='student-info'>{{@model.studentName}}</p>
          <p class='course-info'>{{@model.semester}} {{@model.academicYear}}</p>
        </header>

        <section class='learning-objectives'>
          <h2>Course Learning Objectives</h2>
          <div class='objectives-list'>
            {{#each @model.learningObjectives.courseObjectives as |objective|}}
              <div class='objective-item'>
                <span class='objective-text'>{{objective}}</span>
              </div>
            {{/each}}
          </div>
        </section>

        <section class='course-progress'>
          <h2>Overall Progress</h2>
          <div class='progress-stats'>
            <div class='stat'>
              <span class='label'>Completion</span>
              <span class='value'>{{@model.courseProgress.courseCompletionPercentage}}%</span>
            </div>
            <div class='stat'>
              <span class='label'>Current Week</span>
              <span class='value'>{{@model.courseProgress.currentWeek}} of {{@model.courseProgress.totalWeeks}}</span>
            </div>
            <div class='stat'>
              <span class='label'>Overall Grade</span>
              <span class='value'>{{@model.courseProgress.overallGrade}}%</span>
            </div>
          </div>
        </section>

        <section class='weekly-reports'>
          <h2>Weekly Reports</h2>
          <div class='reports-grid'>
            {{#each @model.weeklyReports as |report|}}
              <div class='report-card'>
                <div class='report-header'>
                  <h3>Week Ending: {{this.formatDate report.weekEnding}}</h3>
                  <div class='overall-progress'>{{report.overallProgress}}</div>
                </div>
                <div class='report-activities'>
                  {{#each report.activities as |activity|}}
                    <div class='activity-item'>
                      <span class='activity-title'>{{activity.title}}</span>
                      <span class='activity-performance'>{{activity.performance}}%</span>
                    </div>
                  {{/each}}
                </div>
                <div class='report-feedback'>
                  <div class='feedback-section'>
                    <h4>Teacher Feedback</h4>
                    <@fields.teacherFeedback />
                  </div>
                  <div class='feedback-section'>
                    <h4>Behavior Notes</h4>
                    <@fields.behaviorNotes />
                  </div>
                </div>
              </div>
            {{/each}}
          </div>
        </section>

        <section class='overall-feedback'>
          <h2>Overall Feedback</h2>
          <div class='feedback-card'>
            <div class='feedback-summary'>
              <p>{{@model.overallFeedback.summary}}</p>
            </div>
            <div class='feedback-details'>
              <div class='strengths'>
                <h3>Strengths</h3>
                <ul>
                  {{#each @model.overallFeedback.strengths as |strength|}}
                    <li>{{strength}}</li>
                  {{/each}}
                </ul>
              </div>
              <div class='improvement-areas'>
                <h3>Areas for Improvement</h3>
                <ul>
                  {{#each @model.overallFeedback.areasForImprovement as |area|}}
                    <li>{{area}}</li>
                  {{/each}}
                </ul>
              </div>
            </div>
          </div>
        </section>

        <section class='next-week-recommendations'>
          <h2>Next Week Learning Recommendations</h2>
          {{#each @model.nextWeekLearningRecommendations as |rec|}}
            <div class='next-week-recommendation'>
              <h3>{{rec.topic}}</h3>
              <div class='recommendations-list'>
                <h4>Recommendations</h4>
                <ul>
                  {{#each rec.recommendations as |recommendation|}}
                    <li>{{recommendation}}</li>
                  {{/each}}
                </ul>
              </div>
              <div class='preparation-steps'>
                <h4>Preparation Steps</h4>
                <ul>
                  {{#each rec.preparationSteps as |step|}}
                    <li>{{step}}</li>
                  {{/each}}
                </ul>
              </div>
            </div>
          {{/each}}
        </section>
      </article>
      <style scoped>
        .progress-tracking-isolated {
          max-width: 800px;
          margin: 0 auto;
          padding: var(--boxel-sp-xl);
        }
        header {
          margin-bottom: var(--boxel-sp-xl);
        }
        .student-info {
          font-size: var(--boxel-font-lg);
          margin: var(--boxel-sp-xs) 0;
        }
        .course-info {
          color: var(--boxel-dark);
          font-size: var(--boxel-font-sm);
        }
        section {
          margin-bottom: var(--boxel-sp-xl);
        }
        .progress-stats {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: var(--boxel-sp);
          margin-top: var(--boxel-sp);
        }
        .stat {
          padding: var(--boxel-sp);
          background: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
          text-align: center;
        }
        .recommendation {
          padding: var(--boxel-sp);
          margin-bottom: var(--boxel-sp);
          border-radius: var(--boxel-border-radius);
        }
        .recommendation.High {
          border-left: 4px solid var(--boxel-error);
        }
        .recommendation.Medium {
          border-left: 4px solid var(--boxel-warning);
        }
        .recommendation.Low {
          border-left: 4px solid var(--boxel-success);
        }
        .mastery-levels {
          display: flex;
          gap: var(--boxel-sp);
          margin: var(--boxel-sp-xs) 0;
        }
        .rec-meta {
          display: flex;
          justify-content: space-between;
          margin-top: var(--boxel-sp);
          font-size: var(--boxel-font-sm);
        }
        .learning-objectives {
          margin-bottom: var(--boxel-sp-xl);
        }
        .objectives-list {
          display: grid;
          gap: var(--boxel-sp);
          margin-top: var(--boxel-sp);
        }
        .objective-item {
          padding: var(--boxel-sp);
          background: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
        }
        .objective-text {
          font-size: var(--boxel-font-sm);
        }
        .weekly-reports {
          margin-top: var(--boxel-sp-xl);
        }
        .reports-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: var(--boxel-sp);
          margin-top: var(--boxel-sp);
        }
        .report-card {
          padding: var(--boxel-sp);
          background: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
          border: 1px solid var(--boxel-border);
        }
        .report-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: var(--boxel-sp);
          padding-bottom: var(--boxel-sp-xs);
          border-bottom: 1px solid var(--boxel-border);
        }
        .report-header h3 {
          margin: 0;
          font-size: var(--boxel-font-size);
        }
        .overall-progress {
          padding: var(--boxel-sp-xxs) var(--boxel-sp-xs);
          background: var(--boxel-highlight-background);
          border-radius: var(--boxel-border-radius);
          font-size: var(--boxel-font-size-sm);
        }
        .report-activities {
          margin-bottom: var(--boxel-sp);
        }
        .activity-item {
          display: flex;
          justify-content: space-between;
          padding: var(--boxel-sp-xxs) 0;
          font-size: var(--boxel-font-size-sm);
        }
        .activity-performance {
          color: var(--boxel-green-600);
          font-weight: 500;
        }
        .report-feedback {
          font-size: var(--boxel-font-size-sm);
        }
        .feedback-section {
          margin-top: var(--boxel-sp-xs);
        }
        .feedback-section h4 {
          margin: 0 0 var(--boxel-sp-xxs);
          font-size: var(--boxel-font-size-sm);
          color: var(--boxel-purple-600);
        }
        .next-week-recommendations {
          margin-top: var(--boxel-sp-xl);
        }
        .next-week-recommendation {
          padding: var(--boxel-sp);
          margin-bottom: var(--boxel-sp);
          background: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
          border-left: 4px solid var(--boxel-purple-600);
        }
        .next-week-recommendation h3 {
          margin: 0 0 var(--boxel-sp-xs);
          color: var(--boxel-purple-600);
        }
        .recommendations-list,
        .preparation-steps {
          margin-top: var(--boxel-sp);
        }
        .recommendations-list h4,
        .preparation-steps h4 {
          margin: 0 0 var(--boxel-sp-xs);
          font-size: var(--boxel-font-sm);
          color: var(--boxel-dark);
        }
        .recommendations-list ul,
        .preparation-steps ul {
          margin: 0;
          padding-left: var(--boxel-sp);
        }
        .recommendations-list li,
        .preparation-steps li {
          margin-bottom: var(--boxel-sp-xxs);
          font-size: var(--boxel-font-sm);
        }
        .overall-feedback {
          margin-top: var(--boxel-sp-xl);
        }
        .feedback-card {
          padding: var(--boxel-sp);
          background: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
          border-left: 4px solid var(--boxel-blue-600);
        }
        .feedback-summary {
          margin-bottom: var(--boxel-sp);
          font-size: var(--boxel-font-sm);
          line-height: 1.5;
        }
        .feedback-details {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: var(--boxel-sp);
        }
        .strengths, .improvement-areas {
          padding: var(--boxel-sp);
          background: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
        }
        .strengths h3, .improvement-areas h3 {
          margin: 0 0 var(--boxel-sp-xs);
          font-size: var(--boxel-font-sm);
          color: var(--boxel-dark);
        }
        .strengths ul, .improvement-areas ul {
          margin: 0;
          padding-left: var(--boxel-sp);
        }
        .strengths li, .improvement-areas li {
          margin-bottom: var(--boxel-sp-xxs);
          font-size: var(--boxel-font-sm);
        }
        .strengths {
          border-left: 4px solid var(--boxel-success);
        }
        .improvement-areas {
          border-left: 4px solid var(--boxel-warning);
        }
      </style>
    </template>
  };

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='progress-tracking-embedded'>
        <div class='header'>
          <h3>{{@model.studentName}}</h3>
          <span class='course'>{{@model.courseName}}</span>
        </div>
        <div class='progress-summary'>
          <div class='completion'>
            <span class='label'>Progress:</span>
            <span class='value'>{{@model.courseProgress.courseCompletionPercentage}}%</span>
          </div>
          <div class='current-week'>
            Week {{@model.courseProgress.currentWeek}}/{{@model.courseProgress.totalWeeks}}
          </div>
        </div>
        <div class='recent-performance'>
          <span class='grade'>{{@model.courseProgress.overallGrade}}%</span>
          <span class='status'>{{this.progressStatus}}</span>
        </div>
      </div>
      <style scoped>
        .progress-tracking-embedded {
          padding: var(--boxel-sp);
          border-radius: var(--boxel-border-radius);
          background-color: var(--boxel-light);
        }
        .header {
          margin-bottom: var(--boxel-sp-xs);
        }
        .course {
          font-size: var(--boxel-font-sm);
          color: var(--boxel-dark);
        }
        .progress-summary {
          display: flex;
          justify-content: space-between;
          margin: var(--boxel-sp-xs) 0;
        }
        .recent-performance {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-top: var(--boxel-sp-xs);
        }
        .grade {
          font-size: var(--boxel-font-lg);
          font-weight: bold;
        }
        .status {
          font-size: var(--boxel-font-sm);
        }
      </style>
    </template>

    get progressStatus() {
      const grade = this.args.model.courseProgress.overallGrade;
      if (grade >= 90) return "Excellent";
      if (grade >= 75) return "Good";
      if (grade >= 60) return "Satisfactory";
      return "Needs Attention";
    }
  };

  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='edit-form'>
        <div class='form-section'>
          <div class='section-label'>Student Name</div>
          <@fields.studentName />
        </div>

        <div class='form-section'>
          <div class='section-label'>Course Information</div>
          <@fields.courseName />
          <@fields.semester />
          <@fields.academicYear />
        </div>

        <div class='form-section'>
          <div class='section-label'>Learning Objectives</div>
          <@fields.learningObjectives />
        </div>

        <div class='form-section'>
          <div class='section-label'>Weekly Reports</div>
          <@fields.weeklyReports />
        </div>

        <div class='form-section'>
          <div class='section-label'>Recommendations</div>
          <@fields.activeRecommendations />
        </div>
      </div>
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
    </template>
  };
}