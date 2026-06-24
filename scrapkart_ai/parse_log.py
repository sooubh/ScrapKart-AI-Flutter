import os
import io

for enc in ['utf-8', 'utf-16', 'cp1252', 'latin-1']:
    try:
        with io.open("cmd_build_log.txt", "r", encoding=enc) as f:
            lines = f.readlines()
            print(f"Read with {enc}. Lines: {len(lines)}")
            for i, line in enumerate(lines):
                if 'build failed' in line.lower() or 'exception' in line.lower() or 'failed with' in line.lower():
                    start = max(0, i - 15)
                    end = min(len(lines), i + 5)
                    print(f"--- MATCH AT LINE {i} ---")
                    for j in range(start, end):
                        print(lines[j].strip())
            break
    except Exception as e:
        print(f"Failed with {enc}: {e}")
