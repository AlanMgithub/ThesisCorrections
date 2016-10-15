#include <iostream>

int main (void) {
	double inputs[2];
	double output;
	char inputSymbol;

	std::cout << "First Value: ";
	std::cin >> inputs[0];
	std::cout << "Second Value: ";
	std::cin >> inputs[1];
	std::cout << "Symbol ' +,-,*,/ ':";
	std::cin >> inputSymbol;

	//std::cout << int ('+') << "|" << int ('-') << "|" << int ('*') << "|" << int ('/') << std::endl;

	// +, -, *, / 
	//43|45|42|47

	switch (inputSymbol) {
		case '+': 
			output = inputs[0] + inputs[1];	
			break;
		case '-': 
			output = inputs[0] - inputs[1];
			break;
		case '*': 
			output = inputs[0] * inputs[1];
			break;
		case '/': 
			output = inputs[0] / inputs[1];
			break;
		default: 
			output = inputs[0] + inputs[1];
			break;
	}

	std::cout << "Solution to x" << inputSymbol << "y: " << output <<std::endl;

	return 0;
}
