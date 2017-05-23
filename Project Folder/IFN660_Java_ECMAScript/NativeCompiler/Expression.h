#pragma once
#include "LexicalScope.h"
#include <iostream>

class Expression : public Node
{
public:
	Type* type;
};

class AssignmentExpression : public Expression
{
private:
	Expression *lhs, *rhs;
public:
	AssignmentExpression(Expression *lhs, Expression *rhs) : lhs(lhs), rhs(rhs) { };
	void dump(int indent)
	{
		label(indent, "AssignmentExpression\n");
		type->dump(indent + 1, "type");
		lhs->dump(indent+1, "lhs");
		rhs->dump(indent+1, "rhs");
	}

	void ResolveNames(LexicalScope* scope)
	{
		lhs->ResolveNames(scope);
		rhs->ResolveNames(scope);
	}

	void TypeCheck()
	{
		lhs->TypeCheck();
		rhs->TypeCheck();
		if (!rhs->type->Compatible(lhs->type))
		{
			fprintf(stderr, "type error in assignment\n");
			throw new std::exception("TypeCheck error");
		}
		type = rhs->type;
	}
};

class IdentifierExpression : public Expression
{
private:
	std::string name;
	Declaration* declaration;

public:
	IdentifierExpression(std::string name) : name(name), declaration(NULL) { }

	void dump(int indent)
	{
		if (declaration != NULL)
			label(indent, "IdentifierExpression %s -> %p\n", name.c_str(), declaration);
		else
			label(indent, "IdentifierExpression %s\n", name.c_str());
		type->dump(indent + 1, "type");
	}

	void ResolveNames(LexicalScope *scope)
	{
		if (scope != NULL)
			declaration = scope->Resolve(name);

		if (declaration == NULL)
		{
			fprintf(stderr, "Error: Undeclared identifier %s\n", name.c_str());
			throw new std::exception("Name Resolution error");
		}
	}

	void TypeCheck()
	{
		type = declaration->GetType();
	}
};

class NumberExpression : public Expression
{
private:
	int value;
public:
	NumberExpression(int value) : value(value) { };
	void dump(int indent)
	{
		label(indent, "NumberExpression %d\n", value);
		type->dump(indent + 1, "type");
	}

	void ResolveNames(LexicalScope* scope)
	{
	}

	void TypeCheck()
	{
		type = new IntType();
	}
};

class BinaryExpression : public Expression
{
private:
	char op;
	Expression *lhs, *rhs;
public:
	BinaryExpression(Expression *lhs, char op, Expression *rhs) : lhs(lhs), rhs(rhs), op(op) { };
	void dump(int indent)
	{
		label(indent, "BinaryExpression %c\n", op);
		type->dump(indent + 1, "type");
		lhs->dump(indent+1, "lhs");
		rhs->dump(indent+1, "rhs");
	}

	void ResolveNames(LexicalScope* scope)
	{
		lhs->ResolveNames(scope);
		rhs->ResolveNames(scope);
	}

	void TypeCheck()
	{
		lhs->TypeCheck();
		rhs->TypeCheck();

		switch (op)
		{
		case '<':
			if (!lhs->type->Equal(new IntType()) || !rhs->type->Equal(new IntType()))
			{
				fprintf(stderr, "invalid arguments for less than expression\n");
				throw new std::exception("TypeCheck error");
			}
			type = new BoolType();
			break;
		case '+':
			if (!lhs->type->Equal(new IntType()) || !rhs->type->Equal(new IntType()))
			{
				fprintf(stderr, "invalid arguments for addition expression\n");
				throw new std::exception("TypeCheck error");
			}
			type = new IntType();
			break;
		default:
		{
			fprintf(stderr, "Unexpected binary operator '%c'\n", op);
			throw new std::exception("TypeCheck error");
		}
			break;
		}
	}
};