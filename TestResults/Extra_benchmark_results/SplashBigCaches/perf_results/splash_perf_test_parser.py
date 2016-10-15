
import re
import sys
import fileinput
import string

#pattern_time = re.compile("Count:")
pattern_miss = re.compile("Miss")
pattern_hit = re.compile("Hit")
pattern_x = re.compile("X")
pattern_y = re.compile("Y")

#print '%s' % (sys.argv[1:])

#output_time = open('time_%s' % sys.argv[1:], 'w+')
#output_miss = open('miss_%s' % sys.argv[1:], 'w+')
#output_hit = open('hit_%s' % sys.argv[1:], 'w+')
#output_x = open('x_%s' % sys.argv[1:], 'w+')
#output_y = open('y_%s' % sys.argv[1:], 'w+')

output = open('parsed_%s' % sys.argv[1:], 'w+')
'''
# Count
i = 0
check_print_pattern = -1
for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_time, line):
		check_print_pattern = i	
	if i == check_print_pattern:
		data_tmp = line
		pattern = ':'
		if pattern in data_tmp:
			data = data_tmp.split(":")[1]
			data = data.strip() 
			print '%s' % (data)
			output.write('%s\n' % (data))
	i = i + 1
'''
# Miss
i = 0
check_print_pattern = -1
for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_miss, line):
		check_print_pattern = i	
	if i == check_print_pattern:
		data_tmp = line
		pattern = ':'
		if pattern in data_tmp:
			data = data_tmp.split(":")[1]
			data = data.strip() 
			print '%s' % (data)
			output.write('%s\n' % (data))
	i = i + 1

# Hit
i = 0
check_print_pattern = -1
for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_hit, line):
		check_print_pattern = i	
	if i == check_print_pattern:
		data_tmp = line
		pattern = ':'
		if pattern in data_tmp:
			data = data_tmp.split(":")[1]
			data = data.strip() 
			print '%s' % (data)
			output.write('%s\n' % (data))
	i = i + 1

# X
i = 0
check_print_pattern = -1
for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_x, line):
		check_print_pattern = i	
	if i == check_print_pattern:
		data_tmp = line
		pattern = ':'
		if pattern in data_tmp:
			data = data_tmp.split(":")[1]
			data = data.strip() 
			print '%s' % (data)
			output.write('%s\n' % (data))
	i = i + 1

# Y
i = 0
check_print_pattern = -1
for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_y, line):
		check_print_pattern = i	
	if i == check_print_pattern:
		data_tmp = line
		pattern = ':'
		if pattern in data_tmp:
			data = data_tmp.split(":")[1]
			data = data.strip() 
			print '%s' % (data)
			output.write('%s\n' % (data))
	i = i + 1
