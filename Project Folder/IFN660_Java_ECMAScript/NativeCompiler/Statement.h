#pragma once
#include "Expression.h"

#include <vector>

using namespace std;

class Statement : public Node
{
};

class IfStatement : public Statement
{
private:
	Expression *cond;
	Statement *thenStmt, *elseStmt;
public:
	IfStatement(Expression *cond, Statement *thenStmt, Statement *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) 
	{ 
	};

	void dump(int indent)
	{
		label(indent, "IfStatement\n");
		cond->dump(indent+1, "cond");
		thenStmt->dump(indent+1, "then");
		elseStmt->dump(indent+1, "else");
	}
	
	void ResolveNames(LexicalScope* scope)
	{
		cond->ResolveNames(scope);
		thenStmt->ResolveNames(scope);
		elseStmt->ResolveNames(scope);
	}

	void TypeCheck()
	{
		cond->TypeCheck();
		if (!cond->type->Equal(new BoolType()))
		{
			fprintf(stderr, "Invalid type for if statement condition\n");
			throw new std::exception("TypeCheck error");
		}
		thenStmt->TypeCheck();
		elseStmt->TypeCheck();
	}
};

class ExpressionStatement : public Statement
{
private:
	Expression *expr;
public:
	ExpressionStatement(Expression *expr) : expr(expr) 
	{ 
	};

	void dump(int indent)
	{
		label(indent, "ExpressionStatement\n");
		expr->dump(indent+1);
	}

	void ResolveNames(LexicalScope* scope)
	{
		expr->ResolveNames(scope);
	}

	void TypeCheck()
	{
		expr->TypeCheck();
	}
};

class VariableDeclaration : public Statement, public Declaration
{
private:
	Type *type;
	std::string name;
public:
	VariableDeclaration(Type *type, std::string name) : type(type), name(name) 
	{ 
	}

	void dump(int indent)
	{
		label(indent, "%p: VariableDeclaration %s\n", (Declaration*)this, name.c_str());
		type->dump(indent + 1);
	}

	std::string GetName()
	{
		return name;
	}

	Type* GetType()
	{
		return type;
	}

	void ResolveNames(LexicalScope* scope)
	{
		type->ResolveNames(scope);
	}

	void TypeCheck()
	{
		type->TypeCheck();
	}
};

class CompoundStatement : public Statement, public LexicalScope
{
private:
	vector<Statement*> *stmts;
public:
	CompoundStatement(vector<Statement*> *stmts) : stmts(stmts) 
	{ 
	};

	void dump(int indent)
	{
		label(indent, "CompoundStatement\n");
		for (std::vector<Statement*>::iterator iter = stmts->begin(); iter != stmts->end(); ++iter)
			(*iter)->dump(indent+1); 
	}

	void ResolveNames(LexicalScope* scope)
	{
		this->parentScope = scope;

		// Add local variable declarations to the symbol table for this lexical scope
		for (std::vector<Statement*>::iterator child = stmts->begin(); child != stmts->end(); ++child)
		{
			Declaration *decl = dynamic_cast<Declaration*>(*child);
			if (decl != NULL)
				symbol_table[decl->GetName()] = decl;
		}

		for (std::vector<Statement*>::iterator child = stmts->begin(); child != stmts->end(); ++child)
			(*child)->ResolveNames(this);
	}

	void TypeCheck()
	{
		for (std::vector<Statement*>::iterator child = stmts->begin(); child != stmts->end(); ++child)
			(*child)->TypeCheck();
	}
};