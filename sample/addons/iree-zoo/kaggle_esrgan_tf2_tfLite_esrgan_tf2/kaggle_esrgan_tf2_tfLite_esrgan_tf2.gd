@icon("res://addons/iree-gd/logo.svg")
extends IREEModuleRunner
class_name IREEModule_kaggle_esrgan_tf2_tfLite_esrgan_tf2

var module: IREEModule
var thread: Thread

## INPUTS
## input_0: PackedFloat32Array [ 1 50 50  3]
## ---
## OUTPUTS
## Identity: PackedFloat32Array [  1 200 200   3]
func main(inputs: Array[IREETensor]) -> int:
	if module == null:
		match OS.get_name():
			"Windows", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
				module = load("res://addons/iree-zoo/kaggle_esrgan_tf2_tfLite_esrgan_tf2/iree.vulkan-spirv.vmfb")
			"macOS", "iOS":
				module = load("res://addons/iree-zoo/kaggle_esrgan_tf2_tfLite_esrgan_tf2/iree.metal-spirv.vmfb")
			"Android":
				module = load("res://addons/iree-zoo/kaggle_esrgan_tf2_tfLite_esrgan_tf2/iree.llvm-cpu.vmfb")
			_:
				assert(false, "Unsupported platform.")
	return run(module, "module.main", inputs)
