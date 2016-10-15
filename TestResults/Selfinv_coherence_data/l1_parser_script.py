# Parser for L1 & L2 cache dump's

cacheDump = open('cachedump_L1')

#cacheDump = open('test')

validCoreZero = 0
validCoreOne = 0
sharedLines = 0
linkedTotal = 0
invalidTotal = 0
cachedLines = 0
uncachedLines = 0

cacheIndexArray0 = [0 for x in range(512)]
cacheIndexArray1 = [0 for x in range(512)]
cacheIndexArray2 = [0 for x in range(512)]
cacheIndexArray3 = [0 for x in range(512)]

for line in cacheDump:
	cacheName, coreID, cacheNo, key, cap, valid, cacheOp, miss, cached, tag = line.split()
	if int(cacheOp) == 6 or int(cacheOp) == 7 or int(cacheOp) == 8:
	#if int(cacheOp) == 8:
		if int(cached) == 1 and int(valid) == 1 and int(miss) == 0:
			if int(coreID) == 0:
				cacheIndexArray0[int(key)] = cacheIndexArray0[int(key)] + 1
			else:
				cacheIndexArray1[int(key)] = cacheIndexArray1[int(key)] + 1
		else:
			if int(coreID) == 0:
				cacheIndexArray2[int(key)] = cacheIndexArray2[int(key)] + 1
			else:
				cacheIndexArray3[int(key)] = cacheIndexArray3[int(key)] + 1
	

'''
	if int(cached) == 0:
		cachedLines = cachedLines + 1
	else:
		uncachedLines = uncachedLines + 1

	if int(coreID) == 0 and int(valid) == 1 and int(miss) == 0:
		validCoreZero = validCoreZero + 1
	elif int(coreID) == 1 and int(valid) == 1 and int(miss) == 0:
		validCoreOne = validCoreOne + 1

	if int(sharers) == 0001: #and int(sharers) != 101 and int(sharers) != 0000:
		sharedLines = sharedLines + 1

	if int(linked) != 0:
		linkedTotal = linkedTotal + 1

	if int(valid) == 0 and int(cached) != 0:
		invalidTotal = invalidTotal + 1

print 'Core0 Valid', validCoreZero, '| Core1 Valid', validCoreOne
#print 'Shared Lines', sharedLines
print 'Linked Lines', linkedTotal
print 'Invalid-Cached Lines', invalidTotal
print 'Cached Lines', cachedLines, 'Uncached Lines', uncachedLines
'''
for x in range(0,512):
	print x, cacheIndexArray0[x], cacheIndexArray1[x], cacheIndexArray2[x], cacheIndexArray3[x]

#print 'Cached Lines', cachedLines, 'Uncached Lines', uncachedLines

cacheDump.close()
