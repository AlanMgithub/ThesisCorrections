#include <iostream>
#include <cmath>

using namespace std;

const double gConstant(9.80665);

class TowerDrop {
private:
	int towerHeight;
	int timeStep;
	int currTime;
	int prevHeight;
	int currVelocity;
public:
	TowerDrop();
	void setParam(int, int);
	double accCalc(int, int);
	double fineTimeMeasurement();
	double velocityCalc();
};

TowerDrop::TowerDrop() {
	towerHeight = 1000;
	timeStep = 100;
	currTime = 0;
	prevHeight = towerHeight;
	currVelocity = 0;
}

void TowerDrop::setParam(int height, int time) {
	towerHeight = height;
	timeStep = time;
}

double accCalc (int height, int time) {
	return (height - ((gConstant/2) * (pow(time,2)))); // d = v*t + (1/2)*a*t^2  {v = 0}
}

double fineTimeMeasurement (double height, double velocity) {
	return (2*height/velocity);
}

double velocityCalc (double velocity, double time) {
	return (velocity + gConstant*time);
}

int main (void) {
	int towerHeight, timeStep;
	TowerDrop towerdrop;
	
	cout << "Enter Height (meters): ";
	cin >> towerHeight;
	cout << "Enter Time Interval (seconds): ";
	cin >> timeStep;

	towerdrop.setParam(towerHeight, timeStep);

	int currTime = 0;
	double result = towerHeight;
	double previousHeight(0);
	double currVelocity(0);
	while (1) {
		previousHeight = result;
		result = accCalc(towerHeight, currTime);
		currVelocity = velocityCalc(currVelocity, currTime);
		if (result > 0) {
			cout << "At time " << currTime << " sec, object height is: " << result << " meters, velocity is: " << currVelocity << " meters/sec" << endl;
		}
		else {
			currTime = currTime - timeStep;
			double fineTime = fineTimeMeasurement(previousHeight, (2*(towerHeight-previousHeight)/currTime));	
			double impactVelocity = velocityCalc(currVelocity, (currTime + fineTime));
			cout << "At time " << double (currTime + fineTime) << " sec, velocity is: " << impactVelocity << " meters/sec, object impact" << endl;
			break;
		}
		currTime = currTime + timeStep;
	}	
		
	return 0;
}
