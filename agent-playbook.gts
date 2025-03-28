import { 
  CardDef, 
  Component, 
  field, 
  contains, 
  containsMany, 
  FieldDef 
} from 'https://cardstack.com/base/card-api';
import MarkdownField from 'https://cardstack.com/base/markdown';

export class PlaybookStepField extends FieldDef {
  static displayName = 'Playbook Step';
  
  @field instruction = contains(MarkdownField);
  @field memory = contains(MarkdownField);

  static embedded = class Embedded extends Component<typeof this> {
    <template>
      <div class='playbook-step'>
        <div class='instruction-section'>
          <h3 class='section-title'>Instruction</h3>
          <div class='markdown-content'>
            <@fields.instruction />
          </div>
        </div>
        {{#if @model.memory}}
          <div class='memory-section'>
            <h3 class='section-title'>Memory</h3>
            <div class='markdown-content'>
              <@fields.memory />
            </div>
          </div>
        {{/if}}
      </div>
      <style scoped>
        .playbook-step {
          display: flex;
          flex-direction: column;
          gap: var(--boxel-sp-sm);
          padding: var(--boxel-sp-sm);
          border-radius: var(--boxel-border-radius);
          background-color: var(--boxel-100);
        }
        
        .section-title {
          font-size: var(--boxel-font-lg);
          font-weight: 600;
          margin: 0 0 var(--boxel-sp-xs) 0;
          color: var(--boxel-600);
        }
        
        .instruction-section {
          padding: var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          background-color: var(--boxel-highlight-100);
          border-left: 3px solid var(--boxel-highlight);
        }
        
        .memory-section {
          padding: var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          background-color: var(--boxel-200);
          border-left: 3px solid var(--boxel-400);
        }
        
        .markdown-content {
          font-size: var(--boxel-font);
          line-height: 1.5;
        }
        
        .markdown-content :deep(h1),
        .markdown-content :deep(h2),
        .markdown-content :deep(h3),
        .markdown-content :deep(h4),
        .markdown-content :deep(h5),
        .markdown-content :deep(h6) {
          margin-top: var(--boxel-sp-xs);
          margin-bottom: var(--boxel-sp-xxs);
        }
        
        .markdown-content :deep(p) {
          margin-top: var(--boxel-sp-xxs);
          margin-bottom: var(--boxel-sp-xxs);
        }
        
        .markdown-content :deep(ul),
        .markdown-content :deep(ol) {
          padding-left: var(--boxel-sp-sm);
          margin: var(--boxel-sp-xxs) 0;
        }
        
        .markdown-content :deep(code) {
          background-color: var(--boxel-300);
          padding: 0.2em 0.4em;
          border-radius: var(--boxel-border-radius-sm);
          font-family: monospace;
          font-size: 0.9em;
        }
        
        .markdown-content :deep(pre) {
          background-color: var(--boxel-300);
          padding: var(--boxel-sp-xs);
          border-radius: var(--boxel-border-radius-sm);
          overflow-x: auto;
          margin: var(--boxel-sp-xs) 0;
        }
        
        .markdown-content :deep(pre code) {
          background-color: transparent;
          padding: 0;
        }
      </style>
    </template>
  };
}

export class AgentPlaybook extends CardDef {
  static displayName = 'Agent Playbook';
  
  @field overallGoal = contains(MarkdownField);
  @field steps = containsMany(PlaybookStepField);
}