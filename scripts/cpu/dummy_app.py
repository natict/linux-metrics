#!/usr/bin/python3

import time
import math


def percentile(N, percent):
    if not N:
        return None
    N = sorted(N)
    k = (len(N) - 1) * percent
    f = math.floor(k)
    c = math.ceil(k)
    if f == c:
        return N[int(k)]
    d0 = N[int(f)] * (c - k)
    d1 = N[int(c)] * (k - f)
    return d0 + d1


def foo():
    for i in range(20000):
        x = math.sqrt(i)


if __name__ == "__main__":
    m = []

    for _ in range(1000):
        start = time.time()
        foo()
        m.append(time.time() - start)

    print(
        "50th, 90th and 99th percentile: %f, %f, %f"
        % (percentile(m, 0.5), percentile(m, 0.9), percentile(m, 0.99))
    )
