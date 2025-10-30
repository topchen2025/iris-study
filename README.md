# IRIS Study Repository

This repository contains documentation and code examples for studying InterSystems IRIS and software performance optimization.

## Contents

### Documentation
- **GCOS.pdf**: Global Caché Object Server documentation
- **RCOS.pdf**: Relational Caché Object Server documentation
- **InterSystems 常用术语.pdf**: Common terminology for InterSystems (Chinese)

### Performance Optimization Resources

#### Performance Optimization Guide
See [PERFORMANCE_OPTIMIZATION_GUIDE.md](PERFORMANCE_OPTIMIZATION_GUIDE.md) for comprehensive information on:
- Common performance issues and their solutions
- Algorithm complexity considerations
- Database query optimization
- Caching strategies
- String operations best practices
- Appropriate data structure selection
- Performance testing tools

#### Code Examples
The [examples/](examples/) directory contains practical demonstrations:
- **inefficient_example.py**: Intentionally slow code showing common anti-patterns
- **improved_example.py**: Optimized versions with best practices
- **benchmark.py**: Performance comparison script showing actual improvements

## Running the Examples

To see the performance improvements in action:

```bash
# Run benchmark comparison
python examples/benchmark.py

# Run individual examples
python examples/inefficient_example.py
python examples/improved_example.py
```

## Key Learnings

The examples demonstrate typical performance improvements:
- **Find Duplicates**: ~500x faster (O(n²) → O(n))
- **Fibonacci Calculation**: ~900x faster (with memoization)
- **List Membership Testing**: ~70x faster (list → set)
- **Scalability**: Fibonacci(100) computed instantly vs impossible with naive approach

## Performance Best Practices

1. ✅ Profile before optimizing
2. ✅ Use appropriate data structures
3. ✅ Minimize algorithm complexity
4. ✅ Cache expensive computations
5. ✅ Batch database operations
6. ✅ Process large files incrementally
7. ✅ Compile regex patterns once
8. ✅ Use generators for large datasets

## Contributing

This is a study repository. Feel free to add more examples or improve existing documentation.

## Resources

- [InterSystems Documentation](https://docs.intersystems.com/)
- [Python Performance Tips](https://wiki.python.org/moin/PythonSpeed/PerformanceTips)
- [Algorithm Complexity Reference](https://www.bigocheatsheet.com/)
