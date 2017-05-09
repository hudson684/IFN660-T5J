#pragma once
#include <cstdarg>

class LexicalScope;

class Node
{
public:
	virtual void dump(int indent) = 0;
	virtual void ResolveNames(LexicalScope* scope) = 0;
	virtual void TypeCheck() = 0;

	void dump(int i, char* name)
	{
		label(i, "%s:\n", name);
		dump(i + 1);
	}
protected:

	void indent(int N)
	{
		for (int i = 0; i < N; i++)
			printf("    ");
	}
	void label(int i, char* fmt, ...)
	{
		indent(i);
		va_list args;
		va_start(args, fmt);
		vprintf(fmt, args);
		va_end(args);
	}
};
