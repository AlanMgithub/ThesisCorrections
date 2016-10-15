#!/usr/bin/env python
import os
import sys
import string

import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab

#import scipy
#from scipy.signal import hilbert, chirp

# Hatch patterns
hatch_pattern = ('-', '+', 'x', '\\', '*', 'o', 'O', '.')

def plotColor():
	plotColor.value += 0.06
	return plotColor.value

def display(dataMatrix, name, count):
	#print(np.matrix(dataMatrix))
	'''
	plt.figure(111, figsize=(15,8))
	plt.suptitle(str(filesToParse), fontsize=10, fontweight='bold')
	peakCorr = np.correlate(dataMatrix[2],dataMatrix[2],"full")
	plt.plot(peakCorr)
	plt.plot(np.correlate(dataMatrix[1],dataMatrix[2],"full"), '-.')
	plt.grid(color='r', linestyle='--', linewidth=0.5)
	#plt.yticks(np.arange(0, max(peakCorr), max(peakCorr)/20))
	#plt.yscale('log')
	'''

	rows = len(dataMatrix)
	if rows > 3:
		rows = 3	
	
	for i in range(1,rows):#range(0,len(dataMatrix)):	
		'''
		# Array average
		badList = []
		average = reduce(lambda x, y: x + y, dataMatrix[i]) / len(dataMatrix[i])
		for j in range(0,len(dataMatrix[i])):
			if dataMatrix[i][j] < (average + average/4):
				#badList.append(j)
				dataMatrix[i][j] = average + average/4
		#'''

		#envelope = abs(hilbert(dataMatrix[1]))

		#Envelope
		window = 5
		for j in range(0,len(dataMatrix[i]),window):
			maxima = max(dataMatrix[i][j:(j+window)])			
			for k in range(j,(j+window)):
				if k < len(dataMatrix[i]):
					dataMatrix[i][k] = maxima

		plt.figure(i, figsize=(15,8))
		plt.suptitle((str(filesToParse) + '\n\n' + str(i)), fontsize=10, fontweight='bold')
		#plt.hist(dataMatrix[i])
		dataRange = plt.plot(range(0, len(dataMatrix[i])),dataMatrix[i],"--",label=str(name))
		#plt.plot(envelope,"-",label=str(name))
		dataRangeColour = dataRange[0].get_color()
		print dataRangeColour
		plt.legend(loc='upper left')
		#plt.yscale("symlog")
		plt.grid('on')

		# calc the trendline
		x = range(0, len(dataMatrix[i]))
		y = dataMatrix[i]
		z = np.polyfit(x, y, 1)
		p = np.poly1d(z)
		plt.plot(x,p(x),c=dataRangeColour)	
	
	#'''
	for i in range(1,rows):#range(0,len(dataMatrix)):	
		plt.figure(i+3, figsize=(15,8))
		plt.suptitle((str(filesToParse) + '\n\n' + str(i)), fontsize=10, fontweight='bold')
		#plt.hist(dataMatrix[i])
		binwidth = 2#10
		plt.hist(dataMatrix[i], bins=range(min(dataMatrix[i]), max(dataMatrix[i]) + binwidth, binwidth),alpha=0.5,label=str(name),hatch=hatch_pattern[count])#,fill=False)
		plt.legend(loc='upper left')
		plt.yscale("symlog")
		plt.grid('on')	
	#'''

	'''
	for i in range(1,3):#range(0,len(dataMatrix)):	
		plt.figure((8 + i), figsize=(15,8))
		plt.suptitle((str(filesToParse) + '\n\n' + str(i)), fontsize=10, fontweight='bold')
		plt.plot(dataMatrix[i], '-.', label=str(name))
		plt.legend(loc='upper left')
		count+=1
		print count
	'''

	'''
	for i in range(1,3):#range(0,len(dataMatrix)):	
		plt.figure((3 + i), figsize=(15,8))
		plt.suptitle((str(filesToParse) + '\n\n' + str(i)), fontsize=10, fontweight='bold')
		plt.imshow(dataMatrix, extent=[-4,4,-1,1], aspect=2, cmap="spectral", label=str(name))
		plt.legend(loc='upper left')
		count+=1
		print count
	'''

plotColor.value = 0.1

def findFiles():
	currDir = os.getcwd()
	for i in os.listdir(currDir):
		fileName = i.split('.')
		try:
			if fileName[1] == 'troj':
				filesToParse.append(fileName[0]+'.'+fileName[1])		
		except:
			print 'No file extension!'

def extractData(name, rows, columns, count):
	print '\n************\t' + name + '\t*************'
	#print name, rows, columns
	Matrix = [[]]
	fd = open(name, 'r')
	colCount = 0
	for line in fd:
		line = line.rstrip()
		lineFragments = line.split(':')
		pattern = lineFragments[0]

		data = 0
		try:
			data = int(lineFragments[1])
		except:
			data = 0

		found = -1

		if pattern == 'K':
			found = 0
		elif pattern == 'T':
			found = 1
		elif pattern == 'V' or pattern == 'CP0 CountReg':
			found = 2
		elif pattern == 'M':
			found = 3
		elif pattern == 'H':
			found = 4
		elif pattern == 'X':
			found = 5
		elif pattern == 'Y':
			found = 6
		
		if found != -1:
			try:
				Matrix[found].append(data)
			except:
				Matrix.append([])
				Matrix[found].append(data)

	display(Matrix, name, count)

def dataDimensions(name, count):
	fd = open(name, 'r')
	largestID = 0
	lineCounter = 0
	for line in fd:
		lineFragments = line.split(' ')
		if lineFragments[0] == '----':
			if int(lineFragments[2]) > largestID:
				largestID = int(lineFragments[2])
			if int(lineFragments[2]) == 0:
				lineCounter += 1
		if lineCounter >= 100: break
	fd.close()
	largestID += 1
	extractData(name, largestID, lineCounter, count)

def parseFiles():
	count = 0
	for i in filesToParse:
		dataDimensions(i, count)
		count+=1

filesToParse = []

if len(sys.argv) > 1:
	for i in range(1,len(sys.argv)):
		filesToParse.append(sys.argv[i])
else:		
	findFiles()

parseFiles()
plt.show()
