# Prova técnica Subiter - respostas e aplicativo Flutter

Este repositório reúne as quatro respostas da `Prova_Subiter_Rev1.pdf`.

## Entregáveis

- `docs/questao_1.cpp`: modelagem C++/Qt para inspeções termográficas e por ultrassom.
- `docs/questao_3.cpp`: cadastro e listagem de três equipamentos em C++17.
- `lib/`: aplicativo Flutter das questões 2 e 4.
- `assets/mocks/inspections.json`: resposta JSON que simula a API REST.
- `docs/respostas.md`: justificativas, arquitetura e instruções.
- `output/pdf/Respostas_Prova_Subiter.pdf`: versão final das respostas.

## Aplicativo Flutter - questões 2 e 4

O app abre na lista de inspeções. A questão 2 usa um JSON local com formato de
resposta REST (`statusCode`, `message`, `data.inspections`). A leitura do asset
fica isolada atrás de `InspectionsRemoteDataSource`, portanto uma API HTTP real
pode substituí-la sem alterações na tela, ViewModel ou domínio.

Funcionalidades disponíveis:

- listagem de inspeções termográficas e por ultrassom;
- exibição de ID, equipamento, inspetor, data, local, resultado e medição;
- atualização da lista com pull-to-refresh;
- feedback visual para carregamento, lista vazia, erro e dados em cache;
- nova tentativa quando o carregamento falha;
- cadastro de atividade com validação e persistência em SQLite.

Arquitetura baseada no padrão do `precificakm-mobile`:

- módulo organizado em `domain/`, `infra/` e `ui/`;
- MVVM com `ChangeNotifier` e `Provider`;
- contrato `InspectionsRepository` no domínio e implementação `Impl` na infra;
- `get_it` para injeção de dependências;
- `go_router` e rota nomeada em `inspections_routes.dart`;
- SQLite para cache das inspeções e persistência das atividades;
- i18n em português e inglês;
- estados explícitos de carregamento, sucesso, vazio, cache e erro.

### Estrutura principal

```text
assets/mocks/inspections.json
lib/
  core/
    database/app_database.dart
    di/service_locator.dart
    i18n/app_localizations.dart
    router.dart
  modules/
    inspections/
      inspections_routes.dart
      domain/
      infra/
      ui/
    activities/
      data/
      domain/
      presentation/
```

### Fluxo da questão 2

```text
InspectionsScreen
  -> InspectionsViewModel
  -> GetInspectionsUseCase
  -> InspectionsRepository
  -> InspectionsRepositoryImpl
       -> JsonInspectionsRemoteDataSource
       -> assets/mocks/inspections.json
       -> SqliteInspectionsLocalDataSource (fallback/cache)
```

O JSON simula o contrato externo. A camada `infra` valida `statusCode`,
`data.inspections` e os campos obrigatórios antes de converter o payload em
`InspectionModel`. Se a leitura falhar, o repositório tenta recuperar a última
lista persistida na tabela SQLite `inspections`.

Rotas:

- `/inspections`: lista de inspeções e tela inicial;
- `/activities/register`: cadastro solicitado na questão 4.

### Executar

```bash
flutter pub get
flutter run
```

O projeto não depende de chave de API ou conexão com a internet para a questão
2, pois a resposta REST é simulada pelo asset JSON.

### Validar

```bash
flutter analyze
flutter test
```

Os testes cobrem parsing do payload, conversão para o domínio, estados de
sucesso/vazio/erro do ViewModel e validação do cadastro de atividade.

Para gerar o APK de validação:

```bash
flutter build apk --debug
```

## C++

Questão 3:

```bash
g++ -std=c++17 -Wall -Wextra -Wpedantic docs/questao_3.cpp -o questao_3
./questao_3
```

Questão 1 (exemplo usando Qt 6):

```bash
g++ -std=c++17 docs/questao_1.cpp $(pkg-config --cflags --libs Qt6Core) -o questao_1
./questao_1
```
