---
layout: post
title: "async/await - C++/C#/CS 기초"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-asyncawait
mermaid: true
---

# async/await

## 📌 학습 목표
- [async/await]({{ site.baseurl }}/posts/whatis-asyncawait/) 키워드의 원리 이해  
- Task 기반 비동기 처리 모델 학습  
- 상태 머신 변환 과정을 이해하고 설명할 수 있음  
- 비동기 프로그래밍에서 발생할 수 있는 문제와 해결 방법 숙지  

---

## 📝 개념 정리

### 1. async/await란?
- C#에서 제공하는 **비동기 프로그래밍 키워드**  
- 메서드를 **Task 기반 비동기 처리 모델**로 실행하게 만들어줌  
- 컴파일러가 내부적으로 **상태 머신(state machine)** 으로 변환하여 동작  

---

### 2. 동작 원리
1. `async` 키워드를 메서드에 붙이면 반환 타입이 `Task` 또는 `Task<T>`로 변환됨  
2. `await` 키워드가 붙은 지점에서 **비동기 작업이 완료될 때까지 제어권을 호출자에게 반환**  
3. 이후 작업이 완료되면 **상태 머신이 재개**되어 코드가 이어서 실행  

```csharp
public async Task<string> GetDataAsync()
{
    await Task.Delay(1000); // 1초 기다림 (비동기)
    return "데이터 로드 완료";
}
```

---

### 3. 상태 머신 변환
- 컴파일러는 async/await 코드를 **비동기 상태 머신**으로 변환함  
- 즉, `await`는 단순한 키워드가 아니라 **코드를 중단점으로 나누어 콜백 등록**하는 것  

```csharp
// 실제 변환되는 개념적 구조
public Task<string> GetDataAsync()
{
    var stateMachine = new GetDataAsyncStateMachine();
    stateMachine.builder = AsyncTaskMethodBuilder<string>.Create();
    stateMachine.state = -1;
    stateMachine.builder.Start(ref stateMachine);
    return stateMachine.builder.Task;
}
```

---

### 4. async/await의 장점
- **비동기 코드도 동기 코드처럼 읽기 쉬움**  
- 콜백 지옥(Callback Hell) 방지  
- 스레드를 블로킹하지 않고 효율적 자원 사용  

---

### 5. 주의사항
- `async void`는 이벤트 핸들러 외에는 사용하지 말 것 (예외 처리 곤란)  
- `ConfigureAwait(false)` → UI/ASP.NET 환경에서 데드락 방지  
- CPU 바운드 작업에는 `Task.Run()`으로 스레드 풀 활용  

---

## 💻 예제 코드

### 비동기 HTTP 요청
```csharp
public async Task<string> FetchDataAsync(string url)
{
    using var client = new HttpClient();
    var response = await client.GetAsync(url);   // I/O 바운드 작업
    return await response.Content.ReadAsStringAsync();
}
```

### CPU 바운드 작업
```csharp
public async Task<int> CalculateAsync(int n)
{
    return await Task.Run(() =>
    {
        int sum = 0;
        for (int i = 0; i < n; i++) sum += i;
        return sum;
    });
}
```

---

## 📊 async/await vs 전통 방식

| 방식 | 특징 | 단점 |
|------|------|------|
| 동기 호출 | 코드 단순 | I/O 블로킹 발생 |
| 콜백 방식 | 비동기 처리 가능 | 가독성 ↓, 콜백 지옥 |
| async/await | Task 기반, 가독성 ↑ | 상태 머신 변환 오버헤드 |

---

## 🎯 연습 문제
1. `async` 메서드와 `await`의 역할을 각각 설명하세요.  
2. `ConfigureAwait(false)`를 사용해야 하는 이유는?  
3. CPU 바운드 작업과 I/O 바운드 작업에서 async/await 차이점을 설명하세요.  

---

## 🔎 심화 학습
- **IAsyncEnumerable<T> (C# 8.0+)**  
  ```csharp
  public async IAsyncEnumerable<int> GenerateAsync()
  {
      for (int i = 0; i < 5; i++)
      {
          await Task.Delay(500);
          yield return i;
      }
  }
  ```
- **IAsyncDisposable (C# 8.0+)** → `await using`  
- C++20의 `co_await`와 비교 (C++에서는 코루틴 기반으로 동작)  

---

## 🪞 면접 질문 & 답변

**Q1. async와 await의 차이는 무엇인가요?**  
A. `async`는 메서드를 비동기 메서드로 선언하는 키워드이고, `await`는 비동기 작업이 끝날 때까지 제어를 반환하고 결과를 기다리는 키워드입니다.  

**Q2. async/await 사용 시 주의할 점은 무엇인가요?**  
A. `async void`는 이벤트 핸들러 외에는 사용하지 말아야 하며, UI 환경에서는 `ConfigureAwait(false)`를 적절히 사용해야 합니다.  

**Q3. async/await가 내부적으로 어떻게 동작하나요?**  
A. 컴파일러가 상태 머신으로 변환하여 await 지점에서 제어권을 반환하고, 작업 완료 후 콜백을 등록해 이어서 실행합니다.  

**Q4. I/O 바운드 작업과 CPU 바운드 작업에서 async/await의 차이는 무엇인가요?**  
A. I/O 바운드는 스레드를 차단하지 않고 효율적으로 대기하지만, CPU 바운드는 Task.Run으로 별도 스레드에서 수행해야 합니다.  

---

## 🔗 관련 페이지
- [IDisposable]({{ site.baseurl }}/posts/whatis-idisposable/)  
- [Garbage Collector]({{ site.baseurl }}/posts/whatis-gc/)  

---