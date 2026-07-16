# Prova técnica Subiter - respostas e aplicativo Flutter

Este repositório reúne as quatro respostas da `Prova_Subiter_Rev1.pdf`.

## Entregáveis

- `docs/questao_1.cpp`: modelagem C++/Qt para inspeções termográficas e por ultrassom.
- `docs/questao_3.cpp`: cadastro e listagem de três equipamentos em C++17.
- `lib/`: aplicativo Flutter das questões 2 e 4.
- `assets/mocks/inspections.json`: resposta JSON que simula a API REST.
- `docs/respostas.md`: justificativas, arquitetura e instruções.
- `output/pdf/Respostas_Prova_Subiter.pdf`: versão final das respostas.

## Aplicativo Flutter

O app abre na lista de inspeções. A questão 2 usa um JSON local com formato de
resposta REST (`statusCode`, `message`, `data.inspections`). A leitura do asset
fica isolada atrás de `InspectionsRemoteDataSource`, portanto uma API HTTP real
pode substituí-la sem alterações na tela, ViewModel ou domínio.

Arquitetura baseada no padrão do `precificakm-mobile`:

- módulo organizado em `domain/`, `infra/` e `ui/`;
- MVVM com `ChangeNotifier` e `Provider`;
- contrato `InspectionsRepository` no domínio e implementação `Impl` na infra;
- `get_it` para injeção de dependências;
- `go_router` e rota nomeada em `inspections_routes.dart`;
- SQLite para cache das inspeções e persistência das atividades;
- i18n em português e inglês;
- estados explícitos de carregamento, sucesso, vazio, cache e erro.

### Executar

```bash
flutter pub get
flutter run
```

### Validar

```bash
flutter analyze
flutter test
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
