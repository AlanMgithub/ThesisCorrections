# Parser for Splash-2

import re
import sys
import fileinput
import string

pattern_lu = re.compile("Blocked Dense LU Factorization")
pattern_water = re.compile("NEW RUN STARTING FROM REGULAR LATTICE")
pattern_radix = re.compile("Integer Radix Sort")
pattern_fft = re.compile("FFT with Blocking Transpose")
pattern_fmm = re.compile("Creating a two cluster")
pattern_ocean = re.compile("Ocean simulation with W-cycle multigrid solver")

# Constant
TEST_DEPTH = 13
MAX_RES = 12
# Global
TEST_DATA = range(2*TEST_DEPTH*MAX_RES)

############ PARSE LU TESTS #####################################################################################
lu_stats_line = -1
lu_timing_line_0 = -1
lu_timing_line_1 = -1
print_pattern = '512 by 512 Matrix' 
check_print_pattern = -1
print_option = -1
i = 0

print '%s' % (sys.argv[1:])
output_file = open('parsed_file_%s' % sys.argv[1:], 'w+')
#output_file.write('%s\n\n' % (sys.argv[1:]))

# Vars
y = 0

'''
print 'LU Header : total time : diagonal time : perimeter time : interior time : barrier time : total + init : total - init'
output_file.write('LU Header : total time : diagonal time : perimeter time : interior time : barrier time : total + init : total - init \n')
'''

for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_lu, line):
		check_print_pattern = i + 1	
		lu_stats_line = i + 9
		lu_timing_line_0 = lu_stats_line + 6
		lu_timing_line_1 = lu_timing_line_0 + 1
	if i == check_print_pattern:
		n_pattern = line.strip()
		if print_pattern == n_pattern:
			print_option = 0
		else: 
			print_option = 1
	if i == lu_stats_line:
		proc, total, diagonal, perimeter, interior, barrier = line.split()
	if i == lu_timing_line_0:
		time_w_init = line
		pattern = ':'
		if pattern in time_w_init:
			time_w_init_data = time_w_init.split(":")[1]
			time_w_init_data = time_w_init_data.strip() 
		else:
			time_w_init_data = '?'
	if i == lu_timing_line_1:
		time_no_init = line
		pattern = ':'
                if pattern in time_no_init:
                        time_no_init_data = time_no_init.split(":")[1]
                        time_no_init_data = time_no_init_data.strip()
                else:
                        time_no_init_data = '?'
		#if print_option == 0:
		#	print 'LU Contiguous Results (%s): %s : %s : %s : %s : %s : %s : %s' % (i+1, total, diagonal, perimeter, interior, barrier, time_w_init_data, time_no_init_data)
		#	output_file.write('LU Contiguous Results (%s): %s : %s : %s : %s : %s : %s : %s \n' % (i+1, total, diagonal, perimeter, interior, barrier, time_w_init_data, time_no_init_data))
		#else:
		#	print 'LU Non Contiguous Results (%s): %s : %s : %s : %s : %s : %s : %s' % (i+1, total, diagonal, perimeter, interior, barrier, time_w_init_data, time_no_init_data)
		#	output_file.write('LU Non Contiguous Results (%s): %s : %s : %s : %s : %s : %s : %s \n' % (i+1, total, diagonal, perimeter, interior, barrier, time_w_init_data, time_no_init_data))

		w = 2*TEST_DEPTH
		TEST_DATA[y] = total
		#TEST_DATA[y+w] = diagonal
		#TEST_DATA[y+2*w] = perimeter
		#TEST_DATA[y+3*w] = interior
		#TEST_DATA[y+4*w] = barrier
		#TEST_DATA[y+5*w] = time_w_init_data
		#TEST_DATA[y+6*w] = time_no_init_data
		y = y + 1
	i = i + 1

sys.stdout.write('\n')
#output_file.write('\n')
sys.stdout.write('%s\n' % (sys.argv[1:]))
#output_file.write('%s\n' % (sys.argv[1:]))
sys.stdout.write('LU Splash-2 Test (Contiguous & Non Contiguous)\n')
#output_file.write('LU Splash-2 Test (Contiguous & Non Contiguous)\n')
z = 0
x = 0
p = 0
t = 0
#while z < 7:
while z < 1:
	while x < y:
		sys.stdout.write('%s :' % (TEST_DATA[p]))
		output_file.write('%s\n' % (TEST_DATA[p]))

		p = p + 1
		x = x + 1
	sys.stdout.write('\n')
	#output_file.write('\n')
	x = 0
	z = z + 1
	p = z*2*TEST_DEPTH

sys.stdout.write('\n')
x = 0
while x<10:
	#output_file.write('\n')
	x = x+1
############ PARSE WATER TESTS ##################################################################################
y = 0
water_stats_line = -1
print_0 = 0
print_1 = 0
printAvg = 0
tmpCount = 0

'''
print 'Water Header : total + init : measured time : intramolecular time : intermolecular time : other time'
output_file.write('Water Header : total + init : measured time : intramolecular time : intermolecular time : other time \n')
'''

for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_water, line):
		water_stats_line = i + 5
	if i >= water_stats_line and i < (water_stats_line + 5):
		stat = line
		pattern = '='
                if pattern in stat:
                        stat_data = stat.split("=")[1]
                        stat_data = stat_data.strip()
                else:
                        stat_data = '?'
		if i == water_stats_line:
			time_w_init = stat_data
		elif i == water_stats_line + 1:
			measured_time = stat_data
		elif i == water_stats_line + 2:
			intramolecular_time = stat_data
		elif i == water_stats_line + 3:
			intermolecular_time = stat_data
		elif i == water_stats_line + 4:
			other_time = stat_data
			#if (tmpCount > 9 and print_0 == 0):
			#	if (printAvg > other_time):
			#		print_0 = 1
			#	if (printAvg == 0):
			#		printAvg = other_time 
			#	else:
			#		printAvg = int(printAvg + other_time)/2
			#tmpCount = tmpCount + 1		
			#if print_0 == 0:
			#	print 'Water NSquared (%s): %s : %s : %s : %s : %s' % (i+1, time_w_init, measured_time, intramolecular_time, intermolecular_time, other_time)
			#	output_file.write('Water Stats (%s): %s : %s : %s : %s : %s \n' % (i+1, time_w_init, measured_time, intramolecular_time, intermolecular_time, other_time))
			#if print_0 != 0:
			#	print 'Water Spacial (%s): %s : %s : %s : %s : %s' % (i+1, time_w_init, measured_time, intramolecular_time, intermolecular_time, other_time)
			#	output_file.write('Water Stats (%s): %s : %s : %s : %s : %s \n' % (i+1, time_w_init, measured_time, intramolecular_time, intermolecular_time, other_time))

			w = 2*TEST_DEPTH
			TEST_DATA[y] = time_w_init 
			TEST_DATA[y+w] = measured_time
			TEST_DATA[y+2*w] = intramolecular_time
			TEST_DATA[y+3*w] = intermolecular_time
			TEST_DATA[y+4*w] = other_time
			y = y + 1
	i = i + 1

sys.stdout.write('\n')
#output_file.write('\n')
sys.stdout.write('%s\n' % (sys.argv[1:]))
#output_file.write('%s\n' % (sys.argv[1:]))
sys.stdout.write('Water Splash-2 Test (NSquare & Spacial)\n')
#output_file.write('Water Splash-2 Test (NSquare & Spacial)\n')
z = 0
x = 0
p = 0
while z < 5:
	while x < y:
		sys.stdout.write('%s :' % (TEST_DATA[p]))
		output_file.write('%s\n' % (TEST_DATA[p]))
		p = p + 1
		x = x + 1
	sys.stdout.write('\n')
	#output_file.write('\n')
	x = 0
	z = z + 1
	p = z*2*TEST_DEPTH

sys.stdout.write('\n')
x = 0
while x<10:
	#output_file.write('\n')
	x = x+1
#print '\n'
#output_file.write('\n')

############ PARSE RADIX TESTS ##################################################################################
y = 0
radix_stats_line = -1
radix_data_line = -1

'''
print 'Radix Header : total - init : total time : intramolecular time : intermolecular time : other time'
output_file.write('Radix Header : total - init : total time : intramolecular time : intermolecular time : other time \n')
'''

for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_radix, line):
		radix_stats_line = i + 10
		radix_data_line = i + 16
	if i == radix_stats_line:
		proc, total, rank, sort = line.split()
	if i == radix_data_line:
		stat = line
		pattern = ':'
                if pattern in stat:
                        stat_data = stat.split(":")[1]
                        stat_data = stat_data.strip()
                else:
                        stat_data = '?'
		time_no_init = stat_data
		#print 'Radix Results (%s): %s : %s : %s : %s' % (i+1, time_no_init, total, rank, sort)
		#output_file.write('Radix Results (%s): %s : %s : %s : %s \n' % (i+1, time_no_init, total, rank, sort))

		w = 2*TEST_DEPTH
		TEST_DATA[y] = total
		#TEST_DATA[y] = time_no_init
		#TEST_DATA[y+w] = total
		#TEST_DATA[y+2*w] = rank
		#TEST_DATA[y+3*w] = sort
		y = y + 1
	i = i + 1

sys.stdout.write('\n')
#output_file.write('\n')
sys.stdout.write('%s\n' % (sys.argv[1:]))
#output_file.write('%s\n' % (sys.argv[1:]))
sys.stdout.write('Radix Splash-2 Test\n')
#output_file.write('Radix Splash-2 Test\n')
z = 0
x = 0
p = 0
t = 0
#while z < 4:
while z < 1:
	while x < y:
		sys.stdout.write('%s :' % (TEST_DATA[p]))
		output_file.write('%s\n' % (TEST_DATA[p]))
		p = p + 1
		x = x + 1
	sys.stdout.write('\n')
	#output_file.write('\n')
	x = 0
	z = z + 1
	p = z*2*TEST_DEPTH

sys.stdout.write('\n')
x = 0
while x<10:
	#output_file.write('\n')
	x = x+1
#print '\n'
#output_file.write('\n')

############ PARSE FFT TESTS ####################################################################################

y = 0
fft_stats_line = -1
fft_data_line = -1
print_pattern = '1024 Complex Doubles' 
check_print_pattern = -1
print_option = -1
i = 0

'''
print 'FFT Header : total + init : computation time : transpose time : transpose fraction'
output_file.write('FFT Header : total + init : computation time : transpose time : transpose fraction \n')
'''

for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_fft, line):
		fft_stats_line = i + 11
		fft_data_line = i + 17
		check_print_pattern = i + 1	
	if i == check_print_pattern:
		n_pattern = line.strip()
		if print_pattern == n_pattern:
			print_option = 0
		else: 
			print_option = 1
	if i == fft_stats_line:
		proc, computation, transpose, fraction = line.split()
	if i == fft_data_line:
		time_init = line
		pattern = ':'
                if pattern in time_init:
                        time_init_data = time_init.split(":")[1]
                        time_init_data = time_init_data.strip()
                else:
                        time_init_data = '?'
		#if print_option == 0:
		#	print 'FFT Easy Results (%s): %s : %s : %s : %s' % (i+1, time_init_data, computation, transpose, fraction)
		#	output_file.write('FFT Easy Results (%s): %s : %s : %s : %s \n' % (i+1, time_init_data, computation, transpose, fraction))
		#else:
		#	print 'FFT Hard Results (%s): %s : %s : %s : %s' % (i+1, time_init_data, computation, transpose, fraction)
		#	output_file.write('FFT Hard Results (%s): %s : %s : %s : %s \n' % (i+1, time_init_data, computation, transpose, fraction))

		w = 2*TEST_DEPTH
		TEST_DATA[y] = computation
		#TEST_DATA[y] = time_init_data
		#TEST_DATA[y+w] = computation
		#TEST_DATA[y+2*w] = transpose
		#TEST_DATA[y+3*w] = fraction
		y = y + 1
	i = i + 1

sys.stdout.write('\n')
#output_file.write('\n')
sys.stdout.write('%s\n' % (sys.argv[1:]))
#output_file.write('%s\n' % (sys.argv[1:]))
sys.stdout.write('FFT Splash-2 Test (Easy & Hard)\n')
#output_file.write('FFT Splash-2 Test (Easy & Hard)\n')
z = 0
x = 0
p = 0
t = 0
#while z < 4:
while z < 1:
	while x < y:
		sys.stdout.write('%s :' % (TEST_DATA[p]))
		output_file.write('%s\n' % (TEST_DATA[p]))
		p = p + 1
		x = x + 1
	sys.stdout.write('\n')
	#output_file.write('\n')
	x = 0
	z = z + 1
	p = z*2*TEST_DEPTH

sys.stdout.write('\n')
x = 0
while x<10:
	#output_file.write('\n')
	x = x+1
#print '\n'
#output_file.write('\n')

############ PARSE FMM TESTS ####################################################################################
y = 0
fmm_stats_line = -1
fmm_timing_line_0 = -1
fmm_timing_line_1 = -1
print_pattern = ' non uniform distribution for 256 particles' 
print_option = 0
i = 0

'''
print 'FMM Header : total + init : total - init : track time : tree time : list time : part time : pass time : inter time : bar time : intra time : other time'
output_file.write('FMM Header : total + init : total - init : track time : tree time : list time : part time : pass time : inter time : bar time : intra time : other time \n')
'''

for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_fmm, line):
		fmm_stats_line = i + 4 + 2
		fmm_timing_line_0 = i + 10 + 2
		fmm_timing_line_1 = i + 11 + 2
		n_pattern = line.strip()
		mod_pattern = n_pattern.split(",")[1]
		if print_pattern == mod_pattern:
			print_option = 0
		else: 
			print_option = 1
	if i == fmm_stats_line:
		proc, track, tree, list_t, part, pass_t, inter, bar, intra, other = line.split()
	if i == fmm_timing_line_0:
		time_w_init = line
		pattern = ':'
		if pattern in time_w_init:
			time_w_init_data = time_w_init.split(":")[1]
			time_w_init_data = time_w_init_data.strip() 
		else:
			time_w_init_data = '?'
	if i == fmm_timing_line_1:
		time_no_init = line
		pattern = ':'
                if pattern in time_no_init:
                        time_no_init_data = time_no_init.split(":")[1]
                        time_no_init_data = time_no_init_data.strip()
                else:
                        time_no_init_data = '?'
		#if print_option == 0:
		#	print 'FMM 256 Results (%s): %s : %s : %s : %s : %s : %s : %s : %s : %s : %s : %s' % (i+1, time_w_init_data, time_no_init_data, track, tree, list_t, part, pass_t, inter, bar, intra, other)
		#	output_file.write('FMM 256 Results (%s): %s : %s : %s : %s : %s : %s : %s : %s : %s : %s : %s \n' % (i+1, time_w_init_data, time_no_init_data, track, tree, list_t, part, pass_t, inter, bar, intra, other))
		#else:
		#	print 'FMM 2048 Results (%s): %s : %s : %s : %s : %s : %s : %s : %s : %s : %s : %s' % (i+1, time_w_init_data, time_no_init_data, track, tree, list_t, part, pass_t, inter, bar, intra, other)
		#	output_file.write('FMM 2048 Results (%s): %s : %s : %s : %s : %s : %s : %s : %s : %s : %s : %s \n' % (i+1, time_w_init_data, time_no_init_data, track, tree, list_t, part, pass_t, inter, bar, intra, other))

		w = 2*TEST_DEPTH
		TEST_DATA[y] = time_w_init_data 
		TEST_DATA[y+w] = time_no_init_data
		TEST_DATA[y+2*w] = track
		TEST_DATA[y+3*w] = tree
		TEST_DATA[y+4*w] = list_t
		TEST_DATA[y+5*w] = part
		TEST_DATA[y+6*w] = pass_t
		TEST_DATA[y+7*w] = inter
		TEST_DATA[y+8*w] = bar
		TEST_DATA[y+9*w] = intra
		TEST_DATA[y+10*w] = other
		y = y + 1
	i = i + 1

sys.stdout.write('\n')
#output_file.write('\n')
sys.stdout.write('%s\n' % (sys.argv[1:]))
#output_file.write('%s\n' % (sys.argv[1:]))
sys.stdout.write('FMM Splash-2 Test (256 & 2048)\n')
#output_file.write('FMM Splash-2 Test (256 & 2048)\n')
z = 0
x = 0
p = 0
while z < 11:
	while x < y:
		sys.stdout.write('%s :' % (TEST_DATA[p]))
		output_file.write('%s\n' % (TEST_DATA[p]))
		p = p + 1
		x = x + 1
	sys.stdout.write('\n')
	#output_file.write('\n')
	x = 0
	z = z + 1
	p = z*2*TEST_DEPTH

sys.stdout.write('\n')
x = 0
while x<10:
	#output_file.write('\n')
	x = x+1
#print '\n'
#output_file.write('\n')

############ PARSE OCEAN TESTS ##################################################################################
y = 0
ocean_stats_line = -1
ocean_timing_line_0 = -1
ocean_timing_line_1 = -1
print_0 = 0
i = 0
printAvg = 0
tmpCount = 0

'''
print 'Ocean Header : total + init : total - init : total time : multigrid time : multigrid fraction'
output_file.write('Ocean Header : total + init : total - init : total time : multigrid time : multigrid fraction \n')
'''

for line in fileinput.input(sys.argv[1:]):
	for match in re.finditer(pattern_ocean, line):
		ocean_stats_line = i + 11
		ocean_timing_line_0 = i + 17
		ocean_timing_line_1 = i + 18
	if i == ocean_stats_line:
		proc, total, multigrid, fraction = line.split()
	if i == ocean_timing_line_0:
		time_w_init = line
		pattern = ':'
		if pattern in time_w_init:
			time_w_init_data = time_w_init.split(":")[1]
			time_w_init_data = time_w_init_data.strip() 
		else:
			time_w_init_data = '?'
	if i == ocean_timing_line_1:
		time_no_init = line
		pattern = ':'
                if pattern in time_no_init:
                        time_no_init_data = time_no_init.split(":")[1]
                        time_no_init_data = time_no_init_data.strip()
                else:
                        time_no_init_data = '?'
		#if (tmpCount > 9 and print_0 == 0):
		#	if (printAvg <  time_w_init_data):
		#		print_0 = 1
		#	if (printAvg == 0):
		#		printAvg = time_w_init_data 
		#	else:
		#		printAvg = int(printAvg + time_w_init_data)/2
		#tmpCount = tmpCount + 1		
		#if print_0 == 0:
		#	print 'Ocean Contiguous %s: %s : %s : %s : %s : %s' % (i+1, time_w_init_data, time_no_init_data, total, multigrid, fraction)
		#	output_file.write('Ocean Contiguous %s: %s : %s : %s : %s : %s \n' % (i+1, time_w_init_data, time_no_init_data, total, multigrid, fraction))
		#if print_0 != 0:
		#	print 'Ocean Non Contiguous %s: %s : %s : %s : %s : %s' % (i+1, time_w_init_data, time_no_init_data, total, multigrid, fraction)
		#	output_file.write('Ocean Non Contiguous %s: %s : %s : %s : %s : %s \n' % (i+1, time_w_init_data, time_no_init_data, total, multigrid, fraction))

		w = 2*TEST_DEPTH
		TEST_DATA[y] = total
		#TEST_DATA[y] = time_w_init_data
		#TEST_DATA[y+w] = time_no_init_data
		#TEST_DATA[y+2*w] = total
		#TEST_DATA[y+3*w] = multigrid
		#TEST_DATA[y+4*w] = fraction
		y = y + 1
	i = i + 1

sys.stdout.write('\n')
#output_file.write('\n')
sys.stdout.write('%s\n' % (sys.argv[1:]))
#output_file.write('%s\n' % (sys.argv[1:]))
sys.stdout.write('Ocean Splash-2 Test (Contiguous & Non Contiguous)\n')
#output_file.write('Ocean Splash-2 Test (Contiguous & Non Contiguous)\n')
z = 0
x = 0
p = 0
t = 0
#while z < 5:
while z < 1:
	while x < y:
		sys.stdout.write('%s :' % (TEST_DATA[p]))
		output_file.write('%s\n' % (TEST_DATA[p]))
		p = p + 1
		x = x + 1
	sys.stdout.write('\n')
	#output_file.write('\n')
	x = 0
	z = z + 1
	p = z*2*TEST_DEPTH

sys.stdout.write('\n')
x = 0
while x<10:
	#output_file.write('\n')
	x = x+1




