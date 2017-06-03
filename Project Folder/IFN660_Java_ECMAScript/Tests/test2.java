public class HelloWorld
{

	public static void Main (String[] args)
	{
		int a;
		int b;
		int c;
		int d;

		
		a = 42;
		b = a + 1;
		c = 0;
		d = 1; 

		
		//d = (double)a * 200; // cast does not work;
		//c = d * 2000;

		c = Add(a , b);
		
		while (a < 1000){
			//b = a + 1;
			a = a + 1;
			b = a + b + 1;
			if(a < 3){
				System.out.println(b);
			} else if (a == 400) {
				System.out.println(d);
			} else if (a < 500) {
				System.out.println(c);
			} else {
				System.out.println(a);
			}	
		}

		int e;
		e = 10000;
		do {
			e = e - 1;
			System.out.println(e);
		} while (e > 0);

	}

	public static int Add(int a, int b)
	{
		int c = 3;
		c = a + b + 2;
		return c;
	}

	
}

