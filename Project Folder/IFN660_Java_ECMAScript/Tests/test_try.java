// tests file for try statement
public class HelloWorld
{
	public void Main (String[] args)
	{
		int i, j;
		i = 0;

		//try statement withou finally
		try {
		    i = 1;
		} catch () {
			i = 2;
		}
		
		//try statement withou catch
		try {
		    i = 1;
		} finally {
			i = 3;
		}
		
		//try statement
		try {
		    i = 1;
		} catch () {
			i = 2;
		} finally {
			i = 3;
		}

	}
}