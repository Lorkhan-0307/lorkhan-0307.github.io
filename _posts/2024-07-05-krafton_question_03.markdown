---
layout: post
title:  "백준 2739번 python 풀이 - 구구단"
date:   2024-07-05 13:40:00 +0900
categories: algorithm
tags: [python, 크래프톤정글문제풀이, 반복문]
---

## 문제 링크
[2739번](https://www.acmicpc.net/problem/2739)

## 해결책
```
N = int(input())

for i in range(1, 10):
    print(f"{N} * {i} = {N * i}")
```

## 주석으로 달 설명

#### for 반복문

[python document](https://docs.python.org/3/reference/compound_stmts.html#for)

코드를 반복시킬 경우, for문 혹은 while문을 사용한다.
물론, 재귀함수로도 구현할 수 있다.

재귀 함수와 `for` 문의 차이는 주로 구조, 사용 사례, 성능 측면에서 나타난다.
두 개념은 반복 작업을 수행하는 데 사용되지만, 각각의 동작 방식과 장단점이 다르다.

#### 재귀 함수

재귀 함수는 스스로를 호출하는 함수이며, 큰 문제를 작은 문제로 분할하여 해결하는 Divide and Conquer 방식이다. 또한, 무한루프를 방지하기 위해 종료 조건을 명시한다.

##### 예제

```python
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)

print(factorial(5))  # 출력: 120
```

#### 특징

1. **구조**: 함수가 자기 자신을 호출하며, 보통 종료 조건(base case)을 포함합니다.
2. **사용 사례**: 트리나 그래프 탐색, 분할 정복 알고리즘(예: 퀵소트, 병합 정렬), 수학적 문제(예: 팩토리얼, 피보나치 수열) 등에 자주 사용됩니다.
3. **메모리 사용**: 각 함수 호출마다 새로운 스택 프레임이 생성되므로, 깊은 재귀는 스택 오버플로우를 초래할 수 있습니다.
4. **가독성**: 복잡한 알고리즘을 간결하고 직관적으로 표현할 수 있습니다. 예를 들어, 트리 구조를 탐색하는 코드를 재귀적으로 작성하면 더 이해하기 쉬울 수 있습니다.

#### `for` 문

`for` 문은 반복 가능한 객체(iterable)의 요소들을 순차적으로 접근하며 반복 작업을 수행하는 제어 구조입니다.

#### 예제

```python
def factorial(n):
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result

print(factorial(5))  # 출력: 120
```

#### 특징

1. **구조**: 반복 가능한 객체(리스트, 튜플, 문자열 등)의 각 요소에 대해 블록 내의 코드를 반복 실행합니다.
2. **사용 사례**: 리스트 처리, 파일 읽기, 범위 내의 숫자 반복 등 일반적인 반복 작업에 사용됩니다.
3. **메모리 사용**: 반복 구조 자체는 추가적인 스택 프레임을 생성하지 않으므로, 재귀보다 메모리 효율적입니다.
4. **가독성**: 단순한 반복 작업을 명확하고 직관적으로 표현할 수 있습니다.

### 차이점 비교

| 특성      | 재귀 함수                      | `for` 문                  |
|----------|--------------------------------|---------------------------|
| 구조         | 자기 자신을 호출               | 반복 가능한 객체 순회     |
| 사용 사례    | 트리/그래프 탐색, 분할 정복    | 리스트 처리, 범위 반복    |
| 메모리 사용  | 스택 프레임 추가               | 추가 메모리 사용 없음     |
| 가독성       | 복잡한 알고리즘 표현에 유리    | 단순 반복 작업에 유리     |
| 종료 조건    | 명시적 종료 조건 필요          | 반복 횟수나 요소에 의존   |

### 예제 비교: 피보나치 수열

#### 재귀 함수

```python
def fibonacci_recursive(n):
    if n <= 1:
        return n
    else:
        return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2)

print(fibonacci_recursive(10))  # 출력: 55
```

#### `for` 문

```python
def fibonacci_iterative(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a

print(fibonacci_iterative(10))  # 출력: 55
```

#### 결론

- **재귀 함수**는 문제를 더 작은 하위 문제로 분할하여 해결하는 데 적합하며, 특정 알고리즘에서 코드의 가독성을 높일 수 있습니다.
- **`for` 문**은 반복 작업을 직관적이고 메모리 효율적으로 수행하는 데 적합합니다.

문제의 성격에 따라 적절한 방법을 선택하여 사용하면 됩니다. 재귀는 매우 깊은 호출 스택을 유발할 수 있으므로, 큰 입력에 대해서는 주의가 필요합니다. 반면, `for` 문은 일반적으로 메모리 사용이 효율적이지만, 재귀적 사고가 필요한 문제를 해결하기에는 적합하지 않을 수 있습니다.

