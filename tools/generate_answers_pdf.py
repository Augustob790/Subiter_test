from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    HRFlowable,
    KeepTogether,
    PageBreak,
    Paragraph,
    Preformatted,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "output" / "pdf" / "Respostas_Prova_Subiter.pdf"

pdfmetrics.registerFont(
    TTFont("Arial", "/System/Library/Fonts/Supplemental/Arial.ttf")
)
pdfmetrics.registerFont(
    TTFont("Arial-Bold", "/System/Library/Fonts/Supplemental/Arial Bold.ttf")
)
pdfmetrics.registerFont(
    TTFont("Arial-Italic", "/System/Library/Fonts/Supplemental/Arial Italic.ttf")
)

GREEN = colors.HexColor("#315C4C")
LIGHT_GREEN = colors.HexColor("#E3EFEA")
INK = colors.HexColor("#23302B")
MUTED = colors.HexColor("#5D6B65")
CODE_BG = colors.HexColor("#F3F5F4")

styles = getSampleStyleSheet()
styles.add(
    ParagraphStyle(
        "CoverTitle",
        fontName="Arial-Bold",
        fontSize=25,
        leading=30,
        textColor=GREEN,
        alignment=TA_CENTER,
        spaceAfter=12,
    )
)
styles.add(
    ParagraphStyle(
        "CoverSub",
        fontName="Arial",
        fontSize=12,
        leading=18,
        textColor=MUTED,
        alignment=TA_CENTER,
    )
)
styles.add(
    ParagraphStyle(
        "H1Custom",
        fontName="Arial-Bold",
        fontSize=18,
        leading=22,
        textColor=GREEN,
        spaceBefore=4,
        spaceAfter=10,
    )
)
styles.add(
    ParagraphStyle(
        "H2Custom",
        fontName="Arial-Bold",
        fontSize=12,
        leading=15,
        textColor=INK,
        spaceBefore=10,
        spaceAfter=5,
    )
)
styles.add(
    ParagraphStyle(
        "BodyCustom",
        fontName="Arial",
        fontSize=9.3,
        leading=13.2,
        textColor=INK,
        alignment=TA_JUSTIFY,
        spaceAfter=7,
    )
)
styles.add(
    ParagraphStyle(
        "BulletCustom",
        parent=styles["BodyCustom"],
        leftIndent=12,
        firstLineIndent=-7,
        bulletIndent=4,
        spaceAfter=4,
    )
)
styles.add(
    ParagraphStyle(
        "CodeCustom",
        fontName="Courier",
        fontSize=6.8,
        leading=8.7,
        leftIndent=7,
        rightIndent=7,
        borderColor=colors.HexColor("#D7DEDA"),
        borderWidth=0.5,
        borderPadding=7,
        backColor=CODE_BG,
        spaceBefore=5,
        spaceAfter=9,
    )
)
styles.add(
    ParagraphStyle(
        "TableHeader",
        fontName="Arial-Bold",
        fontSize=9.3,
        leading=12,
        textColor=colors.white,
    )
)


def header_footer(canvas, document):
    canvas.saveState()
    width, height = A4
    canvas.setStrokeColor(colors.HexColor("#D8E0DC"))
    canvas.line(18 * mm, height - 14 * mm, width - 18 * mm, height - 14 * mm)
    canvas.setFont("Arial", 7.5)
    canvas.setFillColor(MUTED)
    canvas.drawString(18 * mm, height - 10.5 * mm, "Prova técnica Subiter - Respostas")
    canvas.drawRightString(width - 18 * mm, 10 * mm, f"Página {document.page}")
    canvas.restoreState()


def p(text, style="BodyCustom"):
    return Paragraph(text, styles[style])


def bullet(text):
    return Paragraph(f"• {text}", styles["BulletCustom"])


def title(number, text):
    return [p(f"{number}. {text}", "H1Custom"), HRFlowable(color=GREEN, thickness=1)]


def code(text):
    return Preformatted(text.strip(), styles["CodeCustom"])


def build():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=A4,
        rightMargin=18 * mm,
        leftMargin=18 * mm,
        topMargin=20 * mm,
        bottomMargin=17 * mm,
        title="Respostas - Prova Subiter Rev. 1",
        author="Augusto Batista",
    )
    story = []

    story += [
        Spacer(1, 42 * mm),
        p("PROVA TÉCNICA SUBITER", "CoverTitle"),
        p("Respostas completas - Revisão 1", "CoverSub"),
        Spacer(1, 14 * mm),
        HRFlowable(width="65%", color=GREEN, thickness=2, hAlign="CENTER"),
        Spacer(1, 12 * mm),
        p(
            "Soluções em C++/Qt e Flutter, com POO, SOLID, Clean Code, "
            "Clean Architecture, MVVM, Provider/ChangeNotifier, GoRouter, "
            "GetIt, i18n e SQLite.",
            "CoverSub",
        ),
        Spacer(1, 52 * mm),
        p("15 de julho de 2026", "CoverSub"),
        PageBreak(),
    ]

    story += title("1", "Gerenciamento de inspeções industriais em C++ e Qt")
    story += [
        p("a) Modelagem da solução" , "H2Custom"),
        p(
            "A solução usa uma classe abstrata <b>Inspection</b> para os dados e "
            "o contrato comuns: ID, inspetor, data, resultado e geração de relatório. "
            "As classes <b>ThermographicInspection</b> e "
            "<b>UltrasoundInspection</b> especializam apenas o dado e a regra de "
            "relatório próprios de cada modalidade. Os consumidores trabalham com "
            "ponteiros para a abstração, permitindo polimorfismo em tempo de execução."
        ),
        p("b) Diagrama de classes", "H2Custom"),
        code("""
                 +------------------------------+
                 | Inspection (abstrata)        |
                 | id, inspector, date, result  |
                 | + generateReport(): QString  |
                 +---------------+--------------+
                                 |
                   +-------------+-------------+
                   |                           |
 +-----------------v--------------+  +---------v--------------------+
 | ThermographicInspection        |  | UltrasoundInspection         |
 | maximumTemperatureCelsius      |  | measuredThicknessMillimeters |
 | + generateReport(): QString    |  | + generateReport(): QString  |
 +--------------------------------+  +------------------------------+
"""),
        p("Decisões de projeto", "H2Custom"),
        bullet("Encapsulamento: atributos privados e dados comuns protegidos pela classe-base."),
        bullet("SRP: cada modalidade conhece somente a geração de seu relatório."),
        bullet("OCP/LSP: novos tipos podem implementar o contrato sem quebrar os consumidores."),
        bullet("DIP: a aplicação depende de Inspection, e não das classes concretas."),
        bullet("Qt: QString, QDate, QCoreApplication e qInfo integram a solução ao framework."),
        p("Trecho central", "H2Custom"),
        code("""
class Inspection {
public:
    virtual ~Inspection() = default;
    virtual QString generateReport() const = 0;
protected:
    QString commonReportData() const;
private:
    QString id_, inspector_, result_;
    QDate date_;
};

class ThermographicInspection final : public Inspection {
public:
    QString generateReport() const override;
private:
    double maximumTemperatureCelsius_;
};

class UltrasoundInspection final : public Inspection {
public:
    QString generateReport() const override;
private:
    double measuredThicknessMillimeters_;
};
"""),
        p(
            "A implementação C++/Qt completa, incluindo construtores, relatórios e "
            "exemplo de uso polimórfico, está em "
            "<b>subiter_test_c_qt/question1.h</b> e "
            "<b>subiter_test_c_qt/question1.cpp</b>. O executável usa o único "
            "ponto de entrada definido em <b>subiter_test_c_qt/main.cpp</b>."
        ),
        PageBreak(),
    ]

    story += title("2", "Lista de inspeções consumindo API REST simulada")
    story += [
        p("Comportamento entregue", "H2Custom"),
        p(
            "O aplicativo lista inspeções termográficas e por ultrassom. O arquivo "
            "<b>assets/mocks/inspections.json</b> simula o retorno de uma API REST "
            "com statusCode, message e data.inspections. Cada card apresenta ID, "
            "tipo, equipamento, inspetor, data, local, resultado, resumo e medição."
        ),
        p("Contrato JSON simulado", "H2Custom"),
        code("""
{
  "statusCode": 200,
  "message": "Inspeções carregadas com sucesso",
  "data": { "inspections": [ ... ] }
}
"""),
        p("Arquitetura e fluxo", "H2Custom"),
        code("""
InspectionsScreen -> InspectionsViewModel (ChangeNotifier)
  -> GetInspectionsUseCase
  -> InspectionsRepository (contrato do domínio)
  -> InspectionsRepositoryImpl
       |-> JsonInspectionsRemoteDataSource -> JSON/REST simulado
       +-> SqliteInspectionsLocalDataSource -> SQLite
"""),
        p("Separação entre interface e lógica", "H2Custom"),
        bullet("UI: InspectionsScreen e InspectionCard apenas renderizam e encaminham ações."),
        bullet("ViewModel: coordena o caso de uso e expõe estado e lista tipada."),
        bullet("Domain: InspectionModel, enums, contrato do repositório e caso de uso."),
        bullet("Infra: data model, parsing do JSON, SQLite e implementação do repositório."),
        bullet("Injeção: GetIt cria clientes, fontes, repositórios, casos de uso e ViewModels."),
        bullet("Navegação: rota nomeada /inspections integrada ao GoRouter."),
        p("Gerenciamento de estado", "H2Custom"),
        p(
            "O ViewModel estende ChangeNotifier e é fornecido por Provider. Expõe "
            "<b>initial, loading, success, empty e error</b>. A tela usa Consumer, "
            "mostra progresso, lista, estado vazio ou erro e oferece pull-to-refresh."
        ),
        p("Trecho do ViewModel", "H2Custom"),
        code("""
Future<void> getInspections() async {
  if (isLoading) return;
  _state = InspectionsViewState.loading;
  notifyListeners();
  try {
    final response = await _getInspectionsUseCase();
    _inspections = response.inspections;
    _state = _inspections.isEmpty
        ? InspectionsViewState.empty
        : InspectionsViewState.success;
  } on Object {
    _state = InspectionsViewState.error;
  }
  notifyListeners();
}
"""),
        p("Tratamento de erros", "H2Custom"),
        p(
            "A fonte valida status HTTP simulado, envelope, lista e campos "
            "obrigatórios. Payload inválido vira DataException na infraestrutura. "
            "Em falha, o repositório tenta o cache SQLite; sem cache, o ViewModel "
            "expõe error e a tela apresenta mensagem amigável e Tentar novamente. "
            "Uma API HTTP real pode substituir apenas o RemoteDataSource."
        ),
        PageBreak(),
    ]

    story += title("3", "Cadastro de três equipamentos em C++")
    story += [
        p(
            "A classe <b>Equipment</b> representa nome, código, ID e descrição. "
            "A classe <b>EquipmentRegistry</b> tem responsabilidade exclusiva de "
            "armazenar no máximo três equipamentos e listá-los. A leitura exige "
            "texto não vazio, aceita espaços e valida ID inteiro positivo."
        ),
        code("""
class Equipment {
public:
    Equipment(int id, std::string code,
              std::string name, std::string description);
    int id() const;
    const std::string& code() const;
    const std::string& name() const;
    const std::string& description() const;
private:
    int id_;
    std::string code_, name_, description_;
};

class EquipmentRegistry {
public:
    static constexpr std::size_t capacity = 3;
    void add(Equipment equipment);
    void list(std::ostream& output) const;
private:
    std::array<Equipment, capacity> equipments_;
    std::size_t size_ = 0;
};
"""),
        p("Algoritmo", "H2Custom"),
        bullet("Criar EquipmentRegistry com capacidade fixa igual a três."),
        bullet("Repetir três vezes: ler ID, código, nome e descrição; validar; criar Equipment."),
        bullet("Adicionar a entidade ao registro e impedir inserção além da capacidade."),
        bullet("Ao final, percorrer os três objetos e imprimir todos os atributos."),
        p("Compilação", "H2Custom"),
        code("""
cd subiter_test_c_qt
cmake -S . -B build
cmake --build build
./build/SubiterInspections
"""),
        p(
            "O programa completo está em "
            "<b>subiter_test_c_qt/question3.h</b> e "
            "<b>subiter_test_c_qt/question3.cpp</b>. No Qt Creator, a opção "
            "<b>Run in terminal</b> deve estar habilitada porque a atividade usa "
            "entrada interativa com std::cin."
        ),
        PageBreak(),
    ]

    story += title("4", "Cadastro de atividade em Flutter")
    story += [
        p(
            "A rota <b>/activities/register</b> apresenta os campos Nome da empresa "
            "e Local, ambos obrigatórios, e o botão Cadastrar. O formulário mantém "
            "TextEditingControllers na camada de apresentação e os descarta em "
            "dispose(). Após a validação, o ViewModel executa RegisterActivity."
        ),
        p("Fluxo Clean Architecture/MVVM", "H2Custom"),
        code("""
ActivityRegistrationPage
  -> ActivityRegistrationViewModel (ChangeNotifier)
  -> RegisterActivity (valida e normaliza)
  -> ActivitiesRepository (contrato)
  -> ActivitiesRepositoryImpl
  -> SQLite / tabela activities
"""),
        p(
            "O caso de uso remove espaços externos, cria a entidade Activity e "
            "persiste empresa, local e data do cadastro. O ViewModel expõe os estados "
            "initial, saving, success e failure. Durante a gravação, o botão é "
            "desabilitado para evitar duplicidade."
        ),
        p("Trecho do caso de uso", "H2Custom"),
        code("""
Future<Activity> call({
  required String companyName,
  required String location,
}) {
  final company = companyName.trim();
  final place = location.trim();
  if (company.isEmpty || place.isEmpty) {
    throw const FormatException('Campos obrigatórios não informados.');
  }
  return _repository.save(Activity(
    companyName: company,
    location: place,
    createdAt: DateTime.now(),
  ));
}
"""),
        p("Resultado exibido", "H2Custom"),
        Table(
            [[p("<b>Cadastro realizado com sucesso!</b><br/>"
                 "Empresa: ABC Engenharia - Local: São José dos Campos")]],
            colWidths=[155 * mm],
            style=TableStyle([
                ("BACKGROUND", (0, 0), (-1, -1), LIGHT_GREEN),
                ("BOX", (0, 0), (-1, -1), 0.8, GREEN),
                ("LEFTPADDING", (0, 0), (-1, -1), 12),
                ("RIGHTPADDING", (0, 0), (-1, -1), 12),
                ("TOPPADDING", (0, 0), (-1, -1), 12),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 12),
            ])),
        Spacer(1, 8),
        p(
            "A mensagem usa os valores realmente digitados. Textos de interface "
            "são obtidos pelo catálogo i18n, e o GoRouter/GetIt fazem navegação e "
            "injeção sem acoplar a página à infraestrutura."
        ),
        PageBreak(),
    ]

    story += title("5", "Mapa da entrega e validação")
    rows = [
        [p("Item", "TableHeader"), p("Local", "TableHeader")],
        [p("Aplicação/rotas"), p("lib/app/")],
        [p("i18n, banco e injeção"), p("lib/core/")],
        [p("Questão 2"), p("lib/modules/inspections/")],
        [p("JSON REST simulado"), p("assets/mocks/inspections.json")],
        [p("Questão 4"), p("lib/modules/activities/")],
        [p("Questões 1 e 3"), p("subiter_test_c_qt/question1.* e question3.*")],
        [p("Testes"), p("test/")],
    ]
    table = Table(rows, colWidths=[48 * mm, 107 * mm], repeatRows=1)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), GREEN),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#C9D2CE")),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 8),
        ("RIGHTPADDING", (0, 0), (-1, -1), 8),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    story += [
        table,
        Spacer(1, 14),
        p("Comandos de validação executados", "H2Custom"),
        code("""
flutter analyze
flutter test
cmake -S subiter_test_c_qt -B subiter_test_c_qt/build
cmake --build subiter_test_c_qt/build
"""),
        bullet("Análise estática Flutter: sem problemas."),
        bullet("Testes automatizados: parsing, estados das inspeções, erros e cadastro validados."),
        bullet("Questão 3: compilada com avisos rigorosos e executada com três registros."),
        bullet("PDF final: renderizado e inspecionado página a página."),
        p("Execução do aplicativo", "H2Custom"),
        code("""
flutter pub get
flutter run
"""),
        p(
            "A arquitetura usa abstrações apenas onde há fronteiras reais (API, SQLite "
            "e casos de uso), evitando classes artificiais. Isso mantém SOLID e Clean "
            "Architecture de forma prática, legível e testável."
        ),
    ]

    doc.build(story, onFirstPage=header_footer, onLaterPages=header_footer)


if __name__ == "__main__":
    build()
    print(OUTPUT)
