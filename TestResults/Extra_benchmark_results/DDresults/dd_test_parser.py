
import re
import sys
import fileinput
import string

pattern_time = re.compile("bytes transferred in ")

output = open('parsed_%s' % sys.argv[1:], 'w+')

# Count
i = 0
check_print_pattern = -1
for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_time, line):
		check_print_pattern = i	
	if i == check_print_pattern:
		data_tmp = line
		pattern_head = 'in'
		pattern_tail = 'secs'
		if pattern_head in data_tmp:
			data = data_tmp.split("in")[1]
			data = data.strip() 
			if pattern_tail in data:
				data = data.split("secs")[0]
				data = data.strip() 
				print '%s' % (data)
				output.write('%s\n' % (data))
	i = i + 1
