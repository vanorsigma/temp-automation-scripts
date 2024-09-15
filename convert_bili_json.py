# helper script to turn the bili output txt to json

import json

with open("output.txt", "r") as f:
    results = [json.loads(obj) for obj in f.read().split('\n')[:-1]]

with open("output_fixed_fixed.json", "w") as f:
    json.dump(results, f)
