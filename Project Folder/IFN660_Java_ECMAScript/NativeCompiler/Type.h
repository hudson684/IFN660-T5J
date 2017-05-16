#pragma once
#include "Node.h"

class Type : public Node
{
public:
	bool Compatible(Type* other)
	{
		return Equal(other);
	}

	virtual bool Equal(Type* other) = 0;
};



class IntType : public Type
{
public:
	IntType()
	{
	};

	void dump(int indent)
	{
		label(indent, "IntType\n");
	}

	void ResolveNames(LexicalScope* scope)
	{
	}

	void TypeCheck()
	{
	}

	bool Equal(Type* other)
	{
		return dynamic_cast<IntType*>(other) != NULL;
	}
};


class BoolType : public Type
{
public:
	BoolType() { };
	void dump(int indent)
	{
		label(indent, "BoolType\n");
	}

	void ResolveNames(LexicalScope* scope)
	{
	}

	void TypeCheck()
	{
	}

	bool Equal(Type* other)
	{
		return dynamic_cast<BoolType*>(other) != NULL;
	}
};