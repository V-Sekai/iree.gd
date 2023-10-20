// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<7x3x4xf32>, tensor<7x4xf32>)
    %1 = call @expected() : () -> tensor<7x3xf32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_batching_dimensions = [0], rhs_batching_dimensions = [0], lhs_contracting_dimensions = [2], rhs_contracting_dimensions = [1]>} : (tensor<7x3x4xf32>, tensor<7x4xf32>) -> tensor<7x3xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<7x3xf32>, tensor<7x3xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<7x3x4xf32>, tensor<7x4xf32>) {
    %0 = stablehlo.constant dense<[[[-1.55481946, -2.84300208, 0.130727246, -5.37463331], [6.66709518, 2.43167925, 3.84036207, 1.72203171], [2.28491235, -2.59345341, -5.74870396, 1.13241291]], [[3.51428676, 2.11786175, 2.74339271, -4.60666561], [2.35853601, 2.48051023, 1.31201625, -0.999869346], [0.124757007, -5.970819, -2.01327014, 2.19010305]], [[-0.955281555, 0.124370761, -1.15590656, 7.365260e+00], [1.34801543, 4.10404158, 0.668308317, -3.24482584], [4.13807964, -2.23407316, -1.28717101, -6.15596914]], [[2.11344457, 2.81456399, 2.51489782, 1.06386888], [-3.30785418, -1.16936183, -0.460092366, -5.6397028], [-4.824150e+00, 4.43334723, -3.3660388, -0.344859332]], [[1.03909051, -1.66122365, 3.03408194, -0.690698146], [2.01606584, -0.180769563, -2.47521567, 0.760841727], [5.13301516, -4.57306099, -2.61753654, -0.181964964]], [[1.1066184, 5.85380602, -5.27273464, 0.751095354], [-3.67786407, 2.64520931, 2.22783017, -4.61741352], [0.729759633, -0.61146003, -1.45802653, 1.28698456]], [[3.11535406, -1.13828278, 2.18271208, -0.991719305], [4.06768799, -2.17965627, -1.70946264, 3.91555405], [1.48111594, -1.52553177, 1.34009528, 0.594984293]]]> : tensor<7x3x4xf32>
    %1 = stablehlo.constant dense<[[0.675175189, -4.33863735, 1.33903289, 0.891059279], [-6.72175169, -2.56142187, -5.99034643, -2.68342233], [2.07608056, 9.452210e-02, 0.193092689, 2.04242158], [0.473974138, 1.10980368, -3.32067275, -2.74698329], [-0.406609803, -3.41262746, -2.752960e+00, -2.76916671], [1.8181572, 2.6974318, -0.816533684, -0.791226446], [3.50465369, -2.72822666, -0.372476548, -3.53888774]]> : tensor<7x4xf32>
    return %0, %1 : tensor<7x3x4xf32>, tensor<7x4xf32>
  }
  func.func private @expected() -> tensor<7x3xf32> {
    %0 = stablehlo.constant dense<[[6.67091083, 0.628086448, 6.10611343], [-33.1191444, -27.3834877, 20.6384144], [12.8482838, -3.31174588, -4.44181108], [-7.14825153, 14.1543865, 14.7584591], [-1.19341481, 4.50441933, 21.2288837], [21.5133266, 2.2826581, -0.150322422], [16.7203045, 6.98246241, 6.74805784]]> : tensor<7x3xf32>
    return %0 : tensor<7x3xf32>
  }
}

