#include <iostream>
#include <cmath>

int main (void) {
	using std::cin;
	using std::cout;
	using std::endl;

	int inputVal = 1<<31;

	while (inputVal < 0 || inputVal > 255) {  
		cout << "Input Value between 0 .. 255: ";
		cin >> inputVal;
		if (inputVal < 0 || inputVal > 255) {
			cout << "! INPUT ERROR !" << endl;
		}
		else {
			inputVal = inputVal & 0x000000FF;		 
			cout << "Echo " << inputVal << endl;
			int i(0);
			int bitVal = 0x00000080;
			cout << "Binary Value: ";
			for (i = 0; i < 8; i++) {
				int tmpVal = bitVal & inputVal;
				if (tmpVal != 0) 	
					cout << "1";
				else
					cout << "0";
				bitVal = bitVal>>1;
			}
			cout << endl;	
		}
	}

	return 0;
}
