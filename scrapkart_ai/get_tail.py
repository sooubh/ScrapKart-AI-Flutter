import io

with io.open('clean_log.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Clean up backspaces and other control chars too just in case
import re
def clean_line(s):
    # remove all control chars except newline and tab
    return re.sub(r'[\x00-\x08\x0b-\x0c\x0e-\x1f]', '', s)

clean_lines = [clean_line(l) for l in lines[-200:] if clean_line(l).strip() != '']

with io.open('tail_log.txt', 'w', encoding='utf-8') as f:
    f.writelines(clean_lines)
