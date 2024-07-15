class CpuCacheMem:
    def __init__(self, mode):
        self.MEM_SIZE = 512 * 1024
        self.ADDR_LEN = 19
        self.CACHE_WAY = 4
        self.CACHE_TAG_LEN = 10
        self.CACHE_IDX_LEN = 4
        self.CACHE_OFFSET_LEN = 5
        self.CACHE_SIZE = 32 * 64
        self.CACHE_LINE_SIZE = 32
        self.CACHE_LINE_COUNT = 64
        self.CACHE_SETS_COUNT = 16
        self.requests = 0
        self.misses = 0
        self.cache_tags = [[-1] * self.CACHE_WAY for i in range(self.CACHE_SETS_COUNT)]
        self.cache_times = [[0] * self.CACHE_WAY for i in range(self.CACHE_SETS_COUNT)]
        self.modified_tags = [[0] * self.CACHE_WAY for i in range(self.CACHE_SETS_COUNT)]
        self.mode = mode
        self.tact = 0
        self.CACHE_HIT = 6
        self.CACHE_MISS = 4
        self.MEM_RESPONSE = 100
        self.ADDRESS_OR_COMMAND = 1
        self.SPEED = 16

    def upgrade_time(self, index, pos):
        if self.mode == "LRU":
            for k in range(self.CACHE_WAY):
                self.cache_times[index][k] += 1
            self.cache_times[index][pos] = 0
        elif self.mode == "pLRU":
            self.cache_times[index][pos] = 1
            if all(self.cache_times[index]):
                self.cache_times[index] = [0] * self.CACHE_WAY
                self.cache_times[index][pos] = 1
        else:
            print("Wrong mode")

    def request(self, address, size, command):
        DTact = max(1, size // self.SPEED)
        CacheTact = max(1, self.CACHE_LINE_SIZE * 8 // self.SPEED)
        tag = address >> (self.CACHE_OFFSET_LEN + self.CACHE_IDX_LEN)
        index = (address >> self.CACHE_OFFSET_LEN) % self.CACHE_SETS_COUNT
        self.requests += 1

        if tag in self.cache_tags[index]:
            self.tact += self.ADDRESS_OR_COMMAND
            self.tact += self.CACHE_HIT + DTact

            pos = self.cache_tags[index].index(tag)
            self.upgrade_time(index, pos)
            if command == "W":
                self.modified_tags[index][pos] = 1
        else:
            self.misses += 1
            if command == "R":
                self.tact += self.ADDRESS_OR_COMMAND
                self.tact += self.CACHE_MISS
                self.tact += self.ADDRESS_OR_COMMAND
                self.tact += self.MEM_RESPONSE
                self.tact += CacheTact
                self.tact += DTact

            if command == "W":
                self.tact += DTact
                self.tact += self.CACHE_MISS
                self.tact += self.ADDRESS_OR_COMMAND
                self.tact += self.MEM_RESPONSE
                self.tact += CacheTact
                self.tact += self.ADDRESS_OR_COMMAND

            pos = 0
            if self.mode == "LRU":
                max_time = max(self.cache_times[index])
                pos = self.cache_times[index].index(max_time)
            elif self.mode == "pLRU":
                pos = self.cache_times[index].index(0)

            if self.modified_tags[index][pos] == 1:
                self.tact += CacheTact + self.MEM_RESPONSE + self.ADDRESS_OR_COMMAND

            self.cache_tags[index][pos] = tag
            self.modified_tags[index][pos] = 0 if command == "R" else 1
            self.upgrade_time(index, pos)


def simulation(mode):
    M = 64
    N = 60
    K = 32
    Cache = CpuCacheMem(mode)
    MULT = 5
    SUMM = 1
    ITER = 1
    FUNC = 1
    INIT = 1

    a = [[0] * K for i in range(M)]
    b = [[0] * N for i in range(K)]
    c = [[0] * N for i in range(M)]

    address = 2 ** 15

    for i in range(M):
        for j in range(K):
            a[i][j] = address
            address += 1
    for i in range(K):
        for j in range(N):
            b[i][j] = address
            address += 2
    for i in range(M):
        for j in range(N):
            c[i][j] = address
            address += 4

    Cache.tact += 2 * INIT  # два указателя

    Cache.tact += INIT  # иниц y
    for i in range(M):
        Cache.tact += ITER
        Cache.tact += SUMM
        Cache.tact += INIT  # иниц x
        for j in range(N):
            Cache.tact += ITER
            Cache.tact += SUMM
            Cache.tact += 2 * INIT  # иниц *pb и s
            Cache.tact += INIT  # иниц k
            for k in range(K):
                Cache.tact += ITER
                Cache.tact += SUMM
                Cache.tact += 2 * SUMM + MULT  # s += pa[k] * pb[x]
                Cache.request(a[i][k], 8, "R")
                Cache.request(b[k][j], 16, "R")
            Cache.request(c[i][j], 32, "W")
        Cache.tact += 2 * SUMM  # увеличиваем указатели
    Cache.tact += FUNC
    perc = (Cache.requests - Cache.misses) * 100 / Cache.requests
    print("{0}:\thit perc. {1:3.4f}%\ttime: {2}".format(mode, perc, Cache.tact))


if __name__ == "__main__":
    simulation("LRU")
    simulation("pLRU")
