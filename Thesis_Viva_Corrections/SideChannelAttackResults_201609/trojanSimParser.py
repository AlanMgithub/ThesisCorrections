#!/usr/bin/env python
import os
import sys
import string

import numpy as np
import matplotlib
import matplotlib.pyplot as plt

def plotColor():
	plotColor.value += 0.06
	return plotColor.value

def display(dataMatrix, name, count):
	#print(np.matrix(dataMatrix))

	plt.figure(111, figsize=(15,8))
	plt.suptitle(str(filesToParse), fontsize=10, fontweight='bold')
	peakCorr = np.correlate(dataMatrix[0],dataMatrix[0],"full")
	plt.plot(peakCorr)
	plt.plot(np.correlate(dataMatrix[0],dataMatrix[1],"full"), ':')
	plt.grid(color='r', linestyle='--', linewidth=0.5)
	#plt.yticks(np.arange(0, max(peakCorr), max(peakCorr)/20))
	#plt.yscale('log')
	'''
	for i in range(0,3):#range(0,len(dataMatrix)):	
		plt.figure(i, figsize=(15,8))
		plt.suptitle((str(filesToParse) + '\n\n' + str(i)), fontsize=10, fontweight='bold')
		plt.hist(dataMatrix[i])
		#plt.imshow(dataMatrix, extent=[-4,4,-1,1], aspect=2, cmap="spectral")
	'''
	for i in range(1,3):#range(0,len(dataMatrix)):	
		plt.figure((8 + i), figsize=(15,8))
		plt.suptitle((str(filesToParse) + '\n\n' + str(i)), fontsize=10, fontweight='bold')
		plt.plot(dataMatrix[i], '--')

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
		elif pattern == 'V':
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
findFiles()
parseFiles()
plt.show()
