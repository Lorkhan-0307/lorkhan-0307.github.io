---
layout: post
title: "추상 클래스(Abstract Class) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-abstractclass
---

# 추상 클래스(Abstract Class)

## 📌 개념 정리
- 하나 이상의 [[순수 가상 함수]]를 포함하는 [클래스]({{ site.baseurl }}/posts/whatis-class/).
- 객체 생성 불가, 반드시 파생 [클래스]({{ site.baseurl }}/posts/whatis-class/)에서 구현.

## 💻 예제
```cpp
class Shape {
public:
    virtual void Draw() = 0; // 순수 가상 함수
};
class Circle : public Shape {
public:
    void Draw() override { cout << "Circle\n"; }
};
```

## ⚡ 주의점
- 인터페이스 제공 역할.
- C#에서는 `abstract class` 또는 `interface`로 구분.

## 🔗 관련 페이지
- [객체지향]({{ site.baseurl }}/posts/whatis-oop/)
- [순수가상함수]({{ site.baseurl }}/posts/whatis-purevirtualfunction/)
- [상속]({{ site.baseurl }}/posts/whatis-inheritance/)
- [다형성]({{ site.baseurl }}/posts/whatis-polymorphism/)