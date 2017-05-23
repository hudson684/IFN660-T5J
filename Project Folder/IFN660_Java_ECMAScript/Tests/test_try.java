// tests file for try statement
public class HelloWorld
{
	public void Main (String[] args)
	{
		int i;
		i = 0;

		//try statement without finally
		try {
		    i = 1;
			// Throw something
			throw i = 2; // This throw statement is illegal right now 
		} catch () {  // For catch, we keep () here which is diff to the original java
			i = 3;
		}
		System.out.println(i);

		//try statement with finally
		try {
		    i = 1;
		} catch () {
			i = 3;
		} finally {
			i = 4;
		}
		System.out.println(i);

	}
}