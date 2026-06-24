import io
import re

with io.open('cmd_build_log.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# remove carriage returns that aren't followed by newline (progress bar overwrites)
text = re.sub(r'\r(?!\n)', '\n', text)
# remove ansi escape sequence
text = re.sub(r'\x1b\[[0-9;]*m', '', text)

with io.open('clean_log.txt', 'w', encoding='utf-8') as f:
    f.write(text)
