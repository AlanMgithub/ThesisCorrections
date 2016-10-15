#include <iostream>

namespace exitChar {
	char exitValue('n');
}

bool checkPrime (int val) {
	bool returnVal = true;

	int i = 2;
	if (val >= 0 && val <= 2) {
		returnVal = true;
	}
	else if (val < 0) {
		returnVal = false;
	}
	else {
		while (i < val) {
			int check = val % i;
			if (check == 0) {
				returnVal = false;
				break;
			}
			else {
				returnVal = true;
			}
			i++;
		}
	}

	return returnVal;
}

int main (void){
	using std::cout;
	using std::cin;
	using std::endl;

	int number;
	//std::string exitValue = ("null");
	//char exitValue = 'n';

	//while (exitValue.compare("exit") != 0) {
	//while (exitValue != 'e') {
	while (exitChar::exitValue != 'e') {
		cout << "Enter Value: ";
		cin >> number;

		bool evalPrime = checkPrime(number);

		if (evalPrime) {
			cout << "* TRUE *" << endl;
		}
		else {
			cout << "! FALSE !" << endl;
		}

		cout << "Again? or type 'e' to exit > ";
		cin >> exitChar::exitValue;
		cout << "Char Input Was: " << exitChar::exitValue << endl;
	}
}
