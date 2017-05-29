public class HelloWorld
{
	public static void Main (String[] args)
	{
		int x = 1, y = 7;
		x = 42;
		//y = 0;
		// Testing WhileStatement
		while (x < 46)
		{
			x = x + 1;
			y = y + 4;
			System.out.println(x);
			System.out.println(y);
		}
		y = Add(x, y);
		String z = "Y equals ";
		System.out.println(z + y);

		// Testing PreUnaryExpression & PostUnaryExpression
		y--;
		y++;
		++x;
		--x;
		double m;
		m = ~x; 
		boolean bool_var = true;
		boolean invert_bool_var;
		invert_bool_var = !bool_var;

		// Testing CastExpression
		double x_double = 0; 
		x_double = (double)x;
	}

	public int Add(int a, int b)
	{
		int c = 3;
		c = a + b + 2;
		return c;
	}	
}


public class TestMethodName
{
	// Change to Main to test Main method
	static public void Test(String[] args)
	{
		int x = 1, y = 7;
	}

	public int Add(int a, int b)
	{
		int c = 3;
		c = a + b + 2;
		return c;
	}
}