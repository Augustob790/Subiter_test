# AGENTS.md

## Contexto do projeto
Projeto Flutter `precificakm`.

Stack atual confirmada no repositório:
- Flutter / Dart 3
- `provider` + `ChangeNotifier`
- `get_it`
- `go_router`
- `dio`
- `shared_preferences`
- `fl_chart`
- `intl`
- `SQLite`

Arquitetura alvo e padrão de trabalho:
- **Clean Architecture + MVVM + SOLID + Clean Code**
- **organização modular por feature**
- **baixo acoplamento entre módulos**
- **reuso de base compartilhada em `lib/core`**
- **Seguir o padrão de naming de variáveis e funções deste projeto**
- **Seguir o padrão de tipagem deste projeto**
- **Seguir o padrão de importações deste projeto**
- **Seguir o padrão de organização deste projeto**
- **Criar metodo de Request para cada cenário (GET, POST, PUT, DELETE)**
- **Não criar arquivos no diretorio `lib/core/`**
- **Todo texto deve seguir o padrão de internacionalização usando `lib/core/i18n/`, sendo adicionado em core/i18n/strings_pt.dart**
- **Todo widget deve seguir o padrão de design do projeto, usando as cores e estilos definidos em `lib/core/theme/`**
- **Todo menu deve seguir o padrão de navegação usando `lib/core/navigator/app_router.dart`**
- **Criar store para passar dados entre telas do mesmo módulo**
- **Usar AppNavigator para navegar entre telas usando a importação via injeção de dependência IoD**
- **Usar as rotas nomeadas presentes nos arquivos _routes de cada módulo, importando por exemplo `import 'package:precificakm/modules/auth/auth_routes.dart';`**
- **Toda requisição deve seguir o padrão de requisições da API, usando `lib/core/infra/api_client.dart`**
- **Toda pagina que possua drawer deve utilizar o `BaseLayout`**
- **Todo widget que precise de estado deve seguir o padrão de estados usando `BaseViewModel`**
- **Todo widget deve seguir o padrão de validação de campos usando `lib/core/utils/app_validators.dart`**
- **Todo widget deve seguir o padrão de formatação de dados usando `lib/core/utils/app_formatters.dart`**
- **Todo widget deve seguir o padrão de formatação de moeda usando `lib/core/utils/app_formatters.dart`**
- **Todo widget deve seguir o padrão de formatação de data usando `lib/core/utils/app_formatters.dart`**
- **Todo widget deve seguir o padrão de formatação de hora usando `lib/core/utils/app_formatters.dart`**
- **Todo widget deve seguir o padrão de formatação de porcentagem usando `lib/core/utils/app_formatters.dart`**
- **Todo widget deve seguir o padrão de formatação de número usando `lib/core/utils/app_formatters.dart`**
- **Todo widget deve seguir o padrão de formatação de telefone usando `lib/core/utils/app_formatters.dart`**
- **Todo widget deve seguir o padrão de validação de email usando `lib/core/utils/app_validators.dart`**
- **Todo widget deve seguir o padrão de validação de senha usando `lib/core/utils/app_validators.dart`**
- **Todo widget deve seguir o padrão de validação de telefone usando `lib/core/utils/app_validators.dart`**
- **Todo widget deve seguir o padrão de validação de cpf usando `lib/core/utils/app_validators.dart`**
- **Todo widget deve seguir o padrão de validação de cnpj usando `lib/core/utils/app_validators.dart`**
- **Todo widget deve seguir o padrão de validação de placa usando `lib/core/utils/app_validators.dart`**
- **Todo widget deve seguir o padrão de validação de placa usando `lib/core/utils/app_validators.dart`**
- **Não passar paramentros/argumentos via rota, e sim por store**
- **Não utilizar cores personalizadas, utilizar apenas as cores definidas em `lib/core/theme/app_theme.dart`**
- **Não utilizar fontes personalizadas, utilizar apenas as fontes definidas em `lib/core/theme/app_theme.dart`**
- **Não utilizar imagens externas, utilizar apenas as imagens definidas em `lib/core/assets/`**


### Widgets
- `lib/core/widgets/` - componentes reutilizáveis globais
- `lib/modules/<feature>/ui/widgets/` - componentes específicos do módulo

---

## Estrutura real atual do projeto

### Base compartilhada
- `lib/core/`
  - `errors/`
  - `i18n/`
  - `infra/`
  - `navigator/`
  - `stores/`
  - `theme/`
  - `utils/`
  - `widgets/`
- `lib/base_module.dart`
- `lib/base_routes.dart`
- `lib/main.dart`

### Módulos atuais
- `auth`
- `calculadora`
- `corridas`
- `create_user`
- `historico`
- `home`
- `login`
- `perfil`
- `splash`
- `veiculos`
- `viagens`
- `strings`

---

## Regra principal
Ao trabalhar neste repositório, **seguir a estrutura que já existe hoje**. Não refatorar em massa para uma estrutura idealizada se o módulo atual usa outro padrão local.

Exemplo importante:
- muitos módulos usam `ui/<feature>_viewmodel.dart` e `ui/<screen>.dart` diretamente
- portanto, **não criar `ui/screens/` e `ui/viewmodels/` em apenas um módulo isolado** se isso quebrar consistência visual/arquitetural do projeto atual

---

## Estrutura recomendada por módulo
Cada módulo em `lib/modules/<feature>` deve manter, sempre que possível:

```text
lib/modules/<feature>/
  <feature>_routes.dart
  <feature>_string_keys.dart
  domain/
    enums/
    models/
    repositories/
  infra/
    data_models/
    repositories/
  ui/
    <feature>_screen.dart
    <feature>_viewmodel.dart
    widgets/
    steps/
```

### Observações
- `steps/` é aceitável para fluxos wizard, como já ocorre em módulos do projeto.
- `data_models/` já é o padrão usado hoje; não trocar para `dtos/` sem motivo forte.
- só criar `datasources/`, `mappers/` ou `usecases/` quando houver necessidade real e ganho claro.

---

## Responsabilidade por camada

### `domain/`
Camada pura de negócio.

Pode conter:
- models de domínio
- enums
- contratos de repositório
- regras de negócio

Evitar:
- Flutter
- `ChangeNotifier`
- `dio`
- acesso direto a API/local storage

### `infra/`
Camada de dados e integração.

Pode conter:
- `data_models`
- implementação de repositórios
- integração com API
- serialização / desserialização
- adaptação entre payload externo e domínio

Regras:
- não deixar detalhe de API vazar para widget
- tratar erro técnico e converter para falha de domínio/app quando aplicável
- preferir implementação concreta com sufixo `Impl`

### `ui/`
Camada de apresentação.

Pode conter:
- screens
- widgets específicos do módulo
- viewmodels com `ChangeNotifier`
- estados de loading, erro, vazio e sucesso

Regras:
- UI não chama API diretamente
- lógica de apresentação fica no viewmodel
- regra de negócio relevante não deve ficar no `build()`

---

## Convenções específicas deste projeto

### 1. ViewModels
Seguir padrão já usado:
- `login_viewmodel.dart`
- `home_viewmodel.dart`
- `veiculos_viewmodel.dart`
- `novo_veiculo_wizard_viewmodel.dart`

Boas práticas:
- métodos explícitos: `load`, `fetch`, `save`, `submit`, `refresh`
- flags claras: `isLoading`, `errorMessage`, `selected...`
- `notifyListeners()` apenas quando necessário

### 2. Screens
Seguir padrão:
- `<feature>_screen.dart`
- telas de detalhe com nomes descritivos, ex.:
  - `historico_corrida_detalhe_screen.dart`
  - `historico_calculo_detalhe_screen.dart`

### 3. Widgets
- widgets reutilizáveis globais ficam em `lib/core/widgets`
- widgets específicos do módulo ficam em `lib/modules/<feature>/ui/widgets`
- não mover widget para `core` se ele só serve para uma feature

### 4. Steps / Wizards
Quando fluxo for multi-etapas:
- usar `ui/steps/` no próprio módulo
- manter estado no viewmodel principal do fluxo
- evitar estado espalhado entre vários widgets sem coordenação central

### 5. Rotas
- cada módulo pode expor seu arquivo `<feature>_routes.dart`
- integrar navegação respeitando `base_routes.dart`, `core/router.dart` e navegação já existente
- não criar solução paralela de navegação

### 6. Strings e i18n
- usar `_string_keys.dart` por módulo quando já existir
- usar infraestrutura de `lib/core/i18n`
- evitar texto hardcoded em tela, especialmente texto recorrente

### 7. Tema e design system
- usar `lib/core/theme/app_theme.dart`
- usar `lib/core/theme/app_colors.dart`
- respeitar padrão visual existente antes de introduzir novo estilo

### 8. Infra compartilhada
Para integrações comuns, reutilizar:
- `lib/core/infra/base_api.dart`
- `lib/core/infra/base_response.dart`
- `lib/core/infra/precifica_api.dart`
- `lib/core/infra/api_endpoints.dart`

Não duplicar cliente HTTP dentro de módulo sem necessidade.

---

## `core/` vs módulo

### Colocar em `core/` somente se:
- usado por múltiplos módulos
- conceito realmente compartilhado
- utilitário genérico
- componente visual global

### Manter dentro do módulo se:
- regra pertence a uma feature
- widget só é usado nela
- model só faz sentido nela
- fluxo é específico dela

---

## Situação atual importante de arquitetura
Hoje existem módulos separados como:
- `auth`
- `login`
- `create_user`

Ao evoluir o projeto:
- **não consolidar isso automaticamente em uma refatoração ampla** sem pedido explícito
- se o trabalho for local, manter compatibilidade com a estrutura atual
- se houver pedido de refatoração arquitetural, aí sim propor consolidação gradual

O mesmo vale para convivência de módulos como `corridas`, `historico` e `viagens`: respeitar o estado atual do projeto antes de unificar conceitos.

---

## Regras para mudanças de código
1. Fazer **menor mudança possível** para resolver problema.
2. Preservar padrão já existente no módulo alvo.
3. Não introduzir nova pasta/abstração sem necessidade clara.
4. Não misturar responsabilidade de camadas.
5. Preferir consistência do projeto real acima de arquitetura “perfeita” teórica.
6. Se precisar criar estrutura nova, fazê-la de modo incremental e justificável.
7. Evitar refactors amplos não solicitados.

---

## Padrões de nomeação
- arquivos: `snake_case.dart`
- classes: `PascalCase`
- métodos e variáveis: `camelCase`
- contratos: `XRepository`
- implementação: `XRepositoryImpl`
- viewmodels: `XViewModel`

---

## O que evitar
- lógica de API em widget
- widget gigante com regra de negócio
- mover tudo para `core` sem critério
- DTO/model de infra sendo tratado como domínio por conveniência
- criar padrão novo em um módulo e manter outro padrão no resto sem motivo
- dependência circular entre módulos

---

## Testabilidade
Priorizar código fácil de testar:
- dependências injetáveis via `get_it` ou construtor
- regra de negócio fora do widget
- funções pequenas
- parsing e mapeamentos previsíveis

Prioridade de testes:
1. domínio e regras
2. viewmodels
3. mapeamentos críticos
4. widgets com comportamento relevante

---

## Instrução final para agentes
Ao atuar neste repositório:
- ler estrutura existente antes de propor mudança
- seguir padrão do módulo que está sendo alterado
- reutilizar `core` quando já houver solução compartilhada
- manter alinhamento com Clean Architecture e MVVM
- preservar `Provider + ChangeNotifier + get_it + go_router`
- ser incremental, consistente e pragmático
