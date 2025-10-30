"""
Performance Benchmark Comparison
Compares the performance of inefficient vs improved code examples.
"""

import time
import sys
from inefficient_example import (
    find_duplicates_slow,
    fibonacci_slow,
    build_string_slow,
    find_in_list_slow
)
from improved_example import (
    find_duplicates_fast,
    fibonacci_fast,
    build_string_fast,
    find_in_list_fast
)


def benchmark_function(func, *args, iterations=1):
    """Run a function multiple times and return average execution time."""
    total_time = 0
    for _ in range(iterations):
        start = time.time()
        result = func(*args)
        total_time += time.time() - start
    return total_time / iterations, result


def format_speedup(slow_time, fast_time):
    """Calculate and format the speedup factor."""
    if fast_time == 0:
        return "∞x faster"
    speedup = slow_time / fast_time
    return f"{speedup:.2f}x faster"


def print_benchmark_result(name, slow_time, fast_time):
    """Print formatted benchmark results."""
    speedup = format_speedup(slow_time, fast_time)
    print(f"{name:30} | Slow: {slow_time:8.6f}s | Fast: {fast_time:8.6f}s | {speedup}")


def main():
    print("=" * 80)
    print("Performance Benchmark: Inefficient vs Improved Code")
    print("=" * 80)
    print()
    
    # Benchmark 1: Find Duplicates
    print("1. Find Duplicates (1500 items, 500 duplicates)")
    test_data = list(range(1000)) + list(range(500))
    slow_time, _ = benchmark_function(find_duplicates_slow, test_data)
    fast_time, _ = benchmark_function(find_duplicates_fast, test_data)
    print_benchmark_result("Find Duplicates", slow_time, fast_time)
    print()
    
    # Benchmark 2: Fibonacci
    print("2. Fibonacci Calculation")
    fib_n = 25
    print(f"   Computing Fibonacci({fib_n})...")
    slow_time, slow_result = benchmark_function(fibonacci_slow, fib_n)
    fast_time, fast_result = benchmark_function(fibonacci_fast, fib_n)
    print_benchmark_result("Fibonacci", slow_time, fast_time)
    print(f"   Results match: {slow_result == fast_result}")
    print()
    
    # Benchmark 3: String Building
    print("3. String Building (5000 items)")
    items = range(5000)
    slow_time, slow_result = benchmark_function(build_string_slow, items)
    fast_time, fast_result = benchmark_function(build_string_fast, items)
    print_benchmark_result("String Building", slow_time, fast_time)
    print(f"   Results match: {slow_result == fast_result}")
    print()
    
    # Benchmark 4: List Membership Testing
    print("4. List Membership Testing (10000 items, searching 1000)")
    items = list(range(10000))
    search_values = list(range(0, 10000, 10))
    slow_time, slow_result = benchmark_function(find_in_list_slow, items, search_values)
    fast_time, fast_result = benchmark_function(find_in_list_fast, items, search_values)
    print_benchmark_result("List Membership", slow_time, fast_time)
    print(f"   Results match: {set(slow_result) == set(fast_result)}")
    print()
    
    # Demonstrate scalability with larger Fibonacci
    print("5. Scalability Test: Large Fibonacci")
    print(f"   Computing Fibonacci(100) - Only possible with optimized version!")
    try:
        start = time.time()
        result = fibonacci_fast(100)
        elapsed = time.time() - start
        print(f"   Fibonacci(100) = {result}")
        print(f"   Time taken: {elapsed:.6f}s")
        print(f"   (Slow version would take years to complete!)")
    except Exception as e:
        print(f"   Error: {e}")
    print()
    
    print("=" * 80)
    print("Summary:")
    print("The optimized versions demonstrate significant performance improvements")
    print("by using appropriate algorithms and data structures.")
    print("=" * 80)


if __name__ == "__main__":
    main()
