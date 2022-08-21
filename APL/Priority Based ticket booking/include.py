class Person:
    def __init__(self, x, y, z):
        self.Id = x
        self.priority = y
        self.fakePriority = z


class heap:
    heap_size = -1
    persons = []

    def __init__(self):
        pass

    def isEmpty(self):
        if self.heap_size == -1:
            return True
        else:
            return False

    def insert(self, p):
        self.persons.append(p)
        self.heap_size = self.heap_size + 1
        i = self.heap_size
        parent = int((i - 1) / 2)
        while i > 0 and (self.persons[i].fakePriority > self.persons[parent].fakePriority):
            temp = self.persons[parent]
            self.persons[parent] = self.persons[i]
            self.persons[i] = temp
            i = parent
            parent = int((i - 1) / 2)

    def printHeap(self):
        s = ""
        for x in self.persons:
            s = s + str(x.priority) + " "
        print(s)

    def deleteRoot(self):
        res = self.persons[0]
        # Swap max with last
        self.persons[0] = self.persons[self.heap_size]
        self.persons[self.heap_size] = res
        self.heap_size = self.heap_size - 1
        # heapify the root
        i = 0
        maxPosition = i
        while True:
            leftChild = 2 * i + 1
            rightChild = 2 * i + 2
            if leftChild <= self.heap_size and self.persons[leftChild].fakePriority > self.persons[i].fakePriority:
                maxPosition = leftChild
            if maxPosition != leftChild:
                maxPosition = i
            if rightChild <= self.heap_size and self.persons[rightChild].fakePriority > self.persons[
                maxPosition].fakePriority:
                maxPosition = rightChild
            # If max position is not equal to i then swap and make i equal to maxPosition
            if maxPosition == i:
                break
            else:
                temp = self.persons[i]
                self.persons[i] = self.persons[maxPosition]
                self.persons[maxPosition] = temp
                i = maxPosition

        return res
