import { CardDef } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import LayoutList from '@cardstack/boxel-icons/layout-list';

export class DailyFeed extends CardDef {
  static displayName = 'Daily Feed';
  static prefersWideFormat = true;
  static icon = LayoutList;


  static isolated = class Isolated extends Component<typeof DailyFeed> {
    <template>
      <div class="daily-feed-container">
        <div class="column student-list">
          <h2>Classroom 2</h2>
          <div class="student-entries">
            <div class="student active">
              <div class="student-info">
                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=Albert&backgroundColor=b6e3f4" class="student-avatar" alt="Albert C. avatar" />
                <div class="student-details">
                  <span class="student-name">Albert C.</span>
                  <span class="student-tags">
                    <span class="tag medical">Allergy</span>
                  </span>
                </div>
              </div>
              <div class="status-indicator present"></div>
            </div>
            <div class="student">
              <div class="student-info">
                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah&backgroundColor=ffdfbf" class="student-avatar" alt="Sarah M. avatar" />
                <div class="student-details">
                  <span class="student-name">Sarah M.</span>
                  <span class="student-tags">
                    <span class="tag iep">IEP</span>
                  </span>
                </div>
              </div>
              <div class="status-indicator absent"></div>
            </div>
            <div class="student">
              <div class="student-info">
                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=James&backgroundColor=c1f4d1" class="student-avatar" alt="James P. avatar" />
                <div class="student-details">
                  <span class="student-name">James P.</span>
                  <span class="student-tags">
                    <span class="tag enrichment">GT</span>
                  </span>
                </div>
              </div>
              <div class="status-indicator present"></div>
            </div>
          </div>
        </div>

        <div class="column daily-overview">
          <h2>Daily Overview</h2>
          <div class="overview-card">
            <h3>Current Location</h3>
            <p class="location-info">
              <span class="location-icon">📍</span>
              Math Lab (Room 204)
              <span class="location-time">Since 10:00 AM</span>
            </p>
            
            <h3>Schedule</h3>
            <div class="schedule-item completed">
              <span class="time">9:00 AM</span>
              <div class="activity-info">
                <span class="activity">Morning Assembly</span>
                <span class="activity-tag attendance">✓ Present</span>
              </div>
            </div>
            <div class="schedule-item current">
              <span class="time">10:00 AM</span>
              <div class="activity-info">
                <span class="activity">Mathematics</span>
                <span class="activity-tag assessment">Quiz Today</span>
              </div>
            </div>
            <div class="schedule-item">
              <span class="time">11:30 AM</span>
              <div class="activity-info">
                <span class="activity">Science Lab</span>
                <span class="activity-tag project">Project Due</span>
              </div>
            </div>

            <h3>Objectives</h3>
            <ul class="objectives-list">
              <li class="priority-high">
                <span class="objective-status">⏰</span>
                Complete Math Quiz - Chapter 4 Fractions
              </li>
              <li class="priority-medium">
                <span class="objective-status">📊</span>
                Submit Science Project: Ecosystem Model
              </li>
            </ul>

            <h3>Special Notes</h3>
            <p class="special-note dietary">
              <span class="note-icon">🥗</span>
              Vegetarian Lunch - No dairy products
            </p>
            <p class="special-note pickup urgent">
              <span class="note-icon">⚠️</span>
              <strong>CHANGED:</strong> Pickup by Uncle John (3:30 PM)
              <span class="verification-status">✓ Verified</span>
            </p>
          </div>
        </div>

        <div class="column activity-feed">
          <h2>Albert C.'s Activity Feed</h2>
          <div class="post-composer">
            <input type="checkbox" id="academic-form-toggle" class="form-toggle academic-toggle" />
            <input type="checkbox" id="behavioral-form-toggle" class="form-toggle behavioral-toggle" />
            <input type="checkbox" id="social-form-toggle" class="form-toggle social-toggle" />
            <input type="checkbox" id="interpret-toggle" class="form-toggle interpret-toggle" />
            
            <div class="default-composer">
              <textarea 
                id="free-text-input"
                class="post-textarea"
                placeholder="What's happening with Albert C.?"
              ></textarea>
              <div class="composer-actions">
                <div class="tag-suggestions">
                  <label for="academic-form-toggle" class="tag academic">Academic</label>
                  <label for="behavioral-form-toggle" class="tag behavioral">Behavioral</label>
                  <label for="social-form-toggle" class="tag social">Social</label>
                </div>
                <div class="action-buttons">
                  <button class="upload-button" type="button">
                    <span class="upload-icon">📷</span>
                  </button>
                  <button class="upload-button" type="button">
                    <span class="upload-icon">📎</span>
                  </button>
                  <label for="interpret-toggle" class="interpret-button" type="button">
                    <span class="ai-icon">🤖</span>
                    <span class="interpret-text">Interpret</span>
                    <span class="interpreting-text">Analyzing...</span>
                  </label>
                  <button class="post-button" type="button">Post Update</button>
                </div>
              </div>
            </div>

            <!-- Academic Form -->
            <div class="structured-form academic-form">
              <div class="form-header">
                <div class="form-header-content">
                  <span class="tag academic">Academic Update</span>
                  <span class="form-subtitle">Record academic progress and understanding</span>
                </div>
                <label for="academic-form-toggle" class="close-button">×</label>
              </div>
              <div class="form-fields">
                <div class="form-row">
                  <div class="form-group flex-1">
                    <label class="form-label">Subject</label>
                    <select class="form-select">
                      <option>Mathematics</option>
                      <option>Science</option>
                      <option>English</option>
                      <option>Social Studies</option>
                      <option>Art</option>
                      <option>Music</option>
                      <option>Physical Education</option>
                    </select>
                  </div>
                  <div class="form-group flex-2">
                    <label class="form-label">Topic Covered</label>
                    <input type="text" class="form-input" placeholder="e.g., Chapter 4: Fractions" />
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Understanding Level</label>
                  <div class="understanding-levels">
                    <label class="level">
                      <input type="radio" name="understanding" />
                      <span class="level-indicator needs-help">
                        <span class="level-icon">⚠️</span>
                        Needs Help
                        <span class="level-desc">Requires additional support</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="understanding" />
                      <span class="level-indicator getting-there">
                        <span class="level-icon">📈</span>
                        Getting There
                        <span class="level-desc">Making progress</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="understanding" />
                      <span class="level-indicator proficient">
                        <span class="level-icon">✓</span>
                        Proficient
                        <span class="level-desc">Meets expectations</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="understanding" />
                      <span class="level-indicator excellent">
                        <span class="level-icon">⭐</span>
                        Excellent
                        <span class="level-desc">Exceeds expectations</span>
                      </span>
                    </label>
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Detailed Notes</label>
                  <textarea class="form-textarea" placeholder="Describe specific achievements, challenges, and observations..."></textarea>
                </div>
                <div class="form-actions">
                  <label for="academic-form-toggle" class="cancel-button">Cancel</label>
                  <button class="post-button" type="button">Record Progress</button>
                </div>
              </div>
            </div>

            <!-- Behavioral Form -->
            <div class="structured-form behavioral-form">
              <div class="form-header">
                <div class="form-header-content">
                  <span class="tag behavioral">Behavioral Update</span>
                  <span class="form-subtitle">Document behavior patterns and interventions</span>
                </div>
                <label for="behavioral-form-toggle" class="close-button">×</label>
              </div>
              <div class="form-fields">
                <div class="form-row">
                  <div class="form-group flex-1">
                    <label class="form-label">Behavior Type</label>
                    <select class="form-select">
                      <option>Classroom Conduct</option>
                      <option>Peer Interaction</option>
                      <option>Task Engagement</option>
                      <option>Following Instructions</option>
                      <option>Emotional Regulation</option>
                      <option>Conflict Resolution</option>
                    </select>
                  </div>
                  <div class="form-group flex-2">
                    <label class="form-label">Context/Setting</label>
                    <input type="text" class="form-input" placeholder="e.g., During group work, After recess" />
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Behavior Rating</label>
                  <div class="understanding-levels">
                    <label class="level">
                      <input type="radio" name="behavior" />
                      <span class="level-indicator needs-help">
                        <span class="level-icon">⚠️</span>
                        Concerning
                        <span class="level-desc">Needs immediate attention</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="behavior" />
                      <span class="level-indicator getting-there">
                        <span class="level-icon">📈</span>
                        Improving
                        <span class="level-desc">Shows progress</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="behavior" />
                      <span class="level-indicator proficient">
                        <span class="level-icon">✓</span>
                        Good
                        <span class="level-desc">Meets expectations</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="behavior" />
                      <span class="level-indicator excellent">
                        <span class="level-icon">🌟</span>
                        Excellent
                        <span class="level-desc">Role model behavior</span>
                      </span>
                    </label>
                  </div>
                </div>
                <div class="form-row">
                  <div class="form-group flex-1">
                    <label class="form-label">Actions Taken</label>
                    <textarea class="form-textarea" placeholder="What interventions or reinforcements were used..."></textarea>
                  </div>
                  <div class="form-group flex-1">
                    <label class="form-label">Next Steps</label>
                    <textarea class="form-textarea" placeholder="Recommended follow-up actions..."></textarea>
                  </div>
                </div>
                <div class="form-actions">
                  <label for="behavioral-form-toggle" class="cancel-button">Cancel</label>
                  <button class="post-button" type="button">Record Behavior</button>
                </div>
              </div>
            </div>

            <!-- Social Form -->
            <div class="structured-form social-form">
              <div class="form-header">
                <div class="form-header-content">
                  <span class="tag social">Social Update</span>
                  <span class="form-subtitle">Track social development and interactions</span>
                </div>
                <label for="social-form-toggle" class="close-button">×</label>
              </div>
              <div class="form-fields">
                <div class="form-row">
                  <div class="form-group flex-1">
                    <label class="form-label">Activity Type</label>
                    <select class="form-select">
                      <option>Group Work</option>
                      <option>Playground Interaction</option>
                      <option>Class Participation</option>
                      <option>Social Event</option>
                      <option>Team Activity</option>
                      <option>Peer Mentoring</option>
                    </select>
                  </div>
                  <div class="form-group flex-1">
                    <label class="form-label">Group Size</label>
                    <select class="form-select">
                      <option>One-on-One</option>
                      <option>Small Group (2-4)</option>
                      <option>Medium Group (5-8)</option>
                      <option>Large Group (9+)</option>
                      <option>Whole Class</option>
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Interaction Quality</label>
                  <div class="understanding-levels">
                    <label class="level">
                      <input type="radio" name="social" />
                      <span class="level-indicator needs-help">
                        <span class="level-icon">😶</span>
                        Reserved
                        <span class="level-desc">Limited engagement</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="social" />
                      <span class="level-indicator getting-there">
                        <span class="level-icon">🤝</span>
                        Participating
                        <span class="level-desc">Active listener</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="social" />
                      <span class="level-indicator proficient">
                        <span class="level-icon">💬</span>
                        Engaged
                        <span class="level-desc">Active contributor</span>
                      </span>
                    </label>
                    <label class="level">
                      <input type="radio" name="social" />
                      <span class="level-indicator excellent">
                        <span class="level-icon">🌟</span>
                        Leading
                        <span class="level-desc">Guides others</span>
                      </span>
                    </label>
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Social Skills Demonstrated</label>
                  <div class="skill-tags">
                    <label class="skill-tag">
                      <input type="checkbox" name="skills" />
                      <span>Communication</span>
                    </label>
                    <label class="skill-tag">
                      <input type="checkbox" name="skills" />
                      <span>Collaboration</span>
                    </label>
                    <label class="skill-tag">
                      <input type="checkbox" name="skills" />
                      <span>Leadership</span>
                    </label>
                    <label class="skill-tag">
                      <input type="checkbox" name="skills" />
                      <span>Empathy</span>
                    </label>
                    <label class="skill-tag">
                      <input type="checkbox" name="skills" />
                      <span>Problem Solving</span>
                    </label>
                    <label class="skill-tag">
                      <input type="checkbox" name="skills" />
                      <span>Conflict Resolution</span>
                    </label>
                  </div>
                </div>
                <div class="form-group">
                  <label class="form-label">Detailed Observations</label>
                  <textarea class="form-textarea" placeholder="Describe social dynamics, interactions, and notable moments..."></textarea>
                </div>
                <div class="form-actions">
                  <label for="social-form-toggle" class="cancel-button">Cancel</label>
                  <button class="post-button" type="button">Record Social</button>
                </div>
              </div>
            </div>

            <!-- Interpretation Loading -->
            <div class="interpretation-overlay">
              <div class="interpretation-content">
                <div class="interpretation-spinner"></div>
                <p>AI analyzing your input...</p>
              </div>
            </div>
          </div>

          <div class="feed-entries">
            <div class="feed-entry highlight">
              <div class="entry-header">
                <img src="https://api.dicebear.com/7.x/personas/svg?seed=Thompson" class="avatar" alt="Teacher avatar" />
                <div class="entry-meta">
                  <div class="meta-top">
                    <span class="author">Ms. Thompson</span>
                    <span class="tag academic">Academic</span>
                  </div>
                  <span class="timestamp">2:15 PM</span>
                </div>
              </div>
              <p class="entry-content">
                <strong>Mathematics - Chapter 4: Fractions</strong><br>
                Demonstrated excellent understanding of fraction multiplication. Completed all advanced problems with 100% accuracy.
                <span class="understanding-badge excellent">
                  <span class="badge-icon">⭐</span> Excellent Understanding
                </span>
              </p>
              <div class="entry-attachments">
                <div class="attachment">
                  <span class="attachment-icon">📝</span>
                  Practice Problems.pdf
                </div>
              </div>
            </div>

            <div class="feed-entry">
              <div class="entry-header">
                <img src="https://api.dicebear.com/7.x/personas/svg?seed=Martinez" class="avatar" alt="Teacher avatar" />
                <div class="entry-meta">
                  <div class="meta-top">
                    <span class="author">Mr. Martinez</span>
                    <span class="tag behavioral">Behavioral</span>
                  </div>
                  <span class="timestamp">1:30 PM</span>
                </div>
              </div>
              <p class="entry-content">
                <strong>Task Engagement - Science Lab</strong><br>
                Showed exceptional focus during ecosystem modeling. Helped other students understand the concept.
                <span class="behavior-rating excellent">
                  <span class="rating-icon">🌟</span> Excellent Behavior
                </span>
              </p>
              <div class="entry-media">
                <img src="https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3" class="media-thumbnail" alt="Science project photo" />
                <span class="media-caption">Working on ecosystem model</span>
              </div>
            </div>

            <div class="feed-entry">
              <div class="entry-header">
                <img src="https://api.dicebear.com/7.x/personas/svg?seed=Chen" class="avatar" alt="Teacher avatar" />
                <div class="entry-meta">
                  <div class="meta-top">
                    <span class="author">Ms. Chen</span>
                    <span class="tag social">Social</span>
                  </div>
                  <span class="timestamp">11:45 AM</span>
                </div>
              </div>
              <p class="entry-content">
                <strong>Group Work - Science Project</strong><br>
                Led team discussion effectively, ensuring all group members contributed to the ecosystem project.
                <span class="interaction-quality excellent">
                  <span class="quality-icon">💬</span> Leading
                </span>
                <div class="demonstrated-skills">
                  <span class="skill">Leadership</span>
                  <span class="skill">Communication</span>
                  <span class="skill">Collaboration</span>
                </div>
              </p>
              <div class="entry-media">
                <img src="https://images.unsplash.com/photo-1588072432836-e10032774350?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3" class="media-thumbnail" alt="Group work photo" />
                <span class="media-caption">Leading group discussion</span>
              </div>
            </div>

            <div class="feed-entry">
              <div class="entry-header">
                <img src="https://api.dicebear.com/7.x/personas/svg?seed=Thompson" class="avatar" alt="Teacher avatar" />
                <div class="entry-meta">
                  <div class="meta-top">
                    <span class="author">Ms. Thompson</span>
                    <span class="tag academic">Academic</span>
                  </div>
                  <span class="timestamp">10:15 AM</span>
                </div>
              </div>
              <p class="entry-content">
                Albert showed exceptional problem-solving skills during today's math exercise. Successfully completed all advanced problems. 
                <span class="achievement">🌟 Math Excellence</span>
              </p>
              <div class="entry-attachments">
                <div class="attachment">
                  <span class="attachment-icon">📝</span>
                  Quiz Results.pdf
                </div>
              </div>
            </div>

            <div class="feed-entry">
              <div class="entry-header">
                <img src="https://api.dicebear.com/7.x/personas/svg?seed=Johnson" class="avatar" alt="Staff avatar" />
                <div class="entry-meta">
                  <div class="meta-top">
                    <span class="author">Mr. Johnson</span>
                    <span class="tag social">Social</span>
                  </div>
                  <span class="timestamp">9:30 AM</span>
                </div>
              </div>
              <p class="entry-content">
                Led the morning assembly presentation on recycling. Demonstrated excellent public speaking skills and environmental awareness.
              </p>
              <div class="entry-media">
                <img src="https://images.unsplash.com/photo-1544717305-2782549b5136?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3" class="media-thumbnail" alt="Assembly presentation" />
                <span class="media-caption">Morning assembly presentation</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <style scoped>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap');

        .daily-feed-container {
          display: grid;
          grid-template-columns: 220px 280px 1fr;
          gap: 1px;
          height: 100vh;
          background-color: rgb(28, 28, 30);
          font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Inter', sans-serif;
          overflow: hidden; /* Prevent container scroll */
        }

        .column {
          background: rgb(28, 28, 30);
          height: 100vh;
          overflow-y: auto;
          padding: 0;
          box-shadow: none;
          border-radius: 0;
          color: rgb(255, 255, 255);
          position: relative; /* For sticky headers */
        }

        /* Column Headers */
        .column h2 {
          position: sticky;
          top: 0;
          margin: 0;
          padding: var(--boxel-sp-xs) var(--boxel-sp);
          background: inherit;
          z-index: 10;
          border-bottom: 1px solid rgb(58, 58, 60);
        }

        /* Student List Padding */
        .student-entries {
          padding: var(--boxel-sp-xs);
        }

        .student {
          margin-bottom: 1px;
          padding: var(--boxel-sp-xs) var(--boxel-sp-sm);
        }

        /* Daily Overview Density */
        .overview-card h3 {
          font-size: 13px;
          margin: var(--boxel-sp-xs) var(--boxel-sp);
          margin-bottom: 2px;
        }

        .location-info {
          padding: var(--boxel-sp-xs) var(--boxel-sp);
          margin-bottom: 2px;
        }

        .schedule-item {
          padding: var(--boxel-sp-xxs) var(--boxel-sp);
        }

        .objectives-list li {
          padding: var(--boxel-sp-xxs) var(--boxel-sp);
        }

        .special-note {
          padding: var(--boxel-sp-xxs) var(--boxel-sp);
        }

        /* Activity Feed Padding */
        .activity-feed {
          background-color: rgb(250, 250, 250);
        }

        .post-composer {
          position: sticky;
          top: 45px;
          padding: var(--boxel-sp);
          margin: 0 var(--boxel-sp-xs);
        }

        .feed-entries {
          padding: var(--boxel-sp);
        }

        .feed-entry {
          margin: 0 var(--boxel-sp-xs) var(--boxel-sp);
        }

        /* Scrollbar Styling */
        .column::-webkit-scrollbar {
          width: 8px;
        }

        .column::-webkit-scrollbar-track {
          background: transparent;
        }

        .column::-webkit-scrollbar-thumb {
          background-color: rgba(255, 255, 255, 0.1);
          border-radius: 4px;
        }

        .column::-webkit-scrollbar-thumb:hover {
          background-color: rgba(255, 255, 255, 0.2);
        }

        .activity-feed::-webkit-scrollbar-thumb {
          background-color: rgba(0, 0, 0, 0.1);
        }

        .activity-feed::-webkit-scrollbar-thumb:hover {
          background-color: rgba(0, 0, 0, 0.2);
        }

        .student-list {
          background-color: rgb(44, 44, 46);
        }

        .student-list h2 {
          background-color: rgb(44, 44, 46);
          color: rgb(255, 255, 255);
          border-bottom-color: rgb(58, 58, 60);
          font-weight: 600;
          letter-spacing: -0.3px;
        }

        .student {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: var(--boxel-sp-xs) var(--boxel-sp);
          border-bottom: 1px solid rgb(58, 58, 60);
          cursor: pointer;
          transition: all 0.2s ease;
          color: rgb(255, 255, 255);
        }

        .student-info {
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-xs);
        }

        .student-avatar {
          width: 28px;
          height: 28px;
          border-radius: 50%;
          background-color: rgb(58, 58, 60);
        }

        .student-details {
          display: flex;
          flex-direction: column;
          gap: 2px;
        }

        .student-name {
          font-weight: 500;
          letter-spacing: -0.3px;
        }

        .student-tags {
          display: flex;
          gap: 4px;
        }

        .tag {
          font-size: 11px;
          padding: 1px 6px;
          border-radius: 4px;
          font-weight: 500;
        }

        .tag.medical {
          background-color: rgba(255, 69, 58, 0.2);
          color: rgb(255, 69, 58);
        }

        .tag.iep {
          background-color: rgba(255, 159, 10, 0.2);
          color: rgb(255, 159, 10);
        }

        .tag.enrichment {
          background-color: rgba(48, 209, 88, 0.2);
          color: rgb(48, 209, 88);
        }

        .tag.academic {
          background-color: rgba(10, 132, 255, 0.2);
          color: rgb(10, 132, 255);
        }

        .tag.behavioral {
          background-color: rgba(191, 90, 242, 0.2);
          color: rgb(191, 90, 242);
        }

        .tag.social {
          background-color: rgba(94, 92, 230, 0.2);
          color: rgb(94, 92, 230);
        }

        .student:hover {
          background-color: rgb(58, 58, 60);
        }

        .student.active {
          background-color: rgba(10, 132, 255, 0.2);
          border-left: 3px solid rgb(10, 132, 255);
        }

        .status-indicator {
          width: 8px;
          height: 8px;
          border-radius: 50%;
        }

        .status-indicator.present {
          background-color: rgb(48, 209, 88);
        }

        .status-indicator.absent {
          background-color: rgb(255, 69, 58);
        }

        .overview-card {
          padding: 0;
          background-color: rgb(28, 28, 30);
        }

        .location-time {
          color: rgb(174, 174, 178);
          font-size: 12px;
          margin-left: auto;
        }

        .activity-info {
          display: flex;
          flex-direction: column;
          gap: 2px;
        }

        .activity-tag {
          font-size: 11px;
          color: rgb(174, 174, 178);
        }

        .activity-tag.assessment {
          color: rgb(255, 159, 10);
        }

        .activity-tag.project {
          color: rgb(191, 90, 242);
        }

        .objectives-list {
          list-style-type: none;
          padding: 0;
          margin: 0;
          font-size: 13px;
        }

        .priority-high {
          color: rgb(255, 69, 58);
        }

        .priority-medium {
          color: rgb(255, 159, 10);
        }

        .special-note.dietary {
          background-color: rgba(48, 209, 88, 0.1);
          border-left-color: rgb(48, 209, 88);
        }

        .special-note.pickup.urgent {
          background-color: rgba(255, 69, 58, 0.1);
          border-left-color: rgb(255, 69, 58);
        }

        .verification-status {
          margin-left: auto;
          color: rgb(48, 209, 88);
          font-size: 12px;
        }

        .activity-feed {
          background-color: rgb(250, 250, 250);
          color: rgb(0, 0, 0);
        }

        .activity-feed h2 {
          background-color: rgb(250, 250, 250);
          color: rgb(0, 0, 0);
          border-bottom-color: rgb(230, 230, 230);
          font-weight: 600;
          letter-spacing: -0.3px;
        }

        .post-composer {
          position: sticky;
          top: 45px;
          background: rgb(250, 250, 250);
          padding: var(--boxel-sp);
          border-bottom: 1px solid rgb(230, 230, 230);
          z-index: 1;
        }

        .composer-actions {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }

        .tag-suggestions {
          display: flex;
          gap: 4px;
        }

        .tag-suggestions button {
          border: none;
          background: none;
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 12px;
          cursor: pointer;
          font-weight: 500;
        }

        .post-textarea {
          width: 100%;
          min-height: 60px;
          padding: var(--boxel-sp-xs);
          border: 1px solid rgb(210, 210, 210);
          border-radius: var(--boxel-border-radius-sm);
          margin-bottom: var(--boxel-sp-xs);
          resize: vertical;
          font-family: inherit;
          font-size: 13px;
          background-color: white;
          color: rgb(51, 51, 51);
        }

        .post-textarea:focus {
          outline: none;
          border-color: rgb(0, 122, 255);
          box-shadow: 0 0 0 2px rgba(0, 122, 255, 0.2);
        }

        .post-textarea::placeholder {
          color: rgb(128, 128, 128);
        }

        .post-button {
          background-color: rgb(0, 122, 255);
          color: white;
          border: none;
          padding: 4px var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          cursor: pointer;
          transition: all 0.2s ease;
          font-size: 12px;
          font-weight: 500;
        }

        .post-button:hover {
          background-color: rgb(0, 113, 235);
        }

        .feed-entries {
          display: flex;
          flex-direction: column;
          padding: var(--boxel-sp);
        }

        .feed-entry {
          padding: var(--boxel-sp);
          border-radius: var(--boxel-border-radius-sm);
          background-color: white;
          border: 1px solid rgb(230, 230, 230);
          margin-bottom: var(--boxel-sp);
          transition: all 0.2s ease;
        }

        .feed-entry.highlight {
          background-color: rgba(10, 132, 255, 0.05);
          border-color: rgba(10, 132, 255, 0.2);
        }

        .feed-entry:hover {
          transform: translateY(-1px);
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .entry-header {
          display: flex;
          align-items: flex-start;
          gap: var(--boxel-sp-xs);
          margin-bottom: var(--boxel-sp-xs);
        }

        .avatar {
          width: 36px;
          height: 36px;
          border-radius: 50%;
          border: 2px solid rgb(230, 230, 230);
        }

        .entry-meta {
          flex: 1;
        }

        .meta-top {
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-xs);
        }

        .author {
          font-weight: 600;
          color: rgb(0, 0, 0);
          letter-spacing: -0.3px;
        }

        .timestamp {
          font-size: 12px;
          color: rgb(128, 128, 128);
        }

        .entry-content {
          margin: 0;
          line-height: 1.5;
          color: rgb(51, 51, 51);
          font-size: 14px;
        }

        .achievement {
          display: inline-block;
          margin-top: 4px;
          padding: 2px 8px;
          background-color: rgba(48, 209, 88, 0.1);
          color: rgb(48, 209, 88);
          border-radius: 4px;
          font-size: 12px;
          font-weight: 500;
        }

        .entry-attachments {
          margin-top: var(--boxel-sp-xs);
          padding-top: var(--boxel-sp-xs);
          border-top: 1px solid rgb(230, 230, 230);
        }

        .attachment {
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-xs);
          font-size: 12px;
          color: rgb(128, 128, 128);
          cursor: pointer;
        }

        .attachment:hover {
          color: rgb(0, 122, 255);
        }

        .form-toggle {
          display: none;
        }

        .structured-form {
          display: none;
          background: white;
          border-radius: var(--boxel-border-radius-sm);
          border: 1px solid rgb(230, 230, 230);
        }

        .academic-toggle:checked ~ .default-composer,
        .behavioral-toggle:checked ~ .default-composer,
        .social-toggle:checked ~ .default-composer {
          display: none;
        }

        .academic-toggle:checked ~ .academic-form {
          display: block;
        }

        .behavioral-toggle:checked ~ .behavioral-form {
          display: block;
        }

        .social-toggle:checked ~ .social-form {
          display: block;
        }

        .interpret-button {
          position: relative;
          overflow: hidden;
        }

        .interpreting-text {
          display: none;
        }

        .interpret-toggle:checked ~ .default-composer .interpret-button .interpret-text {
          display: none;
        }

        .interpret-toggle:checked ~ .default-composer .interpret-button .interpreting-text {
          display: inline;
        }

        .interpret-toggle:checked ~ .default-composer .interpret-button {
          background-color: rgb(128, 128, 128);
          cursor: wait;
        }

        .interpretation-overlay {
          display: none;
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          height: 60px;
          background-color: rgba(255, 255, 255, 0.9);
          z-index: 2;
          justify-content: center;
          align-items: center;
        }

        .interpretation-content {
          text-align: center;
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-xs);
        }

        .interpretation-spinner {
          width: 16px;
          height: 16px;
          border: 2px solid rgb(191, 90, 242);
          border-radius: 50%;
          border-top-color: transparent;
          animation: spin 0.6s linear infinite;
        }

        @keyframes spin {
          to { transform: rotate(360deg); }
        }

        .interpretation-content p {
          font-size: 12px;
          margin: 0;
          color: rgb(191, 90, 242);
        }

        .interpret-toggle:checked ~ .academic-form,
        .interpret-toggle:checked ~ .behavioral-form,
        .interpret-toggle:checked ~ .social-form {
          display: none;
        }

        .interpret-toggle:checked ~ .academic-form {
          display: block;
          animation: formAppear 0.3s ease 0.4s forwards;
          opacity: 0;
        }

        @keyframes formAppear {
          from {
            opacity: 0;
            transform: translateY(-4px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        .interpret-toggle:checked ~ .academic-form .form-fields {
          animation: none;
          opacity: 1;
        }

        .interpret-button {
          display: inline-flex;
          align-items: center;
          gap: 4px;
          padding: 4px var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          font-size: 12px;
          font-weight: 500;
          background-color: rgb(191, 90, 242);
          color: white;
          border: none;
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .interpret-button:hover {
          background-color: rgb(171, 70, 222);
        }

        .interpret-toggle:checked ~ .default-composer .interpret-button {
          background-color: rgb(128, 128, 128);
          pointer-events: none;
        }

        .ai-icon {
          font-size: 14px;
          line-height: 1;
        }

        .interpret-toggle:checked ~ .default-composer .post-textarea {
          pointer-events: none;
          opacity: 0.7;
        }

        .form-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: var(--boxel-sp-xs) var(--boxel-sp);
          border-bottom: 1px solid rgb(230, 230, 230);
          background-color: rgb(250, 250, 250);
        }

        .form-header-content {
          display: flex;
          flex-direction: column;
          gap: 2px;
        }

        .form-subtitle {
          font-size: 11px;
          color: rgb(128, 128, 128);
        }

        .form-row {
          display: flex;
          gap: var(--boxel-sp-xs);
          margin-bottom: var(--boxel-sp-xs);
        }

        .flex-1 {
          flex: 1;
        }

        .flex-2 {
          flex: 2;
        }

        .form-fields {
          padding: var(--boxel-sp-xs);
        }

        .form-group {
          margin-bottom: var(--boxel-sp-xs);
        }

        .form-actions {
          display: flex;
          justify-content: flex-end;
          gap: var(--boxel-sp-xs);
          margin-top: var(--boxel-sp-xs);
          padding-top: var(--boxel-sp-xs);
          border-top: 1px solid rgb(230, 230, 230);
        }

        .form-label {
          display: block;
          font-size: 11px;
          font-weight: 500;
          color: rgb(51, 51, 51);
          margin-bottom: 2px;
        }

        .form-select,
        .form-input {
          width: 100%;
          height: 28px;
          padding: 0 var(--boxel-sp-xs);
          border: 1px solid rgb(210, 210, 210);
          border-radius: var(--boxel-border-radius-sm);
          font-size: 12px;
          font-family: inherit;
          background-color: white;
          color: rgb(51, 51, 51);
        }

        .form-textarea {
          width: 100%;
          min-height: 60px;
          padding: var(--boxel-sp-xs);
          border: 1px solid rgb(210, 210, 210);
          border-radius: var(--boxel-border-radius-sm);
          font-size: 12px;
          font-family: inherit;
          background-color: white;
          color: rgb(51, 51, 51);
          resize: vertical;
        }

        .cancel-button {
          padding: 4px var(--boxel-sp-xs);
          color: rgb(128, 128, 128);
          cursor: pointer;
          font-size: 12px;
          font-weight: 500;
        }

        .understanding-levels {
          display: flex;
          gap: var(--boxel-sp-xs);
        }

        .level {
          flex: 1;
        }

        .level-indicator {
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 2px;
          padding: 4px;
          border-radius: var(--boxel-border-radius-sm);
          font-size: 11px;
          font-weight: 500;
          cursor: pointer;
          border: 1px solid transparent;
          transition: all 0.2s ease;
          min-height: 52px;
        }

        .level-icon {
          font-size: 14px;
        }

        .level-desc {
          font-size: 10px;
          color: rgb(128, 128, 128);
          font-weight: normal;
          text-align: center;
          line-height: 1.2;
        }

        .skill-tags {
          display: flex;
          flex-wrap: wrap;
          gap: 4px;
          margin-top: 2px;
        }

        .skill-tag span {
          display: inline-block;
          padding: 2px 6px;
          border-radius: 10px;
          font-size: 11px;
          background-color: rgb(240, 240, 240);
          color: rgb(51, 51, 51);
          transition: all 0.2s ease;
        }

        .post-button {
          padding: 4px var(--boxel-sp-xs);
          font-size: 12px;
        }

        .interpretation-spinner {
          width: 32px;
          height: 32px;
          border-width: 2px;
          margin: 0 auto var(--boxel-sp-xs);
        }

        .interpretation-content p {
          font-size: 12px;
          margin: 0;
        }

        .post-textarea {
          min-height: 60px;
          font-size: 13px;
          margin-bottom: var(--boxel-sp-xs);
        }

        .tag-suggestions {
          gap: 4px;
        }

        .tag {
          padding: 2px 6px;
        }

        .interpret-button {
          padding: 4px var(--boxel-sp-xs);
          font-size: 12px;
        }

        .ai-icon {
          font-size: 14px;
        }

        .upload-button {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          width: 28px;
          height: 28px;
          border: 1px solid rgb(210, 210, 210);
          border-radius: var(--boxel-border-radius-sm);
          background-color: white;
          color: rgb(128, 128, 128);
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .upload-button:hover {
          border-color: rgb(0, 122, 255);
          color: rgb(0, 122, 255);
        }

        .upload-icon {
          font-size: 14px;
        }

        .entry-media {
          margin-top: var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          overflow: hidden;
          border: 1px solid rgb(230, 230, 230);
        }

        .media-thumbnail {
          width: 120px;
          height: 80px;
          object-fit: cover;
          display: block;
        }

        .media-caption {
          display: block;
          padding: 4px var(--boxel-sp-xs);
          font-size: 11px;
          color: rgb(128, 128, 128);
          background-color: rgb(250, 250, 250);
        }

        .understanding-badge,
        .behavior-rating,
        .interaction-quality {
          display: inline-flex;
          align-items: center;
          gap: 4px;
          margin-top: 4px;
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 12px;
          font-weight: 500;
        }

        .understanding-badge.excellent,
        .behavior-rating.excellent,
        .interaction-quality.excellent {
          background-color: rgba(191, 90, 242, 0.1);
          color: rgb(191, 90, 242);
        }

        .demonstrated-skills {
          margin-top: var(--boxel-sp-xs);
          display: flex;
          gap: 4px;
          flex-wrap: wrap;
        }

        .skill {
          padding: 2px 8px;
          background-color: rgb(240, 240, 240);
          border-radius: 10px;
          font-size: 11px;
          color: rgb(51, 51, 51);
        }
      </style>
    </template>
  };

  
}
