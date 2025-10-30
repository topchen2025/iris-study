"""
Inefficient Code Examples
This file contains intentionally inefficient code to demonstrate common performance issues.
See improved_example.py for optimized versions.
"""

import time
import re


def find_duplicates_slow(items):
    """
    Issue: O(n²) time complexity with nested loops
    Performance: Very slow for large lists
    """
    duplicates = []
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            if items[i] == items[j] and items[i] not in duplicates:
                duplicates.append(items[i])
    return duplicates


def fibonacci_slow(n):
    """
    Issue: Exponential time complexity O(2^n) due to repeated calculations
    Performance: Unusable for n > 35
    """
    if n <= 1:
        return n
    return fibonacci_slow(n - 1) + fibonacci_slow(n - 2)


def build_string_slow(items):
    """
    Issue: String concatenation in loop creates many intermediate objects
    Performance: O(n²) due to string immutability
    """
    result = ""
    for item in items:
        result += str(item) + ","
    return result[:-1] if result else ""


def find_in_list_slow(items, search_values):
    """
    Issue: Using list for membership testing (O(n) per lookup)
    Performance: Inefficient for large datasets
    """
    found = []
    for value in search_values:
        if value in items:
            found.append(value)
    return found


def process_file_slow(filename):
    """
    Issue: Loading entire file into memory at once
    Performance: Can cause memory issues with large files
    """
    with open(filename, 'r') as f:
        content = f.read()
        lines = content.split('\n')
        return [line.strip().upper() for line in lines if line.strip()]


def extract_emails_slow(texts):
    """
    Issue: Compiling regex pattern on every iteration
    Performance: Unnecessary overhead from repeated compilation
    """
    emails = []
    for text in texts:
        matches = re.findall(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', text)
        emails.extend(matches)
    return emails


def calculate_statistics_slow(numbers):
    """
    Issue: Multiple passes through data for different calculations
    Performance: O(n) per calculation instead of single pass
    """
    total = sum(numbers)
    count = len(numbers)
    mean = total / count if count > 0 else 0
    
    # Separate pass for variance
    variance = sum((x - mean) ** 2 for x in numbers) / count if count > 0 else 0
    
    # Separate sorting for median
    sorted_numbers = sorted(numbers)
    median = sorted_numbers[count // 2] if count > 0 else 0
    
    return {
        'mean': mean,
        'median': median,
        'variance': variance,
        'count': count
    }


def get_user_data_slow(user_ids, db_connection):
    """
    Issue: N+1 query problem - making separate query for each user
    Performance: High database load, slow response time
    """
    results = []
    for user_id in user_ids:
        # Simulated database query (would be actual DB call in real code)
        user = f"User-{user_id}"
        results.append(user)
    return results


def check_all_conditions_slow(value):
    """
    Issue: Not using short-circuit evaluation effectively
    Performance: Evaluates all conditions even when early ones fail
    """
    expensive_check_1 = time.sleep(0.001) or True  # Simulated expensive operation
    expensive_check_2 = time.sleep(0.001) or True  # Simulated expensive operation
    expensive_check_3 = time.sleep(0.001) or True  # Simulated expensive operation
    
    if expensive_check_1 and expensive_check_2 and expensive_check_3:
        return value > 0 and value < 100
    return False


def load_configuration_slow():
    """
    Issue: Loading configuration on every call
    Performance: Redundant I/O operations
    """
    config = {
        'database_url': 'localhost:5432',
        'timeout': 30,
        'max_connections': 10
    }
    return config


if __name__ == "__main__":
    # Demonstrate slow performance
    print("Running inefficient examples...")
    
    # Example 1: Find duplicates
    test_data = list(range(1000)) + list(range(500))
    start = time.time()
    duplicates = find_duplicates_slow(test_data)
    print(f"Find duplicates (slow): {time.time() - start:.4f}s")
    
    # Example 2: Fibonacci (don't test with large numbers!)
    start = time.time()
    result = fibonacci_slow(20)
    print(f"Fibonacci 20 (slow): {time.time() - start:.4f}s")
    
    # Example 3: String building
    start = time.time()
    result = build_string_slow(range(1000))
    print(f"Build string (slow): {time.time() - start:.4f}s")
    
    print("\nSee improved_example.py for optimized versions!")
