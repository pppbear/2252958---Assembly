#include<stdio.h>

int main() {
	for (char type = 'a'; type <= 'z'; type++)
	{
		printf("%c", type);
		if (type == 'm')
			printf("\n");
	}
	return 0;
}