import { CardDef, Component, field, contains, containsMany, linksTo } from 'https://cardstack.com/base/card-api';
import DateField from 'https://cardstack.com/base/date';
import StringField from 'https://cardstack.com/base/string';
import MarkdownField from 'https://cardstack.com/base/markdown';
import { Student } from "./student";

export class DailyRecord extends CardDef {
  static displayName = "Daily Record";

  @field date = contains(DateField);
  @field student = linksTo(() => Student);
  @field workTask = contains(MarkdownField);

  @field title = contains(StringField, {
    computeVia: function(this: DailyRecord) {
      const dateStr = this.date ? this.date.toLocaleDateString('en-US', {
        month: 'numeric',
        day: 'numeric',
        year: 'numeric'
      }) : '';
      const studentName = this.student?.title ?? '';
      
      if (!dateStr && !studentName) return 'Daily Record';
      if (!dateStr) return `Daily - ${studentName}`;
      if (!studentName) return `Daily - ${dateStr}`;
      
      return `Daily - ${dateStr} - ${studentName}`;
    }
  });

  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='edit-wrapper'>
        <div class='edit-container'>
          <div class='header-fields'>
            <@fields.student />
            <@fields.date />
          </div>
          <div class='markdown-container'>
            <@fields.workTask />
          </div>
        </div>
      </div>
      <style scoped>
        .edit-wrapper {
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          overflow: hidden;
        }

        .edit-container {
          height: 100%;
          display: grid;
          grid-template-rows: auto 1fr;
          padding: var(--boxel-sp);
          gap: var(--boxel-sp);
        }

        .header-fields {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: var(--boxel-sp);
        }

        .markdown-container {
          position: relative;
          overflow: hidden;
          display: flex;
        }

        .markdown-container :deep(*) {
          width: 100%;
          height: 100%;
        }

        .markdown-container :deep(textarea) {
          position: absolute;
          inset: 0;
          resize: none;
        }
      </style>
    </template>
  }
}