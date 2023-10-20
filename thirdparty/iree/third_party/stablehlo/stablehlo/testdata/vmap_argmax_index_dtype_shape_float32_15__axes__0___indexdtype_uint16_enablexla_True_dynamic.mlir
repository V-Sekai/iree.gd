// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x15xf32> {mhlo.sharding = ""}) -> tensor<?xui16> {
    %0 = call @argmax(%arg0, %arg1) : (tensor<i64>, tensor<?x15xf32>) -> tensor<?xui16>
    return %0 : tensor<?xui16>
  }
  func.func private @argmax(%arg0: tensor<i64>, %arg1: tensor<?x15xf32>) -> tensor<?xui16> {
    %0 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %1 = stablehlo.reshape %0 : (tensor<i32>) -> tensor<1xi32>
    %2 = stablehlo.constant dense<15> : tensor<1xi32>
    %3 = stablehlo.concatenate %1, %2, dim = 0 : (tensor<1xi32>, tensor<1xi32>) -> tensor<2xi32>
    %4 = stablehlo.dynamic_iota %3, dim = 1 : (tensor<2xi32>) -> tensor<?x15xui16>
    %5 = stablehlo.constant dense<0xFF800000> : tensor<f32>
    %6 = stablehlo.constant dense<0> : tensor<ui16>
    %7:2 = stablehlo.reduce(%arg1 init: %5), (%4 init: %6) across dimensions = [1] : (tensor<?x15xf32>, tensor<?x15xui16>, tensor<f32>, tensor<ui16>) -> (tensor<?xf32>, tensor<?xui16>)
     reducer(%arg2: tensor<f32>, %arg4: tensor<f32>) (%arg3: tensor<ui16>, %arg5: tensor<ui16>)  {
      %8 = stablehlo.compare  GT, %arg2, %arg4,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %9 = stablehlo.compare  NE, %arg2, %arg2,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %10 = stablehlo.or %8, %9 : tensor<i1>
      %11 = stablehlo.compare  EQ, %arg2, %arg4,  FLOAT : (tensor<f32>, tensor<f32>) -> tensor<i1>
      %12 = stablehlo.compare  LT, %arg3, %arg5,  UNSIGNED : (tensor<ui16>, tensor<ui16>) -> tensor<i1>
      %13 = stablehlo.and %11, %12 : tensor<i1>
      %14 = stablehlo.or %10, %13 : tensor<i1>
      %15 = stablehlo.select %10, %arg2, %arg4 : tensor<i1>, tensor<f32>
      %16 = stablehlo.select %14, %arg3, %arg5 : tensor<i1>, tensor<ui16>
      stablehlo.return %15, %16 : tensor<f32>, tensor<ui16>
    }
    return %7#1 : tensor<?xui16>
  }
}

