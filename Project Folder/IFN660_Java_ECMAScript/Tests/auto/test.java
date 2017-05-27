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
			System.out.println(x);
			System.out.println(y);
		}
		y = Add(y, x);
		++x;
		--x;
		//~x;
		bool bool_var = true;
		bool invert_bool_var;
		invert_bool_var = !bool_var;
		System.out.println(y);

	}

	public int Add(int a, int b)
	{
		int c = 3;
		c = a + b + 2;
		return c;
	}
}