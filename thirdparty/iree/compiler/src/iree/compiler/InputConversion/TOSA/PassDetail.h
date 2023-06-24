// Copyright 2021 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_COMPILER_INPUTCONVERSION_TOSA_PASSDETAIL_H_
#define IREE_COMPILER_INPUTCONVERSION_TOSA_PASSDETAIL_H_

#include "iree-dialects/Dialect/LinalgExt/IR/LinalgExtDialect.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace iree_compiler {

#define GEN_PASS_CLASSES
#include "iree/compiler/InputConversion/TOSA/Passes.h.inc"

} // namespace iree_compiler
} // namespace mlir

#endif // IREE_COMPILER_INPUTCONVERSION_TOSA_PASSDETAIL_H_
