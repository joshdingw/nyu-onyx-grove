import { CardDef, field, contains, Component } from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export class StudentDashboard extends CardDef {
  static displayName = "Student Dashboard";

  @field studentName = contains(StringField);

  static isolated = class Isolated extends Component<typeof this> {
    @tracked currentView = 'home';

    @action
    switchView(view: string) {
      this.currentView = view;
    }

    <template>
      <div class='dashboard-container'>
        {{!-- 导航栏 --}}
        <nav class='nav-bar'>
          <div class='nav-logo'>
            <h1>学生仪表盘</h1>
          </div>
          <div class='nav-items'>
            <button 
              class='nav-item {{if (eq this.currentView "home") "active"}}' 
              {{on 'click' (fn this.switchView 'home')}}>
              主页
            </button>
            <button 
              class='nav-item {{if (eq this.currentView "courses") "active"}}' 
              {{on 'click' (fn this.switchView 'courses')}}>
              课程
            </button>
            <button 
              class='nav-item {{if (eq this.currentView "assignments") "active"}}' 
              {{on 'click' (fn this.switchView 'assignments')}}>
              作业
            </button>
          </div>
          <div class='nav-profile'>
            欢迎, {{@model.studentName}}
          </div>
        </nav>

        {{!-- 主要内容区域 --}}
        <main class='main-content'>
          {{#if (eq this.currentView 'home')}}
            <div class='home-view'>
              <h2>欢迎回来！</h2>
              <div class='dashboard-cards'>
                <div class='card'>
                  <h3>待完成作业</h3>
                  <p>您有 3 个待完成的作业</p>
                </div>
                <div class='card'>
                  <h3>近期课程</h3>
                  <p>今天有 2 节课程</p>
                </div>
                <div class='card'>
                  <h3>通知</h3>
                  <p>您有 1 条新通知</p>
                </div>
              </div>
            </div>
          {{/if}}
        </main>
      </div>

      <style scoped>
        .dashboard-container {
          display: flex;
          flex-direction: column;
          height: 100vh;
        }

        .nav-bar {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 1rem 2rem;
          background-color: #ffffff;
          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .nav-logo h1 {
          margin: 0;
          font-size: 1.5rem;
          color: #333;
        }

        .nav-items {
          display: flex;
          gap: 1rem;
        }

        .nav-item {
          padding: 0.5rem 1rem;
          border: none;
          background: none;
          cursor: pointer;
          font-size: 1rem;
          color: #666;
          border-radius: 4px;
          transition: all 0.3s ease;
        }

        .nav-item:hover {
          background-color: #f5f5f5;
        }

        .nav-item.active {
          background-color: #e0e0e0;
          color: #333;
        }

        .main-content {
          flex: 1;
          padding: 2rem;
          background-color: #f9f9f9;
        }

        .dashboard-cards {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
          gap: 1.5rem;
          margin-top: 2rem;
        }

        .card {
          background: white;
          padding: 1.5rem;
          border-radius: 8px;
          box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .card h3 {
          margin: 0 0 1rem 0;
          color: #333;
        }

        .card p {
          margin: 0;
          color: #666;
        }
      </style>
    </template>
  }

  static edit = class Edit extends Component<typeof this> {
    <template>
      <div class='edit-container'>
        <label>学生姓名:</label>
        <@fields.studentName />
      </div>

      <style scoped>
        .edit-container {
          padding: 1rem;
        }
        
        label {
          display: block;
          margin-bottom: 0.5rem;
          font-weight: bold;
        }
      </style>
    </template>
  }
}