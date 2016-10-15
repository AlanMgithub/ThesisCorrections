#include <iostream>

int doubleValue (int var)
{
	return var + var;
}

int main (void)
{
	using std::cout;
	using std::cin;
	int var = 0;

	cout << "Enter Value: ";
	cin >> var;
	cout << "New Value:" << doubleValue(var) << std::endl;
}
