#ifndef RESOURCE_FORMAT_LOADER_IREE_MODULE_H
#define RESOURCE_FORMAT_LOADER_IREE_MODULE_H

#include "core/io/resource.h"
#include "core/io/resource_loader.h"

class ResourceFormatLoaderIREEModule : public ResourceFormatLoader {
public:
	virtual Ref<Resource> load(const String &p_path, const String &p_original_path = "", Error *r_error = nullptr, bool p_use_sub_threads = false, float *r_progress = nullptr, CacheMode p_cache_mode = CACHE_MODE_REUSE);
	virtual void get_recognized_extensions(List<String> *p_extensions) const;
	virtual bool handles_type(const String &p_type) const;
	virtual String get_resource_type(const String &p_path) const;
};

#endif //RESOURCE_FORMAT_LOADER_IREE_MODULE_H