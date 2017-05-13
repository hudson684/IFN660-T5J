// tests file for try statement
public class HelloWorld
{
	public void Main (String[] args)
	{
		int i, j;
		i = 0;

		try {
		    i = 1;
		} catch () {
			i = 2;
		} finally {
			i = 3;
		}

	}
}