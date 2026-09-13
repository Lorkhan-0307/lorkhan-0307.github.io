---
layout: post
title: "컴포지션(Composition) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-composition
---

# 컴포지션(Composition)

## 📌 개념 정리
- [상속]({{ site.baseurl }}/posts/whatis-inheritance/) 대신 [클래스]({{ site.baseurl }}/posts/whatis-class/) 안에 다른 [클래스]({{ site.baseurl }}/posts/whatis-class/)를 멤버로 포함하는 방식.
- 관계: “has-a” vs 상속의 “is-a”.

## 💻 예제
```cpp
class Engine {
public:
    void Start() { cout << "Engine start\n"; }
};
class Car {
private:
    Engine engine; // 컴포지션
public:
    void Drive() { engine.Start(); }
};
```

## ⚡ 주의점
- 유연성 ↑, 상속보다 결합도 낮음.
- 상속보다 권장되는 경우 많음.

## 🔗 관련 페이지
- [객체지향]({{ site.baseurl }}/posts/whatis-oop/)
- [클래스]({{ site.baseurl }}/posts/whatis-class/)
- [상속]({{ site.baseurl }}/posts/whatis-inheritance/)
