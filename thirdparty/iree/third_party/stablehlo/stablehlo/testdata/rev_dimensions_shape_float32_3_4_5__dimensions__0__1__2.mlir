// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4x5xf32>
    %1 = call @expected() : () -> tensor<3x4x5xf32>
    %2 = stablehlo.reverse %0, dims = [0, 1, 2] : tensor<3x4x5xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x4x5xf32>, tensor<3x4x5xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4x5xf32> {
    %0 = stablehlo.constant dense<[[[-1.39323878, -2.07355523, 3.61496592, -1.41638482, 4.3499279], [4.61657476, -0.847035408, 0.39680019, 4.4041729, 3.43903923], [-1.1432842, 2.33014345, -4.82425261, -1.52138329, 8.390310e+00], [0.895365178, -1.7085067, -1.49679315, 0.981733798, -2.47507167]], [[-3.56485152, -2.95351219, 1.17888641, 1.69931138, -0.0145214852], [1.68052375, 2.70574522, -1.23294461, -1.20053291, -3.10411549], [-0.671810328, 2.47057939, 1.90365231, -0.240815163, -5.70334673], [5.26833439, -2.79723477, -2.1762886, -1.09088278, -0.494020909]], [[2.68829536, 1.48864734, -2.68438172, 4.32412481, -6.42869281], [5.74774504, 0.600558162, -3.89856243, -2.57673311, 2.84599566], [2.61949801, -1.06490338, 3.48048162, -2.98022199, 0.0734020919], [2.57875085, 3.73390079, -3.21010566, 2.22122025, -3.73207211]]]> : tensor<3x4x5xf32>
    return %0 : tensor<3x4x5xf32>
  }
  func.func private @expected() -> tensor<3x4x5xf32> {
    %0 = stablehlo.constant dense<[[[-3.73207211, 2.22122025, -3.21010566, 3.73390079, 2.57875085], [0.0734020919, -2.98022199, 3.48048162, -1.06490338, 2.61949801], [2.84599566, -2.57673311, -3.89856243, 0.600558162, 5.74774504], [-6.42869281, 4.32412481, -2.68438172, 1.48864734, 2.68829536]], [[-0.494020909, -1.09088278, -2.1762886, -2.79723477, 5.26833439], [-5.70334673, -0.240815163, 1.90365231, 2.47057939, -0.671810328], [-3.10411549, -1.20053291, -1.23294461, 2.70574522, 1.68052375], [-0.0145214852, 1.69931138, 1.17888641, -2.95351219, -3.56485152]], [[-2.47507167, 0.981733798, -1.49679315, -1.7085067, 0.895365178], [8.390310e+00, -1.52138329, -4.82425261, 2.33014345, -1.1432842], [3.43903923, 4.4041729, 0.39680019, -0.847035408, 4.61657476], [4.3499279, -1.41638482, 3.61496592, -2.07355523, -1.39323878]]]> : tensor<3x4x5xf32>
    return %0 : tensor<3x4x5xf32>
  }
}
