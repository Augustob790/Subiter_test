#include <QCoreApplication>
#include <QDebug>

#include <exception>

#include "question1.h"
#include "question3.h"

int main(int argc, char *argv[])
{
    QCoreApplication application(argc, argv);

    try {
        qInfo().noquote()
        << "=== QUESTÃO 1 ===\n";

        runQuestion1();

        qInfo().noquote()
            << "\n=== QUESTÃO 3 ===\n";

        runQuestion3();
    } catch (const std::exception &error) {
        qCritical().noquote()
        << "Erro:"
        << error.what();

        return 1;
    }

    return 0;
}