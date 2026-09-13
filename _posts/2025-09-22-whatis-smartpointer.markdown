---
layout: post
title: "스마트 포인터(Smart Pointer) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-smartpointer
---

# 스마트 포인터(Smart Pointer)

## 📌 개념 정리
- **스마트 포인터**: 포인터처럼 동작하지만, 객체의 소멸 시 자동으로 메모리 해제  
- C++11 이후 도입된 자동 메모리 관리 도구
- C++11 이후 표준 제공: `unique_ptr`, `shared_ptr`, `weak_ptr`  
- 핵심 아이디어: 참조 카운트, 소유권 개념을 이용하여 `delete`를 자동화  

## 📌 학습 목표
- C++에서 [스마트포인터]({{ site.baseurl }}/posts/whatis-smartpointer/)의 필요성과 원리 이해  
- `unique_ptr`, `shared_ptr`, `weak_ptr`의 차이 학습  
- 메모리 누수 방지와 RAII와의 관계 이해  


---

## 📝 스마트 포인터란?

스마트 포인터는 C++의 특별한 클래스 타입으로, 포인터처럼 동작하지만 스스로 메모리를 관리하는 포인터입니다.
이는 메모리 누수를 방지하고, 메모리 관리의 복잡성을 줄여줍니다.
스마트 포인터는 객체가 더 이상 필요하지 않을 때 자동으로 삭제하며, 이러한 기능 때문에 '스마트' 라고 부릅니다.


## 스마트 포인터의 작동 원리

스마트 포인터는 포인터처럼 동작하나, 메모리를 직접 관리하는 것이 아니라 [RAII]({{ site.baseurl }}/posts/whatis-raii/) 원칙을 사용해 메모리를 자동으로 관리합니다. 
RAII는 간단하게 설명하자면, 객체의 수명이 그 객체가 소유한 자원의 수명과 동일하게 관리되는 것을 의미합니다. 그렇기에, 객체가 생성될 때 자원을 할당하고, 소멸될 때 자원을 해제합니다.

스마트 포인터는 기본적으로 템플릿 클래스로, 포인터와 같은 방식으로 사용할 수 있습니다. 스마트 포인터 객체가 소멸될 때, 스마트 포인터는 자신이 가리키는 메모리를 자동으로 해제하여, 프로그래머가 메모리 해제를 잊어버리는 문제를 예방합니다. 

스마트 포인터의 작동 원리는 C++의 생성자와 소멸자의 대한 이해가 필요합니다.
생성자는 객체가 생성될 때 호출되고, 소멸자는 객체가 소멸할 때 호출되는데, 스마트 포인터는 생성자에서 메모리를 할당하고, 소멸자에서 메모리를 해제합니다.

스마트 포인터는 내부에 원시 포인터(raw pointer)를 보관하고 있으며, 이 원시 포인터는 스마트 포인터가 가리키는 실제 메모리를 가리킵니다. 하지만, 사용자는 이 원시 포인터에 직접 접근할 수 없으며, 스마트 포인터가 제공하는 인터페이스를 통해서만 메모리에 접근할 수 있습니다.

```cpp
unique_ptr<int> p1 = make_unique<int>(42);
*p1 = 20;
```

또한 스마트 포인터는 소유권(ownership)을 도입하여, 동일한 메모리에 대한 접근을 관리합니다.
예시로, `unique_ptr`은 하나의 스마트 포인터만 메모리를 소유할 수 있게 하여, 메모리 해제 시에 발생할 수 있는 해제 후 사용(dangling pointer)나 중복 해제의 문제를 해결합니다.


## 스마트 포인터의 종류

### 1. unique_ptr
- 단일 소유권 → 복사 불가, 이동만 가능  
- 가장 가볍고 안전  

### 2. shared_ptr
- 참조 카운팅 기반  
- 여러 개의 포인터가 하나의 자원 공유 가능  
- 참조 카운트가 0이 되면 자동 해제  
- 불필요한 참조 카운트가 많아지면 성능 저하 발생 가능
- 순환 참조 문제가 발생 가능

### 3. weak_ptr
- `shared_ptr`의 순환 참조 문제를 해결하기 위해 사용  
- 참조 카운트를 증가시키지 않음  
- 객체의 수명에 영향을 주지 않는 약한 참조(weak reference)를 제공 -> 순환 참조 해결!

---

## 💻 예제 코드
```cpp
#include <iostream>
#include <memory>
using namespace std;

void UniquePtrDemo() {
    unique_ptr<int> p1 = make_unique<int>(42);
    // unique_ptr<int> p2 = p1; // ❌ 복사 불가
    unique_ptr<int> p3 = move(p1); // ✅ 이동
}

void SharedPtrDemo() {
    shared_ptr<int> sp1 = make_shared<int>(100);
    shared_ptr<int> sp2 = sp1; // 참조 카운트 증가
    cout << "use_count: " << sp1.use_count() << endl; // 2
}

void WeakPtrDemo() {
    shared_ptr<int> sp = make_shared<int>(200);
    weak_ptr<int> wp = sp; // 순환 참조 방지
    if (auto locked = wp.lock()) {
        cout << *locked << endl;
    }
}
```


### 순환 참조 문제

#### 문제 발생 예시

다음 예제 코드에서, A와 B 객체는 서로를 참조하여, 순환 참조가 발생하고 이로 인해 Reference Count가 0이 되지 않아 메모리가 누수된다.

```cpp
#include <iostream>
#include <memory>
using namespace std;

struct B;
struct A{
    shared_ptr<B> b_ptr;
};

struct B{
    shared_ptr<A> a_ptr;
};

void main() {
    shared_ptr<A> a(new A());
    shared_ptr<B> b(new B());

    a->b_ptr = b;
    b->a_ptr = a; // 순환 참조가 생성된다.
}
```

#### 해결 예시

다음 해결 예제 코드에서는 B가 `weak_ptr`를 사용하여 A를 참조하기 때문에 순환 참조가 발생하지 않는다.
A가 파괴되면 `weak_ptr`는 자동으로 nullptr로 설정되고, `weak_ptr`는 `lock()` 함수를 사용하여 `shared_ptr`로 변환될 수 있다.
이 함수는 해당 객체가 여전히 존재하는 경우에만 `shared_ptr`를 반환하기에, 메모리에 안전하게 접근할 수 있다. 

```cpp
#include <iostream>
#include <memory>
using namespace std;

struct B;
struct A{
    shared_ptr<B> b_ptr;
};

struct B{
    weak_ptr<A> a_ptr; // 약한 참조를 사용한다.
};

void main() {
    shared_ptr<A> a(new A());
    shared_ptr<B> b(new B());

    a->b_ptr = b;
    b->a_ptr = a; // 순환 참조가 발생하지 않는다.

    if(shared_ptr<A> a_locked = b->a_ptr.lock()){
        // do something
    }
    else{
        // already destroied
    }
}
```

---

## 🎯 연습 문제
1. `unique_ptr`로 동적 배열을 관리하는 예제를 작성하세요.  
2. `shared_ptr` 순환 참조 문제를 코드로 시뮬레이션하고, `weak_ptr`로 해결해보세요.  
3. `unique_ptr`과 `shared_ptr`의 성능 차이를 비교해보세요.  

---

## 🔎 심화 학습
- `shared_ptr`의 제어 블록 구조  
- `enable_shared_from_this` 사용법  
- `scoped_ptr`(Boost)와 표준 스마트 포인터 비교  



### 1. Shared pointer 의 제어 블록 구조

Shared pointer는 다음 네개의 정보를 가진다.

1. Strong Reference Count
- 현재 객체를 소유하는 갯수(shared_ptr)
- `shared_ptr`이 복사/이동되면 증가하고 소멸하면 감소한다.
- 0이 되면 실제 객체를 삭제한다(delete 호출).

2. Weak Reference Count
- `weak_ptr` 개수 추적
- `shared_ptr`가 모두 사라져도, `weak_ptr`가 남아있으면 제어 블록은 유지된다.
- 마지막 `weak_ptr`가 해제될 때 제어 블록 자체도 해제된다(즉, 객체는 사라져도 제어 블록은 남아있을 수 있다).

3. 삭제자(Deleter)
- 객체를 삭제할 방법을 저장한다(delete, free, custom 함수 등).

4. 할당자(Allocator)
- 메모리 해제를 제어할 수 있도록 선택적으로 저장된다.


### 2. enable_shared_from_this

enable_shared_from_this<T>를 상속받으면, 객체가 `shared_ptr`로 관리될 때 내부적으로 자신의 제어 블록을 알고 있는 **약한 참조(weak_ptr)**를 저장한다.
이를 통해, enable_shared_from_this() 를 통해 신규 제어 블록이 아닌, 기존 제어 블록을 공유하는 `shared_ptr`를 제공받는 함수이다.

```
#include <iostream>
#include <memory>

struct Foo : std::enable_shared_from_this<Foo> {
    std::shared_ptr<Foo> getPtr() {
        return shared_from_this(); // ✅ 안전
    }
    ~Foo() { std::cout << "Foo destroyed\n"; }
};

int main() {
    auto sp1 = std::make_shared<Foo>();
    auto sp2 = sp1->getPtr(); // 같은 control block 공유

    std::cout << sp1.use_count() << "\n"; // 2
    std::cout << sp2.use_count() << "\n"; // 2
}
```

3. Boost ptr는 Obsolete. 이제는 사용하지 않는다.

---

## 🪞 회고
- 왜 여전히 `raw pointer`가 필요한 경우가 있을까?  
- 스마트 포인터 사용 시 주의해야 할 점은 무엇일까?  

---

## 🔗 관련 페이지
- [C++ 메모리 관리]({{ site.baseurl }}/posts/cpp-memory-management/)  
- [RAII]({{ site.baseurl }}/posts/whatis-raii/)  