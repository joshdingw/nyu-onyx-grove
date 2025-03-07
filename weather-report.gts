import { CardDef, field, contains } from 'https://cardstack.com/base/card-api';
import { Component } from 'https://cardstack.com/base/card-api';
import CloudSun from '@cardstack/boxel-icons/cloud-sun';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import RefreshIcon from '@cardstack/boxel-icons/refresh';
import { WeatherConditionsField } from './weather-conditions';

export class WeatherReport extends CardDef {
  static displayName = "Weather Report";
  static icon = CloudSun;

  @field currentConditions = contains(WeatherConditionsField);

  static isolated = class Isolated extends Component<typeof this> {
    @action
    refreshWeather() {
      this.args.model.currentConditions.timestamp = new Date();
    }

    formatTime(date?: Date) {
      const currentDate = date || new Date();
      const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      const dayName = days[currentDate.getDay()];
      let hours = currentDate.getHours();
      const minutes = currentDate.getMinutes().toString().padStart(2, '0');
      const ampm = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12;
      hours = hours ? hours : 12;
      
      return `${dayName} ${hours}:${minutes} ${ampm}`;
    }

    formatDayName(date?: Date) {
      if (!date) return '';
      const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      return days[date.getDay()];
    }

    <template>
      <div class='weather-container {{this.weatherClass}}'>
        <div class='weather-layout'>
          <div class='weather-card current-weather'>
            <div class='city-name'>{{@model.currentConditions.city}}</div>
            <div class='header'>
              <div class='timestamp'>
                {{this.formatTime @model.currentConditions.timestamp}}
              </div>
              <button 
                class='refresh-button' 
                type='button'
                {{on "click" this.refreshWeather}}
              >
                <RefreshIcon />
                <span class='boxel-sr-only'>Refresh Weather</span>
              </button>
            </div>
            
            <div class='main-weather'>
              <div class='temperature'>
                {{@model.currentConditions.temperature}}°
              </div>
              <div class='conditions'>
                {{@model.currentConditions.conditions}}
              </div>
            </div>

            <div class='weather-details'>
              <div class='detail-item'>
                <div class='detail-label'>Humidity</div>
                <div class='detail-value'>{{@model.currentConditions.humidity}}%</div>
              </div>
              
              <div class='detail-item'>
                <div class='detail-label'>Wind</div>
                <div class='detail-value'>{{@model.currentConditions.windSpeed}} mph {{@model.currentConditions.windDirection}}</div>
              </div>

              <div class='detail-item'>
                <div class='detail-label'>Pressure</div>
                <div class='detail-value'>{{@model.currentConditions.pressure}} hPa</div>
              </div>

              <div class='detail-item'>
                <div class='detail-label'>Visibility</div>
                <div class='detail-value'>{{@model.currentConditions.visibility}} mi</div>
              </div>
            </div>
          </div>

          <div class='forecast-container'>
            {{#each @model.currentConditions.forecast as |day|}}
              <div class='forecast-day'>
                <div class='forecast-date'>
                  {{this.formatDayName day.date}}
                </div>
                <div class='forecast-temps'>
                  <span class='high-temp'>{{day.highTemp}}°</span>
                  <span class='low-temp'>{{day.lowTemp}}°</span>
                </div>
                <div class='forecast-conditions'>
                  {{day.conditions}}
                </div>
              </div>
            {{/each}}
          </div>
        </div>
      </div>
      <style scoped>
        .weather-container {
          min-height: 100vh;
          width: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
          padding: var(--boxel-sp-lg);
          color: white;
          background: linear-gradient(180deg, #2c3e50 0%, #3498db 100%);
          transition: background 0.3s ease;
        }

        .city-name {
          font-size: var(--boxel-font-size-xl);
          font-weight: 600;
          text-align: center;
          margin-bottom: var(--boxel-sp-sm);
        }

        .weather-layout {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-lg);
          width: 100%;
          max-width: 800px;
        }

        /* Weather condition-specific backgrounds */
        .weather-container.clear {
          background: linear-gradient(180deg, #2980b9 0%, #6dd5fa 100%);
        }

        .weather-container.cloudy {
          background: linear-gradient(180deg, #606c88 0%, #3f4c6b 100%);
        }

        .weather-container.rain {
          background: linear-gradient(180deg, #4B79A1 0%, #283E51 100%);
        }

        .weather-container.snow {
          background: linear-gradient(180deg, #8e9eab 0%, #eef2f3 100%);
        }

        .weather-container.thunderstorm {
          background: linear-gradient(180deg, #373B44 0%, #4286f4 100%);
        }

        .weather-container.foggy {
          background: linear-gradient(180deg, #757F9A 0%, #D7DDE8 100%);
        }

        .current-weather {
          width: 100%;
          aspect-ratio: 1;
          max-width: 500px;
          margin: 0 auto;
          padding: var(--boxel-sp-xl);
          border-radius: var(--boxel-border-radius-xl);
          background: rgba(255, 255, 255, 0.1);
          backdrop-filter: blur(10px);
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .forecast-container {
          display: flex;
          gap: var(--boxel-sp-sm);
          padding: var(--boxel-sp-sm);
          border-radius: var(--boxel-border-radius-lg);
          background: rgba(255, 255, 255, 0.1);
          backdrop-filter: blur(10px);
        }

        .forecast-day {
          flex: 1;
          padding: var(--boxel-sp-sm);
          text-align: center;
          border-radius: var(--boxel-border-radius-sm);
          transition: background-color 0.3s ease;
        }

        .forecast-day:hover {
          background: rgba(255, 255, 255, 0.1);
        }

        .forecast-date {
          font-size: var(--boxel-font-size-sm);
          font-weight: 500;
          margin-bottom: var(--boxel-sp-xs);
        }

        .forecast-temps {
          font-size: var(--boxel-font-size-lg);
          margin-bottom: var(--boxel-sp-xs);
        }

        .high-temp {
          font-weight: 600;
        }

        .low-temp {
          opacity: 0.7;
          margin-left: var(--boxel-sp-xs);
        }

        .forecast-conditions {
          font-size: var(--boxel-font-size-sm);
          opacity: 0.9;
        }

        .header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: var(--boxel-sp-lg);
        }

        .timestamp {
          margin-bottom: 0;  /* Override previous margin */
        }

        .refresh-button {
          background: rgba(255, 255, 255, 0.2);
          border: none;
          border-radius: 50%;
          width: 36px;
          height: 36px;
          display: flex;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.3s ease;
          padding: var(--boxel-sp-xxs);
        }

        .refresh-button:hover {
          background: rgba(255, 255, 255, 0.3);
          transform: rotate(180deg);
        }

        .refresh-button:active {
          transform: rotate(180deg) scale(0.95);
        }

        .refresh-button :global(svg) {
          width: 20px;
          height: 20px;
          color: white;
        }

        .main-weather {
          text-align: center;
          margin-bottom: var(--boxel-sp-xl);
        }

        .temperature {
          font-size: 6rem;
          font-weight: 200;
          line-height: 1;
          margin-bottom: var(--boxel-sp-sm);
        }

        .conditions {
          font-size: var(--boxel-font-size-lg);
          font-weight: 500;
          opacity: 0.9;
        }

        .weather-details {
          display: grid;
          grid-template-columns: repeat(2, 1fr);
          gap: var(--boxel-sp-lg);
          padding-top: var(--boxel-sp-lg);
          border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        .detail-item {
          text-align: center;
        }

        .detail-label {
          font-size: var(--boxel-font-size-sm);
          text-transform: uppercase;
          letter-spacing: 1px;
          opacity: 0.8;
          margin-bottom: var(--boxel-sp-xxs);
        }

        .detail-value {
          font-size: var(--boxel-font-size-lg);
          font-weight: 500;
        }

        /* Enhanced Weather Animations */
        .weather-container::before,
        .weather-container::after {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          pointer-events: none;
        }

        /* Clear/Sunny Animation */
        .weather-container.clear::before {
          background: radial-gradient(
            circle at 50% 120px,
            rgba(255, 215, 0, 0.2) 0%,
            transparent 60%
          );
          animation: sunPulse 3s ease-in-out infinite;
        }

        .weather-container.clear::after {
          background: conic-gradient(
            from 0deg at 50% 120px,
            transparent 0deg,
            rgba(255, 215, 0, 0.1) 20deg,
            transparent 40deg,
            rgba(255, 215, 0, 0.1) 60deg,
            transparent 80deg
          );
          animation: sunRays 20s linear infinite;
        }

        @keyframes sunPulse {
          0%, 100% { opacity: 0.5; transform: scale(1); }
          50% { opacity: 0.7; transform: scale(1.1); }
        }

        @keyframes sunRays {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }

        /* Rain Animation */
        .weather-container.rain::before {
          background-image: 
            repeating-linear-gradient(
              transparent 0px,
              rgba(255, 255, 255, 0.3) 2px,
              transparent 4px
            );
          background-size: 100% 14px;
          animation: rain 0.8s linear infinite;
        }

        .weather-container.rain::after {
          background: linear-gradient(
            to bottom,
            transparent 0%,
            rgba(255, 255, 255, 0.1) 100%
          );
          animation: rainFog 3s ease-in-out infinite;
        }

        @keyframes rain {
          from { background-position: 0 -14px; }
          to { background-position: 0 0; }
        }

        @keyframes rainFog {
          0%, 100% { opacity: 0.3; }
          50% { opacity: 0.6; }
        }

        /* Snow Animation */
        .weather-container.snow::before {
          background-image: 
            radial-gradient(
              circle at center,
              white 1px,
              transparent 1px
            );
          background-size: 12px 12px;
          animation: snow 3s linear infinite;
        }

        .weather-container.snow::after {
          background: linear-gradient(
            to bottom,
            transparent 0%,
            rgba(255, 255, 255, 0.2) 100%
          );
          animation: snowGlow 4s ease-in-out infinite;
        }

        @keyframes snow {
          from { background-position: 0 -12px; }
          to { background-position: 0 0; }
        }

        @keyframes snowGlow {
          0%, 100% { opacity: 0.2; }
          50% { opacity: 0.4; }
        }

        /* Thunderstorm Animation */
        .weather-container.thunderstorm::before {
          background: linear-gradient(
            to bottom,
            rgba(255, 255, 255, 0) 96%,
            rgba(255, 255, 255, 0.3) 100%
          );
          animation: lightning 5s ease-in-out infinite;
        }

        @keyframes lightning {
          0%, 95%, 100% { opacity: 0; }
          96%, 98% { opacity: 1; }
        }

        /* Cloudy Animation */
        .weather-container.cloudy::before {
          background: linear-gradient(
            45deg,
            transparent 0%,
            rgba(255, 255, 255, 0.1) 100%
          );
          animation: cloudMove 8s ease-in-out infinite;
        }

        @keyframes cloudMove {
          0%, 100% { transform: translateX(0); }
          50% { transform: translateX(20px); }
        }

        /* Foggy Animation */
        .weather-container.foggy::before {
          background: linear-gradient(
            to bottom,
            transparent 0%,
            rgba(255, 255, 255, 0.2) 50%,
            transparent 100%
          );
          animation: fogFlow 6s ease-in-out infinite;
        }

        .weather-container.foggy::after {
          background: repeating-linear-gradient(
            45deg,
            transparent 0px,
            rgba(255, 255, 255, 0.05) 2px,
            transparent 4px
          );
          animation: fogPattern 15s linear infinite;
        }

        @keyframes fogFlow {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(-10px); }
        }

        @keyframes fogPattern {
          from { background-position: 0 0; }
          to { background-position: 100px 100px; }
        }

        /* Apply scaled animations to fitted view */
        .weather-widget::before,
        .weather-widget::after {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          pointer-events: none;
          border-radius: inherit;
        }

        /* Add the same animations to weather-widget with adjusted scales */
        .weather-widget.clear::before,
        .weather-widget.rain::before,
        .weather-widget.snow::before,
        .weather-widget.thunderstorm::before,
        .weather-widget.cloudy::before,
        .weather-widget.foggy::before {
          background-size: 50% auto;
        }
      </style>
    </template>

    get weatherClass() {
      const condition = this.args.model.currentConditions.conditions?.toLowerCase();
      if (condition?.includes('clear')) return 'clear';
      if (condition?.includes('cloud')) return 'cloudy';
      if (condition?.includes('rain')) return 'rain';
      if (condition?.includes('snow')) return 'snow';
      if (condition?.includes('thunder')) return 'thunderstorm';
      if (condition?.includes('fog')) return 'foggy';
      return 'clear';
    }
  };

  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='weather-widget {{this.weatherClass}}'>
        <div class='widget-content'>
          <div class='widget-header'>
            <div class='widget-city'>{{@model.currentConditions.city}}</div>
            <div class='widget-time'>{{this.formatTime @model.currentConditions.timestamp}}</div>
          </div>
          
          <div class='widget-main'>
            <div class='widget-temp'>{{@model.currentConditions.temperature}}°</div>
            <div class='widget-conditions'>{{@model.currentConditions.conditions}}</div>
          </div>

          <div class='widget-forecast'>
            {{#each @model.currentConditions.forecast as |day index|}}
              {{#if (lt index 3)}}
                <div class='widget-forecast-day'>
                  <div class='widget-forecast-date'>{{this.formatDayName day.date}}</div>
                  <div class='widget-forecast-temps'>
                    <span class='widget-high'>{{day.highTemp}}°</span>
                    <span class='widget-low'>{{day.lowTemp}}°</span>
                  </div>
                </div>
              {{/if}}
            {{/each}}
          </div>
        </div>
      </div>
      <style scoped>
        .weather-widget {
          width: 100%;
          height: 100%;
          color: white;
          background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
          border-radius: var(--boxel-border-radius-lg);
          padding: var(--boxel-sp-xs);
          overflow: hidden;
        }

        .widget-content {
          height: 100%;
          display: grid;
          grid-template-rows: auto auto 1fr;
          gap: var(--boxel-sp-xxs);
        }

        .widget-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          font-size: var(--boxel-font-size-sm);
        }

        .widget-city {
          font-weight: 600;
        }

        .widget-time {
          opacity: 0.8;
        }

        .widget-main {
          display: flex;
          align-items: center;
          gap: var(--boxel-sp-sm);
        }

        .widget-temp {
          font-size: 2.5rem;
          font-weight: 200;
          line-height: 1;
        }

        .widget-conditions {
          font-size: var(--boxel-font-size-sm);
          opacity: 0.9;
        }

        .widget-forecast {
          display: flex;
          justify-content: space-between;
          align-items: flex-end;
          padding-top: var(--boxel-sp-xxs);
          border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        .widget-forecast-day {
          text-align: center;
          font-size: var(--boxel-font-size-xs);
        }

        .widget-forecast-date {
          opacity: 0.8;
          margin-bottom: 2px;
        }

        .widget-forecast-temps {
          font-size: var(--boxel-font-size-sm);
        }

        .widget-high {
          font-weight: 600;
        }

        .widget-low {
          opacity: 0.7;
          margin-left: 4px;
        }

        /* Weather condition-specific backgrounds */
        .weather-widget.clear {
          background: linear-gradient(135deg, #2980b9 0%, #6dd5fa 100%);
        }

        .weather-widget.cloudy {
          background: linear-gradient(135deg, #606c88 0%, #3f4c6b 100%);
        }

        .weather-widget.rain {
          background: linear-gradient(135deg, #4B79A1 0%, #283E51 100%);
        }

        .weather-widget.snow {
          background: linear-gradient(135deg, #8e9eab 0%, #eef2f3 100%);
        }

        .weather-widget.thunderstorm {
          background: linear-gradient(135deg, #373B44 0%, #4286f4 100%);
        }

        .weather-widget.foggy {
          background: linear-gradient(135deg, #757F9A 0%, #D7DDE8 100%);
        }
      </style>
    </template>

    formatTime(date?: Date) {
      if (!date) return '';
      let hours = date.getHours();
      const minutes = date.getMinutes().toString().padStart(2, '0');
      const ampm = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12;
      hours = hours ? hours : 12;
      return `${hours}:${minutes} ${ampm}`;
    }

    formatDayName(date?: Date) {
      if (!date) return '';
      const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      return days[date.getDay()];
    }
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