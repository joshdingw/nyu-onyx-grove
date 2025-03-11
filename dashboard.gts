import { CardDef } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import Dashboard from '@cardstack/boxel-icons/dashboard';
import Book from '@cardstack/boxel-icons/book';
import Calendar from '@cardstack/boxel-icons/calendar';
import Message from '@cardstack/boxel-icons/message';
import Users from '@cardstack/boxel-icons/users';
import FileText from '@cardstack/boxel-icons/file-text';
import ChartBar from '@cardstack/boxel-icons/chart-bar';
import Settings from '@cardstack/boxel-icons/settings';
import Library from '@cardstack/boxel-icons/library';
import Bell from '@cardstack/boxel-icons/bell';

export class LavaDashboard extends CardDef {
  static displayName = "Lava Dashboard";
  static prefersWideFormat = true;
  static headerColor = '#FF4D00';
  static icon = ChartBar;

  static isolated = class Isolated extends Component<typeof this> {
    <template>
      <div class='dashboard-container'>
        <nav class='side-nav'>
          <div class='nav-header'>
            <img src='https://assets.grok.com/users/d81e68e2-c259-4a5f-904c-26187e7178d7/RUVtsesp9IS6F7GJ-generated_image.jpg' alt='Lava Logo' class='logo' />
            <span class='logo-text'>Lava LMS</span>
          </div>
          
          <div class='nav-links'>
            <a href='#' class='nav-item active'>
              <Dashboard />
              <span>Dashboard</span>
            </a>
            <a href='#' class='nav-item'>
              <Book />
              <span>Courses</span>
            </a>
            <a href='#' class='nav-item'>
              <Calendar />
              <span>Schedule</span>
            </a>
            <a href='#' class='nav-item'>
              <FileText />
              <span>Assignments</span>
            </a>
            <a href='#' class='nav-item'>
              <ChartBar />
              <span>Grades</span>
            </a>
            <a href='#' class='nav-item'>
              <Library />
              <span>Resources</span>
            </a>
            <a href='#' class='nav-item'>
              <Message />
              <span>Messages</span>
              <span class='badge'>3</span>
            </a>
            <a href='#' class='nav-item'>
              <Users />
              <span>Community</span>
            </a>
            <a href='#' class='nav-item'>
              <Bell />
              <span>Notifications</span>
              <span class='badge'>5</span>
            </a>
          </div>

          <div class='nav-footer'>
            <a href='#' class='nav-item'>
              <Settings />
              <span>Settings</span>
            </a>
          </div>
        </nav>

        <div class='dashboard'>
          <header class='dashboard-header'>
            <div class='school-info'>
              <h1>Lava Academy</h1>
              <p class='term'>Spring Term 2024 • Week 7 of 15</p>
            </div>
            <div class='quick-stats'>
              <div class='stat-card'>
                <span class='stat-number'>7</span>
                <span class='stat-label'>Active Courses</span>
              </div>
              <div class='stat-card'>
                <span class='stat-number'>12</span>
                <span class='stat-label'>Assignments Due</span>
              </div>
              <div class='stat-card'>
                <span class='stat-number'>94%</span>
                <span class='stat-label'>Attendance</span>
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
                      <p>Due April 12, 2024 • 3 days overdue</p>
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
                      <p>Due April 18, 2024 • 3 days remaining</p>
                    </div>
                    <div class='assignment-actions'>
                      <button class='button button-primary'>Start</button>
                    </div>
                  </div>
                  <div class='assignment-item due-soon'>
                    <div class='assignment-status'>
                      <span class='status-indicator'></span>
                      <span class='status-text'>Due Soon</span>
                    </div>
                    <div class='assignment-details'>
                      <h3>LIT240: Comparative Literature Essay</h3>
                      <p>Due April 22, 2024 • 7 days remaining</p>
                    </div>
                    <div class='assignment-actions'>
                      <button class='button button-primary'>Continue</button>
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
                      <p>Room 305 • Dr. Sarah Chen</p>
                    </div>
                  </div>
                  <div class='schedule-item current'>
                    <div class='time'>10:15 - 11:45</div>
                    <div class='class sciences'>
                      <h3>Physics & Engineering</h3>
                      <p>Lab 201 • Prof. James Miller</p>
                    </div>
                  </div>
                  <div class='schedule-item'>
                    <div class='time'>12:30 - 14:00</div>
                    <div class='class humanities'>
                      <h3>World Literature</h3>
                      <p>Room 118 • Dr. Emily Parker</p>
                    </div>
                  </div>
                  <div class='schedule-item'>
                    <div class='time'>14:15 - 15:45</div>
                    <div class='class languages'>
                      <h3>Advanced Latin</h3>
                      <p>Room 224 • Prof. Marcus Reid</p>
                    </div>
                  </div>
                </div>
              </section>

              <section class='courses-section'>
                <h2>My Courses</h2>
                <div class='course-grid'>
                  <div class='course-card'>
                    <div class='course-header advanced'>MATH405: Advanced Mathematics</div>
                    <div class='course-body'>
                      <p class='instructor'>Dr. Sarah Chen</p>
                      <div class='progress-bar'>
                        <div class='progress' style='width: 75%'></div>
                      </div>
                      <div class='course-details'>
                        <p class='progress-text'>75% Complete</p>
                        <p class='grade'>Current Grade: A-</p>
                      </div>
                    </div>
                  </div>
                  <div class='course-card'>
                    <div class='course-header sciences'>PHYS301: Physics & Engineering</div>
                    <div class='course-body'>
                      <p class='instructor'>Prof. James Miller</p>
                      <div class='progress-bar'>
                        <div class='progress' style='width: 60%'></div>
                      </div>
                      <div class='course-details'>
                        <p class='progress-text'>60% Complete</p>
                        <p class='grade'>Current Grade: B+</p>
                      </div>
                    </div>
                  </div>
                  <div class='course-card'>
                    <div class='course-header humanities'>LIT240: World Literature</div>
                    <div class='course-body'>
                      <p class='instructor'>Dr. Emily Parker</p>
                      <div class='progress-bar'>
                        <div class='progress' style='width: 88%'></div>
                      </div>
                      <div class='course-details'>
                        <p class='progress-text'>88% Complete</p>
                        <p class='grade'>Current Grade: A</p>
                      </div>
                    </div>
                  </div>
                  <div class='course-card'>
                    <div class='course-header languages'>LANG350: Advanced Latin</div>
                    <div class='course-body'>
                      <p class='instructor'>Prof. Marcus Reid</p>
                      <div class='progress-bar'>
                        <div class='progress' style='width: 45%'></div>
                      </div>
                      <div class='course-details'>
                        <p class='progress-text'>45% Complete</p>
                        <p class='grade'>Current Grade: B</p>
                      </div>
                    </div>
                  </div>
                  <div class='course-card'>
                    <div class='course-header computer-science'>CS330: Algorithm Design</div>
                    <div class='course-body'>
                      <p class='instructor'>Dr. Alan Zhang</p>
                      <div class='progress-bar'>
                        <div class='progress' style='width: 65%'></div>
                      </div>
                      <div class='course-details'>
                        <p class='progress-text'>65% Complete</p>
                        <p class='grade'>Current Grade: A-</p>
                      </div>
                    </div>
                  </div>
                  <div class='course-card'>
                    <div class='course-header biology'>BIO210: Molecular Biology</div>
                    <div class='course-body'>
                      <p class='instructor'>Dr. Maria Gonzalez</p>
                      <div class='progress-bar'>
                        <div class='progress' style='width: 78%'></div>
                      </div>
                      <div class='course-details'>
                        <p class='progress-text'>78% Complete</p>
                        <p class='grade'>Current Grade: B+</p>
                      </div>
                    </div>
                  </div>
                  <div class='course-card'>
                    <div class='course-header economics'>ECON250: Macroeconomics</div>
                    <div class='course-body'>
                      <p class='instructor'>Prof. Thomas Wilson</p>
                      <div class='progress-bar'>
                        <div class='progress' style='width: 55%'></div>
                      </div>
                      <div class='course-details'>
                        <p class='progress-text'>55% Complete</p>
                        <p class='grade'>Current Grade: A-</p>
                      </div>
                    </div>
                  </div>
                </div>
              </section>
            </div>

            <aside class='dashboard-sidebar'>
              <section class='user-profile'>
                <div class='user-info'>
                  <img src='https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=80&h=80&auto=format&fit=crop&crop=face' alt='User Profile' class='user-avatar' />
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
                      <h3>Physics Lab Report Due</h3>
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
                  <div class='event-item'>
                    <div class='event-date'>
                      <span class='day'>22</span>
                      <span class='month'>APR</span>
                    </div>
                    <div class='event-details'>
                      <h3>Literature Essay Due</h3>
                      <p>LIT240 • Comparative Analysis</p>
                    </div>
                  </div>
                  <div class='event-item'>
                    <div class='event-date'>
                      <span class='day'>25</span>
                      <span class='month'>APR</span>
                    </div>
                    <div class='event-details'>
                      <h3>Algorithm Design Test</h3>
                      <p>CS330 • Graph Algorithms</p>
                    </div>
                  </div>
                  <div class='event-item'>
                    <div class='event-date'>
                      <span class='day'>30</span>
                      <span class='month'>APR</span>
                    </div>
                    <div class='event-details'>
                      <h3>Economics Presentation</h3>
                      <p>ECON250 • Fiscal Policy Analysis</p>
                    </div>
                  </div>
                </div>
              </section>

              <section class='recent-notifications'>
                <div class='section-header'>
                  <h2>Notifications</h2>
                  <a href='#' class='see-all'>See All</a>
                </div>
                <div class='notification-list'>
                  <div class='notification-item unread'>
                    <div class='notification-icon'>
                      <Bell />
                    </div>
                    <div class='notification-content'>
                      <p>Your Physics Lab Report has been graded: <strong>A-</strong></p>
                      <span class='time'>1 hour ago</span>
                    </div>
                  </div>
                  <div class='notification-item unread'>
                    <div class='notification-icon'>
                      <Message />
                    </div>
                    <div class='notification-content'>
                      <p>New message from <strong>Dr. Sarah Chen</strong></p>
                      <span class='time'>3 hours ago</span>
                    </div>
                  </div>
                  <div class='notification-item'>
                    <div class='notification-icon'>
                      <FileText />
                    </div>
                    <div class='notification-content'>
                      <p>New assignment posted in <strong>LANG350</strong></p>
                      <span class='time'>Yesterday</span>
                    </div>
                  </div>
                  <div class='notification-item'>
                    <div class='notification-icon'>
                      <FileText />
                    </div>
                    <div class='notification-content'>
                      <p>Assignment deadline extended for <strong>MATH405</strong></p>
                      <span class='time'>Yesterday</span>
                    </div>
                  </div>
                </div>
              </section>
            </aside>
          </main>
        </div>
      </div>

      <style scoped>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap');
        
        :root {
          --background: 0 0% 100%;
          --foreground: 220 40% 12%;
          --card: 0 0% 100%;
          --card-foreground: 220 40% 12%;
          --popover: 0 0% 100%;
          --popover-foreground: 220 40% 12%;
          --primary: 16 95% 54%;
          --primary-foreground: 0 0% 100%;
          --secondary: 12 90% 97%;
          --secondary-foreground: 220 40% 12%;
          --muted: 12 30% 96%;
          --muted-foreground: 220 15% 40%;
          --accent: 16 95% 54%;
          --accent-foreground: 0 0% 100%;
          --destructive: 0 90% 60%;
          --destructive-foreground: 0 0% 100%;
          --border: 16 40% 88%;
          --input: 214.3 31.8% 91.4%;
          --ring: 16 95% 54%;
          --radius-xs: 4px;
          --radius-sm: 6px;
          --radius: 8px;
          --radius-lg: 10px;
          --radius-xl: 12px;
          --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
          
          /* Status colors - increased contrast */
          --success: 142 76% 42%;
          --warning: 38 95% 48%;
          --danger: 0 90% 55%;
          --info: 221 90% 50%;
          
          /* Course colors - adjusted for better contrast */
          --advanced-math: 16 95% 54%;
          --sciences: 20 90% 48%;
          --humanities: 12 85% 45%;
          --languages: 25 85% 55%;
          --computer-science: 4 89% 50%;
          --biology: 8 85% 48%;
          --economics: 0 85% 58%;
          --shadow-color: 20 15% 15%;  /* Darker and more saturated shadow */
        }

        .dashboard-container {
          display: flex;
          min-height: 100vh;
          font-family: var(--font-sans);
          letter-spacing: -0.011em;
          background-color: #f5f5f5;
        }

        .side-nav {
          width: 220px;
          background-color: hsl(var(--card));
          border-right: 1px solid hsl(var(--border));
          padding: 1rem 0;
          display: flex;
          flex-direction: column;
          height: 100vh;
          flex-shrink: 0;
          position: sticky;
          top: 0;
          box-shadow: 2px 0 20px rgba(0, 0, 0, 0.15);
          border-radius: 0 12px 12px 0;
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
          object-fit: cover;
          background-color: hsl(var(--primary));
        }

        .logo-text {
          font-size: 1.125rem;
          font-weight: 500;
          color: hsl(var(--foreground));
        }

        .nav-links {
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 0.125rem;
          padding: 0 0.5rem;
          overflow-y: auto;
        }

        .nav-footer {
          padding: 1rem 0.5rem 0;
          border-top: 1px solid hsl(var(--border));
        }

        .nav-item {
          display: flex;
          align-items: center;
          gap: 0.625rem;
          padding: 0.625rem 1rem;
          color: hsl(var(--muted-foreground));
          text-decoration: none;
          border-radius: 6px;
          transition: all 0.2s ease;
          position: relative;
          font-size: 0.8125rem;
        }

        .nav-item:hover {
          background-color: hsl(var(--accent));
          color: hsl(var(--accent-foreground));
        }

        .nav-item.active {
          background-color: hsl(var(--primary));
          color: hsl(var(--primary-foreground));
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .nav-item :deep(svg) {
          width: 18px;
          height: 18px;
        }

        .nav-item span {
          font-size: 0.8125rem;
          font-weight: 400;
        }

        .badge {
          position: absolute;
          right: 12px;
          top: 50%;
          transform: translateY(-50%);
          background-color: hsl(var(--destructive));
          color: hsl(var(--destructive-foreground));
          font-size: 0.6875rem;
          padding: 0.125rem 0.375rem;
          border-radius: 10px;
          font-weight: 500;
        }

        .dashboard {
          flex: 1;
          background-color: hsl(var(--muted));
          padding: 1rem;
          min-height: 100vh;
          overflow-y: auto;
        }

        .dashboard-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 1.25rem;
          padding-bottom: 1rem;
          border-bottom: 1px solid hsl(var(--border));
          background-color: hsl(var(--card));
          padding: 1rem;
          border-radius: 12px;
          box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .school-info h1 {
          font-size: 1.875rem;
          font-weight: 500;
          color: hsl(var(--foreground));
          margin: 0;
          letter-spacing: -0.03em;
        }

        .term {
          color: hsl(var(--muted-foreground));
          font-size: 0.9375rem;
          margin-top: 0.25rem;
        }

        .quick-stats {
          display: flex;
          gap: 1rem;
        }

        .stat-card {
          background: hsl(var(--card));
          padding: 0.625rem 1rem;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
          text-align: center;
          min-width: 80px;
          border: 1px solid hsl(var(--border));
        }

        .stat-number {
          display: block;
          font-size: 1.5rem;
          font-weight: 500;
          color: hsl(var(--foreground));
          letter-spacing: -0.02em;
        }

        .stat-label {
          color: hsl(var(--muted-foreground));
          font-size: 0.75rem;
        }

        .dashboard-content {
          display: grid;
          grid-template-columns: 1fr 300px;
          gap: 1rem;
        }

        .main-content {
          display: flex;
          flex-direction: column;
          gap: 1rem;
        }

        section {
          background-color: hsl(var(--card));
          border-radius: 12px;
          padding: 1rem;
          box-shadow: 0 6px 24px rgba(0, 0, 0, 0.12);
          border: 1px solid hsl(var(--border));
        }

        .section-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 0.75rem;
        }

        .section-header h2 {
          margin: 0;
        }

        .see-all {
          font-size: 0.75rem;
          color: hsl(var(--primary));
          text-decoration: none;
        }

        .see-all:hover {
          text-decoration: underline;
        }

        .date {
          font-size: 0.8125rem;
          color: hsl(var(--muted-foreground));
        }

        h2 {
          font-size: 1.125rem;
          font-weight: 500;
          color: hsl(var(--foreground));
          margin-top: 0;
          margin-bottom: 0.75rem;
          letter-spacing: -0.02em;
        }

        .course-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
          gap: 1rem;
        }

        .course-card {
          background: hsl(var(--card));
          border-radius: 12px;
          overflow: hidden;
          box-shadow: 0 6px 24px rgba(0, 0, 0, 0.12);
          border: 1px solid hsl(var(--border));
          transition: all 0.2s ease;
        }

        .course-card:hover {
          box-shadow: 0 12px 32px rgba(0, 0, 0, 0.18);
          transform: translateY(-2px);
        }

        .course-header {
          padding: 0.5rem 0.75rem;
          color: hsl(var(--primary-foreground));
          font-weight: 500;
          font-size: 0.8125rem;
        }

        .course-header.advanced { background-color: hsl(var(--advanced-math)); }
        .course-header.sciences { background-color: hsl(var(--sciences)); }
        .course-header.humanities { background-color: hsl(var(--humanities)); }
        .course-header.languages { background-color: hsl(var(--languages)); }
        .course-header.computer-science { background-color: hsl(var(--computer-science)); }
        .course-header.biology { background-color: hsl(var(--biology)); }
        .course-header.economics { background-color: hsl(var(--economics)); }

        .course-body {
          padding: 0.75rem;
        }

        .instructor {
          color: hsl(var(--muted-foreground));
          margin-bottom: 0.5rem;
          font-size: 0.75rem;
        }

        .progress-bar {
          height: 5px;
          background-color: hsl(var(--secondary));
          border-radius: 4px;
          overflow: hidden;
          margin: 0.5rem 0;
        }

        .progress {
          height: 100%;
          background-color: hsl(var(--primary));
          transition: width 0.3s ease;
          border-radius: 4px;
        }

        .course-details {
          display: flex;
          justify-content: space-between;
        }

        .progress-text, .grade {
          color: hsl(var(--foreground));
          font-size: 0.75rem;
          margin: 0;
        }

        .event-list {
          display: flex;
          flex-direction: column;
          gap: 0.625rem;
        }

        .event-item {
          display: flex;
          gap: 0.625rem;
          padding: 0.5rem;
          background: hsl(var(--card));
          border-radius: 8px;
          border: 1px solid hsl(var(--border));
        }

        .event-date {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          background: hsl(var(--primary));
          color: hsl(var(--primary-foreground));
          padding: 0.375rem 0.5rem;
          border-radius: 6px;
          min-width: 48px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .event-date .day {
          font-size: 1.125rem;
          font-weight: 500;
          line-height: 1;
        }

        .event-date .month {
          font-size: 0.75rem;
          font-weight: 400;
        }

        .event-details h3 {
          color: hsl(var(--foreground));
          font-size: 0.875rem;
          font-weight: 500;
          margin: 0;
        }

        .event-details p {
          color: hsl(var(--muted-foreground));
          font-size: 0.75rem;
          margin: 0.125rem 0 0;
        }

        .user-profile {
          margin-bottom: 1rem;
        }

        .user-info {
          display: flex;
          align-items: center;
          gap: 0.75rem;
        }

        .user-avatar {
          width: 42px;
          height: 42px;
          border-radius: 10px;
          object-fit: cover;
        }

        .user-info h3 {
          margin: 0;
          font-size: 1rem;
          font-weight: 500;
        }

        .user-info p {
          margin: 0.125rem 0 0;
          font-size: 0.75rem;
          color: hsl(var(--muted-foreground));
        }

        .notification-list {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }

        .notification-item {
          display: flex;
          gap: 0.625rem;
          padding: 0.625rem;
          border-radius: 8px;
          border: 1px solid hsl(var(--border));
        }

        .notification-item.unread {
          border-left: 3px solid hsl(var(--primary));
          background-color: hsl(var(--primary) / 0.08);
        }

        .notification-icon {
          color: hsl(var(--primary));
          display: flex;
          align-items: center;
          justify-content: center;
        }

        .notification-icon :deep(svg) {
          width: 16px;
          height: 16px;
        }

        .notification-content p {
          margin: 0;
          font-size: 0.75rem;
          color: hsl(var(--foreground));
        }

        .notification-content .time {
          font-size: 0.6875rem;
          color: hsl(var(--muted-foreground));
        }

        .current-assignments {
          margin-bottom: 1rem;
        }

        .assignment-list {
          display: flex;
          flex-direction: column;
          gap: 0.625rem;
        }

        .assignment-item {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 0.75rem;
          border-radius: 8px;
          border: 1px solid hsl(var(--border));
        }

        .assignment-item.overdue {
          border-left: 3px solid hsl(var(--danger));
        }

        .assignment-item.due-soon {
          border-left: 3px solid hsl(var(--warning));
        }

        .assignment-status {
          display: flex;
          align-items: center;
          gap: 0.375rem;
          min-width: 90px;
        }

        .status-indicator {
          width: 8px;
          height: 8px;
          border-radius: 4px;
        }

        .overdue .status-indicator {
          background-color: hsl(var(--danger));
        }

        .due-soon .status-indicator {
          background-color: hsl(var(--warning));
        }

        .status-text {
          font-size: 0.75rem;
          font-weight: 500;
        }

        .overdue .status-text {
          color: hsl(var(--danger));
        }

        .due-soon .status-text {
          color: hsl(var(--warning));
        }

        .assignment-details {
          flex: 1;
        }

        .assignment-details h3 {
          margin: 0;
          font-size: 0.875rem;
          font-weight: 500;
        }

        .assignment-details p {
          margin: 0.125rem 0 0;
          font-size: 0.75rem;
          color: hsl(var(--muted-foreground));
        }

        .assignment-actions {
          display: flex;
          gap: 0.5rem;
        }

        .button {
          padding: 0.375rem 0.75rem;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 500;
          border: none;
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .button-primary {
          background-color: hsl(var(--primary));
          color: hsl(var(--primary-foreground));
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .button-primary:hover {
          background-color: hsl(var(--primary) / 0.9);
          box-shadow: 0 6px 16px rgba(0, 0, 0, 0.25);
        }

        .today-schedule {
          margin-bottom: 1rem;
        }

        .schedule-timeline {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }

        .schedule-item {
          display: flex;
          gap: 0.625rem;
          padding: 0.5rem;
          border-radius: 8px;
          border: 1px solid hsl(var(--border));
        }

        .schedule-item.past {
          opacity: 0.7;
        }

        .schedule-item.current {
          border-left: 3px solid hsl(var(--primary));
          background-color: hsl(var(--primary) / 0.05);
        }

        .time {
          width: 100px;
          font-size: 0.75rem;
          color: hsl(var(--muted-foreground));
          padding-top: 2px;
        }

        .class {
          flex: 1;
          padding-left: 0.5rem;
          border-left: 2px solid;
        }

        .class.advanced {
          border-left-color: hsl(var(--advanced-math));
        }

        .class.sciences {
          border-left-color: hsl(var(--sciences));
        }

        .class.humanities {
          border-left-color: hsl(var(--humanities));
        }

        .class.languages {
          border-left-color: hsl(var(--languages));
        }

        .class h3 {
          margin: 0;
          font-size: 0.875rem;
          font-weight: 500;
        }

        .class p {
          margin: 0.125rem 0 0;
          font-size: 0.75rem;
          color: hsl(var(--muted-foreground));
        }
      </style>
    </template>
  };

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