from include import *


def allotTicket(l, n):
    H = heap()
    for x in l:
        Id = x[0]
        priority = x[1]
        fakePriority = x[2]
        p = Person(Id, priority, fakePriority)
        H.insert(p)
        H.printHeap()
    s = ""
    while not H.isEmpty():
        x = H.deleteRoot()
        s = s + x.Id + " "
    print(s)


n = int(input())
m = n
details = []
for i in range(n):
    name, priority = input().split()
    priority = int(priority)
    fakePriority = priority * 10000 + m
    m = m - 1
    details.append([name, priority, fakePriority])
allotTicket(details, n)