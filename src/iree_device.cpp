#include "iree_device.h"

#include <iree/hal/drivers/local_task/task_device.h>
#include <iree/hal/local/executable_loader.h>
#include <iree/hal/local/loaders/embedded_elf_loader.h>
#include <iree/task/api.h>
#include <iree/modules/hal/module.h>

#include <godot_cpp/core/error_macros.hpp>

#define IREE_MAX_EXECUTOR_COUNT 8

using namespace godot;

Error IREEDevice::catch_device(iree_vm_instance_t* p_instance) {
    Error e = OK;
    iree_string_view_t id = iree_make_cstring_view("local-task");
    iree_hal_executable_loader_t* loader = nullptr;
    iree_task_executor_t* executors[IREE_MAX_EXECUTOR_COUNT] = {0};
    iree_host_size_t executor_count = 0;
    iree_hal_allocator_t* device_allocator = nullptr;
    iree_hal_device_t* new_device = nullptr;
    iree_vm_module_t* new_hal_module = nullptr;
    iree_hal_task_device_params_t params;

    iree_hal_task_device_params_initialize(&params);

    // Create loader.
    ERR_FAIL_COND_V_MSG(iree_hal_embedded_elf_loader_create(
        /*plugin_manager=*/{0}, iree_allocator_system(), &loader
    ), ERR_CANT_CREATE, "Unable to create loader for CPU task.");

    // Create executors.
    if(iree_task_executors_create_from_flags(
        iree_allocator_system(), IREE_ARRAYSIZE(executors), executors, &executor_count
    )) {
        e = ERR_CANT_CREATE;
        ERR_PRINT("Unable to create CPU executor.");
        goto clean_up_loader;
    }

    // Create device allocator.
    if(iree_hal_allocator_create_heap(
        id, iree_allocator_system(),
        iree_allocator_system(), &device_allocator
    )) {
        e = ERR_CANT_CREATE;
        ERR_PRINT("Unable to create CPU device allocator.");
        goto clean_up_executors;
    }
    

    // Create the device.
    if(iree_hal_task_device_create(
        id, &params, executor_count, executors,
        /*loader_count=*/1, &loader, device_allocator, iree_allocator_system(),
        &new_device
    )) {
        e = ERR_CANT_CREATE;
        ERR_PRINT("Unable to capture CPU device.");
        goto clean_up_device_allocator;
    }

    goto create_hal_module;

clean_up_device_allocator:
    iree_hal_allocator_release(device_allocator);
clean_up_executors:
    for(iree_host_size_t i = 0; i < executor_count; i++)
        iree_task_executor_release(executors[i]);
clean_up_loader:
    iree_hal_executable_loader_release(loader);

    return e;

create_hal_module:
    // Create hal module.
    if(iree_hal_module_create(
        p_instance, new_device, IREE_HAL_MODULE_FLAG_SYNCHRONOUS,
        iree_allocator_system(), &new_hal_module
    )) {
        iree_hal_device_release(new_device);
        ERR_PRINT("Unable to create HAL module of the device.");
        return ERR_CANT_CREATE;
    }

    device = new_device;
    hal_module = new_hal_module;

    return OK;
}

void IREEDevice::release_device() {
    if(hal_module != nullptr) {iree_vm_module_release(hal_module); hal_module = nullptr;}
    if(device != nullptr) {iree_hal_device_release(device); device = nullptr;}
}

IREEDevice::IREEDevice()
:
    device(nullptr),
    hal_module(nullptr)
{}

IREEDevice::~IREEDevice() { release_device(); }