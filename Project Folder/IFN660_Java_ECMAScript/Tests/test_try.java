// tests file for try statement
public class HelloWorld
{
	public void Main (String[] args)
	{
		int i;
		i = 0;

		// Note that with or without finally statement will show an different result
		// However, the results are same to the C# code so the CodeGen for TryStatement works as expected

		//try statement withou finally
		try {
		    i = 1;
			// this part aims to make an error
			while(i > 0)
			{
			    i = i+ 1000000;
			}
		} catch () {
			i = 2;
		}
		System.out.println(i);

		//try statement withou finally
		try {
		    i = 1;
			// this part aims to make an error
			while(i > 0)
			{
			    i = i+ 1000000;
			}
		} catch () {
			i = 2;
		} finally {
			i = 3;
		}
		System.out.println(i);
		
		//try statement withou catch
		try {
		    i = 1;
		} finally {
			i = 3;
		}
		System.out.println(i);
		
		//try statement
		try {
		    i = 1;
		} catch () {
			i = 2;
		} finally {
			i = 3;
		}
		System.out.println(i);

	}
}