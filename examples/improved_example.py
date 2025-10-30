"""
Improved Code Examples
This file contains optimized versions of the inefficient code from inefficient_example.py
Each function demonstrates performance best practices.
"""

import time
import re
from functools import lru_cache


def find_duplicates_fast(items):
    """
    Improvement: O(n) time complexity using sets
    Performance: Dramatically faster for large lists
    """
    seen = set()
    duplicates = set()
    for item in items:
        if item in seen:
            duplicates.add(item)
        else:
            seen.add(item)
    return list(duplicates)


@lru_cache(maxsize=None)
def fibonacci_fast(n):
    """
    Improvement: O(n) time complexity with memoization
    Performance: Can handle much larger values of n
    """
    if n <= 1:
        return n
    return fibonacci_fast(n - 1) + fibonacci_fast(n - 2)


def build_string_fast(items):
    """
    Improvement: Using join() for O(n) complexity
    Performance: Much faster as no intermediate strings created
    """
    return ",".join(str(item) for item in items)


def find_in_list_fast(items, search_values):
    """
    Improvement: Converting to set for O(1) lookup time
    Performance: Efficient even for large datasets
    """
    items_set = set(items)
    return [value for value in search_values if value in items_set]


def process_file_fast(filename):
    """
    Improvement: Processing file line-by-line
    Performance: Memory efficient for files of any size
    """
    result = []
    with open(filename, 'r') as f:
        for line in f:
            stripped = line.strip()
            if stripped:
                result.append(stripped.upper())
    return result


# Compile regex pattern once at module level
EMAIL_PATTERN = re.compile(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')


def extract_emails_fast(texts):
    """
    Improvement: Compile regex pattern once
    Performance: Avoids repeated compilation overhead
    """
    emails = []
    for text in texts:
        matches = EMAIL_PATTERN.findall(text)
        emails.extend(matches)
    return emails


def calculate_statistics_fast(numbers):
    """
    Improvement: Single pass through data where possible
    Performance: Reduces iterations and improves cache efficiency
    """
    if not numbers:
        return {'mean': 0, 'median': 0, 'variance': 0, 'count': 0}
    
    # Single pass for mean
    total = 0
    count = 0
    for x in numbers:
        total += x
        count += 1
    
    mean = total / count
    
    # Single pass for variance
    variance_sum = 0
    for x in numbers:
        variance_sum += (x - mean) ** 2
    variance = variance_sum / count
    
    # For median, we still need to sort, but we can optimize
    sorted_numbers = sorted(numbers)
    mid = count // 2
    if count % 2 == 0:
        median = (sorted_numbers[mid - 1] + sorted_numbers[mid]) / 2
    else:
        median = sorted_numbers[mid]
    
    return {
        'mean': mean,
        'median': median,
        'variance': variance,
        'count': count
    }


def get_user_data_fast(user_ids, db_connection):
    """
    Improvement: Batch query instead of N+1 queries
    Performance: Single database round-trip instead of multiple
    """
    # Simulated batch query (would be actual DB call in real code)
    # In real SQL: SELECT * FROM users WHERE id IN (user_ids)
    results = [f"User-{user_id}" for user_id in user_ids]
    return results


def check_all_conditions_fast(value):
    """
    Improvement: Order conditions by cost and use short-circuit evaluation
    Performance: Exits early if cheap conditions fail
    """
    # Check cheap conditions first
    if not (value > 0 and value < 100):
        return False
    
    # Only run expensive checks if cheap ones pass
    expensive_check_1 = time.sleep(0.001) or True
    if not expensive_check_1:
        return False
    
    expensive_check_2 = time.sleep(0.001) or True
    if not expensive_check_2:
        return False
    
    expensive_check_3 = time.sleep(0.001) or True
    return expensive_check_3


# Cache configuration at module level
_CONFIG_CACHE = None


def load_configuration_fast():
    """
    Improvement: Cache configuration instead of reloading
    Performance: Avoids redundant operations
    """
    global _CONFIG_CACHE
    if _CONFIG_CACHE is None:
        _CONFIG_CACHE = {
            'database_url': 'localhost:5432',
            'timeout': 30,
            'max_connections': 10
        }
    return _CONFIG_CACHE


def batch_process_items(items, batch_size=100):
    """
    Best Practice: Process large datasets in batches
    Performance: Reduces memory usage and allows progress tracking
    """
    for i in range(0, len(items), batch_size):
        batch = items[i:i + batch_size]
        # Process batch
        yield [item * 2 for item in batch]


def lazy_evaluation_example(n):
    """
    Best Practice: Use generators for lazy evaluation
    Performance: Memory efficient, only computes values as needed
    """
    for i in range(n):
        if i % 2 == 0:
            yield i * i


if __name__ == "__main__":
    # Demonstrate improved performance
    print("Running optimized examples...")
    
    # Example 1: Find duplicates
    test_data = list(range(1000)) + list(range(500))
    start = time.time()
    duplicates = find_duplicates_fast(test_data)
    print(f"Find duplicates (fast): {time.time() - start:.4f}s")
    
    # Example 2: Fibonacci
    start = time.time()
    result = fibonacci_fast(20)
    print(f"Fibonacci 20 (fast): {time.time() - start:.4f}s")
    
    # Example 3: String building
    start = time.time()
    result = build_string_fast(range(1000))
    print(f"Build string (fast): {time.time() - start:.4f}s")
    
    # Example 4: Demonstrate even larger Fibonacci is now feasible
    start = time.time()
    result = fibonacci_fast(100)
    print(f"Fibonacci 100 (fast): {time.time() - start:.4f}s - Result: {result}")
    
    print("\nCompare these times with inefficient_example.py!")
