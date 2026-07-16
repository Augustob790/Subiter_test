#ifndef QUESTION3_H
#define QUESTION3_H

#include <array>
#include <cstddef>
#include <iosfwd>
#include <optional>
#include <string>

class Equipment final
{
public:
    Equipment(
        int id,
        std::string code,
        std::string name,
        std::string description
        );

    int id() const;
    const std::string &code() const;
    const std::string &name() const;
    const std::string &description() const;

private:
    int id_;
    std::string code_;
    std::string name_;
    std::string description_;
};

class EquipmentRegistry final
{
public:
    static constexpr std::size_t capacity = 3;

    void add(Equipment equipment);
    void list(std::ostream &output) const;

private:
    std::array<std::optional<Equipment>, capacity> equipments_;
    std::size_t size_ = 0;
};

void runQuestion3();

#endif // QUESTION3_H