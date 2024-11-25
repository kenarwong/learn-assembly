#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int
main()
{
	int a = time(NULL);
	int b = rand();
	int c = a/b;
	return c;
}
