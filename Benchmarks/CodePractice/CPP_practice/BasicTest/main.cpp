#include "io.h"

int main (void)
{
	static int i = 0;
	int ans = readNumber(i);
	i++;
	ans = ans + readNumber(i);
	writeAnswer(ans);
	return 0;
}
