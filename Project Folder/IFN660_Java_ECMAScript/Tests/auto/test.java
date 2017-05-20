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
	}
}