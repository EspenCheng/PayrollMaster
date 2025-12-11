import re

# 读取文件
with open('specs/tasks.md', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# 修复每一行
fixed_lines = []
for line in lines:
    # 匹配任务编号模式 T015 到 T096
    if re.match(r'- \[ \] T09[5-6]', line):
        # T096 -> T097
        line = re.sub(r'T096', 'T097', line)
    elif re.match(r'- \[ \] T0[2-9][0-9]', line):
        # T027-T095 -> T028-T096
        match = re.search(r'T0(\d{2})', line)
        if match:
            num = int(match.group(1))
            if 15 <= num <= 96:
                line = re.sub(r'T0' + str(num), 'T0' + str(num + 1), line)
    elif re.match(r'- \[ \] T1[0-4][0-9]', line):
        # T100-T149 -> T101-T150
        match = re.search(r'T1(\d{2})', line)
        if match:
            num = int(match.group(1))
            if 0 <= num <= 49:
                line = re.sub(r'T1' + str(num).zfill(2), 'T1' + str(num + 1).zfill(2), line)
    
    fixed_lines.append(line)

# 写入文件
with open('specs/tasks.md', 'w', encoding='utf-8') as f:
    f.writelines(fixed_lines)

print("修复完成")
