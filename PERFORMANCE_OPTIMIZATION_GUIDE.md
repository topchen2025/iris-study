# Performance Optimization Guide

## Overview
This guide provides best practices and examples for identifying and improving slow or inefficient code. While this repository currently contains documentation, this guide demonstrates common performance issues and their solutions.

## Common Performance Issues and Solutions

### 1. Algorithm Complexity
**Issue**: Using algorithms with poor time complexity for large datasets.

**Bad Practice** - O(n²) nested loops:
```python
# Inefficient: O(n²) time complexity
def find_duplicates_slow(items):
    duplicates = []
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            if items[i] == items[j] and items[i] not in duplicates:
                duplicates.append(items[i])
    return duplicates
```

**Good Practice** - O(n) using sets:
```python
# Efficient: O(n) time complexity
def find_duplicates_fast(items):
    seen = set()
    duplicates = set()
    for item in items:
        if item in seen:
            duplicates.add(item)
        else:
            seen.add(item)
    return list(duplicates)
```

### 2. Unnecessary Database Queries (N+1 Problem)
**Issue**: Making multiple database queries in a loop instead of batch processing.

**Bad Practice**:
```python
# Inefficient: N+1 queries
def get_user_posts_slow(user_ids):
    results = []
    for user_id in user_ids:
        user = db.query("SELECT * FROM users WHERE id = ?", user_id)
        posts = db.query("SELECT * FROM posts WHERE user_id = ?", user_id)
        results.append({'user': user, 'posts': posts})
    return results
```

**Good Practice**:
```python
# Efficient: Batch queries
def get_user_posts_fast(user_ids):
    users = db.query("SELECT * FROM users WHERE id IN (?)", user_ids)
    posts = db.query("SELECT * FROM posts WHERE user_id IN (?)", user_ids)
    
    # Organize results
    users_dict = {u['id']: u for u in users}
    posts_dict = {}
    for post in posts:
        posts_dict.setdefault(post['user_id'], []).append(post)
    
    return [{'user': users_dict[uid], 'posts': posts_dict.get(uid, [])} 
            for uid in user_ids]
```

### 3. String Concatenation in Loops
**Issue**: Building strings through repeated concatenation creates many intermediate objects.

**Bad Practice**:
```python
# Inefficient: Creates many intermediate strings
def build_html_slow(items):
    html = ""
    for item in items:
        html += f"<li>{item}</li>\n"
    return f"<ul>\n{html}</ul>"
```

**Good Practice**:
```python
# Efficient: Using join() or list accumulation
def build_html_fast(items):
    parts = ["<ul>"]
    parts.extend(f"<li>{item}</li>" for item in items)
    parts.append("</ul>")
    return "\n".join(parts)
```

### 4. Not Using Caching
**Issue**: Recalculating expensive operations repeatedly.

**Bad Practice**:
```python
# Inefficient: Recalculates Fibonacci every time
def fibonacci_slow(n):
    if n <= 1:
        return n
    return fibonacci_slow(n - 1) + fibonacci_slow(n - 2)
```

**Good Practice**:
```python
# Efficient: Using memoization
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci_fast(n):
    if n <= 1:
        return n
    return fibonacci_fast(n - 1) + fibonacci_fast(n - 2)
```

### 5. Loading Entire Files into Memory
**Issue**: Reading large files all at once can cause memory issues.

**Bad Practice**:
```python
# Inefficient: Loads entire file into memory
def process_large_file_slow(filename):
    with open(filename, 'r') as f:
        data = f.read()
        lines = data.split('\n')
        return [line.upper() for line in lines if line.strip()]
```

**Good Practice**:
```python
# Efficient: Process line by line
def process_large_file_fast(filename):
    result = []
    with open(filename, 'r') as f:
        for line in f:
            stripped = line.strip()
            if stripped:
                result.append(stripped.upper())
    return result
```

### 6. Not Using Appropriate Data Structures
**Issue**: Using lists when sets or dictionaries would be more efficient.

**Bad Practice**:
```python
# Inefficient: O(n) lookup time with list
def find_common_elements_slow(list1, list2):
    common = []
    for item in list1:
        if item in list2 and item not in common:
            common.append(item)
    return common
```

**Good Practice**:
```python
# Efficient: O(1) lookup time with sets
def find_common_elements_fast(list1, list2):
    return list(set(list1) & set(list2))
```

### 7. Inefficient Regular Expressions
**Issue**: Compiling regex patterns repeatedly in loops.

**Bad Practice**:
```python
# Inefficient: Compiles regex on every iteration
import re

def extract_emails_slow(texts):
    emails = []
    for text in texts:
        matches = re.findall(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', text)
        emails.extend(matches)
    return emails
```

**Good Practice**:
```python
# Efficient: Compile regex once
import re

EMAIL_PATTERN = re.compile(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')

def extract_emails_fast(texts):
    emails = []
    for text in texts:
        matches = EMAIL_PATTERN.findall(text)
        emails.extend(matches)
    return emails
```

### 8. Premature Optimization
**Important Note**: Always profile your code before optimizing. Focus on:
1. **Correctness first**: Make it work correctly
2. **Profile**: Measure where the bottlenecks actually are
3. **Optimize**: Focus on the actual bottlenecks
4. **Measure again**: Verify improvements

## Performance Testing Tools

### Python
- `cProfile`: Built-in profiler
- `timeit`: Measure execution time
- `memory_profiler`: Track memory usage
- `py-spy`: Sampling profiler

### JavaScript
- Chrome DevTools Performance tab
- `console.time()` and `console.timeEnd()`
- `performance.now()`

### Java
- JProfiler
- VisualVM
- Java Mission Control

## Best Practices Checklist

- [ ] Use appropriate data structures for the problem
- [ ] Minimize database queries (use batch operations)
- [ ] Cache expensive computations
- [ ] Avoid nested loops where possible
- [ ] Use generators for large datasets
- [ ] Profile before optimizing
- [ ] Consider time vs space tradeoffs
- [ ] Use connection pooling for databases
- [ ] Implement pagination for large result sets
- [ ] Use indexes on database columns used in WHERE/JOIN clauses
- [ ] Close resources properly (files, connections, etc.)

## Conclusion

Performance optimization should be data-driven. Always measure before and after optimizations to ensure they provide real benefits. Remember: premature optimization is the root of all evil, but knowing these patterns helps you write better code from the start.
