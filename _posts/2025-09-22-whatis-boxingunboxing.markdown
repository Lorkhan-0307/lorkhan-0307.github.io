---
layout: post
title: "박싱과 언박싱(Boxing and Unboxing) - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan, c-sharp]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-boxingunboxing
---

# 박싱과 언박싱(Boxing and Unboxing)

## 📌 학습 목표
- [값 타입과 참조 타입]({{ site.baseurl }}/posts/whatis-class/)의 차이를 이해한다.  
- C#에서 [박싱과 언박싱]({{ site.baseurl }}/posts/whatis-boxingunboxing/)의 동작 원리를 설명한다.  
- 박싱/언박싱으로 발생하는 성능 비용을 분석한다.  
- [제네릭(Generic)]({{ site.baseurl }}/posts/whatis-genericinterface/)을 통한 회피 방법을 학습한다.  
- [C++ RAII]({{ site.baseurl }}/posts/whatis-raii/) / [스마트 포인터]({{ site.baseurl }}/posts/whatis-smartpointer/)와 비교해 개념적 연관성을 정리한다.

---

## 📌 개념 정리
- **박싱(Boxing)**: 값 타입(`struct`, `int` 등)을 참조 타입(`object`, `System.ValueType`)으로 변환하는 과정  
- **언박싱(Unboxing)**: 참조 타입에 담긴 값을 다시 원래 값 타입으로 꺼내는 과정  
- 힙 할당과 복사 비용이 수반되므로 **성능 저하** 원인이 될 수 있다.

```csharp
int n = 123;
object obj = n;      // 박싱: 값 타입 → object
int m = (int)obj;    // 언박싱: object → 값 타입
```

---

## 📌 동작 원리
- **박싱 시**: 새로운 힙 객체를 생성하고, 값 타입의 데이터를 그 안에 복사  
- **언박싱 시**: 힙 객체의 내용을 값 타입 변수에 다시 복사  

```text
스택 (값 타입) → 힙에 object 생성 → 복사 저장 → 참조 반환
```

---

## 📌 성능 비용
- 매번 힙에 객체 생성 + GC 부담  
- 언박싱은 **형변환 + 복사** 과정이 필요  
- 반복문/핫패스에서 사용 시 심각한 성능 저하  

> 면접 포인트: "박싱/언박싱이 왜 문제가 될까?" → **불필요한 힙 할당과 GC 부담** 때문이다.

---

## 📌 박싱/언박싱 회피법
1. **제네릭(Generic) 사용**  

```csharp
// 박싱 발생
ArrayList list = new ArrayList();
list.Add(1);           // int → object (박싱)
int x = (int)list[0];  // 언박싱

// 무박싱
List<int> list2 = new List<int>();
list2.Add(1);          // int 그대로 저장
int y = list2[0];      // 언박싱 없음
```

2. **인터페이스 대신 제네릭 제약 사용**  
```csharp
int Sum<T>(List<T> data) where T : struct
{
    int sum = 0;
    foreach (var v in data) sum += Convert.ToInt32(v);
    return sum;
}
```

3. `Span<T>`, `Memory<T>` 사용 (고급)**  
- 값 타입 데이터를 힙 할당 없이 안전하게 다룰 수 있다.  
- 참고: [고급 메모리 관리]({{ site.baseurl }}/posts/csharp-memory-management/)

---

## 📌 C++과의 비교
- C++에는 **박싱/언박싱 개념이 없음** (값 타입/참조 타입 구분이 다름)  
- 대신 **RAII**와 [스마트 포인터]({{ site.baseurl }}/posts/whatis-smartpointer/)로 메모리 관리  
- C#의 박싱/언박싱은 **런타임 비용**이므로 반드시 회피 전략 필요

---

## 📌 자주 묻는 질문
1) 박싱은 언제 발생하나요?  
→ 값 타입이 `object`나 인터페이스로 변환될 때  

2) 언박싱은 왜 비용이 큰가요?  
→ **형변환 검사 + 값 복사** 과정이 필요하기 때문  

3) 어떻게 피할 수 있나요?  
→ **제네릭 사용, Span<T>, 캐싱** 등을 통해  

---

## 📌 치트시트
- 박싱: 값 타입 → 참조 타입(object) 변환  
- 언박싱: 참조 타입(object) → 값 타입 변환  
- 비용: 힙 할당, GC 부담, 값 복사  
- 회피: 제네릭, Span<T>, Memory<T>  

---