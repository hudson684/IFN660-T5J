#pragma once
#include <string>
#include "Type.h"

class Declaration
{
public:
	virtual Type* GetType() = 0;
	virtual std::string GetName() = 0;
};
