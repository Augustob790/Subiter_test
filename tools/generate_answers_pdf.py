from pathlib import Path

from PIL import Image as PilImage
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    HRFlowable,
    Image,
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
IMAGES = ROOT / "docs" / "images"
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
LIGHT_GREEN = colors.HexColor("#E7F0EC")
INK = colors.HexColor("#26332E")
MUTED = colors.HexColor("#637069")
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
        spaceAfter=10,
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
        spaceAfter=9,
    )
)
styles.add(
    ParagraphStyle(
        "H2Custom",
        fontName="Arial-Bold",
        fontSize=12,
        leading=15,
        textColor=INK,
        spaceBefore=8,
        spaceAfter=5,
    )
)
styles.add(
    ParagraphStyle(
        "BodyCustom",
        fontName="Arial",
        fontSize=9.5,
        leading=13.7,
        textColor=INK,
        alignment=TA_LEFT,
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
        "NoteCustom",
        parent=styles["BodyCustom"],
        backColor=LIGHT_GREEN,
        borderColor=GREEN,
        borderLeftWidth=2,
        borderPadding=8,
        leftIndent=6,
        rightIndent=6,
        spaceBefore=4,
        spaceAfter=8,
    )
)
styles.add(
    ParagraphStyle(
        "CaptionCustom",
        fontName="Arial-Italic",
        fontSize=8,
        leading=10,
        textColor=MUTED,
        alignment=TA_CENTER,
        spaceBefore=4,
        spaceAfter=8,
    )
)


def header_footer(canvas, document):
    canvas.saveState()
    width, height = A4
    canvas.setStrokeColor(colors.HexColor("#D8E0DC"))
    canvas.line(18 * mm, height - 14 * mm, width - 18 * mm, height - 14 * mm)
    canvas.setFont("Arial", 7.5)
    canvas.setFillColor(MUTED)
    canvas.drawString(18 * mm, height - 10.5 * mm, "Augusto Batista | Prova técnica Subiter")
    canvas.drawRightString(width - 18 * mm, 10 * mm, f"Página {document.page}")
    canvas.restoreState()


def p(text, style="BodyCustom"):
    return Paragraph(text, styles[style])


def bullet(text):
    return Paragraph(f"• {text}", styles["BulletCustom"])


def title(number, text):
    return [
        p(f"{number}. {text}", "H1Custom"),
        HRFlowable(color=GREEN, thickness=1),
        Spacer(1, 3 * mm),
    ]


def code(text):
    return Preformatted(text.strip(), styles["CodeCustom"])


def scaled_image(path, max_width, max_height):
    with PilImage.open(path) as source:
        width, height = source.size
    scale = min(max_width / width, max_height / height)
    return Image(str(path), width=width * scale, height=height * scale)


def build():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    document = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=A4,
        rightMargin=18 * mm,
        leftMargin=18 * mm,
        topMargin=20 * mm,
        bottomMargin=17 * mm,
        title="Resolução da Prova Técnica Subiter",
        author="Augusto Batista",
    )

    story = [
        Spacer(1, 40 * mm),
        p("PROVA TÉCNICA SUBITER", "CoverTitle"),
        p("Resolução das atividades", "CoverSub"),
        Spacer(1, 13 * mm),
        HRFlowable(width="62%", color=GREEN, thickness=2, hAlign="CENTER"),
        Spacer(1, 13 * mm),
        p("Augusto Batista", "CoverTitle"),
        p("Implementações em C++/Qt e Flutter", "CoverSub"),
        Spacer(1, 10 * mm),
        p(
            'Código-fonte: <link href="https://github.com/Augustob790/Subiter_test" '
            'color="#315C4C"><u>github.com/Augustob790/Subiter_test</u></link>',
            "CoverSub",
        ),
        Spacer(1, 14 * mm),
        p(
            "Neste documento apresento as decisões que tomei em cada atividade, "
            "os pontos principais do código e a forma de executar os dois projetos.",
            "CoverSub",
        ),
        Spacer(1, 34 * mm),
        p("15 de julho de 2026", "CoverSub"),
        PageBreak(),
    ]

    story += title("1", "Inspeções industriais em C++ e Qt")
    story += [
        p("Como organizei a solução", "H2Custom"),
        p(
            "Optei por concentrar os dados comuns em <b>Inspection</b>: código, "
            "inspetor, data e resultado. Ela é abstrata porque uma inspeção genérica "
            "não tem relatório próprio. Quem define esse conteúdo são "
            "<b>ThermographicInspection</b> e <b>UltrasoundInspection</b>."
        ),
        p(
            "O método <b>commonReportData()</b> evita repetir a montagem do cabeçalho. "
            "Cada classe derivada acrescenta somente sua medição: temperatura máxima "
            "ou espessura. Assim, se surgir outro tipo de inspeção, basta criar uma "
            "nova classe e implementar <b>generateReport()</b>."
        ),
        p("Visão das classes", "H2Custom"),
        KeepTogether(
            [
                scaled_image(
                    IMAGES / "inspection_uml.png",
                    160 * mm,
                    87 * mm,
                ),
                p(
                    "Diagrama de classes usado na modelagem das inspeções.",
                    "CaptionCustom",
                ),
            ]
        ),
        p("Uso do polimorfismo", "H2Custom"),
        code("""
std::vector<std::unique_ptr<Inspection>> inspections;
inspections.push_back(
    std::make_unique<ThermographicInspection>(/* dados */));
inspections.push_back(
    std::make_unique<UltrasoundInspection>(/* dados */));

for (const auto &inspection : inspections) {
    qInfo().noquote() << inspection->generateReport();
}
"""),
        p(
            "Esse trecho é o que demonstra o polimorfismo de fato: o laço conhece "
            "somente <b>Inspection</b>, mas cada objeto gera o relatório correto. "
            "O uso de <b>unique_ptr</b> também deixa clara a propriedade dos objetos "
            "e evita gerenciamento manual de memória."
        ),
        p(
            "Em termos de SOLID, a decisão mais relevante aqui é manter o consumidor "
            "dependente da abstração. SRP, OCP e LSP aparecem como consequência dessa "
            "modelagem, e não como camadas adicionais sem necessidade."
        ),
        p(
            "Código: <b>subiter_test_c_qt/question1.h</b> e "
            "<b>subiter_test_c_qt/question1.cpp</b>. O único <b>main()</b> do projeto "
            "fica em <b>subiter_test_c_qt/main.cpp</b>.",
            "NoteCustom",
        ),
        PageBreak(),
    ]

    story += title("2", "Lista de inspeções consumindo uma API REST simulada")
    story += [
        p("O que foi implementado", "H2Custom"),
        p(
            "Como não havia um backend para o exercício, usei "
            "<b>assets/mocks/inspections.json</b> como resposta da API. O arquivo "
            "mantém um envelope parecido com o de um endpoint real, com statusCode, "
            "message e data.inspections. A intenção foi exercitar o mesmo parsing e "
            "o mesmo tratamento de falhas que eu usaria com uma chamada HTTP."
        ),
        code("""
{
  "statusCode": 200,
  "message": "Inspeções carregadas com sucesso",
  "data": { "inspections": [ ... ] }
}
"""),
        p("Separação entre tela e lógica", "H2Custom"),
        p(
            "A tela apenas observa o <b>InspectionsViewModel</b> pelo Provider. Ela "
            "não abre o JSON, não consulta SQLite e não conhece o formato externo. "
            "O ViewModel chama <b>GetInspectionsUseCase</b>, que depende do contrato "
            "<b>InspectionsRepository</b>. A implementação concreta fica em infra."
        ),
        code("""
InspectionsScreen
  -> InspectionsViewModel (ChangeNotifier)
  -> GetInspectionsUseCase
  -> InspectionsRepository
  -> JSON simulado + cache SQLite
"""),
        p("Estado e erros", "H2Custom"),
        p(
            "Mantive estados explícitos para <b>initial</b>, <b>loading</b>, "
            "<b>success</b>, <b>empty</b> e <b>error</b>. Isso deixa o build da tela "
            "previsível: cada estado tem uma representação e o botão de nova tentativa "
            "apenas dispara o carregamento novamente."
        ),
        p(
            "No repositório, primeiro tento a fonte que simula o servidor. Quando a "
            "resposta é válida, substituo o cache SQLite. Se a leitura falhar, procuro "
            "a última lista salva. Só devolvo erro para a tela quando também não há "
            "cache. Preferi esse fluxo porque ele mantém a listagem útil mesmo em uma "
            "falha temporária."
        ),
        p(
            "Para trocar o mock por uma API real, seria necessário substituir somente "
            "a implementação de <b>InspectionsRemoteDataSource</b>. Tela, ViewModel, "
            "caso de uso e domínio permanecem iguais.",
            "NoteCustom",
        ),
        PageBreak(),
        p("Resultado da questão 2", "H1Custom"),
        Spacer(1, 4 * mm),
        scaled_image(IMAGES / "inspections_list.png", 82 * mm, 178 * mm),
        p(
            "Lista carregada a partir do contrato JSON, com tipo, resultado, "
            "responsável, local e medição de cada inspeção.",
            "CaptionCustom",
        ),
        PageBreak(),
    ]

    story += title("3", "Cadastro de três equipamentos em C++")
    story += [
        p("Escolha da estrutura", "H2Custom"),
        p(
            "O enunciado limita o cadastro a exatamente três equipamentos. Por isso, "
            "usei um <b>std::array</b> com capacidade fixa em vez de um vector que "
            "cresceria sem limite. Cada posição é um <b>std::optional&lt;Equipment&gt;</b>, "
            "pois um espaço ainda não preenchido não deve ser representado por um "
            "equipamento falso com ID zero e textos vazios."
        ),
        code("""
class EquipmentRegistry final {
public:
    static constexpr std::size_t capacity = 3;
    void add(Equipment equipment);
    void list(std::ostream &output) const;
private:
    std::array<std::optional<Equipment>, capacity> equipments_;
    std::size_t size_ = 0;
};
"""),
        p("Validação da entrada", "H2Custom"),
        p(
            "O ID só é aceito quando é inteiro e positivo. Em uma entrada inválida, "
            "limpo o estado de <b>std::cin</b> e descarto o restante da linha antes de "
            "pedir o valor novamente. Código, nome e descrição são lidos com getline, "
            "portanto aceitam espaços, mas não podem ficar vazios."
        ),
        p(
            "Também tratei o fim da entrada. Foi esse caso que apareceu quando o Qt "
            "Creator executou o programa sem terminal interativo; por isso o projeto "
            "mostrou a mensagem “A entrada de dados foi encerrada”."
        ),
        p("Como executar", "H2Custom"),
        code("""
cd subiter_test_c_qt
cmake -S . -B build
cmake --build build
./build/SubiterInspections
"""),
        p(
            "No Qt Creator, habilite <b>Projects &gt; Run &gt; Run Settings &gt; "
            "Run in terminal</b>. A questão 3 depende dessa opção para receber os "
            "dados digitados.",
            "NoteCustom",
        ),
        p(
            "Código: <b>subiter_test_c_qt/question3.h</b> e "
            "<b>subiter_test_c_qt/question3.cpp</b>."
        ),
        PageBreak(),
    ]

    story += title("4", "Cadastro de atividade em Flutter")
    story += [
        p("Organização da funcionalidade", "H2Custom"),
        p(
            "A tela pede nome da empresa e local. Mantive <b>Activity</b> como nome da "
            "entidade de domínio, seguindo o enunciado, e agrupei as telas no módulo "
            "<b>companies</b>, que é como a funcionalidade aparece para o usuário."
        ),
        p(
            "Ao tocar em Cadastrar, a página envia os valores para "
            "<b>ActivityRegistrationViewModel</b>. O ViewModel não grava no banco "
            "diretamente: ele chama <b>RegisterActivity</b>, que remove espaços nas "
            "extremidades, valida os dois campos e usa o contrato "
            "<b>ActivitiesRepository</b>. A implementação desse contrato persiste o "
            "registro na tabela activities do SQLite."
        ),
        code("""
ActivityRegistrationPage
  -> ActivityRegistrationViewModel
  -> RegisterActivity
  -> ActivitiesRepository
  -> ActivitiesRepositoryImpl
  -> SQLite
"""),
        p("Comportamento da tela", "H2Custom"),
        p(
            "Durante a gravação, o estado passa para <b>saving</b> e novas submissões "
            "são bloqueadas. Em caso de sucesso, o objeto salvo fica disponível para "
            "montar a confirmação com os dados realmente digitados. Em caso de falha, "
            "a tela recebe um estado próprio e continua responsável apenas por mostrar "
            "a mensagem adequada."
        ),
        p(
            "A mesma tela também recebe um item selecionado para edição. A listagem "
            "permite atualizar e excluir registros, sempre passando pelas classes do "
            "módulo em vez de acessar o banco a partir do widget."
        ),
        p(
            "Rotas: <b>/activities</b> para a lista e "
            "<b>/activities/register</b> para o formulário. Os textos visíveis usam o "
            "catálogo de internacionalização e as dependências são registradas no GetIt.",
            "NoteCustom",
        ),
        PageBreak(),
        p("Resultado da questão 4", "H1Custom"),
        Spacer(1, 5 * mm),
    ]

    companies_image = scaled_image(
        IMAGES / "companies_list.png", 74 * mm, 166 * mm
    )
    registration_image = scaled_image(
        IMAGES / "company_registration.png", 74 * mm, 166 * mm
    )
    evidence = Table(
        [
            [companies_image, registration_image],
            [
                p("Lista com registro persistido.", "CaptionCustom"),
                p("Formulário de cadastro.", "CaptionCustom"),
            ],
        ],
        colWidths=[78 * mm, 78 * mm],
        hAlign="CENTER",
    )
    evidence.setStyle(
        TableStyle(
            [
                ("ALIGN", (0, 0), (-1, -1), "CENTER"),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 2 * mm),
                ("RIGHTPADDING", (0, 0), (-1, -1), 2 * mm),
                ("TOPPADDING", (0, 0), (-1, -1), 0),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 1 * mm),
            ]
        )
    )
    story += [
        KeepTogether([evidence]),
        Spacer(1, 5 * mm),
        p(
            "Os projetos são independentes na execução, mas ficam no mesmo "
            "repositório: Flutter na raiz e C++/Qt em "
            "<b>subiter_test_c_qt/</b>."
        ),
        p(
            'Código completo: <link href="https://github.com/Augustob790/Subiter_test" '
            'color="#315C4C"><u>github.com/Augustob790/Subiter_test</u></link>',
            "NoteCustom",
        ),
    ]

    document.build(
        story,
        onFirstPage=header_footer,
        onLaterPages=header_footer,
    )


if __name__ == "__main__":
    build()
    print(OUTPUT)
