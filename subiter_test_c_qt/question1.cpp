#include "question1.h"

#include <QDebug>

#include <memory>
#include <utility>
#include <vector>

Inspection::Inspection(
    QString id,
    QString inspector,
    QDate date,
    QString result
    )
    : id_(std::move(id)),
    inspector_(std::move(inspector)),
    date_(std::move(date)),
    result_(std::move(result))
{
}

QString Inspection::commonReportData() const
{
    return QStringLiteral(
               "ID: %1\n"
               "Inspetor: %2\n"
               "Data: %3\n"
               "Resultado: %4"
               )
        .arg(id_)
        .arg(inspector_)
        .arg(date_.toString(Qt::ISODate))
        .arg(result_);
}

ThermographicInspection::ThermographicInspection(
    QString id,
    QString inspector,
    QDate date,
    QString result,
    double maximumTemperatureCelsius
    )
    : Inspection(
          std::move(id),
          std::move(inspector),
          std::move(date),
          std::move(result)
          ),
    maximumTemperatureCelsius_(maximumTemperatureCelsius)
{
}

QString ThermographicInspection::generateReport() const
{
    return QStringLiteral(
               "RELATÓRIO TERMOGRÁFICO\n"
               "%1\n"
               "Temperatura máxima: %2 °C"
               )
        .arg(commonReportData())
        .arg(maximumTemperatureCelsius_, 0, 'f', 1);
}

UltrasoundInspection::UltrasoundInspection(
    QString id,
    QString inspector,
    QDate date,
    QString result,
    double measuredThicknessMillimeters
    )
    : Inspection(
          std::move(id),
          std::move(inspector),
          std::move(date),
          std::move(result)
          ),
    measuredThicknessMillimeters_(measuredThicknessMillimeters)
{
}

QString UltrasoundInspection::generateReport() const
{
    return QStringLiteral(
               "RELATÓRIO DE ULTRASSOM\n"
               "%1\n"
               "Espessura medida: %2 mm"
               )
        .arg(commonReportData())
        .arg(measuredThicknessMillimeters_, 0, 'f', 2);
}

void runQuestion1()
{
    std::vector<std::unique_ptr<Inspection>> inspections;

    inspections.push_back(
        std::make_unique<ThermographicInspection>(
            QStringLiteral("T-001"),
            QStringLiteral("Ana Souza"),
            QDate(2026, 7, 15),
            QStringLiteral("Ponto quente identificado"),
            87.4
            )
        );

    inspections.push_back(
        std::make_unique<UltrasoundInspection>(
            QStringLiteral("U-001"),
            QStringLiteral("Carlos Lima"),
            QDate(2026, 7, 15),
            QStringLiteral("Espessura dentro da tolerância"),
            8.25
            )
        );

    for (const std::unique_ptr<Inspection> &inspection : inspections) {
        qInfo().noquote()
        << inspection->generateReport()
        << '\n';
    }
}