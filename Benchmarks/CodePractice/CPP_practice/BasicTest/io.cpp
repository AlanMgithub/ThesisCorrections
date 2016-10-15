#include <iostream>

int readNumber (int i)
{
	int input = 0;
	std::cout << "Enter Input[" << i << "]:";
	std::cin >> input;
	return input;
}

void writeAnswer (int ans)
{
	std::cout << "Output Value:" << ans << std::endl;
}
