#include "question3.h"

#include <iostream>
#include <limits>
#include <stdexcept>
#include <utility>

namespace
{

std::string readRequiredLine(const std::string &label)
{
    std::string value;

    while (value.empty()) {
        std::cout << label;

        if (!std::getline(std::cin, value)) {
            throw std::runtime_error("A entrada de dados foi encerrada.");
        }
    }

    return value;
}

int readId()
{
    while (true) {
        std::cout << "ID: ";

        int id = 0;

        if (std::cin >> id) {
            std::cin.ignore(
                std::numeric_limits<std::streamsize>::max(),
                '\n'
                );

            if (id > 0) {
                return id;
            }
        } else {
            if (std::cin.eof()) {
                throw std::runtime_error(
                    "A entrada de dados foi encerrada."
                    );
            }

            std::cin.clear();
            std::cin.ignore(
                std::numeric_limits<std::streamsize>::max(),
                '\n'
                );
        }

        std::cout << "Informe um ID inteiro e positivo.\n";
    }
}

} // namespace

Equipment::Equipment(
    int id,
    std::string code,
    std::string name,
    std::string description
    )
    : id_(id),
    code_(std::move(code)),
    name_(std::move(name)),
    description_(std::move(description))
{
}

int Equipment::id() const
{
    return id_;
}

const std::string &Equipment::code() const
{
    return code_;
}

const std::string &Equipment::name() const
{
    return name_;
}

const std::string &Equipment::description() const
{
    return description_;
}

void EquipmentRegistry::add(Equipment equipment)
{
    if (size_ >= capacity) {
        throw std::length_error(
            "Limite de equipamentos atingido."
            );
    }

    equipments_[size_] = std::move(equipment);
    ++size_;
}

void EquipmentRegistry::list(std::ostream &output) const
{
    for (std::size_t index = 0; index < size_; ++index) {
        const Equipment &equipment = equipments_[index].value();

        output
            << "\nEquipamento " << index + 1 << '\n'
            << "ID: " << equipment.id() << '\n'
            << "Código: " << equipment.code() << '\n'
            << "Nome: " << equipment.name() << '\n'
            << "Descrição: " << equipment.description() << '\n';
    }
}

void runQuestion3()
{
    EquipmentRegistry registry;

    for (
        std::size_t index = 0;
        index < EquipmentRegistry::capacity;
        ++index
        ) {
        std::cout
            << "\nCadastro do equipamento "
            << index + 1
            << '\n';

        const int id = readId();

        const std::string code =
            readRequiredLine("Código: ");

        const std::string name =
            readRequiredLine("Nome: ");

        const std::string description =
            readRequiredLine("Descrição: ");

        registry.add(
            Equipment(
                id,
                code,
                name,
                description
                )
            );
    }

    std::cout
        << "\n=== Equipamentos cadastrados ===\n";

    registry.list(std::cout);
}