---
layout: post
title: "RAII(Resource Acquisition Is Initialization) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-raii
---

# RAII(Resource Acquisition Is Initialization)

## 📌 학습 목표
- [RAII]({{ site.baseurl }}/posts/whatis-raii/) 개념 이해  
- C++에서 객체 수명과 자원 관리의 연계성 학습  
- [스마트포인터]({{ site.baseurl }}/posts/whatis-smartpointer/)와의 관계 이해  


## 📌 개념 정리
- **RAII**: 객체의 생성(Initialization) 시 자원 획득(Acquisition), 소멸 시 해제  
- 자원 획득이 초기화라는 의미의 C++ 프로그래밍 기법
- C++ 소멸자의 자동 호출 메커니즘을 활용  
- 자원: 메모리, 파일 핸들, 소켓, 뮤텍스 등  
- 객체의 생성자에서 자원을 획득하고 소멸자에서 해제
- 스마트 포인터, using 문 등에서 활용되는 패턴

**장점**  
- 예외 안전성 보장  
- `delete`, `close()` 호출 누락 방지  
- 명확한 객체 수명 관리  

---

## 💻 예제 코드
```cpp
#include <iostream>
#include <fstream>
using namespace std;

class FileHandler {
    ifstream file;
public:
    FileHandler(const string& path) {
        file.open(path);
        cout << "Open file: " << path << endl;
    }
    ~FileHandler() {
        file.close();
        cout << "Close file" << endl;
    }
};

void Foo() {
    FileHandler fh("data.txt");
    // 함수 종료 시 소멸자가 호출되어 자동으로 close()
}
```

---

## 🎯 연습 문제
1. `RAII` 패턴을 이용해 `LockGuard` 클래스를 직접 구현하세요.  
2. `RAII`를 사용하지 않은 경우와 비교하여 예외 발생 시 동작 차이를 확인하세요.  
3. 파일, 네트워크, 메모리 중 하나를 선택해 `RAII` 클래스를 작성해보세요.  

---

## 🔎 심화 학습
- `std::lock_guard`, `std::scoped_lock`  
- C++ 표준 라이브러리에서 활용되는 RAII 사례  
- C#의 `IDisposable`과 `using` 문과의 비교  

---

## 🪞 회고
- RAII가 없다면 어떤 문제가 발생할까?  
- 예외 안전성을 확보하기 위한 다른 방법과 비교했을 때 장단점은?  

---

## 🔗 관련 페이지
- [C++ 메모리 관리]({{ site.baseurl }}/posts/cpp-memory-management/)  
- [스마트포인터]({{ site.baseurl }}/posts/whatis-smartpointer/)  
