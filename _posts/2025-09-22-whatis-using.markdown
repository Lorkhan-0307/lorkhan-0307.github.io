---
layout: post
title: "using/await using -  C# 메모리 관리 핵심"
date: 2025-09-22 15:00:00 +0900
categories: [Tech Interview, Study Plan]
tags: [cpp, c-sharp, computer-science, algorithm, data-structure, operating-system, network, database, design-pattern]
slug: whatis-using
mermaid: true
---

# using / await using 문법 정리

## 📌 학습 목표
- C#의 [IDisposable 패턴]({{ site.baseurl }}/posts/whatis-idisposable/)과 `using` 키워드의 관계를 이해한다.  
- `await using`을 통해 [IAsyncDisposable]({{ site.baseurl }}/posts/whatis-idisposable/) 자원을 안전하게 해제하는 방법을 설명한다.  
- 코드 예제와 함께 `using`/`await using`의 내부 동작과 차이를 학습한다.  

---

## 📌 기본 개념
- `using` 문은 **IDisposable.Dispose()**를 보장하는 구문  
- `await using` 문은 **IAsyncDisposable.DisposeAsync()**를 보장하는 구문  

> 면접 포인트: "`using`을 쓰지 않으면 어떻게 되나요?"  
→ Dispose 호출을 깜빡하면 파일 핸들, 소켓, DB 연결 등이 **GC가 수거하기 전까지 해제되지 않는다.**

---

## 📌 using 문법

```csharp
using (var fs = new FileStream("log.txt", FileMode.Create))
{
    byte[] data = Encoding.UTF8.GetBytes("Hello");
    fs.Write(data, 0, data.Length);
} // 범위를 벗어나면 자동으로 Dispose 호출
```

- C# 8.0 이후에는 **using 선언문**도 가능:
```csharp
using var fs = new FileStream("log.txt", FileMode.Create);
fs.WriteByte(1); // 스코프 종료 시 자동 Dispose
```

---

## 📌 await using 문법

비동기 Dispose가 필요한 경우 (`IAsyncDisposable` 구현체)

```csharp
public sealed class AsyncResource : IAsyncDisposable
{
    public async ValueTask DisposeAsync()
    {
        await Task.Delay(100); // 비동기 해제 작업
    }
}

public async Task UseAsync()
{
    await using var res = new AsyncResource();
    // 비동기 리소스 사용
} // await res.DisposeAsync() 자동 호출
```

---

## 📌 내부 동작
- `using`은 `try-finally`로 변환되어 finally 블록에서 Dispose 호출  
- `await using`은 `try-finally` + `await DisposeAsync()` 호출로 변환  

```csharp
// using 변환 예시
var fs = new FileStream("a.txt", FileMode.Open);
try
{
    // 사용
}
finally
{
    if (fs != null) ((IDisposable)fs).Dispose();
}
```

---

## 📌 실무 팁
- 항상 `using`을 통해 자원 해제를 보장  
- 비동기 리소스(`DbConnection.OpenAsync()`, `Stream.DisposeAsync()`)는 `await using` 활용  
- 여러 리소스는 중첩 `using` 대신 `using var` 여러 개 선언으로 간결하게 관리  

---

## 📌 치트시트
- `using`: IDisposable.Dispose() 자동 호출  
- `using var`: C# 8.0+ 간소화 문법  
- `await using`: IAsyncDisposable.DisposeAsync() 자동 호출  
- 내부적으로 `try-finally` 변환  

---