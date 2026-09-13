---
layout: post
title: "C++ 핵심 개념: 상속, 다형성, 순수 가상 함수, 추상 클래스, 컴포지션"
date: 2025-09-21 15:08:00 +0900
categories: [Tech Interview, C++]
tags: [cpp, inheritance, polymorphism, pure virtual function, abstract class, composition, class design]
---

## 📌 학습 목표
- C++ 객체지향의 핵심 개념들을 종합적으로 이해
- 각 개념의 실무 적용 시나리오와 최적 사용법 학습
- 상속과 컴포지션의 적절한 선택 기준 습득
- 현대적인 C++ 클래스 설계 원칙 완벽 이해

---

## 📝 상속 (Inheritance)

### 핵심 개념
**기존 클래스를 기반으로 새로운 클래스를 정의하는 기법**

- 코드 재사용성과 다형성 지원의 핵심
- "is-a" 관계를 표현하는 가장 자연스러운 방법
- C++에서는 public, protected, private 상속 지원

### 상속의 종류와 활용
```cpp
#include <iostream>
#include <memory>
#include <vector>

class Vehicle {
protected:
    std::string brand;
    int year;
    double speed;
    
public:
    Vehicle(const std::string& b, int y) : brand(b), year(y), speed(0) {
        std::cout << "Vehicle constructor: " << brand << std::endl;
    }
    
    virtual ~Vehicle() {
        std::cout << "Vehicle destructor: " << brand << std::endl;
    }
    
    // 가상 함수 - 다형성 지원
    virtual void start() {
        std::cout << brand << " starting..." << std::endl;
        speed = 10;
    }
    
    virtual void accelerate(double increment) {
        speed += increment;
        std::cout << brand << " accelerating to " << speed << " km/h" << std::endl;
    }
    
    virtual void displayInfo() const {
        std::cout << "Brand: " << brand << ", Year: " << year 
                  << ", Current Speed: " << speed << " km/h" << std::endl;
    }
    
    // 비가상 함수 - 공통 기능
    void stop() {
        speed = 0;
        std::cout << brand << " stopped" << std::endl;
    }
};

// Public 상속 - 가장 일반적
class Car : public Vehicle {
private:
    int numDoors;
    bool isElectric;
    
public:
    Car(const std::string& brand, int year, int doors, bool electric = false)
        : Vehicle(brand, year), numDoors(doors), isElectric(electric) {}
    
    // 메서드 오버라이드
    void start() override {
        std::cout << "Car ignition started" << std::endl;
        Vehicle::start(); // 부모 클래스 메서드 호출
    }
    
    void accelerate(double increment) override {
        if (isElectric) {
            speed += increment * 1.2; // 전기차는 더 빠른 가속
        } else {
            Vehicle::accelerate(increment);
        }
    }
    
    void displayInfo() const override {
        Vehicle::displayInfo();
        std::cout << "Doors: " << numDoors 
                  << ", Electric: " << (isElectric ? "Yes" : "No") << std::endl;
    }
    
    // Car만의 고유 메서드
    void honk() const {
        std::cout << brand << ": Beep beep!" << std::endl;
    }
};

class Motorcycle : public Vehicle {
private:
    bool hasSidecar;
    
public:
    Motorcycle(const std::string& brand, int year, bool sidecar = false)
        : Vehicle(brand, year), hasSidecar(sidecar) {}
    
    void start() override {
        std::cout << "Motorcycle engine roaring..." << std::endl;
        speed = 0;
    }
    
    void accelerate(double increment) override {
        speed += increment * 1.5; // 오토바이는 더 빠른 가속
        std::cout << brand << " motorcycle accelerating to " << speed << " km/h" << std::endl;
    }
    
    void wheelie() const {
        if (speed > 30) {
            std::cout << "Performing a wheelie!" << std::endl;
        } else {
            std::cout << "Need more speed for wheelie" << std::endl;
        }
    }
};
```

---

## 📝 다형성 (Polymorphism)

### 동적 다형성 vs 정적 다형성
```cpp
// 동적 다형성 - 런타임에 결정
class Shape {
public:
    virtual ~Shape() = default;
    virtual double area() const = 0;
    virtual double perimeter() const = 0;
    virtual void draw() const = 0;
    virtual std::string getType() const = 0;
};

class Circle : public Shape {
private:
    double radius;
    
public:
    explicit Circle(double r) : radius(r) {}
    
    double area() const override {
        return 3.14159 * radius * radius;
    }
    
    double perimeter() const override {
        return 2 * 3.14159 * radius;
    }
    
    void draw() const override {
        std::cout << "Drawing a circle with radius " << radius << std::endl;
    }
    
    std::string getType() const override {
        return "Circle";
    }
};

class Rectangle : public Shape {
private:
    double width, height;
    
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    
    double area() const override {
        return width * height;
    }
    
    double perimeter() const override {
        return 2 * (width + height);
    }
    
    void draw() const override {
        std::cout << "Drawing a rectangle " << width << "x" << height << std::endl;
    }
    
    std::string getType() const override {
        return "Rectangle";
    }
};

// 다형성 활용 예제
class ShapeProcessor {
public:
    static void processShapes(const std::vector<std::unique_ptr<Shape>>& shapes) {
        double totalArea = 0;
        
        std::cout << "=== Shape Processing ===" << std::endl;
        for (const auto& shape : shapes) {
            shape->draw();                    // 런타임에 올바른 draw() 호출
            double shapeArea = shape->area(); // 런타임에 올바른 area() 호출
            totalArea += shapeArea;
            
            std::cout << "Type: " << shape->getType() 
                      << ", Area: " << shapeArea 
                      << ", Perimeter: " << shape->perimeter() << std::endl;
        }
        
        std::cout << "Total area: " << totalArea << std::endl;
    }
};

// 정적 다형성 - 템플릿 활용
template<typename T>
class StaticPolymorphism {
public:
    void execute() {
        static_cast<T*>(this)->implementation();
    }
    
    void processData() {
        static_cast<T*>(this)->process();
    }
};

class FastProcessor : public StaticPolymorphism<FastProcessor> {
public:
    void implementation() {
        std::cout << "Fast implementation - no vtable overhead" << std::endl;
    }
    
    void process() {
        std::cout << "Processing data quickly" << std::endl;
    }
};
```

---

## 📝 순수 가상 함수와 추상 클래스

### 순수 가상 함수 (Pure Virtual Function)
```cpp
class Database {
public:
    virtual ~Database() = default;
    
    // 순수 가상 함수 - 구현 없이 선언만
    virtual void connect() = 0;
    virtual void disconnect() = 0;
    virtual bool executeQuery(const std::string& query) = 0;
    virtual std::vector<std::string> getResults() = 0;
    
    // 공통 기능은 구현 제공 가능
    virtual void logOperation(const std::string& operation) {
        std::cout << "Database operation: " << operation << std::endl;
    }
};

class MySQLDatabase : public Database {
private:
    bool connected;
    std::vector<std::string> results;
    
public:
    MySQLDatabase() : connected(false) {}
    
    void connect() override {
        connected = true;
        logOperation("Connected to MySQL database");
    }
    
    void disconnect() override {
        connected = false;
        logOperation("Disconnected from MySQL database");
    }
    
    bool executeQuery(const std::string& query) override {
        if (!connected) {
            std::cout << "Error: Not connected to database" << std::endl;
            return false;
        }
        
        logOperation("Executing MySQL query: " + query);
        // MySQL 특화 쿼리 실행 로직
        results = {"result1", "result2", "result3"};
        return true;
    }
    
    std::vector<std::string> getResults() override {
        return results;
    }
};

class PostgreSQLDatabase : public Database {
private:
    bool connected;
    std::vector<std::string> results;
    
public:
    PostgreSQLDatabase() : connected(false) {}
    
    void connect() override {
        connected = true;
        logOperation("Connected to PostgreSQL database");
    }
    
    void disconnect() override {
        connected = false;
        logOperation("Disconnected from PostgreSQL database");
    }
    
    bool executeQuery(const std::string& query) override {
        if (!connected) {
            std::cout << "Error: Not connected to database" << std::endl;
            return false;
        }
        
        logOperation("Executing PostgreSQL query: " + query);
        // PostgreSQL 특화 쿼리 실행 로직
        results = {"pg_result1", "pg_result2"};
        return true;
    }
    
    std::vector<std::string> getResults() override {
        return results;
    }
};

// 팩토리 패턴과 함께 활용
class DatabaseFactory {
public:
    enum class DatabaseType { MySQL, PostgreSQL };
    
    static std::unique_ptr<Database> createDatabase(DatabaseType type) {
        switch (type) {
            case DatabaseType::MySQL:
                return std::make_unique<MySQLDatabase>();
            case DatabaseType::PostgreSQL:
                return std::make_unique<PostgreSQLDatabase>();
            default:
                return nullptr;
        }
    }
};
```

---

## 📝 컴포지션 (Composition)

### 상속 대신 컴포지션 활용
```cpp
// 엔진 컴포넌트
class Engine {
private:
    int horsepower;
    std::string fuelType;
    bool isRunning;
    
public:
    Engine(int hp, const std::string& fuel) 
        : horsepower(hp), fuelType(fuel), isRunning(false) {}
    
    void start() {
        if (!isRunning) {
            isRunning = true;
            std::cout << fuelType << " engine (" << horsepower 
                      << " HP) started" << std::endl;
        }
    }
    
    void stop() {
        if (isRunning) {
            isRunning = false;
            std::cout << "Engine stopped" << std::endl;
        }
    }
    
    int getHorsepower() const { return horsepower; }
    bool getRunning() const { return isRunning; }
};

// 전송 시스템 컴포넌트
class Transmission {
private:
    std::string type;
    int currentGear;
    int maxGears;
    
public:
    Transmission(const std::string& t, int maxGear) 
        : type(t), currentGear(1), maxGears(maxGear) {}
    
    void shiftUp() {
        if (currentGear < maxGears) {
            currentGear++;
            std::cout << "Shifted to gear " << currentGear << std::endl;
        }
    }
    
    void shiftDown() {
        if (currentGear > 1) {
            currentGear--;
            std::cout << "Shifted to gear " << currentGear << std::endl;
        }
    }
    
    int getCurrentGear() const { return currentGear; }
};

// 컴포지션을 활용한 자동차 클래스
class CompositionCar {
private:
    std::string model;
    Engine engine;              // 엔진을 포함 (has-a 관계)
    Transmission transmission;   // 변속기를 포함 (has-a 관계)
    
public:
    CompositionCar(const std::string& m, int hp, const std::string& fuel, 
                   const std::string& transType, int gears)
        : model(m), 
          engine(hp, fuel), 
          transmission(transType, gears) {}
    
    void start() {
        std::cout << "Starting " << model << std::endl;
        engine.start();
    }
    
    void accelerate() {
        if (engine.getRunning()) {
            std::cout << model << " accelerating..." << std::endl;
            transmission.shiftUp();
        } else {
            std::cout << "Engine not running!" << std::endl;
        }
    }
    
    void brake() {
        std::cout << model << " braking..." << std::endl;
        transmission.shiftDown();
    }
    
    void stop() {
        engine.stop();
        std::cout << model << " stopped" << std::endl;
    }
    
    void displayStatus() {
        std::cout << "Model: " << model 
                  << ", Engine: " << engine.getHorsepower() << " HP"
                  << ", Running: " << (engine.getRunning() ? "Yes" : "No")
                  << ", Gear: " << transmission.getCurrentGear() << std::endl;
    }
};

// 상속 vs 컴포지션 비교
void demonstrateCompositionAdvantages() {
    std::cout << "=== Composition Example ===" << std::endl;
    
    CompositionCar car("Tesla Model 3", 350, "Electric", "Automatic", 1);
    
    car.start();
    car.displayStatus();
    car.accelerate();
    car.brake();
    car.stop();
    
    // 컴포지션의 장점:
    // 1. 유연성: 런타임에 컴포넌트 교체 가능
    // 2. 단일 책임: 각 컴포넌트가 특정 기능만 담당
    // 3. 결합도 감소: 클래스 간 의존성 최소화
    // 4. 테스트 용이성: 각 컴포넌트 독립적 테스트 가능
}
```

---

## 📝 클래스 설계 원칙

### SOLID 원칙 적용
```cpp
// Single Responsibility Principle (SRP)
class FileReader {
public:
    std::string readFile(const std::string& filename) {
        // 파일 읽기만 담당
        return "file content";
    }
};

class DataValidator {
public:
    bool validateData(const std::string& data) {
        // 데이터 검증만 담당
        return !data.empty();
    }
};

class DataProcessor {
public:
    std::string processData(const std::string& data) {
        // 데이터 처리만 담당
        return "processed " + data;
    }
};

// Open/Closed Principle (OCP)
class ShapeCalculator {
public:
    double calculateTotalArea(const std::vector<std::unique_ptr<Shape>>& shapes) {
        double total = 0;
        for (const auto& shape : shapes) {
            total += shape->area(); // 새로운 도형 추가 시 수정 없이 확장 가능
        }
        return total;
    }
};

// Liskov Substitution Principle (LSP)
class Bird {
public:
    virtual ~Bird() = default;
    virtual void eat() = 0;
    virtual void makeSound() = 0;
    // fly()는 모든 새가 할 수 있는 것이 아니므로 별도 인터페이스로 분리
};

class IFlyable {
public:
    virtual void fly() = 0;
    virtual ~IFlyable() = default;
};

class Sparrow : public Bird, public IFlyable {
public:
    void eat() override {
        std::cout << "Sparrow eating seeds" << std::endl;
    }
    
    void makeSound() override {
        std::cout << "Chirp chirp!" << std::endl;
    }
    
    void fly() override {
        std::cout << "Sparrow flying" << std::endl;
    }
};

class Penguin : public Bird {
public:
    void eat() override {
        std::cout << "Penguin eating fish" << std::endl;
    }
    
    void makeSound() override {
        std::cout << "Penguin sound!" << std::endl;
    }
    
    // Penguin은 날 수 없으므로 IFlyable 구현하지 않음
};
```

---

## 🎯 실무 활용 예제

### 게임 엔진 컴포넌트 시스템
```cpp
class GameObject; // 전방 선언

class Component {
public:
    virtual ~Component() = default;
    virtual void update(float deltaTime) = 0;
    virtual void render() = 0;
    virtual std::string getType() const = 0;
    
    void setOwner(GameObject* owner) { this->owner = owner; }
    GameObject* getOwner() const { return owner; }
    
private:
    GameObject* owner = nullptr;
};

class TransformComponent : public Component {
private:
    float x, y, z;
    float rotX, rotY, rotZ;
    float scaleX, scaleY, scaleZ;
    
public:
    TransformComponent(float x = 0, float y = 0, float z = 0)
        : x(x), y(y), z(z), rotX(0), rotY(0), rotZ(0), 
          scaleX(1), scaleY(1), scaleZ(1) {}
    
    void update(float deltaTime) override {
        // 변환 행렬 업데이트 등
    }
    
    void render() override {
        // 렌더링 시스템에 변환 정보 전달
    }
    
    std::string getType() const override { return "Transform"; }
    
    void setPosition(float newX, float newY, float newZ) {
        x = newX; y = newY; z = newZ;
    }
    
    void translate(float dx, float dy, float dz) {
        x += dx; y += dy; z += dz;
    }
};

class RenderComponent : public Component {
private:
    std::string meshName;
    std::string materialName;
    bool visible;
    
public:
    RenderComponent(const std::string& mesh, const std::string& material)
        : meshName(mesh), materialName(material), visible(true) {}
    
    void update(float deltaTime) override {
        // 렌더링 관련 업데이트
    }
    
    void render() override {
        if (visible) {
            std::cout << "Rendering " << meshName 
                      << " with " << materialName << std::endl;
        }
    }
    
    std::string getType() const override { return "Render"; }
    
    void setVisible(bool v) { visible = v; }
};

class GameObject {
private:
    std::vector<std::unique_ptr<Component>> components;
    std::string name;
    
public:
    GameObject(const std::string& objName) : name(objName) {}
    
    void addComponent(std::unique_ptr<Component> component) {
        component->setOwner(this);
        components.push_back(std::move(component));
    }
    
    template<typename T>
    T* getComponent() {
        for (auto& component : components) {
            T* comp = dynamic_cast<T*>(component.get());
            if (comp) {
                return comp;
            }
        }
        return nullptr;
    }
    
    void update(float deltaTime) {
        for (auto& component : components) {
            component->update(deltaTime);
        }
    }
    
    void render() {
        for (auto& component : components) {
            component->render();
        }
    }
    
    const std::string& getName() const { return name; }
};
```

---

## 💡 실무 적용 팁

### 1. 상속 vs 컴포지션 선택 기준
```cpp
// 상속이 적절한 경우 - 진정한 "is-a" 관계
class Animal {
public:
    virtual void breathe() = 0;
    virtual void eat() = 0;
};

class Mammal : public Animal {  // Mammal은 Animal이다
public:
    void breathe() override {
        std::cout << "Breathing with lungs" << std::endl;
    }
};

// 컴포지션이 적절한 경우 - "has-a" 관계
class Car {
private:
    Engine engine;     // Car는 Engine을 가진다
    Wheel wheels[4];   // Car는 Wheel들을 가진다
public:
    // ...
};
```

### 2. 성능 고려사항
```cpp
// 가상 함수 오버헤드가 중요한 경우
template<typename Derived>
class CRTP_Base {
public:
    void execute() {
        static_cast<Derived*>(this)->implementation();
    }
};

class FastImplementation : public CRTP_Base<FastImplementation> {
public:
    void implementation() {
        // 가상 함수 오버헤드 없는 다형성
    }
};
```

---

## 🌐 외부 링크
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/)
- [Effective C++ by Scott Meyers](https://www.aristeia.com/books.html)
- [Modern C++ Design Patterns](https://en.wikipedia.org/wiki/Modern_C%2B%2B_Design)

---

## 다음 학습 주제
- **디자인 패턴**: 전략, 팩토리, 옵저버, 싱글톤 패턴의 C++ 구현
- **메모리 관리**: 스마트 포인터와 RAII 패턴
- **템플릿 메타프로그래밍**: 컴파일 타임 다형성과 타입 추론
- **C++20 모던 기능**: 모듈, 컨셉, 코루틴

---

## 🪞 회고 질문
- 각 개념의 적절한 사용 시나리오를 명확히 구분할 수 있는가?
- 순수 가상 함수와 추상 클래스의 설계 의도를 이해하고 있는가?
- 상속과 컴포지션 중 어떤 것을 선택할지 판단 기준을 가지고 있는가?
- 다형성의 성능 오버헤드와 유연성 간의 트레이드오프를 이해하고 있는가?