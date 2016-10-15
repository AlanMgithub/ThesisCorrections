# Parser for L1 & L2 cache dump's

cacheDump = open('cachedump_L2')
cacheStats = open('stats_cache_L2', 'w')
cacheGraph = open('graph_cache_l2', 'w')
#cacheDump = open('test')

evictionCount0 = 0
evictionCount1 = 0
sharedLine0 = 0
sharedLine1 = 0
writeShared0 = 0
writeShared1 = 0
readShared0 = 0
readShared1 = 0
falseSharedWrite0 = 0
falseSharedWrite1 = 0
falseSharedRead0 = 0
falseSharedRead1 = 0
falseSharedUncachedWrite0 = 0
falseSharedUncachedWrite1 = 0
falseSharedUncachedRead0 = 0
falseSharedUncachedRead1 = 0
evictSharedUncachedWrite0 = 0
evictSharedUncachedWrite1 = 0
evictSharedUncachedRead0 = 0
evictSharedUncachedRead1 = 0
loadLinked0 = 0
loadLinked1 = 0
storeConditional0 = 0
storeConditional1 = 0
cacheAccessCore0 = 0
cacheAccessCore1 = 0
hitCached0 = 0
hitCached1 = 0
missCached0 = 0
missCached1 = 0
scResultOut0 = 0
scResultOut1 = 0
readHitCached0 = 0
readHitCached1 = 0
writeHitCached0 = 0
writeHitCached1 = 0
readMissCached0 = 0
readMissCached1 = 0
writeMissCached0 = 0
writeMissCached1 = 0

arraySharers0 = [0 for x in range(2048)]
arraySharers1 = [0 for x in range(2048)]
arrayUnshared0 = [0 for x in range(2048)]
arrayUnshared1 = [0 for x in range(2048)]

cacheIndexArray = [0 for x in range(2048)]
cacheIndexArray0 = [0 for x in range(2048)]
cacheIndexArray1 = [0 for x in range(2048)]
cacheIndexArray2 = [0 for x in range(2048)]
cacheIndexArray3 = [0 for x in range(2048)]

for line in cacheDump:
	#cacheName, coreID, cacheNo, key, cap, valid, cacheOp, miss, cached, tag, sharers, dirty, linked = line.split()
	cacheName, coreID, cacheNo, key, cap, valid, cacheOp, miss, cached, tag, sharers, dirty, linked, scResult = line.split()
	#scResult = 0;
	cacheIndexArray[int(key)] = cacheIndexArray[int(key)] + 1

# CORE 0 STATISTICS
	if int(coreID) == 0:
		# TOTAL NUMBER OF CACHE ACCESSES
		cacheAccessCore0 = cacheAccessCore0 + 1;
		# NUMBER OF CACHED HITS
		if int(miss) == 0 and int(cached) == 1:
			hitCached0 = hitCached0 + 1;
		# NUMBER OF CACHED MISSES
		if int(miss) == 1 and int(cached) == 1:
			missCached0 = missCached0 + 1;
		# NUMBER OF CACHED READ HITS
		if int(miss) == 0 and int(cached) == 1 and (int(cacheOp) == 6 or int(cacheOp) == 9):
			readHitCached0 = readHitCached0 + 1;
		# NUMBER OF CACHED WRITE HITS
		if int(miss) == 0 and int(cached) == 1 and (int(cacheOp) == 7 or int(cacheOp) == 8):
			writeHitCached0 = writeHitCached0 + 1;
		# NUMBER OF CACHED READ MISSES
		if int(miss) == 1 and int(cached) == 1 and (int(cacheOp) == 6 or int(cacheOp) == 9):
			readMissCached0 = readMissCached0 + 1;
		# NUMBER OF CACHED WRITE MISSES
		if int(miss) == 1 and int(cached) == 1 and (int(cacheOp) == 7 or int(cacheOp) == 8):
			writeMissCached0 = writeMissCached0 + 1;
		# COUNT EVICTIONS
		if int(valid) == 1 and int(miss) == 1 and int(dirty) == 1:
			evictionCount0 = evictionCount0 + 1;
		# COUNT NUMBER OF DATA SHARERS (FALSE AND NOT)
		if int(sharers) != 0 and int(sharers) != 1 and int(sharers) != 10 and int(sharers) != 100 and int(sharers) != 1000 and int(cached) == 1:
			sharedLine0 = sharedLine0 + 1;
		# LOG SHARERS FOR EACH KEY & WRITES/READS TO SHARED LINE & NUMBER OF NON SHARED LINES PER KEY 
		if int(sharers) == 101 and int(cached) == 1:
			arraySharers0[int(key)] = arraySharers0[int(key)] + 1
			if int(cacheOp) == 7:
				writeShared0 = writeShared0 + 1;
			elif int(cacheOp) == 6:
				readShared0 = readShared0 + 1;
		elif int(sharers) != 101 and int(cached) == 1:
	                arrayUnshared0[int(key)] = arrayUnshared0[int(key)] + 1
		# FALSE SHARED READS/WRITES (lINES ARE SHARED NOT BETWEEN THE PROVATE DATA CACHES)
		if int(sharers) != 101 and int(sharers) != 0 and int(sharers) != 1 and int(sharers) != 10 and int(sharers) != 100 and int(sharers) != 1000 and int(cached) == 1:
			if int(cacheOp) == 7:
				falseSharedWrite0 = falseSharedWrite0 + 1;
			elif int(cacheOp) == 6:
				falseSharedRead0 = falseSharedRead0 + 1;
		# LINE IS SHARED BUT AN UNCACHED READ/WRITE HITS IT
		if int(sharers) != 0 and int(sharers) != 1 and int(sharers) != 10 and int(sharers) != 100 and int(sharers) != 1000 and int(cached) == 0:
			if int(cacheOp) == 7:
				falseSharedUncachedWrite0 = falseSharedUncachedWrite0 + 1;
			elif int(cacheOp) == 6:
				falseSharedUncachedRead0 = falseSharedUncachedRead0 + 1;
		# SHARED LINE HIT BY AN UNCACHED READ/WRITE
		if int(sharers) == 101 and int(cached) == 0:
			if int(cacheOp) == 7:
				evictSharedUncachedWrite0 = evictSharedUncachedWrite0 + 1;
			elif int(cacheOp) == 6:
				evictSharedUncachedRead0 = evictSharedUncachedRead0 + 1;
		# COUNT NUMBER OF LL & SC
		#if int(linked) == 1:
		#	if int(cacheOp) == 6:
		#		loadLinked0 = loadLinked0 + 1;
		if int(cacheOp) == 9:
			loadLinked0 = loadLinked0 + 1;
		if int(cacheOp) == 8:
			storeConditional0 = storeConditional0 + 1;
			if int(scResult) == 1:
				scResultOut0 = scResultOut0 + 1;

# CORE 1 STATISTICS
	else:
		# TOTAL NUMBER OF CACHE ACCESSES
		cacheAccessCore1 = cacheAccessCore1 + 1;
		# NUMBER OF CACHED HITS
		if int(miss) == 0 and int(cached) == 1:
			hitCached1 = hitCached1 + 1;
		# NUMBER OF CACHED MISSES
		if int(miss) == 1 and int(cached) == 1:
			missCached1 = missCached1 + 1;
		# NUMBER OF CACHED READ HITS
		if int(miss) == 0 and int(cached) == 1 and (int(cacheOp) == 6 or int(cacheOp) == 9):
			readHitCached1 = readHitCached1 + 1;
		# NUMBER OF CACHED WRITE HITS
		if int(miss) == 0 and int(cached) == 1 and (int(cacheOp) == 7 or int(cacheOp) == 8):
			writeHitCached1 = writeHitCached1 + 1;
		# NUMBER OF CACHED READ MISSES
		if int(miss) == 1 and int(cached) == 1 and (int(cacheOp) == 6 or int(cacheOp) == 9):
			readMissCached1 = readMissCached1 + 1;
		# NUMBER OF CACHED WRITE MISSES
		if int(miss) == 1 and int(cached) == 1 and (int(cacheOp) == 7 or int(cacheOp) == 8):
			writeMissCached1 = writeMissCached1 + 1;
		# COUNT EVICTIONS
		if int(valid) == 1 and int(miss) == 1 and int(dirty) == 1:
			evictionCount1 = evictionCount1 + 1;
		# COUNT NUMBER OF DATA SHARERS (FALSE AND NOT)
		if int(sharers) != 0 and int(sharers) != 1 and int(sharers) != 10 and int(sharers) != 100 and int(sharers) != 1000 and int(cached) == 1:
			sharedLine1 = sharedLine1 + 1;
		# LOG SHARERS FOR EACH KEY & WRITES/READS TO SHARED LINE & NUMBER OF NON SHARED LINES PER KEY 
		if int(sharers) == 101 and int(cached) == 1:
			arraySharers1[int(key)] = arraySharers1[int(key)] + 1
			if int(cacheOp) == 7:
				writeShared1 = writeShared1 + 1;
			elif int(cacheOp) == 6:
				readShared1 = readShared1 + 1;
		elif int(sharers) != 101 and int(cached) == 1:
	                arrayUnshared1[int(key)] = arrayUnshared1[int(key)] + 1
		# FALSE SHARED READS/WRITES (lINES ARE SHARED NOT BETWEEN THE PROVATE DATA CACHES)
		if int(sharers) != 101 and int(sharers) != 0 and int(sharers) != 1 and int(sharers) != 10 and int(sharers) != 100 and int(sharers) != 1000 and int(cached) == 1:
			if int(cacheOp) == 7:
				falseSharedWrite1 = falseSharedWrite1 + 1;
			elif int(cacheOp) == 6:
				falseSharedRead1 = falseSharedRead1 + 1;
		# LINE IS SHARED BUT AN UNCACHED READ/WRITE HITS IT
		if int(sharers) != 0 and int(sharers) != 1 and int(sharers) != 10 and int(sharers) != 100 and int(sharers) != 1000 and int(cached) == 0:
			if int(cacheOp) == 7:
				falseSharedUncachedWrite1 = falseSharedUncachedWrite1 + 1;
			elif int(cacheOp) == 6:
				falseSharedUncachedRead1 = falseSharedUncachedRead1 + 1;
		# SHARED LINE HIT BY AN UNCACHED READ/WRITE
		if int(sharers) == 101 and int(cached) == 0:
			if int(cacheOp) == 7:
				evictSharedUncachedWrite1 = evictSharedUncachedWrite1 + 1;
			elif int(cacheOp) == 6:
				evictSharedUncachedRead1 = evictSharedUncachedRead1 + 1;
		# COUNT NUMBER OF LL & SC
		#if int(linked) == 1:
		#	if int(cacheOp) == 6:
		#		loadLinked1 = loadLinked1 + 1;
		if int(cacheOp) == 9:
			loadLinked1 = loadLinked1 + 1;
		if int(cacheOp) == 8:
			storeConditional1 = storeConditional1 + 1;
			if int(scResult) == 1:
				scResultOut1 = scResultOut1 + 1;

			
totalEvictionCount = evictionCount0 + evictionCount1;
totalSharedLine = sharedLine0 + sharedLine1;

'''
print 'Cache Access Core 0:', cacheAccessCore0, 'Cache Access Core 1:', cacheAccessCore1
print 'Cache Hit Core 0:', hitCached0, 'Cache Hit Core 1:', hitCached1
print 'Cache Miss Core 0:', missCached0, 'Cache Miss Core 1:', missCached1
print 'Cache Read Hit Core 0:', readHitCached0, 'Cache Read Hit Core 1:', readHitCached1
print 'Cache Write Hit Core 0:', writeHitCached0, 'Cache Write Hit Core 1:', writeHitCached1
print 'Cache Read Miss Core 0:', readMissCached0, 'Cache Read Miss Core 1:', readMissCached1
print 'Cache Write Miss Core 0:', writeMissCached0, 'Cache Write Miss Core 1:', writeMissCached1
print 'Eviction Count:', totalEvictionCount
print 'Shared Line:', totalSharedLine
print 'Write Shared Core 0:', writeShared0, 'Write Shared Core 1:', writeShared1
print 'Read Shared Core 0:', readShared0, 'Read Shared Core 1:', readShared1
print 'False Shared Write Core 0:', falseSharedWrite0, 'False Shared Write Core 1:', falseSharedWrite1 
print 'False Shared Read Core 0:', falseSharedRead0, 'False Shared Read Core 1:', falseSharedRead1 
print 'False Shared Uncached Write Core 0:', falseSharedUncachedWrite0, 'False Shared Uncached Write Core 1:', falseSharedUncachedWrite1 
print 'False Shared Uncached Read Core 0:', falseSharedUncachedRead0, 'False Shared Uncached Read Core 1:', falseSharedUncachedRead1 
print 'Evict Shared Uncached Write Core 0:', evictSharedUncachedWrite0, 'Evict Shared Uncached Write Core 1:', evictSharedUncachedWrite1 
print 'Evict Shared Uncached Read Core 0:', evictSharedUncachedRead0, 'Evict Shared Uncached Read Core 1:', evictSharedUncachedRead1 
print 'Load Linked Core 0:', loadLinked0, 'Load Linked Core 1:', loadLinked1 
print 'Store Conditional Core 0:', storeConditional0, 'Store Conditional Core 1:', storeConditional1 
print 'Store Conditional Result Core 0:', scResultOut0, 'Store Conditional Result Core 1:', scResultOut1 


for x in range(0,2048):
	print x, arraySharers0[x], arraySharers1[x], arrayUnshared0[x], arrayUnshared1[x] 
'''

print >> cacheStats, 'Cache Access Core 0:', cacheAccessCore0, 'Cache Access Core 1:', cacheAccessCore1
print >> cacheStats, 'Cache Hit Core 0:', hitCached0, 'Cache Hit Core 1:', hitCached1
print >> cacheStats, 'Cache Miss Core 0:', missCached0, 'Cache Miss Core 1:', missCached1
print >> cacheStats, 'Cache Read Hit Core 0:', readHitCached0, 'Cache Read Hit Core 1:', readHitCached1
print >> cacheStats, 'Cache Write Hit Core 0:', writeHitCached0, 'Cache Write Hit Core 1:', writeHitCached1
print >> cacheStats, 'Cache Read Miss Core 0:', readMissCached0, 'Cache Read Miss Core 1:', readMissCached1
print >> cacheStats, 'Cache Write Miss Core 0:', writeMissCached0, 'Cache Write Miss Core 1:', writeMissCached1
print >> cacheStats, 'Eviction Count:', totalEvictionCount
print >> cacheStats, 'Shared Line:', totalSharedLine
print >> cacheStats, 'Write Shared Core 0:', writeShared0, 'Write Shared Core 1:', writeShared1
print >> cacheStats, 'Read Shared Core 0:', readShared0, 'Read Shared Core 1:', readShared1
print >> cacheStats, 'False Shared Write Core 0:', falseSharedWrite0, 'False Shared Write Core 1:', falseSharedWrite1 
print >> cacheStats, 'False Shared Read Core 0:', falseSharedRead0, 'False Shared Read Core 1:', falseSharedRead1 
print >> cacheStats, 'False Shared Uncached Write Core 0:', falseSharedUncachedWrite0, 'False Shared Uncached Write Core 1:', falseSharedUncachedWrite1 
print >> cacheStats, 'False Shared Uncached Read Core 0:', falseSharedUncachedRead0, 'False Shared Uncached Read Core 1:', falseSharedUncachedRead1 
print >> cacheStats, 'Evict Shared Uncached Write Core 0:', evictSharedUncachedWrite0, 'Evict Shared Uncached Write Core 1:', evictSharedUncachedWrite1 
print >> cacheStats, 'Evict Shared Uncached Read Core 0:', evictSharedUncachedRead0, 'Evict Shared Uncached Read Core 1:', evictSharedUncachedRead1 
print >> cacheStats, 'Load Linked Core 0:', loadLinked0, 'Load Linked Core 1:', loadLinked1 
print >> cacheStats, 'Store Conditional Core 0:', storeConditional0, 'Store Conditional Core 1:', storeConditional1 
print >> cacheStats, 'Store Conditional Result Core 0:', scResultOut0, 'Store Conditional Result Core 1:', scResultOut1 


for x in range(0,2048):
	print >> cacheGraph, x, arraySharers0[x], arraySharers1[x], arrayUnshared0[x], arrayUnshared1[x] 

cacheDump.close()
cacheStats.close()
cacheGraph.close()
