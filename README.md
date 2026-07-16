# Prova técnica Subiter - respostas, Flutter e Qt

As quatro respostas da `Prova_Subiter_Rev1.pdf` estão divididas em dois projetos
irmãos dentro de `/Users/augustobatista/Documents/SUBITER/`:

```text
SUBITER/
  subiter_test/        # questões 2 e 4 em Flutter, documentação e PDF
  subiter_test_c_qt/   # questões 1 e 3 em C++17/Qt 6
```

## Entregáveis

- [`question1.h`](../subiter_test_c_qt/question1.h) e
  [`question1.cpp`](../subiter_test_c_qt/question1.cpp): modelagem C++/Qt para
  inspeções termográficas e por ultrassom.
- [`question3.h`](../subiter_test_c_qt/question3.h) e
  [`question3.cpp`](../subiter_test_c_qt/question3.cpp): cadastro e listagem de
  três equipamentos.
- [`main.cpp`](../subiter_test_c_qt/main.cpp): ponto de entrada único que
  executa as questões 1 e 3.
- [`CMakeLists.txt`](../subiter_test_c_qt/CMakeLists.txt): configuração CMake
  do executável Qt.
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

Resultado da última validação:

- `flutter analyze`: nenhuma inconsistência encontrada;
- `flutter test`: 7 testes aprovados;
- `flutter build apk --debug`: compilação concluída;
- APK: `build/app/outputs/flutter-apk/app-debug.apk`.

Para gerar o APK de validação:

```bash
flutter build apk --debug
```

## Aplicativo C++/Qt - questões 1 e 3

O código C++ não faz parte do projeto Flutter. Ele está no diretório separado:

```bash
cd "/Users/augustobatista/Documents/SUBITER/subiter_test_c_qt"
```

A estrutura é:

```text
subiter_test_c_qt/
  CMakeLists.txt
  main.cpp
  question1.h
  question1.cpp
  question3.h
  question3.cpp
```

O projeto utiliza C++17 e somente o módulo `Qt6::Core`. Existe apenas um
`main()`, localizado em `main.cpp`; as questões expõem, respectivamente,
`runQuestion1()` e `runQuestion3()`.

### Executar no Qt Creator

1. Abra [`subiter_test_c_qt/CMakeLists.txt`](../subiter_test_c_qt/CMakeLists.txt)
   no Qt Creator.
2. Selecione o kit Qt 6 para macOS e configure o projeto.
3. Em **Projects > Run > Run Settings**, habilite **Run in terminal**.
4. Compile e execute o alvo `SubiterInspections`.

A execução em terminal é necessária porque a questão 3 lê os dados com
`std::cin`. Sem entrada interativa, o programa informa “A entrada de dados foi
encerrada”.

### Executar pelo Terminal

```bash
cd "/Users/augustobatista/Documents/SUBITER/subiter_test_c_qt"
cmake -S . -B build
cmake --build build
./build/SubiterInspections
```

Caso o Qt não seja encontrado pelo CMake no Terminal, informe a instalação do
Qt em `CMAKE_PREFIX_PATH` ou compile diretamente pelo kit configurado no Qt
Creator.
