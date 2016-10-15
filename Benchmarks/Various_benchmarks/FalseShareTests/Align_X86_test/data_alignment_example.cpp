#include <stdio.h>
int main()
{
   char a;
   char b;
   class S1 
   {
      public:
      char m_1;             // 1-byte element
                  // 3-bytes of padding are placed here
      int m_2;           // 4-byte element
      double m_3, m_4;      // 8-byte elements
   };
   S1 x;
   long y;
   S1 z[5];
   
   printf("b = %p\n", &b);
printf("x = %p\n", &x);
printf("x.m_2 = %p\n", &x.m_2);
printf("x.m_3 =  %p\n", &x.m_3); 
printf("y = %p\n", &y);
printf("z[0] = %p\n", z);
printf("z[1] = %p\n", &z[1]);
   return 0;
}
