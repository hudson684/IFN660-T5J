// tests file for if statement
public class HelloWorld
{
	public void Main (String[] args)
	{
		int i, j;
		i = 0;

		if (i > 5)
		    j = 10;

		if (i < 4)
		{
			i = i + 1;
			j = i;
		}
		else if (i == 4)
		{
			i = j;
			j = 3;
		}
		else
		{
			i = j;
			j = 6;
		}
	}
}