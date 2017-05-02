#pragma once
#include <map>
#include "Declaration.h"

class LexicalScope
{
protected:
	LexicalScope* parentScope;
	std::map<std::string, Declaration*> symbol_table;

public:
	LexicalScope()
	{
		parentScope = NULL;
		symbol_table.clear();
	}

	Declaration* ResolveHere(std::string symbol)
	{
		std::map<std::string, Declaration*>::iterator it = symbol_table.find(symbol);
		if (it != symbol_table.end())
			return it->second;
		return NULL;
	}

	Declaration* Resolve(std::string symbol)
	{
		Declaration* local = ResolveHere(symbol);
		if (local != NULL)
			return local;
		else if (parentScope != NULL)
			return parentScope->Resolve(symbol);
		else
			return NULL;
	}
};