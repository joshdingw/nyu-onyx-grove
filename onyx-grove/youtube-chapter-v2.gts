import {
  CardDef,
  Component,
  field,
  contains, 
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
import TextAreaField from "https://cardstack.com/base/text-area";
import MarkdownField from 'https://cardstack.com/base/markdown';
import YouTubeIcon from '@cardstack/boxel-icons/youtube';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { Command } from '@cardstack/runtime-common';
import CreateAiAssistantRoomCommand from '@cardstack/boxel-host/commands/create-ai-assistant-room';
import OpenAiAssistantRoomCommand from '@cardstack/boxel-host/commands/open-ai-assistant-room';
import SetActiveLLMCommand from '@cardstack/boxel-host/commands/set-active-llm';
import SendAiAssistantMessageCommand from '@cardstack/boxel-host/commands/send-ai-assistant-message';
import PatchCardCommand from '@cardstack/boxel-host/commands/patch-card';
import ReloadCardCommand from '@cardstack/boxel-host/commands/reload-card';

function includes(list, item) {
  return list.includes(item);
}

function or(a, b) {
  if (a || b) {
    return true;
  }
  return false;
}

function eq(a, b) {
  return a == b;
}

function not(a) {
  if (a) {
    return false;
  }
  return true;
}

function and(a, b) {
  if (a && b) {
    return true;
  }
  return false;
}

class YouTubeService {
  private static instance: YouTubeService;

  static getInstance() {
    if (!this.instance) {
      this.instance = new YouTubeService();
    }
    return this.instance;
  }

  initPlayer(videoId: string) {
    if (typeof document === 'undefined') return; // Guard for SSR

    console.log('🎥 Initializing YouTube player for video:', videoId);
    // Load YouTube API if not already loaded
    if (!(window as any).YT) {
      console.log('📜 Loading YouTube IFrame API script...');
      const tag = document.createElement('script');
      tag.src = 'https://www.youtube.com/iframe_api';
      const firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode?.insertBefore(tag, firstScriptTag);
    } else {
      console.log('✅ YouTube IFrame API already loaded');
    }
  }

  seekTo(seconds: number) {
    console.log('⏱️ Attempting to seek to:', seconds, 'seconds');
    const iframe = document.getElementById('youtube-player');
    if (iframe) {
      console.log('🎯 Found YouTube player iframe, sending seek command...');
      const seekMessage = JSON.stringify({
        event: "command",
        func: "seekTo",
        args: [seconds, true]
      });
      
      console.log('📤 Sending seek message:', seekMessage);
      iframe.contentWindow?.postMessage(seekMessage, "*");

      // Also send play command
      const playMessage = JSON.stringify({
        event: "command",
        func: "playVideo",
        args: []
      });
      
      console.log('▶️ Sending play message:', playMessage);
      iframe.contentWindow?.postMessage(playMessage, "*");
    } else {
      console.warn('⚠️ YouTube player iframe not found!');
    }
  }
}

class FormattedDescription extends Component {
  get formattedLines() {
    const text = this.args.text || '';
    return text.split('\n').map(line => {
      const trimmedLine = line.trim();
      // Match YouTube timestamp format (e.g., 0:00, 1:23, 01:23, 1:23:45)
      const hasTimestamp = /^(?:\d{1,2}:)?\d{1,2}:\d{2}/.test(trimmedLine);
      return {
        text: trimmedLine,
        isTimestamp: hasTimestamp,
        isEmpty: trimmedLine.length === 0,
        seconds: hasTimestamp ? this.convertTimestampToSeconds(trimmedLine.split(' ')[0]) : 0
      };
    });
  }

  convertTimestampToSeconds(timestamp) {
    console.log('🕒 Processing timestamp:', timestamp);
    // Remove any non-digit or non-colon characters
    const cleanTimestamp = timestamp.replace(/[^\d:]/g, '');
    console.log('🧹 Cleaned timestamp:', cleanTimestamp);
    
    const parts = cleanTimestamp.split(':').map(part => parseInt(part, 10));
    console.log('🔢 Timestamp parts:', parts);
    
    let seconds = 0;
    if (parts.length === 3) {
      // HH:MM:SS format
      seconds = (parts[0] * 3600) + (parts[1] * 60) + parts[2];
    } else if (parts.length === 2) {
      // MM:SS format
      seconds = (parts[0] * 60) + parts[1];
    }
    
    console.log('⏰ Converted to seconds:', seconds);
    return isNaN(seconds) ? 0 : seconds;
  }

  @action
  onTimestampClick(seconds, timestamp) {
    if (timestamp === '00:00' || timestamp === '0:00') {
      console.log('🔄 Restarting video from beginning');
      YouTubeService.getInstance().seekTo(0);
      return;
    }

    if (seconds === 0) {
      console.warn('⚠️ Invalid timestamp conversion resulted in 0 seconds');
      return;
    }
    console.log('👆 Timestamp clicked at:', seconds, 'seconds');
    YouTubeService.getInstance().seekTo(seconds);
  }

  getTimestamp(text) {
    return text.split(' ')[0];
  }

  getTitle(text) {
    return text.split(' ').slice(1).join(' ');
  }

  <template>
    <div class='formatted-description'>
      <div class='chapters-list'>
        {{#each this.formattedLines as |line|}}
          {{#if line.isTimestamp}}
            <div 
              class='chapter-entry'
              role='button'
              {{on 'click' (fn this.onTimestampClick line.seconds (this.getTimestamp line.text))}}
            >
              <div class='timestamp'>
                {{this.getTimestamp line.text}}
              </div>
              <div class='chapter-title'>
                {{this.getTitle line.text}}
              </div>
            </div>
          {{/if}}
        {{/each}}
      </div>
    </div>
    <style scoped>
      .formatted-description {
        font-family: -apple-system, BlinkMacSystemFont, var(--boxel-font-family);
      }

      .chapters-list {
        display: flex;
        flex-direction: column;
        gap: var(--boxel-sp-xs);
        padding: var(--boxel-sp-xs);
      }

      .chapter-entry {
        display: grid;
        grid-template-columns: 80px 1fr;
        align-items: center;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-radius: 12px;
        min-height: 44px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
        transition: all 0.2s ease;
        cursor: pointer;
        border: 1px solid rgba(0, 0, 0, 0.05);
      }

      .chapter-entry:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
        background: rgba(255, 255, 255, 0.98);
        border-color: var(--boxel-purple-200);
      }

      .chapter-entry:active {
        transform: translateY(0);
        background: var(--boxel-purple-50);
      }

      .timestamp {
        padding: var(--boxel-sp-2xs) var(--boxel-sp-xs);
        font-weight: 600;
        color: var(--boxel-purple-700);
        font-family: -apple-system, BlinkMacSystemFont, monospace;
        text-align: center;
        border-right: 1px solid rgba(0, 0, 0, 0.08);
        transition: all 0.2s ease;
        font-size: 14px;
      }

      .chapter-entry:hover .timestamp {
        color: var(--boxel-purple-800);
        background: rgba(var(--boxel-purple-rgb-100), 0.3);
      }

      .chapter-title {
        padding: var(--boxel-sp-2xs) var(--boxel-sp-sm);
        color: var(--boxel-dark);
        line-height: 1.3;
        font-size: 15px;
        font-weight: 500;
      }

      @media (prefers-color-scheme: dark) {
        .chapter-entry {
          background: rgba(50, 50, 50, 0.95);
          border-color: rgba(255, 255, 255, 0.1);
        }

        .chapter-entry:hover {
          background: rgba(60, 60, 60, 0.98);
          border-color: var(--boxel-purple-400);
        }

        .chapter-entry:active {
          background: rgba(var(--boxel-purple-rgb-900), 0.3);
        }

        .timestamp {
          color: var(--boxel-purple-300);
          border-right-color: rgba(255, 255, 255, 0.1);
        }

        .chapter-entry:hover .timestamp {
          color: var(--boxel-purple-200);
          background: rgba(var(--boxel-purple-rgb-800), 0.3);
        }

        .chapter-title {
          color: rgba(255, 255, 255, 0.9);
        }
      }
    </style>
  </template>
}

class GenerateChaptersCommand extends Command<typeof YouTubeDescriptionWriter, typeof YouTubeDescriptionWriter> {
  protected async run(
    input: YouTubeDescriptionWriter
  ): Promise<YouTubeDescriptionWriter> {
    // Create a new room
    let createRoomCommand = new CreateAiAssistantRoomCommand(this.commandContext);
    let { roomId } = await createRoomCommand.execute({
      name: 'YouTube Chapter Generation',
    });

    // Open the room
    let openRoomCommand = new OpenAiAssistantRoomCommand(this.commandContext);
    await openRoomCommand.execute({
      roomId,
    });

    // Set the active LLM to Gemini
    let setLLMCommand = new SetActiveLLMCommand(this.commandContext);
    await setLLMCommand.execute({
      model: 'google/gemini-2.0-flash-001',
      roomId: roomId,
    });
    
    // Create a PatchCardCommand to allow the AI to update the card
    let patchCardCommand = new PatchCardCommand(this.commandContext, {
      cardType: YouTubeDescriptionWriter,
    });

    // Send message with the current card and the patch command
    let sendMessageCommand = new SendAiAssistantMessageCommand(this.commandContext);
    await sendMessageCommand.execute({
      roomId,
      prompt: "Generate YouTube description with chapters from the captions and the slide deck export. The data you need is in the json in your prompt in the Cards that are attached. In the patchCard command you must fill the youtubeDescription field with a timestamped overview based on the transcript and slide deck, which you already have. Make sure to split sections intelligently so that a user can easily find the relevant part. ",
      attachedCards: [input],
      commands: [{ command: patchCardCommand, autoExecute: true }],
      requireCommandCall: true,
    });
    
    // Wait for the patch command to be completed
    await patchCardCommand.waitForNextCompletion();
    
    // Reload the card to get the latest changes
    let reloadCardCommand = new ReloadCardCommand(this.commandContext);
    await reloadCardCommand.execute(input);

    return input;
  }
}

export class YouTubeDescriptionWriter extends CardDef {
  static displayName = "YouTube Description Writer";
  static icon = YouTubeIcon;

  @field videoUrl = contains(StringField, {
    displayName: 'YouTube Video URL'
  });

  @field captionText = contains(TextAreaField);
  @field slideOutline = contains(MarkdownField, {
    displayName: 'Slide Deck Outline',
  });

  

  @field youtubeDescription = contains(TextAreaField);

  static isolated = class Isolated extends Component<typeof this> {
    get videoEmbedUrl() {
      const url = this.args.model.videoUrl;
      if (not(url)) return '';
      
      let videoId = '';
      if (includes(url, 'youtu.be/')) {
        videoId = url.split('youtu.be/')[1]?.split('?')[0];
      } else if (includes(url, 'youtube.com/watch')) {
        videoId = url.split('v=')[1]?.split('&')[0];
      }

      if (videoId) {
        // Initialize player when we have a video ID
        YouTubeService.getInstance().initPlayer(videoId);
        return `https://www.youtube.com/embed/${videoId}?enablejsapi=1&controls=1`;
      }
      
      return '';
    }

    @action
    async generateChapters() {
      try {
        const command = new GenerateChaptersCommand(this.args.context?.commandContext);
        await command.execute(this.args.model);
      } catch (error) {
        console.error('Error generating chapters:', error);
        window.alert('Error generating chapters. See console for details.');
      }
    }

    <template>
      <div class='youtube-page-layout'>
        <div class='sticky-header'>
          {{#if this.videoEmbedUrl}}
            <div class='video-container'>
              <iframe 
                width="100%" 
                height="100%" 
                src={{this.videoEmbedUrl}}
                title="YouTube video player" 
                frameborder="0" 
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                allowfullscreen
                id="youtube-player"
              ></iframe>
            </div>
          {{else}}
            <div class='video-url-input'>
              <h2>YouTube Video URL</h2>
              <@fields.videoUrl />
            </div>
          {{/if}}
        </div>

        <div class='scrollable-content'>
          <div class='content-section'>
            <div class='chapter-section'>
              <h2>Chapter Markers</h2>
              <FormattedDescription @text={{@model.youtubeDescription}} @fields={{@fields}} />
            </div>

            <div class='editing-panel'>
              <div class='editing-column'>
                <h2>Video Captions</h2>
                <@fields.captionText @format='edit' />
              </div>
              
              <div class='editing-column'>
                <h2>Slide Deck Outline</h2>
                <@fields.slideOutline @format='edit' />
              </div>
            </div>

            <div class='generate-button-container'>
              <button 
                class='generate-chapters-button' 
                type='button'
                {{on 'click' this.generateChapters}}
              >
                <span>Generate Chapters</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <style scoped>
        .youtube-page-layout {
          display: flex;
          flex-direction: column;
          max-width: 1600px;
          margin: 0 auto;
          min-height: 100vh;
          background: linear-gradient(to bottom, #f7f7f7, #ffffff);
        }

        .sticky-header {
          position: sticky;
          top: 0;
          z-index: 10;
          background: linear-gradient(to bottom, #f7f7f7, #ffffff);
          padding: var(--boxel-sp-lg) var(--boxel-sp-lg) var(--boxel-sp-md);
        }

        .scrollable-content {
          padding: 0 var(--boxel-sp-lg) var(--boxel-sp-lg);
        }

        .video-container {
          position: relative;
          padding-bottom: 56.25%;
          height: 0;
          overflow: hidden;
          background: var(--boxel-dark);
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .video-container iframe {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
        }

        .video-url-input {
          padding: var(--boxel-sp-md);
          background: rgba(255, 255, 255, 0.8);
          backdrop-filter: blur(10px);
          border-radius: 12px;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .content-section {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-xl);
          margin-top: var(--boxel-sp-xl);
        }

        .chapter-section {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-sm);
          background: rgba(255, 255, 255, 0.8);
          backdrop-filter: blur(10px);
          border-radius: 16px;
          padding: var(--boxel-sp-lg);
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
          margin-bottom: var(--boxel-sp-xl);
        }

        .editing-panel {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: var(--boxel-sp-xl);
          height: 400px;
          margin-bottom: var(--boxel-sp-xl);
        }

        .editing-column {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-sm);
          padding: var(--boxel-sp-md);
        }

        .editing-column :deep(.field) {
          flex: 1;
          background: transparent;
          border: none;
          border-radius: 0;
          transition: all 0.2s ease;
          box-shadow: none;
        }

        .editing-column :deep(.field:focus-within) {
          box-shadow: none;
        }

        h2 {
          font: 600 17px -apple-system, BlinkMacSystemFont, var(--boxel-font-family);
          color: var(--boxel-dark);
          margin: 0;
          letter-spacing: -0.01em;
        }

        .generate-button-container {
          display: flex;
          justify-content: center;
          margin-bottom: var(--boxel-sp-xl);
        }

        .generate-chapters-button {
          background: var(--boxel-purple-600);
          color: white;
          font: 600 16px -apple-system, BlinkMacSystemFont, var(--boxel-font-family);
          border: none;
          border-radius: 12px;
          padding: var(--boxel-sp-sm) var(--boxel-sp-xxl);
          cursor: pointer;
          transition: all 0.2s ease;
          box-shadow: 0 4px 12px rgba(var(--boxel-purple-rgb-500), 0.3);
          height: 56px;
          min-width: 250px;
        }

        .generate-chapters-button:hover {
          background: var(--boxel-purple-700);
          transform: translateY(-2px);
          box-shadow: 0 6px 14px rgba(var(--boxel-purple-rgb-500), 0.4);
        }

        .generate-chapters-button:active {
          background: var(--boxel-purple-800);
          transform: translateY(0);
          box-shadow: 0 2px 6px rgba(var(--boxel-purple-rgb-500), 0.3);
        }

        @media (max-width: 768px) {
          .sticky-header,
          .scrollable-content {
            padding: var(--boxel-sp-sm);
          }

          .editing-panel {
            grid-template-columns: 1fr;
            height: auto;
            gap: var(--boxel-sp-lg);
          }

          .editing-column {
            height: 300px;
          }
        }

        @media (prefers-color-scheme: dark) {
          .youtube-page-layout,
          .sticky-header {
            background: linear-gradient(to bottom, #1a1a1a, #2a2a2a);
          }

          .video-url-input,
          .chapter-section {
            background: rgba(40, 40, 40, 0.8);
          }

          .editing-column :deep(.field) {
            background: rgba(50, 50, 50, 0.9);
          }

          h2 {
            color: rgba(255, 255, 255, 0.9);
          }
        }
      </style>
    </template>                                
  };

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='embedded-description'>
        <h3><@fields.youtubeDescription /></h3>
      </div>
      <style scoped>
        .embedded-description {
          padding: var(--boxel-sp-sm);
        }

        h3 {
          font: var(--boxel-font-sm);
          margin: 0;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 3;
          -webkit-box-orient: vertical;
        }
      </style>
    </template>                                
  };

  static fitted = class Fitted extends Component<typeof this> {
    <template>
      <div class='fitted-description'>
        <@fields.youtubeDescription />
      </div>
      <style scoped>
        .fitted-description {
          padding: var(--boxel-sp-sm);
          height: 100%;
          overflow: hidden;
        }
      </style>
    </template>                                
  };
}