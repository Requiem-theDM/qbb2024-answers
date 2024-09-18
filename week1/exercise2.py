#!/usr/bin/env python3

reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']
graph = {}
k=3

for read in reads:
    for i in range(len(read) - k):
        kmer1 = read[i: i+k]
        kmer2 = read[i+1: i+1+k]
        graph.setdefault((kmer1,kmer2),0)
        graph[(kmer1,kmer2)] += 1

print("digraph{")
for left, right in graph:
        print(f"{left} -> {right}")
print("}")
