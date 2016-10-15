#!/usr/bin/env python
import os
import sys
import string

import numpy as np
import matplotlib
import matplotlib.pyplot as plt

def display(dataMatrix):
	#print(np.matrix(dataMatrix))
	plt.imshow(dataMatrix, extent=[-4,4,-1,1], aspect=2, cmap="spectral")
	plt.figure(figCount)

def findFiles():
	currDir = os.getcwd()
	for i in os.listdir(currDir):
		fileName = i.split('.')
		try:
			if fileName[1] == 'txt':
				filesToParse.append(fileName[0]+'.'+fileName[1])		
		except:
			print 'No file extension!'

def extractData(name, rows, columns):
	print '\n************\t' + name + '\t*************'
	#print name, rows, columns
	Matrix = [[0 for x in range(columns)] for y in range(rows)]
	fd = open(name, 'r')
	colCount = 0
	tmpCount = 0
	for line in fd:
		lineFragments = line.split(' ')
		if lineFragments[0] == '----':
			Matrix[int(lineFragments[2])][colCount] = int(lineFragments[4])
			tmpCount += 1
			if tmpCount >= rows:
				colCount += 1
				tmpCount = 0
		if colCount >= 100: break
	display(Matrix)
'''
	print '***\t name \t***'
	print Matrix	
	print '***\t END \t***'
'''

def dataDimensions(name):
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
	extractData(name, largestID, lineCounter)

def parseFiles():
	for i in filesToParse:
		dataDimensions(i)

filesToParse = []
findFiles()
figCount = len(filesToParse)
parseFiles()

fig = matplotlib.pyplot.gcf()
fig.set_size_inches(18.5, 10.5)
plt.show()
