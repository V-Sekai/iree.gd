/* godot-cpp integration testing project.
 *
 * This is free and unencumbered software released into the public domain.
 */

#ifndef IREE_GD_REGISTER_TYPES_H
#define IREE_GD_REGISTER_TYPES_H

#include "modules/register_module_types.h"

void initialize_iree_gd_module(ModuleInitializationLevel p_level);
void uninitialize_iree_gd_module(ModuleInitializationLevel p_level);

#endif // IREE_GD_REGISTER_TYPES_H
