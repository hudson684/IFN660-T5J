public class HelloWorld
{
	public static void Main (String[] args)
	{
		int x = 1, y = 7;
		x = 42;
		//y = 0;
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