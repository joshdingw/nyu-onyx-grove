import { CardDef, Component, field, linksToMany } from 'https://cardstack.com/base/card-api';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { Student } from './student';  // Add this import

export class StudentList extends CardDef {
  static displayName = "Student List";

  @field students = linksToMany(() => Student);  // Changed from StudentCard to Student

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class='student-list'>
        <h2>Students</h2>
        <div class='student-grid'>
          {{#each this.args.model.students as |student index|}}
            <div class='student-item'>
              <@fields.students @index={{index}} />
            </div>
          {{/each}}
        </div>
      </div>
      <style scoped>
        .student-list {
          padding: 20px;
          max-width: 1200px;
          margin: 0 auto;
        }
        .student-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
          gap: 20px;
          margin-top: 20px;
        }
        .student-item {
          background: white;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          padding: 16px;
        }
        h2 {
          font-size: 24px;
          color: #333;
          margin-bottom: 20px;
        }
      </style>
    </template>
  }
}