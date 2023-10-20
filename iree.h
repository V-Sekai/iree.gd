#ifndef IREE_H
#define IREE_H

#include "core/object/ref_counted.h"

class Iree : public RefCounted {
	GDCLASS(Iree, RefCounted);
    
protected:
	static void _bind_methods() {}

public:

	Iree() {}
};

#endif // IREE_H