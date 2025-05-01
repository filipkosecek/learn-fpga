import re
import sys

replace = ["4005 0000", "4015 0000", "4025 0000", "4035 0000", "4045 0000", "4055 0000", "4065 0000", "4075 0000",
           "5085 0500", "5095 0500",  "50a5 0500", "50b5 0500", "50c5 0500", "50d5 0500", "50e5 0500"]

def replace_instance(data, pos, i):
    for j in range(len(replace[i])):
        data[pos + j] = replace[i][j]

data = sys.stdin.read()
# Find all occurrences using re.finditer
positions = [match.start() for match in re.finditer("1300 0000", data)]
data_list = list(data)
i = 0
for pos in positions:
    replace_instance(data_list, pos, i)
    i += 1

data = "".join(data_list)
print(data)
