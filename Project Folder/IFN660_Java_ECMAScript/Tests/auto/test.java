public class HelloWorld
{
	public void Main (String[] args)
	{
		int x = 1, y = 7;
		x = 42;
		//y = 0;
		while (x < 46)
		{
			x = x + 1;
			y = y + 4;
		}
		y = y + x;
		System.out.println(y);
		
		// Boolean Test
		boolean z;
		z = true;

		// Float and double test
		float m;
		m = 0.2f;

		// Should cause error cause it is a double not float
		//m = 0.2;

		double n;
		n = 0.2;
		n= m + 1;

		// Variable name test
		int _test;
		int $test;
	}
}