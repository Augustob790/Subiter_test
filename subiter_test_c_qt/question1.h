#ifndef QUESTION1_H
#define QUESTION1_H

#include <QDate>
#include <QString>

class Inspection
{
public:
    Inspection(
        QString id,
        QString inspector,
        QDate date,
        QString result
        );

    virtual ~Inspection() = default;

    Inspection(const Inspection &) = delete;
    Inspection &operator=(const Inspection &) = delete;

    virtual QString generateReport() const = 0;

protected:
    QString commonReportData() const;

private:
    QString id_;
    QString inspector_;
    QDate date_;
    QString result_;
};

class ThermographicInspection final : public Inspection
{
public:
    ThermographicInspection(
        QString id,
        QString inspector,
        QDate date,
        QString result,
        double maximumTemperatureCelsius
        );

    QString generateReport() const override;

private:
    double maximumTemperatureCelsius_;
};

class UltrasoundInspection final : public Inspection
{
public:
    UltrasoundInspection(
        QString id,
        QString inspector,
        QDate date,
        QString result,
        double measuredThicknessMillimeters
        );

    QString generateReport() const override;

private:
    double measuredThicknessMillimeters_;
};

void runQuestion1();

#endif // QUESTION1_H