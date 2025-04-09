import {
  contains,
  containsMany,
  linksTo,
  linksToMany,
  field,
  CardDef,
  Component,
} from 'https://cardstack.com/base/card-api';
import StringField from 'https://cardstack.com/base/string';
// don't forget the {} for this import:
import { SkillCard } from 'https://cardstack.com/base/skill-card';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import AddSkillsToRoomCommand from '@cardstack/boxel-host/commands/add-skills-to-room';
import PatchCardCommand from '@cardstack/boxel-host/commands/patch-card'
import SendAiAssistantMessageCommand from '@cardstack/boxel-host/commands/send-ai-assistant-message';
import CreateAiAssistantRoomCommand from '@cardstack/boxel-host/commands/create-ai-assistant-room';
import OpenAiAssistantRoomCommand from '@cardstack/boxel-host/commands/open-ai-assistant-room';

export class AnswerKey extends CardDef {
  @field answerExplanation = contains(StringField);
  @field gradingSkill = linksTo(SkillCard);
  @field guidingSkill = linksTo(SkillCard);
}

export class Problem extends CardDef {
  static displayName = 'Problem';

  @field description = contains(StringField);
  @field answerKey = linksTo(AnswerKey);
  @field question = contains(StringField);
  @field answer = contains(StringField);
  @field grade = contains(StringField);

  static isolated = class Isolated extends Component<typeof this> {
    @tracked isGrading = false;
    roomId: string | null = null;


    async setupRoom() {
      // Command context is required for all commands
      let commandContext = this.args.context?.commandContext;
      
      // First create the room if it doesn't exist

      if (!this.roomId) {
        let createAIAssistantRoomCommand = new CreateAiAssistantRoomCommand(
          commandContext,
        );
        let { roomId } = await createAIAssistantRoomCommand.execute({
          name: 'Grading',
        });

        // Add the skill
        // Note - this should be the *instance* not an ID
        let addSkillsToRoomCommand = new AddSkillsToRoomCommand(
        commandContext
        );
        addSkillsToRoomCommand.execute({
        roomId,
        skills: [this.args.model.answerKey.gradingSkill, this.args.model.answerKey.guidingSkill]
        })
        this.roomId = roomId;
      }
      

      // Optional - open the room
      let openAiAssistantRoomCommand = new OpenAiAssistantRoomCommand(
        commandContext,
      );
      await openAiAssistantRoomCommand.execute({
        roomId: this.roomId,
      });
    }


    @action
    async getHelp() {
      if (this.isHelping) return;
      
      this.isHelping = true;
      try {
        await this.setupRoom();
        // Command context is required for all commands
        let commandContext = this.args.context?.commandContext;
        let sendMessageCommand = new SendAiAssistantMessageCommand(
          commandContext,
        );
        await sendMessageCommand.execute({
          roomId: this.roomId,
          prompt: `I'd like some help with this problem.`,
          openCardIds: [this.args.model.id],
          attachedCards: [this.args.model, this.args.model.answerKey]
        });
      } catch (error) {
        throw error;
        
      } finally {
        this.isHelping = false;
      }
    }

    @action
    async grade() {
      if (this.isGrading) return;
      
      this.isGrading = true;
      try {
        await this.setupRoom();
       // Command context is required for all commands
        let commandContext = this.args.context?.commandContext;
        let sendMessageCommand = new SendAiAssistantMessageCommand(
          commandContext,
        );
        await sendMessageCommand.execute({
          roomId: this.roomId,
          prompt: `Please grade my work`,
          commands: [
            {command: new PatchCardCommand(commandContext, {cardType: Problem})}
          ],
          openCardIds: [this.args.model.id],
          attachedCards: [this.args.model, this.args.model.answerKey]
        })
          
      } catch (error) {
        throw error;
      } finally {
        this.isGrading = false;
      }
    }

    <template>
      <div class='problem-container'>
        <div class='description'>
          <h2>Problem Description</h2>
          <@fields.description />
        </div>

        <div class='question-section'>
          <h2>Question</h2>
          <@fields.question />
        </div>

        <div class='answer-section'>
          <h2>Your Answer</h2>
          <@fields.answer @format="edit" />
        </div>

        <div class='grade-section'>
          <h2>Grade</h2>
          <div class='grade-display'>
            {{#if this.args.model.grade}}
              <div class='grade-value'>{{this.args.model.grade}}</div>
            {{else}}
              <div class='grade-pending'>Not yet graded</div>
            {{/if}}
          </div>
        </div>
        
        <div class='button-group'>
          <button 
            class='grade-button'
            type='button'
            {{on 'click' (fn this.grade)}}
            disabled={{this.isGrading}}
          >
            {{if this.isGrading 'Grading...' 'Grade'}}
          </button>
          
          <button 
            class='help-button'
            type='button'
            {{on 'click' (fn this.getHelp)}}
            disabled={{this.isHelping}}
          >
            {{if this.isHelping 'Getting Help...' 'Get Help'}}
          </button>
        </div>

   
      </div>
      <style scoped>
        .problem-container {
          padding: 1.5rem;
          max-width: 800px;
          margin: 0 auto;
        }
        .description, .question-section, .answer-section, .grade-section {
          margin-bottom: 2rem;
          padding: 1rem;
          border-radius: 8px;
          background-color: #f8f9fa;
        }

        .grade-section {
          background-color: #f3f4f6;
        }

        .grade-display {
          font-size: 1.2rem;
          padding: 0.5rem;
          border-radius: 4px;
        }

        .grade-value {
          color: #2563eb;
          font-weight: 600;
        }

        .grade-pending {
          color: #6b7280;
          font-style: italic;
        }
        h2 {
          margin: 0 0 1rem 0;
          color: #2c3e50;
          font-size: 1.25rem;
        }
        .button-group {
          display: flex;
          gap: 1rem;
          margin-bottom: 1rem;
        }
        
        .grade-button, .help-button {
          padding: 0.5rem 1rem;
          border-radius: 4px;
          cursor: pointer;
          font-size: 1rem;
          border: none;
          color: white;
          min-width: 120px;
        }
        
        .grade-button {
          background-color: #4a90e2;
        }
        
        .help-button {
          background-color: #28a745;
        }
        
        .grade-button:hover {
          background-color: #357abd;
        }
        
        .help-button:hover {
          background-color: #218838;
        }
        
        .grade-button:disabled, .help-button:disabled {
          opacity: 0.7;
          cursor: not-allowed;
        }
        
        .result {
          margin-top: 1rem;
          padding: 1rem;
          border-radius: 4px;
          font-weight: 500;
        }
        
        .grading-result {
          background-color: #e8f0fe;
          color: #1967d2;
        }
        
        .help-result {
          background-color: #e8f5e9;
          color: #1b5e20;
        }
      </style>
    </template>
  };

}
