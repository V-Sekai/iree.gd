#include "register_types.h"


#include "iree_tensor.h"
#include "iree_module.h"
#include "resource_format_loader_iree_module.h"

#include "core/object/class_db.h"
#include "core/io/resource_loader.h"

static Ref<ResourceFormatLoaderIREEModule> resource_loader_iree_module;

void initialize_iree_gd_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	resource_loader_iree_module.instantiate();
	ResourceLoader::add_resource_format_loader(resource_loader_iree_module);
	ClassDB::register_class<IREETensor>();
	ClassDB::register_class<IREEModule>();
}

void uninitialize_iree_gd_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	ResourceLoader::remove_resource_format_loader(resource_loader_iree_module);
	resource_loader_iree_module.unref();
}