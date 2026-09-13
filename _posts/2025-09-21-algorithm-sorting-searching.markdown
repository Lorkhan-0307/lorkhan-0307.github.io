---
layout: post
title: "알고리즘 완벽 가이드: 정렬(퀵소트, 머지소트)과 이진 탐색"
date: 2025-09-21 15:01:00 +0900
categories: [Tech Interview, algorithm]
slug: algorithm-sorting-searching
tags: [algorithm, sorting, quick sort, merge sort, binary search, time complexity]
---

## 📌 학습 목표
- 주요 정렬 알고리즘(퀵소트, 머지소트) 완벽 이해
- 이진 탐색 동작 원리와 구현 방법 학습
- 각 알고리즘의 시간/공간 복잡도 분석
- 실무에서의 적절한 알고리즘 선택 기준 습득

---

## 📝 개념 정리

### 1. 퀵 정렬 (Quick Sort)

**핵심 원리:**
- 분할 정복(Divide and Conquer) 알고리즘
- 피벗(pivot)을 기준으로 배열을 분할
- **평균 시간복잡도**: O(n log n)
- **최악 시간복잡도**: O(n²) - 이미 정렬된 배열에서 발생
- **공간복잡도**: O(log n) - 재귀 호출 스택

**동작 과정:**
1. 배열에서 피벗 선택
2. 피벗보다 작은 원소는 왼쪽, 큰 원소는 오른쪽으로 분할
3. 분할된 부분 배열에 대해 재귀적으로 퀵정렬 수행

```cpp
void quickSort(vector<int>& arr, int low, int high) {
    if (low < high) {
        int pivot = partition(arr, low, high);
        quickSort(arr, low, pivot - 1);    // 피벗 왼쪽 정렬
        quickSort(arr, pivot + 1, high);   // 피벗 오른쪽 정렬
    }
}

int partition(vector<int>& arr, int low, int high) {
    int pivot = arr[high];    // 마지막 원소를 피벗으로 선택
    int i = low - 1;          // 작은 원소들의 마지막 인덱스
    
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    swap(arr[i + 1], arr[high]);
    return i + 1;
}
```

### 2. 머지 정렬 (Merge Sort)

**핵심 원리:**
- 분할 정복 알고리즘 (안정 정렬)
- 배열을 절반씩 나누어 각각 정렬 후 병합
- **시간복잡도**: O(n log n) - 모든 경우에 일정
- **공간복잡도**: O(n) - 추가 메모리 필요

**동작 과정:**
1. 배열을 절반으로 분할 (더 이상 나눌 수 없을 때까지)
2. 각 부분을 재귀적으로 정렬
3. 정렬된 두 부분을 병합

```cpp
void mergeSort(vector<int>& arr, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        
        mergeSort(arr, left, mid);       // 왼쪽 절반 정렬
        mergeSort(arr, mid + 1, right);  // 오른쪽 절반 정렬
        merge(arr, left, mid, right);    // 병합
    }
}

void merge(vector<int>& arr, int left, int mid, int right) {
    vector<int> temp(right - left + 1);
    int i = left, j = mid + 1, k = 0;
    
    // 두 부분 배열 병합
    while (i <= mid && j <= right) {
        if (arr[i] <= arr[j]) {
            temp[k++] = arr[i++];
        } else {
            temp[k++] = arr[j++];
        }
    }
    
    // 남은 원소들 추가
    while (i <= mid) temp[k++] = arr[i++];
    while (j <= right) temp[k++] = arr[j++];
    
    // 원본 배열에 복사
    for (i = left; i <= right; i++) {
        arr[i] = temp[i - left];
    }
}
```

### 3. 이진 탐색 (Binary Search)

**핵심 원리:**
- **전제조건**: 정렬된 배열에서만 사용 가능
- 중간값과 비교하여 탐색 범위를 절반씩 줄임
- **시간복잡도**: O(log n)
- **공간복잡도**: O(1) - 반복문 구현 시

**동작 과정:**
1. 배열의 중간 원소와 타겟 비교
2. 타겟이 중간값보다 작으면 왼쪽 절반에서 탐색
3. 타겟이 중간값보다 크면 오른쪽 절반에서 탐색
4. 타겟을 찾거나 탐색 범위가 없을 때까지 반복

```cpp
int binarySearch(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;  // 오버플로우 방지
        
        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return -1;  // 타겟을 찾지 못한 경우
}

// 재귀 버전
int binarySearchRecursive(vector<int>& arr, int target, int left, int right) {
    if (left > right) return -1;
    
    int mid = left + (right - left) / 2;
    
    if (arr[mid] == target) return mid;
    else if (arr[mid] < target) return binarySearchRecursive(arr, target, mid + 1, right);
    else return binarySearchRecursive(arr, target, left, mid - 1);
}
```

---

## 💻 실무 활용 예제

### STL을 활용한 이진 탐색
```cpp
#include <algorithm>

vector<int> arr = {1, 3, 5, 7, 9, 11, 13};

// 값 존재 여부 확인
bool found = binary_search(arr.begin(), arr.end(), 7);

// 첫 번째 위치 찾기 (lower_bound)
auto it_lower = lower_bound(arr.begin(), arr.end(), 7);
int index_lower = it_lower - arr.begin();

// 마지막 위치 다음 찾기 (upper_bound)
auto it_upper = upper_bound(arr.begin(), arr.end(), 7);
int index_upper = it_upper - arr.begin();

// 특정 값의 개수 구하기
int count = upper_bound(arr.begin(), arr.end(), 7) - 
           lower_bound(arr.begin(), arr.end(), 7);
```

### 하이브리드 정렬 (Introsort) 개념
```cpp
// STL sort()는 실제로 Introsort를 사용
// - 빠른 평균 성능을 위해 퀵소트 사용
// - 재귀 깊이가 깊어지면 힙소트로 전환
// - 작은 배열에서는 삽입정렬 사용

vector<int> data = {64, 34, 25, 12, 22, 11, 90};
sort(data.begin(), data.end());  // Introsort 사용
```

---

## 🎯 연습 문제

### 1. 퀵 정렬 최적화
```cpp
// 피벗 선택 최적화: 3-median 방법
int medianOfThree(vector<int>& arr, int low, int high) {
    int mid = low + (high - low) / 2;
    
    if (arr[mid] < arr[low]) swap(arr[low], arr[mid]);
    if (arr[high] < arr[low]) swap(arr[low], arr[high]);
    if (arr[high] < arr[mid]) swap(arr[mid], arr[high]);
    
    return mid;
}
```

### 2. 이진 탐색 변형 문제
```cpp
// 타겟 이상의 첫 번째 원소 위치 찾기
int findFirstGreaterEqual(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1, result = -1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] >= target) {
            result = mid;
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return result;
}
```

### 3. 회전된 정렬 배열에서 탐색
```cpp
int searchInRotatedArray(vector<int>& nums, int target) {
    int left = 0, right = nums.size() - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (nums[mid] == target) return mid;
        
        // 왼쪽 절반이 정렬되어 있는 경우
        if (nums[left] <= nums[mid]) {
            if (target >= nums[left] && target < nums[mid]) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        } 
        // 오른쪽 절반이 정렬되어 있는 경우
        else {
            if (target > nums[mid] && target <= nums[right]) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
    }
    return -1;
}
```

---

## 🔎 심화 학습

### 안정 정렬 vs 불안정 정렬
- **안정 정렬**: 머지소트, 삽입정렬 - 동일한 값의 상대적 순서 유지
- **불안정 정렬**: 퀵소트, 힙소트 - 동일한 값의 순서가 바뀔 수 있음

### 정렬 알고리즘 비교표
| 알고리즘 | 최선 | 평균 | 최악 | 공간복잡도 | 안정성 |
|---------|------|------|------|------------|--------|
| 퀵소트 | O(n log n) | O(n log n) | O(n²) | O(log n) | 불안정 |
| 머지소트 | O(n log n) | O(n log n) | O(n log n) | O(n) | 안정 |
| 힙소트 | O(n log n) | O(n log n) | O(n log n) | O(1) | 불안정 |

### 고급 탐색 기법
```cpp
// 삼분 탐색 (Ternary Search) - 단봉 함수에서 최값 찾기
double ternarySearch(double left, double right, function<double(double)> f) {
    const double EPS = 1e-9;
    
    while (right - left > EPS) {
        double m1 = left + (right - left) / 3;
        double m2 = right - (right - left) / 3;
        
        if (f(m1) < f(m2)) {
            left = m1;
        } else {
            right = m2;
        }
    }
    return (left + right) / 2;
}
```

---

## 🌐 외부 링크
- [VisuAlgo - 정렬 알고리즘 시각화](https://visualgo.net/en/sorting)
- [GeeksforGeeks - Binary Search](https://www.geeksforgeeks.org/binary-search/)
- [알고리즘 문제해결 전략 - 정렬과 탐색](https://book.algospot.com/)

---

## 💡 실무 적용 팁

1. **알고리즘 선택 기준**:
   - 데이터 크기가 작으면 삽입정렬 고려
   - 안정성이 중요하면 머지소트 선택
   - 메모리가 제한적이면 퀵소트나 힙소트 고려

2. **이진 탐색 활용**:
   - 데이터베이스 인덱스 구조 이해
   - 캐시 효율성을 위한 메모리 접근 패턴 고려
   - 실수형 데이터에서는 epsilon 값 고려

3. **성능 최적화**:
   - 작은 배열에서는 삽입정렬이 더 빠를 수 있음
   - 캐시 친화적인 알고리즘 선택 고려
   - 병렬처리 가능한 알고리즘 활용

---

## 다음 학습 주제
- **고급 정렬**: 기수 정렬, 계수 정렬, 버킷 정렬
- **고급 탐색**: 해시 테이블, B-트리, LSM-트리
- **문자열 알고리즘**: KMP, Rabin-Karp, Z 알고리즘
- **그래프 알고리즘**: DFS, BFS, 다익스트라, A* 알고리즘

---

## 🪞 회고 질문
- 퀵소트와 머지소트의 장단점을 실무 상황에 맞춰 설명할 수 있는가?
- 이진 탐색이 실패하는 경우(정렬되지 않은 배열)를 사전에 어떻게 방지할 수 있을까?
- 대용량 데이터 정렬 시 메모리 제약을 어떻게 해결할 수 있을까?
- 실시간 시스템에서 최악의 경우 성능이 중요하다면 어떤 정렬을 선택해야 할까?
