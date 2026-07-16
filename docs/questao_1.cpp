#include <QCoreApplication>
#include <QDate>
#include <QDebug>
#include <QString>

#include <memory>
#include <utility>
#include <vector>

class Inspection {
public:
    Inspection(QString id, QString inspector, QDate date, QString result)
        : id_(std::move(id)),
          inspector_(std::move(inspector)),
          date_(std::move(date)),
          result_(std::move(result)) {}

    virtual ~Inspection() = default;

    virtual QString generateReport() const = 0;

protected:
    QString commonReportData() const {
        return QStringLiteral("ID: %1\nInspetor: %2\nData: %3\nResultado: %4")
            .arg(id_, inspector_, date_.toString(Qt::ISODate), result_);
    }

private:
    QString id_;
    QString inspector_;
    QDate date_;
    QString result_;
};

class ThermographicInspection final : public Inspection {
public:
    ThermographicInspection(
        QString id,
        QString inspector,
        QDate date,
        QString result,
        double maximumTemperatureCelsius)
        : Inspection(std::move(id), std::move(inspector), std::move(date), std::move(result)),
          maximumTemperatureCelsius_(maximumTemperatureCelsius) {}

    QString generateReport() const override {
        return QStringLiteral("RELATÓRIO TERMOGRÁFICO\n%1\nTemperatura máxima: %2 °C")
            .arg(commonReportData())
            .arg(maximumTemperatureCelsius_, 0, 'f', 1);
    }

private:
    double maximumTemperatureCelsius_;
};

class UltrasoundInspection final : public Inspection {
public:
    UltrasoundInspection(
        QString id,
        QString inspector,
        QDate date,
        QString result,
        double measuredThicknessMillimeters)
        : Inspection(std::move(id), std::move(inspector), std::move(date), std::move(result)),
          measuredThicknessMillimeters_(measuredThicknessMillimeters) {}

    QString generateReport() const override {
        return QStringLiteral("RELATÓRIO DE ULTRASSOM\n%1\nEspessura medida: %2 mm")
            .arg(commonReportData())
            .arg(measuredThicknessMillimeters_, 0, 'f', 2);
    }

private:
    double measuredThicknessMillimeters_;
};

int main(int argc, char *argv[]) {
    QCoreApplication application(argc, argv);

    std::vector<std::unique_ptr<Inspection>> inspections;
    inspections.push_back(std::make_unique<ThermographicInspection>(
        QStringLiteral("T-001"),
        QStringLiteral("Ana Souza"),
        QDate(2026, 7, 15),
        QStringLiteral("Ponto quente identificado"),
        87.4));
    inspections.push_back(std::make_unique<UltrasoundInspection>(
        QStringLiteral("U-001"),
        QStringLiteral("Carlos Lima"),
        QDate(2026, 7, 15),
        QStringLiteral("Espessura dentro da tolerância"),
        8.25));

    for (const auto &inspection : inspections) {
        qInfo().noquote() << inspection->generateReport() << '\n';
    }

    return 0;
}
