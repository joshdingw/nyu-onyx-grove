import { 
  CardDef, 
  Component, 
  field, 
  contains,
  containsMany,
  FieldDef,
  linksTo
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import NumberField from 'https://cardstack.com/base/number';
import MarkdownField from 'https://cardstack.com/base/markdown';
import { FileField } from '@cardstack/boxel-ui/components'; //not used
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { add } from '@cardstack/boxel-ui/helpers';
import Upload from '@cardstack/boxel-icons/upload';
import { Answer } from './answer'

export class HomeworkQuestion extends FieldDef {
  static displayName = 'Homework Question';
  
  @field question = contains(StringField);
  @field maxPoints = contains(NumberField);
  @field points = contains(NumberField);
  @field feedback = contains(StringField);
}

export class Homeworkassignment extends CardDef {
  static displayName = "Homework Assignment";

  @field title = contains(StringField);
  @field courseTitle = contains(StringField);
  @field dueDate = contains(StringField);
  @field instructions = contains(MarkdownField);
  @field questions = containsMany(HomeworkQuestion);
  @field submissionFile = contains(StringField);
  @field totalScore = contains(NumberField);
  @field maxScore = contains(NumberField);
  @field status = contains(StringField);
  @field aiGradingFeedback = contains(MarkdownField);
  @field answer = linksTo( Answer )

  static isolated = class Isolated extends Component<typeof this> {
    @tracked isSubmitting = false;
    @tracked fileError = null;

    @action
    async handleFileUpload(event) {
      const file = event.target.files[0];
      if (!file) return;

      // Validate file type
      if (!file.name.endsWith('.md')) {
        this.fileError = 'Please upload a markdown (.md) file';
        return;
      }

      // Clear any previous errors
      this.fileError = null;

      // Create file URL and update model
      const fileUrl = URL.createObjectURL(file);
      this.args.model.submissionFile = fileUrl;
    }

    @action
    async submitForGrading() {
      if (!this.args.model.submissionFile) return;
      
      this.isSubmitting = true;
      this.args.model.status = 'grading';
      
      try {
        // Read the markdown file
        const response = await fetch(this.args.model.submissionFile); //does this do anything?
        const markdown = await response.text();

        // Here you would send the markdown content to AI for grading
        // For now, we'll simulate the grading process
        await new Promise(resolve => setTimeout(resolve, 2000));

        // Update with sample feedback (in real implementation, this would come from AI)
        this.args.model.aiGradingFeedback = "# Grading Feedback\n\nWell-structured answers...";
        this.args.model.totalScore = 85;
        this.args.model.status = 'graded';
      } catch (error) {
        this.fileError = 'Error processing submission. Please try again.';
        this.args.model.status = null;
      } finally {
        this.isSubmitting = false;
      }
    }

    <template>
      <div class='homework-container'>
        <header class='assignment-header'>
          <h1>{{@model.title}}</h1>
          <div class='course-info'>{{@model.courseTitle}}</div>
          <div class='due-date'>Due: {{@model.dueDate}}</div>
          {{#if @model.status}}
            <div class='status {{@model.status}}'>{{@model.status}}</div>
          {{/if}}
        </header>

        <section class='instructions'>
          <h2>Instructions</h2>
          <@fields.instructions />
          <div class='file-format-guide'>
            <h3>Submission Format</h3>
            <p>Please submit your work as a markdown (.md) file with the following structure:</p>
            <pre>
# {{@model.title}}
## Question 1
[Your answer here]
## Question 2
[Your answer here]
...etc
            </pre>
          </div>
        </section>

        <section class='questions'>
          <h2>Questions</h2>
          {{#each @model.questions as |question index|}}
            <div class='question-item'>
              <div class='question-number'>Question {{(add index 1)}}</div>
              <div class='question-text'>{{question.question}}</div>
              <div class='points'>Points: {{question.maxPoints}}</div>
            </div>
          {{/each}}
        </section>

        <section class='submission'>
          <h2>Submit Your Work</h2>
          <div class='upload-container'>
            <input 
              type="file" 
              accept=".md"
              {{on 'change' this.handleFileUpload}}
            />
            {{#if this.fileError}}
              <div class='error-message'>{{this.fileError}}</div>
            {{/if}}
            {{#if @model.submissionFile}}
              <button 
                class='grade-button'
                {{on 'click' this.submitForGrading}}
                disabled={{this.isSubmitting}}
              >
                {{if this.isSubmitting 'Grading...' 'Submit for Grading'}}
              </button>
            {{/if}}
          </div>
        </section>

        {{#if @model.aiGradingFeedback}}
          <section class='feedback'>
            <h2>AI Feedback</h2>
            <@fields.aiGradingFeedback />
          </section>
        {{/if}}

        {{#if @model.totalScore}}
          <footer class='score-summary'>
            <div class='total-score'>
              Total Score: {{@model.totalScore}}/{{@model.maxScore}}
            </div>
          </footer>
        {{/if}}
      </div>
      <style scoped>
        .homework-container {
          max-width: 800px;
          margin: 0 auto;
          padding: var(--boxel-sp-lg);
        }

        .assignment-header {
          margin-bottom: var(--boxel-sp-xl);
          padding-bottom: var(--boxel-sp-sm);
          border-bottom: 2px solid var(--boxel-purple-200);
        }

        h1 {
          font-size: var(--boxel-font-size-xl);
          margin: 0 0 var(--boxel-sp-sm);
          color: var(--boxel-purple-900);
        }

        .course-info {
          font-size: var(--boxel-font-size-lg);
          color: var(--boxel-dark);
          margin-bottom: var(--boxel-sp-xs);
        }

        .due-date {
          color: var(--boxel-purple-600);
          font-weight: 500;
        }

        .status {
          display: inline-block;
          padding: var(--boxel-sp-xxs) var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          font-size: var(--boxel-font-sm);
          font-weight: 500;
          margin-top: var(--boxel-sp-xs);
        }

        .status.grading {
          background-color: var(--boxel-yellow-100);
          color: var(--boxel-yellow-700);
        }

        .status.graded {
          background-color: var(--boxel-purple-100);
          color: var(--boxel-purple-700);
        }

        section {
          margin-bottom: var(--boxel-sp-xl);
        }

        h2 {
          font-size: var(--boxel-font-size-lg);
          color: var(--boxel-purple-800);
          margin: 0 0 var(--boxel-sp-sm);
        }

        .file-format-guide {
          margin-top: var(--boxel-sp-sm);
          padding: var(--boxel-sp-sm);
          background: var(--boxel-purple-50);
          border-radius: var(--boxel-border-radius);
        }

        .file-format-guide pre {
          background: var(--boxel-light);
          padding: var(--boxel-sp-sm);
          border-radius: var(--boxel-border-radius-sm);
          font-family: monospace;
        }

        .question-item {
          padding: var(--boxel-sp-sm);
          border: 1px solid var(--boxel-border);
          border-radius: var(--boxel-border-radius);
          margin-bottom: var(--boxel-sp-sm);
        }

        .question-number {
          font-weight: 600;
          color: var(--boxel-purple-700);
          margin-bottom: var(--boxel-sp-xs);
        }

        .points {
          margin-top: var(--boxel-sp-xs);
          font-size: var(--boxel-font-sm);
          color: var(--boxel-dark);
        }

        .upload-container {
          display: flex;
          gap: var(--boxel-sp-sm);
          align-items: center;
        }

        .grade-button {
          padding: var(--boxel-sp-xs) var(--boxel-sp-sm);
          background: var(--boxel-purple-600);
          color: white;
          border: none;
          border-radius: var(--boxel-border-radius);
          cursor: pointer;
          font-weight: 500;
        }

        .grade-button:disabled {
          background: var(--boxel-purple-300);
          cursor: not-allowed;
        }

        .score-summary {
          margin-top: var(--boxel-sp-xl);
          padding-top: var(--boxel-sp-sm);
          border-top: 2px solid var(--boxel-purple-200);
        }

        .total-score {
          font-size: var(--boxel-font-size-lg);
          font-weight: 600;
          color: var(--boxel-purple-900);
        }
      </style>
    </template>
  };

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='homework-card'>
        <div class='main-info'>
          <h3>{{@model.title}}</h3>
          <div class='course'>{{@model.courseTitle}}</div>
        </div>
        <div class='meta-info'>
          <div class='due'>Due: {{@model.dueDate}}</div>
          {{#if @model.status}}
            <div class='status {{@model.status}}'>{{@model.status}}</div>
          {{/if}}
        </div>
      </div>
      <style scoped>
        .homework-card {
          padding: var(--boxel-sp-sm);
          background: var(--boxel-light);
          border-radius: var(--boxel-border-radius);
          display: flex;
          justify-content: space-between;
          align-items: center;
        }

        h3 {
          margin: 0 0 var(--boxel-sp-xxs);
          font-size: var(--boxel-font-size);
        }

        .course {
          color: var(--boxel-dark);
          font-size: var(--boxel-font-sm);
        }

        .meta-info {
          text-align: right;
        }

        .due {
          font-size: var(--boxel-font-sm);
          color: var(--boxel-purple-600);
        }

        .status {
          font-size: var(--boxel-font-sm);
          font-weight: 500;
          margin-top: var(--boxel-sp-xxs);
        }

        .status.graded {
          color: var(--boxel-purple-700);
        }

        .status.grading {
          color: var(--boxel-yellow-700);
        }
      </style>
    </template>
  };
}