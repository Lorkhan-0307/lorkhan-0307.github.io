---
layout: post
title: "객체지향 프로그래밍 4대 특성: 추상화, 캡슐화, 상속, 다형성 완벽 가이드"
date: 2025-09-21 15:06:00 +0900
categories: [Tech Interview, OOP]
tags: [oop, abstraction, encapsulation, inheritance, polymorphism, cpp, design-principles]
---

## 📌 학습 목표
- 객체지향 프로그래밍의 4대 특성 완벽 이해
- 각 특성의 실무 적용 방법과 구현 기법 학습
- C++와 C#에서의 객체지향 개념 구현 차이점 분석
- 객체지향 설계 원칙과 모범 사례 습득

---

## 📝 객체지향 프로그래밍(OOP) 개요

**핵심 아이디어:**
- **데이터와 행위를 객체 단위로 묶어서** 설계하는 방법론
- 복잡한 소프트웨어를 관리 가능한 단위로 분해
- 코드 재사용성, 유지보수성, 확장성 향상

**4대 특성:**
1. **추상화 (Abstraction)** - 본질적 특성만 추출
2. **캡슐화 (Encapsulation)** - 데이터와 행위를 하나로 묶고 보호
3. **상속 (Inheritance)** - 기존 클래스의 특성을 재사용하고 확장
4. **다형성 (Polymorphism)** - 같은 인터페이스로 다양한 구현 제공

---

## 1. 추상화 (Abstraction)

### 핵심 개념
**본질적인 공통 행위와 속성만 드러내고 복잡한 구현 세부사항을 감추는 것**

- 복잡한 현실이나 구현을 단순화하여 표현
- 공통 인터페이스를 통한 일관된 상호작용 제공
- 변경에 유연하게 대응할 수 있는 설계 기반

### C++ 구현
```cpp
// 추상 기본 클래스
class Shape {
public:
    virtual ~Shape() = default;
    
    // 순수 가상 함수로 인터페이스 정의
    virtual double area() const = 0;
    virtual double perimeter() const = 0;
    virtual void draw() const = 0;
    
    // 공통 기능 제공
    virtual void move(double dx, double dy) {
        cout << "Moving shape by (" << dx << ", " << dy << ")" << endl;
    }
};

// 구체적인 구현 클래스들
class Circle : public Shape {
private:
    double radius;
    double centerX, centerY;
    
public:
    explicit Circle(double r, double x = 0, double y = 0) 
        : radius(r), centerX(x), centerY(y) {}
    
    double area() const override {
        return M_PI * radius * radius;
    }
    
    double perimeter() const override {
        return 2 * M_PI * radius;
    }
    
    void draw() const override {
        cout << "Drawing circle with radius " << radius 
             << " at (" << centerX << ", " << centerY << ")" << endl;
    }
};

class Rectangle : public Shape {
private:
    double width, height;
    double x, y;
    
public:
    Rectangle(double w, double h, double x = 0, double y = 0)
        : width(w), height(h), x(x), y(y) {}
    
    double area() const override {
        return width * height;
    }
    
    double perimeter() const override {
        return 2 * (width + height);
    }
    
    void draw() const override {
        cout << "Drawing rectangle " << width << "x" << height 
             << " at (" << x << ", " << y << ")" << endl;
    }
};

// 추상화를 통한 일관된 사용
void processShapes(const vector<unique_ptr<Shape>>& shapes) {
    double totalArea = 0;
    
    for (const auto& shape : shapes) {
        shape->draw();                    // 구체적인 그리기 방법은 몰라도 됨
        totalArea += shape->area();       // 구체적인 면적 계산은 몰라도 됨
        cout << "Area: " << shape->area() << ", Perimeter: " << shape->perimeter() << endl;
    }
    
    cout << "Total area: " << totalArea << endl;
}
```

### C# 구현
```csharp
// 추상 클래스
public abstract class Sensor {
    public abstract float Read();           // 추상 메서드
    public abstract string GetUnit();
    
    // 공통 기능
    public virtual void Calibrate() {
        Console.WriteLine($"Calibrating {GetType().Name}...");
    }
    
    public void LogReading() {
        Console.WriteLine($"Reading: {Read()} {GetUnit()}");
    }
}

// 구체적인 센서들
public class TemperatureSensor : Sensor {
    private float temperature = 25.0f;
    
    public override float Read() => temperature;
    public override string GetUnit() => "°C";
}

public class PressureSensor : Sensor {
    private float pressure = 1013.25f;
    
    public override float Read() => pressure;
    public override string GetUnit() => "hPa";
}

// 인터페이스를 통한 추상화
public interface IDataProcessor {
    void ProcessData(float[] data);
    string GetProcessorType();
}

public class AverageProcessor : IDataProcessor {
    public void ProcessData(float[] data) {
        float average = data.Sum() / data.Length;
        Console.WriteLine($"Average: {average}");
    }
    
    public string GetProcessorType() => "Average";
}
```

### 추상화 모범 사례
```cpp
// 좋은 추상화 - 의미 있는 경계
class FileSystem {
public:
    virtual ~FileSystem() = default;
    virtual bool writeFile(const string& path, const string& content) = 0;
    virtual string readFile(const string& path) = 0;
    virtual bool deleteFile(const string& path) = 0;
};

class LocalFileSystem : public FileSystem {
    // 로컬 파일 시스템 구현
};

class CloudFileSystem : public FileSystem {
    // 클라우드 스토리지 구현
};

// 나쁜 추상화 - 과도한 추상화
class OverAbstracted {
public:
    virtual void doSomething() = 0;  // 너무 모호함
    virtual void process() = 0;      // 의미가 불분명함
};
```

---

## 2. 캡슐화 (Encapsulation)

### 핵심 개념
**데이터와 행위를 하나의 클래스로 묶고, 접근 제어를 통해 내부 상태를 보호**

- 객체의 내부 구현을 외부로부터 숨김
- 불변식(invariant)을 유지하는 메서드만 외부에 공개
- 객체의 일관성과 무결성 보장

### C++ 구현
```cpp
class BankAccount {
private:
    string accountNumber;
    string ownerName;
    double balance;
    vector<string> transactionHistory;
    
    // 내부 헬퍼 메서드
    void addTransaction(const string& description, double amount) {
        transactionHistory.push_back(
            description + ": $" + to_string(amount) + 
            " (Balance: $" + to_string(balance) + ")"
        );
    }
    
    bool isValidAmount(double amount) const {
        return amount > 0 && amount <= 1000000; // 합리적인 범위
    }
    
public:
    BankAccount(const string& accNum, const string& owner, double initialBalance = 0)
        : accountNumber(accNum), ownerName(owner), balance(initialBalance) {
        if (initialBalance < 0) {
            throw invalid_argument("Initial balance cannot be negative");
        }
        addTransaction("Account opened", initialBalance);
    }
    
    // 의미 있는 동작 메서드 (데이터 직접 접근 대신)
    bool deposit(double amount) {
        if (!isValidAmount(amount)) {
            return false;
        }
        
        balance += amount;
        addTransaction("Deposit", amount);
        return true;
    }
    
    bool withdraw(double amount) {
        if (!isValidAmount(amount) || amount > balance) {
            return false;
        }
        
        balance -= amount;
        addTransaction("Withdrawal", -amount);
        return true;
    }
    
    bool transfer(BankAccount& toAccount, double amount) {
        if (withdraw(amount)) {
            if (toAccount.deposit(amount)) {
                return true;
            } else {
                // 실패 시 롤백
                deposit(amount);
                return false;
            }
        }
        return false;
    }
    
    // 읽기 전용 접근자
    double getBalance() const { return balance; }
    string getAccountNumber() const { return accountNumber; }
    string getOwnerName() const { return ownerName; }
    
    vector<string> getTransactionHistory() const {
        return transactionHistory; // 복사본 반환으로 보호
    }
};

// 사용 예제
void demonstrateEncapsulation() {
    BankAccount account1("123456", "Alice", 1000.0);
    BankAccount account2("789012", "Bob", 500.0);
    
    // 직접적인 잔액 조작은 불가능 (private)
    // account1.balance = 999999; // 컴파일 에러!
    
    // 의미 있는 메서드를 통해서만 상태 변경 가능
    account1.deposit(200.0);
    account1.withdraw(150.0);
    account1.transfer(account2, 300.0);
    
    cout << "Account1 balance: $" << account1.getBalance() << endl;
    cout << "Account2 balance: $" << account2.getBalance() << endl;
}
```

### C# 속성을 이용한 캡슐화
```csharp
public class Employee {
    private string _name;
    private int _age;
    private decimal _salary;
    private DateTime _hireDate;
    
    // 속성을 통한 제어된 접근
    public string Name {
        get => _name;
        set {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("Name cannot be empty");
            _name = value.Trim();
        }
    }
    
    public int Age {
        get => _age;
        set {
            if (value < 18 || value > 70)
                throw new ArgumentException("Age must be between 18 and 70");
            _age = value;
        }
    }
    
    public decimal Salary {
        get => _salary;
        private set => _salary = value; // 외부에서 직접 설정 불가
    }
    
    public DateTime HireDate { get; private set; }
    
    // 계산된 속성
    public int YearsOfService => DateTime.Now.Year - HireDate.Year;
    
    // 생성자
    public Employee(string name, int age, decimal initialSalary) {
        Name = name;
        Age = age;
        _salary = initialSalary;
        HireDate = DateTime.Now;
    }
    
    // 의미 있는 동작 메서드
    public void GiveRaise(decimal percentage) {
        if (percentage <= 0 || percentage > 50)
            throw new ArgumentException("Raise percentage must be between 0 and 50");
        
        _salary *= (1 + percentage / 100);
        Console.WriteLine($"{Name} received a {percentage}% raise. New salary: ${_salary:F2}");
    }
    
    public bool IsEligibleForPromotion() {
        return YearsOfService >= 2 && _salary < 100000;
    }
}
```

---

## 3. 상속 (Inheritance)

### 핵심 개념
**상위 클래스의 속성과 행위를 하위 클래스가 재사용하고 확장**

- "is-a" 관계를 표현
- 코드 재사용과 계층적 구조 구현
- 다형성의 기반 제공

### C++ 상속 구현
```cpp
// 기본 상속
class Vehicle {
protected:
    string brand;
    int year;
    double speed;
    
public:
    Vehicle(const string& b, int y) : brand(b), year(y), speed(0) {}
    
    virtual void start() {
        cout << "Vehicle starting..." << endl;
        speed = 10;
    }
    
    virtual void accelerate(double increment) {
        speed += increment;
        cout << brand << " accelerating to " << speed << " km/h" << endl;
    }
    
    virtual void brake(double decrement) {
        speed = max(0.0, speed - decrement);
        cout << brand << " slowing down to " << speed << " km/h" << endl;
    }
    
    virtual void displayInfo() const {
        cout << "Brand: " << brand << ", Year: " << year 
             << ", Speed: " << speed << " km/h" << endl;
    }
    
    virtual ~Vehicle() = default;
};

class Car : public Vehicle {
private:
    int numDoors;
    bool isConvertible;
    
public:
    Car(const string& b, int y, int doors, bool convertible = false)
        : Vehicle(b, y), numDoors(doors), isConvertible(convertible) {}
    
    void start() override {
        cout << "Car engine starting with key..." << endl;
        speed = 0;
    }
    
    void accelerate(double increment) override {
        // 자동차는 더 빠르게 가속
        speed += increment * 1.2;
        cout << brand << " car accelerating to " << speed << " km/h" << endl;
    }
    
    void displayInfo() const override {
        Vehicle::displayInfo(); // 부모 클래스 메서드 호출
        cout << "Doors: " << numDoors 
             << ", Convertible: " << (isConvertible ? "Yes" : "No") << endl;
    }
    
    // Car만의 고유 메서드
    void honk() const {
        cout << brand << " car: Beep beep!" << endl;
    }
    
    void openTrunk() const {
        cout << "Trunk opened" << endl;
    }
};

class Motorcycle : public Vehicle {
private:
    bool hasSidecar;
    
public:
    Motorcycle(const string& b, int y, bool sidecar = false)
        : Vehicle(b, y), hasSidecar(sidecar) {}
    
    void start() override {
        cout << "Motorcycle engine starting with electric starter..." << endl;
        speed = 0;
    }
    
    void accelerate(double increment) override {
        // 오토바이는 훨씬 빠르게 가속
        speed += increment * 1.5;
        cout << brand << " motorcycle accelerating to " << speed << " km/h" << endl;
    }
    
    void displayInfo() const override {
        Vehicle::displayInfo();
        cout << "Sidecar: " << (hasSidecar ? "Yes" : "No") << endl;
    }
    
    // Motorcycle만의 고유 메서드
    void wheelie() const {
        if (speed > 30) {
            cout << "Performing a wheelie!" << endl;
        } else {
            cout << "Too slow for a wheelie" << endl;
        }
    }
};
```

### 다중 상속과 가상 상속
```cpp
class Engine {
protected:
    int horsepower;
    
public:
    Engine(int hp) : horsepower(hp) {}
    
    virtual void startEngine() {
        cout << "Engine with " << horsepower << " HP starting..." << endl;
    }
};

class ElectricMotor {
protected:
    int batteryCapacity;
    
public:
    ElectricMotor(int capacity) : batteryCapacity(capacity) {}
    
    virtual void startMotor() {
        cout << "Electric motor with " << batteryCapacity << " kWh starting..." << endl;
    }
};

// 다이아몬드 상속 문제 해결을 위한 가상 상속
class PowerSource {
protected:
    string type;
    
public:
    PowerSource(const string& t) : type(t) {}
    virtual void displayPowerInfo() {
        cout << "Power source: " << type << endl;
    }
};

class GasEngine : virtual public PowerSource {
public:
    GasEngine() : PowerSource("Gasoline") {}
    void startGasEngine() { cout << "Gas engine starting..." << endl; }
};

class ElectricMotorVirtual : virtual public PowerSource {
public:
    ElectricMotorVirtual() : PowerSource("Electric") {}
    void startElectricMotor() { cout << "Electric motor starting..." << endl; }
};

class HybridPowerSystem : public GasEngine, public ElectricMotorVirtual {
public:
    HybridPowerSystem() : PowerSource("Hybrid") {} // 가상 상속으로 한 번만 초기화
    
    void startHybridSystem() {
        displayPowerInfo(); // 모호성 없이 호출 가능
        startGasEngine();
        startElectricMotor();
    }
};
```

### C# 단일 상속과 인터페이스
```csharp
// C#은 단일 상속만 지원
public class Animal {
    protected string name;
    protected int age;
    
    public Animal(string name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public virtual void Eat() {
        Console.WriteLine($"{name} is eating");
    }
    
    public virtual void Sleep() {
        Console.WriteLine($"{name} is sleeping");
    }
}

// 인터페이스로 다중 행위 구현
public interface ISwimmable {
    void Swim();
    int SwimSpeed { get; }
}

public interface IFlyable {
    void Fly();
    int FlightAltitude { get; }
}

public class Duck : Animal, ISwimmable, IFlyable {
    public int SwimSpeed { get; private set; } = 5;
    public int FlightAltitude { get; private set; } = 1000;
    
    public Duck(string name, int age) : base(name, age) {}
    
    public override void Eat() {
        Console.WriteLine($"{name} the duck is eating bread crumbs");
    }
    
    public void Swim() {
        Console.WriteLine($"{name} is swimming at {SwimSpeed} km/h");
    }
    
    public void Fly() {
        Console.WriteLine($"{name} is flying at {FlightAltitude} meters");
    }
    
    public void Quack() {
        Console.WriteLine($"{name}: Quack quack!");
    }
}
```

---

## 4. 다형성 (Polymorphism)

### 핵심 개념
**같은 메시지(인터페이스)에 여러 다른 구현이 응답**

- 정적 다형성: 컴파일 타임 결정 (오버로딩, 템플릿)
- 동적 다형성: 런타임 결정 (가상 함수, vtable)

### C++ 동적 다형성
```cpp
class MediaPlayer {
public:
    virtual ~MediaPlayer() = default;
    virtual void play() = 0;
    virtual void pause() = 0;
    virtual void stop() = 0;
    virtual string getFormat() const = 0;
};

class MP3Player : public MediaPlayer {
private:
    string currentTrack;
    
public:
    void play() override {
        cout << "Playing MP3: " << currentTrack << endl;
    }
    
    void pause() override {
        cout << "MP3 playback paused" << endl;
    }
    
    void stop() override {
        cout << "MP3 playback stopped" << endl;
        currentTrack.clear();
    }
    
    string getFormat() const override {
        return "MP3";
    }
    
    void loadTrack(const string& track) {
        currentTrack = track;
    }
};

class VideoPlayer : public MediaPlayer {
private:
    string currentVideo;
    bool isFullscreen;
    
public:
    VideoPlayer() : isFullscreen(false) {}
    
    void play() override {
        cout << "Playing video: " << currentVideo 
             << (isFullscreen ? " (Fullscreen)" : " (Windowed)") << endl;
    }
    
    void pause() override {
        cout << "Video playback paused" << endl;
    }
    
    void stop() override {
        cout << "Video playback stopped" << endl;
        currentVideo.clear();
        isFullscreen = false;
    }
    
    string getFormat() const override {
        return "MP4";
    }
    
    void loadVideo(const string& video) {
        currentVideo = video;
    }
    
    void toggleFullscreen() {
        isFullscreen = !isFullscreen;
    }
};

// 다형성을 활용한 미디어 시스템
class MediaSystem {
private:
    vector<unique_ptr<MediaPlayer>> players;
    
public:
    void addPlayer(unique_ptr<MediaPlayer> player) {
        players.push_back(move(player));
    }
    
    void playAll() {
        for (auto& player : players) {
            player->play(); // 런타임에 올바른 play() 메서드 호출
        }
    }
    
    void stopAll() {
        for (auto& player : players) {
            player->stop();
        }
    }
    
    void listPlayers() {
        for (size_t i = 0; i < players.size(); ++i) {
            cout << "Player " << i << ": " << players[i]->getFormat() << endl;
        }
    }
};
```

### C++ 정적 다형성 (템플릿)
```cpp
// 템플릿을 이용한 정적 다형성
template<typename T>
class Container {
private:
    vector<T> data;
    
public:
    void add(const T& item) {
        data.push_back(item);
    }
    
    T get(size_t index) const {
        if (index >= data.size()) {
            throw out_of_range("Index out of range");
        }
        return data[index];
    }
    
    size_t size() const {
        return data.size();
    }
    
    // 템플릿 특수화로 타입별 특별한 동작 정의 가능
    void display() const {
        for (const auto& item : data) {
            cout << item << " ";
        }
        cout << endl;
    }
};

// 함수 오버로딩
class Calculator {
public:
    int add(int a, int b) {
        return a + b;
    }
    
    double add(double a, double b) {
        return a + b;
    }
    
    string add(const string& a, const string& b) {
        return a + b;
    }
    
    template<typename T>
    T add(const vector<T>& values) {
        T sum = T{};
        for (const auto& value : values) {
            sum += value;
        }
        return sum;
    }
};
```

### C# 다형성
```csharp
public abstract class Payment {
    protected decimal amount;
    protected string currency;
    
    public Payment(decimal amount, string currency = "USD") {
        this.amount = amount;
        this.currency = currency;
    }
    
    public abstract bool ProcessPayment();
    public abstract string GetPaymentMethod();
    
    public virtual void SendReceipt() {
        Console.WriteLine($"Receipt: {amount} {currency} via {GetPaymentMethod()}");
    }
}

public class CreditCardPayment : Payment {
    private string cardNumber;
    private string cardHolderName;
    
    public CreditCardPayment(decimal amount, string cardNumber, string cardHolderName) 
        : base(amount) {
        this.cardNumber = cardNumber.Substring(cardNumber.Length - 4); // 마지막 4자리만 저장
        this.cardHolderName = cardHolderName;
    }
    
    public override bool ProcessPayment() {
        Console.WriteLine($"Processing credit card payment of {amount} {currency}");
        Console.WriteLine($"Card ending in: {cardNumber}");
        // 실제 신용카드 처리 로직
        return true;
    }
    
    public override string GetPaymentMethod() => "Credit Card";
}

public class PayPalPayment : Payment {
    private string email;
    
    public PayPalPayment(decimal amount, string email) : base(amount) {
        this.email = email;
    }
    
    public override bool ProcessPayment() {
        Console.WriteLine($"Processing PayPal payment of {amount} {currency}");
        Console.WriteLine($"PayPal account: {email}");
        // PayPal API 호출 로직
        return true;
    }
    
    public override string GetPaymentMethod() => "PayPal";
}

// 다형성 활용 시스템
public class PaymentProcessor {
    public void ProcessPayments(Payment[] payments) {
        foreach (Payment payment in payments) {
            if (payment.ProcessPayment()) {  // 런타임에 올바른 메서드 호출
                payment.SendReceipt();
            } else {
                Console.WriteLine($"Payment failed for {payment.GetPaymentMethod()}");
            }
        }
    }
}
```

---

## 🎯 실무 적용 예제: 게임 엔진

### 컴포넌트 시스템 설계
```cpp
// 추상화: 모든 컴포넌트의 공통 인터페이스
class Component {
public:
    virtual ~Component() = default;
    virtual void update(float deltaTime) = 0;
    virtual void render() = 0;
    virtual string getType() const = 0;
    virtual Component* clone() const = 0;
};

// 캡슐화: 내부 상태를 보호하면서 의미 있는 인터페이스 제공
class TransformComponent : public Component {
private:
    Vector3 position;
    Vector3 rotation;
    Vector3 scale;
    bool isDirty; // 변경 감지를 위한 플래그
    
public:
    TransformComponent(const Vector3& pos = Vector3::Zero()) 
        : position(pos), rotation(Vector3::Zero()), scale(Vector3::One()), isDirty(true) {}
    
    // 제어된 접근 메서드
    void setPosition(const Vector3& pos) {
        if (position != pos) {
            position = pos;
            isDirty = true;
        }
    }
    
    Vector3 getPosition() const { return position; }
    
    void translate(const Vector3& delta) {
        position += delta;
        isDirty = true;
    }
    
    void rotate(const Vector3& euler) {
        rotation += euler;
        isDirty = true;
    }
    
    // Component 인터페이스 구현
    void update(float deltaTime) override {
        // 변환 매트릭스 업데이트 등
        if (isDirty) {
            updateTransformMatrix();
            isDirty = false;
        }
    }
    
    void render() override {
        // 렌더링 시스템에 변환 정보 전달
    }
    
    string getType() const override { return "Transform"; }
    
    Component* clone() const override {
        return new TransformComponent(*this);
    }
    
private:
    void updateTransformMatrix() {
        // 내부 구현 숨김
    }
};

// 상속: 기본 렌더링 기능을 확장
class RenderComponent : public Component {
protected:
    string materialName;
    bool isVisible;
    float opacity;
    
public:
    RenderComponent(const string& material) 
        : materialName(material), isVisible(true), opacity(1.0f) {}
    
    virtual void setMaterial(const string& material) {
        materialName = material;
    }
    
    void setVisible(bool visible) { isVisible = visible; }
    void setOpacity(float alpha) { opacity = clamp(alpha, 0.0f, 1.0f); }
    
    void update(float deltaTime) override {
        // 기본 렌더링 업데이트
    }
    
    string getType() const override { return "Render"; }
};

class MeshRenderComponent : public RenderComponent {
private:
    string meshName;
    
public:
    MeshRenderComponent(const string& mesh, const string& material)
        : RenderComponent(material), meshName(mesh) {}
    
    void render() override {
        if (isVisible && opacity > 0) {
            // 메시 렌더링 로직
            cout << "Rendering mesh: " << meshName 
                 << " with material: " << materialName << endl;
        }
    }
    
    Component* clone() const override {
        return new MeshRenderComponent(*this);
    }
};

class SpriteRenderComponent : public RenderComponent {
private:
    string textureName;
    Vector2 size;
    
public:
    SpriteRenderComponent(const string& texture, const string& material, const Vector2& size)
        : RenderComponent(material), textureName(texture), size(size) {}
    
    void render() override {
        if (isVisible && opacity > 0) {
            // 스프라이트 렌더링 로직
            cout << "Rendering sprite: " << textureName 
                 << " size: " << size.x << "x" << size.y << endl;
        }
    }
    
    Component* clone() const override {
        return new SpriteRenderComponent(*this);
    }
};

// 다형성: 다양한 컴포넌트를 일관된 방식으로 처리
class GameObject {
private:
    vector<unique_ptr<Component>> components;
    string name;
    
public:
    GameObject(const string& objName) : name(objName) {}
    
    void addComponent(unique_ptr<Component> component) {
        components.push_back(move(component));
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
            component->update(deltaTime); // 다형적 호출
        }
    }
    
    void render() {
        for (auto& component : components) {
            component->render(); // 다형적 호출
        }
    }
    
    void listComponents() {
        cout << "GameObject '" << name << "' components:" << endl;
        for (const auto& component : components) {
            cout << "- " << component->getType() << endl; // 다형적 호출
        }
    }
};
```

---

## 💡 객체지향 설계 원칙

### SOLID 원칙
```cpp
// S - Single Responsibility Principle
class FileManager {
public:
    void saveFile(const string& filename, const string& content) {
        // 파일 저장만 담당
    }
};

class DataValidator {
public:
    bool validateData(const string& data) {
        // 데이터 검증만 담당
        return !data.empty();
    }
};

// O - Open/Closed Principle
class ShapeCalculator {
public:
    double calculateArea(const Shape& shape) {
        return shape.area(); // 새로운 도형 추가 시 수정 없이 확장 가능
    }
};

// L - Liskov Substitution Principle
void processVehicles(vector<Vehicle*>& vehicles) {
    for (auto* vehicle : vehicles) {
        vehicle->start();    // 모든 Vehicle 하위 클래스에서 동일하게 동작
        vehicle->accelerate(10);
    }
}

// I - Interface Segregation Principle
class IMovable {
public:
    virtual void move() = 0;
    virtual ~IMovable() = default;
};

class IRenderable {
public:
    virtual void render() = 0;
    virtual ~IRenderable() = default;
};

// D - Dependency Inversion Principle
class OrderProcessor {
private:
    shared_ptr<PaymentProcessor> paymentProcessor;
    
public:
    OrderProcessor(shared_ptr<PaymentProcessor> processor) 
        : paymentProcessor(processor) {}
    
    void processOrder(const Order& order) {
        // 구체적인 결제 구현체가 아닌 추상화에 의존
        paymentProcessor->processPayment(order.getAmount());
    }
};
```

---

## 🌐 외부 링크
- [Object-Oriented Programming Concepts](https://docs.oracle.com/javase/tutorial/java/concepts/)
- [C++ Object Model by Stanley Lippman](https://www.informit.com/store/inside-the-c-plus-plus-object-model-9780201834543)
- [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612)

---

## 💡 실무 적용 팁

1. **적절한 추상화 수준**:
   - 과도한 추상화 피하기
   - 의미 있는 경계에서만 추상화 도입
   - 미래 변경 가능성을 고려한 설계

2. **효과적인 캡슐화**:
   - 데이터 직접 노출 금지
   - 의미 있는 동작 메서드 제공
   - 불변식 유지 보장

3. **상속 vs 컴포지션**:
   - "is-a" 관계에서만 상속 사용
   - "has-a" 관계에서는 컴포지션 우선
   - 유연성이 필요한 경우 컴포지션 선택

4. **다형성 활용**:
   - 성능이 중요한 곳에서는 정적 다형성 고려
   - 런타임 유연성이 필요한 곳에서 동적 다형성 사용
   - 적절한 인터페이스 설계

---

## 다음 학습 주제
- **디자인 패턴**: 생성, 구조, 행위 패턴의 객체지향적 활용
- **SOLID 원칙**: 객체지향 설계의 5가지 핵심 원칙
- **함수형 프로그래밍**: 객체지향과의 비교 및 하이브리드 접근법
- **현대 C++ 기법**: 스마트 포인터, RAII, 이동 시맨틱

---

## 🪞 회고 질문
- 4가지 객체지향 특성을 실무 프로젝트에 어떻게 적용할 수 있는가?
- 추상화와 캡슐화의 차이점을 명확하게 설명할 수 있는가?
- 상속 대신 컴포지션을 선택해야 하는 상황을 판단할 수 있는가?
- 정적 다형성과 동적 다형성의 트레이드오프를 이해하고 있는가?