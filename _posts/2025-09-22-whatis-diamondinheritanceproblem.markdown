---
layout: post
title: "다이아몬드 상속 문제(Diamond Inheritance Problem) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-diamondinheritanceproblem
---

# 다이아몬드 상속 문제(Diamond Inheritance Problem)

## 📌 개념 정리
- 다중 [상속]({{ site.baseurl }}/posts/whatis-inheritance/) 시 공통 조상 [클래스]({{ site.baseurl }}/posts/whatis-class/)가 중복 포함되는 문제.
- 메모리 중복, 호출 모호성 발생.

## 💻 예제
```cpp
class A {E};
class B : public A {E override};
class C : public A {E override};
class D : public B, public C {}; // A 중복됨


->

A* d = new D();
d->E;
```

### 해결 → 가상 상속
```cpp
class B : virtual public A {};
class C : virtual public A {};
class D : public B, public C {}; // A 1번만 포함
```

## ⚡ 주의점
- 구조 복잡해짐 → 가능하면 [컴포지션]({{ site.baseurl }}/posts/whatis-composition/) 선호.

## 🔗 관련 페이지
- [상속]({{ site.baseurl }}/posts/whatis-inheritance/)
- [객체지향]({{ site.baseurl }}/posts/whatis-oop/)
- [클래스]({{ site.baseurl }}/posts/whatis-class/)
