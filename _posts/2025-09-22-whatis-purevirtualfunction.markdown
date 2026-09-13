---
layout: post
title: "순수가상함수(Pure Virtual Function) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-purevirtualfunction
---

# 순수가상함수(Pure Virtual Function)

## 📌 개념 정리
- 구현 없이 선언만 하는 [가상함수vptr]({{ site.baseurl }}/posts/whatis-vptr/).
- 문법: `virtual void f() = 0;`.
- [추상클래스]({{ site.baseurl }}/posts/whatis-abstractclass/) 생성의 핵심.

## 💻 예제
```cpp
class Shape {
public:
	int x;
	int y;
    virtual void Draw() = 0; // 순수 가상 함수
	virtual vector<int> GetCenter()
	{
		return {x, y};
	}
};

class Circle : Shape {
	virtual vector<int> GetCenter() override
	{
		vector<int> baseCenter = Shape::GetCenter();
		
		baseCenter[0] += 1;
		baseCenter[1] += 1;
		
		return baseCenter;
	}
}

class CircleA : Circle {

	vector<int> GetCenter() override
	{
		???
	}
}

int main()
{

	Shape A;
	Circle B;
	CircleA C;
	
	
	return 0;
}


```

## ⚡ 주의점
- 반드시 파생 [클래스]({{ site.baseurl }}/posts/whatis-class/)에서 구현해야 함.
- [추상클래스]({{ site.baseurl }}/posts/whatis-abstractclass/)라서 직접 객체화 불가.

## 🔗 관련 페이지
- [추상클래스]({{ site.baseurl }}/posts/whatis-abstractclass/)
- [다형성]({{ site.baseurl }}/posts/whatis-polymorphism/)
- [클래스]({{ site.baseurl }}/posts/whatis-class/)
