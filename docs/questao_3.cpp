#include <array>
#include <cstddef>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <utility>

class Equipment {
public:
    Equipment(int id, std::string code, std::string name, std::string description)
        : id_(id),
          code_(std::move(code)),
          name_(std::move(name)),
          description_(std::move(description)) {}

    int id() const { return id_; }
    const std::string &code() const { return code_; }
    const std::string &name() const { return name_; }
    const std::string &description() const { return description_; }

private:
    int id_;
    std::string code_;
    std::string name_;
    std::string description_;
};

class EquipmentRegistry {
public:
    static constexpr std::size_t capacity = 3;

    void add(Equipment equipment) {
        if (size_ == capacity) {
            throw std::length_error("Limite de equipamentos atingido.");
        }
        equipments_[size_++] = std::move(equipment);
    }

    void list(std::ostream &output) const {
        for (std::size_t index = 0; index < size_; ++index) {
            const Equipment &equipment = equipments_[index];
            output << "\nEquipamento " << index + 1 << '\n'
                   << "ID: " << equipment.id() << '\n'
                   << "Código: " << equipment.code() << '\n'
                   << "Nome: " << equipment.name() << '\n'
                   << "Descrição: " << equipment.description() << '\n';
        }
    }

private:
    std::array<Equipment, capacity> equipments_ = {
        Equipment(0, "", "", ""),
        Equipment(0, "", "", ""),
        Equipment(0, "", "", "")
    };
    std::size_t size_ = 0;
};

std::string readRequiredLine(const std::string &label) {
    std::string value;
    do {
        std::cout << label;
        std::getline(std::cin, value);
    } while (value.empty());
    return value;
}

int readId() {
    int id = 0;
    while (true) {
        std::cout << "ID: ";
        if (std::cin >> id && id > 0) {
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            return id;
        }
        std::cin.clear();
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        std::cout << "Informe um ID inteiro e positivo.\n";
    }
}

int main() {
    EquipmentRegistry registry;

    for (std::size_t index = 0; index < EquipmentRegistry::capacity; ++index) {
        std::cout << "\nCadastro do equipamento " << index + 1 << '\n';
        const int id = readId();
        const std::string code = readRequiredLine("Código: ");
        const std::string name = readRequiredLine("Nome: ");
        const std::string description = readRequiredLine("Descrição: ");
        registry.add(Equipment(id, code, name, description));
    }

    std::cout << "\n=== Equipamentos cadastrados ===\n";
    registry.list(std::cout);
    return 0;
}
