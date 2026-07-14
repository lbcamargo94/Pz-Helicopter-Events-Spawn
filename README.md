# Pz-Helicopter-Events-Spawn

Mod para **Project Zomboid Build 42** que adiciona um atalho de teclado para disparar imediatamente o evento de helicóptero vanilla do jogo. Pressione **F7** (configurável) e o helicóptero aparece — com suporte a chance aleatória, confirmação por duplo clique, som de rádio militar e proteção contra duplicação.

---

## Como funciona

Ao pressionar a tecla configurada, o mod executa as seguintes verificações antes de disparar:

1. **Sandbox** — se `respectSandbox` estiver ativo e eventos de helicóptero estiverem desativados nas opções do mundo, o disparo é bloqueado.
2. **Veículo** — se `allowVehicle` estiver desativado e o jogador estiver dentro de um veículo, o disparo é bloqueado.
3. **Confirmação** — se `requireConfirm` estiver ativo, o jogador deve pressionar a tecla uma segunda vez em até 5 segundos.
4. **Cooldown anti-duplicação** — após um disparo bem-sucedido, um bloqueio de **15 minutos em tempo real** impede que o evento seja acionado novamente enquanto está ativo. O cooldown é reiniciado a cada carregamento de save (em memória apenas).
5. **Chance** — sorteio baseado no valor configurado (padrão: 100%).

Se todas as verificações passarem, o evento de helicóptero vanilla é disparado via `testHelicopter()`.

---

## Funcionalidades

| Funcionalidade | Descrição |
|---|---|
| **Tecla configurável** | Padrão: F7. Qualquer tecla disponível no mapeamento do PZ. |
| **Chance de ativação** | Porcentagem de chance de o evento realmente disparar (padrão: 100%). |
| **Confirmação por duplo clique** | Exige pressionar a tecla duas vezes em até 5 segundos. |
| **Bloqueio em veículo** | Opção para impedir ativação dentro de veículos. |
| **Respeitar sandbox** | Bloqueia o disparo se eventos de helicóptero estiverem desativados no mundo. |
| **Notificação na HUD** | Exibe mensagem na tela ao ativar o evento. |
| **Som de rádio militar** | Toca um áudio de rádio militar ao disparar o evento (OGG customizado). |
| **Suporte a Multiplayer** | Funciona em servidores SP e MP. |
| **Logs de depuração** | Opção para exibir mensagens de diagnóstico no console. |

---

## Configuração

Acesse **Opções > Mods > Helicopter Event Trigger** para ajustar todas as opções.

| Opção | Padrão | Descrição |
|---|---|---|
| `Tecla de Ativação` | F7 | Tecla que dispara o evento. |
| `Chance de Ativação (%)` | 100 | Probabilidade de disparo ao pressionar a tecla. |
| `Exibir notificação` | Ativado | Mostra mensagem na HUD ao ativar. |
| `Tocar som de confirmação` | Ativado | Reproduz o áudio de rádio militar. |
| `Permitir ativação em veículos` | Ativado | Quando desativado, bloqueia o uso dentro de veículos. |
| `Exigir confirmação` | Desativado | Exige pressionar a tecla duas vezes para confirmar. |
| `Respeitar sandbox` | Desativado | Bloqueia o disparo se helicópteros estiverem desativados no sandbox. |
| `Logs de depuração` | Desativado | Imprime mensagens de diagnóstico no console. |

---

## Compatibilidade

- **Build:** Project Zomboid B42.19+
- **Multiplayer:** compatível (SP e MP)
- **Outros mods:** não modifica arquivos base, sem conflito esperado
- Reutiliza o evento vanilla de helicóptero do jogo (`testHelicopter()`)

---

## Notas técnicas (B42)

- **`testHelicopter()`**: função Java nativa, sem retorno nem evento de fim (`OnHelicopterEnd` não existe). O cooldown de 15 min é a única forma viável de evitar duplicação.
- **`HES_State.cooldownUntil`**: timestamp em memória (`getTimeInMillis() + 15min`). Reinicia a cada carregamento de save — intencional.
- **Som**: registrado via `getFMODSoundBank():addSound()` no evento `OnLoadSoundBanks`. Arquivo: `media/sound/military-radio-sound.ogg`. Se o OGG não for encontrado, o handle retorna 0 e o mod usa o som vanilla como fallback.
- **Translations**: sistema de tradução Lua nativo com chaves JSON em `Translate/EN/UI.json` e `Translate/PTBR/UI.json`.

---

## Estrutura do projeto

```
Pz-Helicopter-Events-Spawn/
├── workshop.txt
├── preview.png
└── Contents/mods/Pz-Helicopter-Events-Spawn/42/
    ├── mod.info
    ├── poster.png
    └── media/
        ├── sound/
        │   └── military-radio-sound.ogg
        └── lua/
            ├── shared/
            │   └── Pz-Helicopter-Events-Spawn/
            │       ├── Options.lua         — SandboxVars e opções do mod
            │       ├── Sounds.lua          — registro do OGG via OnLoadSoundBanks
            │       ├── Translations.lua    — sistema de tradução Lua nativo
            │       └── Translate/
            │           ├── EN/UI.json      — chaves em inglês
            │           └── PTBR/UI.json   — chaves em português
            └── client/
                └── Pz-Helicopter-Events-Spawn/
                    └── Main.lua            — lógica principal, cooldown, doTrigger()
```

---

## Histórico de versões

| Versão | Descrição |
|---|---|
| `v1.0.0` | Implementação inicial: tecla F7, disparo do evento vanilla |
| `v1.1.0` | Funcionalidades avançadas: keybind configurável, chance, confirmação, som, bloqueio em veículo, sistema de tradução JSON |
| `v1.2.0` | Remoção do sistema de fogo simulado e CooldownBar; mod simplificado e focado |
| `v1.2.1` | Anti-duplicação: cooldown de 15 min em tempo real; corrigido nome do arquivo OGG do som |
