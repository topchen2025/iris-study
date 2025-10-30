# Performance Optimization Examples

This directory contains practical examples demonstrating common performance issues and their solutions.

## Files

- **inefficient_example.py**: Contains intentionally slow and inefficient code to demonstrate common performance anti-patterns
- **improved_example.py**: Contains optimized versions of the same functions with best practices
- **benchmark.py**: Compares the performance of both versions and shows the improvements

## Running the Examples

### Run Inefficient Examples
```bash
python examples/inefficient_example.py
```

### Run Improved Examples
```bash
python examples/improved_example.py
```

### Run Performance Benchmark
```bash
python examples/benchmark.py
```

## Key Performance Issues Demonstrated

1. **Algorithm Complexity**: O(n²) vs O(n) implementations
2. **Memoization**: Caching expensive recursive calculations
3. **String Building**: String concatenation vs join()
4. **Data Structures**: List vs Set for membership testing
5. **Regex Compilation**: Repeated compilation vs compiled patterns
6. **Batch Processing**: N+1 queries vs batch operations
7. **Caching**: Redundant loading vs cached configuration

## Expected Performance Improvements

When running the benchmark, you should see:
- Find Duplicates: ~100-1000x faster
- Fibonacci(25): ~1000-10000x faster
- String Building: ~10-50x faster
- List Membership: ~50-100x faster

## Learning Objectives

After reviewing these examples, you should understand:
1. How to identify performance bottlenecks
2. When to use different data structures
3. The importance of algorithm complexity
4. How to apply memoization and caching
5. Best practices for string operations
6. How to avoid N+1 query problems
7. The value of benchmarking before and after optimization
