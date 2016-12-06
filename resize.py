import struct

with open("train-images-idx3-ubyte", "rb") as fin, open("train-resize", "wb") as fout:
    magic = fin.read(4)
    n = struct.unpack(">i", fin.read(4))[0]
    r = struct.unpack(">i", fin.read(4))[0]
    c = struct.unpack(">i", fin.read(4))[0]

    # print struct.unpack(">i", struct.pack(">i", r>>1))[0]
    fout.write(magic)
    fout.write(struct.pack(">i", n))
    fout.write(struct.pack(">i", r>>1))
    fout.write(struct.pack(">i", c>>1))
    # fout.write(str(int(c)>>1))

    # n = 0
    # i = 0
    # n0 = 0

    byte = fin.read(1)
    while byte != "":
        for i in range(n):
            print i
            # jj = 0
            for j in range(r):
                # kk = 0
                for k in range(c):
                    if j%2 == 1 and k%2 == 1:
                        fout.write(byte)
                    # kk = 1 - kk
                # jj = 1 - jj
                    byte = fin.read(1)

    # byte = fin.read(1)
    # while byte != "":
    #     if i == 1:
    #         fout.write(byte)
    #         n += 1
    #     byte = fin.read(1)
    #     i = 1 - i
    #     n0 += 1
    # print n, n0