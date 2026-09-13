---
layout: post
title: "상속(Inheritance) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-inheritance
---

# 상속(Inheritance)

## 📌 개념 정리
- 기존 [클래스]({{ site.baseurl }}/posts/whatis-class/)를 기반으로 새로운 [클래스]({{ site.baseurl }}/posts/whatis-class/)를 정의하는 기법.
- 코드 재사용성과 [다형성]({{ site.baseurl }}/posts/whatis-polymorphism/) 지원.
- 상속 방식: `public`, `protected`, `private`.

## 💻 예제
```cpp
class Animal {
public:
    virtual void Speak() { cout << "Animal\n"; }
};

class Dog : public Animal { // public 상속
public:
    void Speak() override { cout << "Woof!\n"; }
};
```

## ⚡ 주의점
- 잘못 사용하면 강한 결합, 유지보수 어려움.
- 다중 상속에서 [다이아몬드상속문제]({{ site.baseurl }}/posts/whatis-diamondinheritanceproblem/) 발생 가능.
- "is-a" 관계일 때만 적절. "has-a"는 [컴포지션]({{ site.baseurl }}/posts/whatis-composition/) 권장.

## 🔗 관련 페이지
- [객체지향]({{ site.baseurl }}/posts/whatis-oop/)
- [클래스]({{ site.baseurl }}/posts/whatis-class/)
- [다형성]({{ site.baseurl }}/posts/whatis-polymorphism/)
- [추상클래스]({{ site.baseurl }}/posts/whatis-abstractclass/)
- [다이아몬드상속문제]({{ site.baseurl }}/posts/whatis-diamondinheritanceproblem/)
- [컴포지션]({{ site.baseurl }}/posts/whatis-composition/)
