; LLVM IR for the test can be generated by SYCL Clang Compiler -
; see https://github.com/intel/llvm
; SYCL source code can be found below:

; struct st {
;   int a;
;   float b;
; };
;
; union un {
;   int a;
;   char c[4];
; };
;
; class A {
; public:
;   A(int a) {
;     m_val = a;
;   }
;   A(const A &a) {
;     m_val = a.m_val;
;   }
; private:
;     int m_val;
; };
;
; typedef int myInt;

; void foo() {
;   int a=123;
;   myInt myA = 321;
;   int b = __builtin_intel_fpga_reg(a);
;   int myB = __builtin_intel_fpga_reg(myA);
;   int c = __builtin_intel_fpga_reg(2.0f);
;   int d = __builtin_intel_fpga_reg( __builtin_intel_fpga_reg( b+12 ));
;   int e = __builtin_intel_fpga_reg( __builtin_intel_fpga_reg( a+b ));
;   int f;
;   f = __builtin_intel_fpga_reg(a);
;
;   struct st i = {1, 5.0f};
;   struct st i2 = i;
;   struct st ii = __builtin_intel_fpga_reg(i);
;   struct st iii;
;   iii = __builtin_intel_fpga_reg(ii);
;
;   struct st *iiii = __builtin_intel_fpga_reg(&iii);
;
;   union un u1 = {1};
;   union un u2, *u3;
;   u2 = __builtin_intel_fpga_reg(u1);
;
;   u3 = __builtin_intel_fpga_reg(&u2);
;
;   A ca(213);
;   A cb = __builtin_intel_fpga_reg(ca);

; RUN: llvm-as %s -o %t.bc
; FIXME: add more negative test cases
; RUN: llvm-spirv %t.bc --spirv-ext=+SPV_INTEL_fpga_reg -o %t.spv
; RUN: llvm-spirv %t.spv -to-text -o %t.spt
; RUN: FileCheck < %t.spt %s --check-prefix=CHECK-SPIRV

; RUN: llvm-spirv -r %t.spv -o %t.rev.bc
; RUN: llvm-dis < %t.rev.bc | FileCheck %s --check-prefix=CHECK-LLVM

; CHECK-SPIRV: Capability FPGARegINTEL
; CHECK-SPIRV: Extension "SPV_INTEL_fpga_reg"

; CHECK-SPIRV-DAG: TypeInt [[TYPE_INT64:[0-9]+]] 64 0
; CHECK-SPIRV-DAG: TypeInt [[TYPE_INT32:[0-9]+]] 32 0
; CHECK-SPIRV-DAG: TypeInt [[TYPE_INT8:[0-9]+]] 8 0
; CHECK-SPIRV-DAG: TypePointer [[TYPE_PTR:[0-9]+]] 7 [[TYPE_INT8]]{{ *$}}

; CHECK-LLVM-DAG: @[[STR:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR1:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR2:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR3:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR4:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR5:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR6:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR7:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR8:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR9:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR10:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR11:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR12:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR13:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg
; CHECK-LLVM-DAG: @[[STR14:[0-9]+]] = {{.*}}__builtin_intel_fpga_reg

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir64-unknown-linux-sycldevice"

%struct._ZTS2st.st = type { i32, float }
%union._ZTS2un.un = type { i32 }
%"class._ZTSZ4mainE3$_0.anon" = type { i8 }
%class._ZTS1A.A = type { i32 }

$_ZN1AC1Ei = comdat any

$_ZN1AC2Ei = comdat any

@.str = private unnamed_addr constant [25 x i8] c"__builtin_intel_fpga_reg\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [9 x i8] c"test.cpp\00", section "llvm.metadata"
@__const._Z3foov.i = private unnamed_addr constant %struct._ZTS2st.st { i32 1, float 5.000000e+00 }, align 4
@__const._Z3foov.u1 = private unnamed_addr constant %union._ZTS2un.un { i32 1 }, align 4

; Function Attrs: nounwind
define spir_kernel void @_ZTSZ4mainE11fake_kernel() #0 !kernel_arg_addr_space !4 !kernel_arg_access_qual !4 !kernel_arg_type !4 !kernel_arg_base_type !4 !kernel_arg_type_qual !4 {
entry:
  %0 = alloca %"class._ZTSZ4mainE3$_0.anon", align 1
  %1 = bitcast %"class._ZTSZ4mainE3$_0.anon"* %0 to i8*
  call void @llvm.lifetime.start.p0i8(i64 1, i8* %1) #4
  %2 = addrspacecast %"class._ZTSZ4mainE3$_0.anon"* %0 to %"class._ZTSZ4mainE3$_0.anon" addrspace(4)*
  call spir_func void @"_ZZ4mainENK3$_0clEv"(%"class._ZTSZ4mainE3$_0.anon" addrspace(4)* %2)
  %3 = bitcast %"class._ZTSZ4mainE3$_0.anon"* %0 to i8*
  call void @llvm.lifetime.end.p0i8(i64 1, i8* %3) #4
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inlinehint nounwind
define internal spir_func void @"_ZZ4mainENK3$_0clEv"(%"class._ZTSZ4mainE3$_0.anon" addrspace(4)* %this) #2 align 2 {
entry:
  %this.addr = alloca %"class._ZTSZ4mainE3$_0.anon" addrspace(4)*, align 8
  store %"class._ZTSZ4mainE3$_0.anon" addrspace(4)* %this, %"class._ZTSZ4mainE3$_0.anon" addrspace(4)** %this.addr, align 8, !tbaa !5
  %this1 = load %"class._ZTSZ4mainE3$_0.anon" addrspace(4)*, %"class._ZTSZ4mainE3$_0.anon" addrspace(4)** %this.addr, align 8
  call spir_func void @_Z3foov()
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind
define spir_func void @_Z3foov() #3 {
entry:
  %a = alloca i32, align 4
  %myA = alloca i32, align 4
  %b = alloca i32, align 4
  %myB = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  %e = alloca i32, align 4
  %f = alloca i32, align 4
  %i = alloca %struct._ZTS2st.st, align 4
  %i2 = alloca %struct._ZTS2st.st, align 4
  %ii = alloca %struct._ZTS2st.st, align 4
  %agg-temp = alloca %struct._ZTS2st.st, align 4
  %iii = alloca %struct._ZTS2st.st, align 4
  %ref.tmp = alloca %struct._ZTS2st.st, align 4
  %agg-temp2 = alloca %struct._ZTS2st.st, align 4
  %iiii = alloca %struct._ZTS2st.st addrspace(4)*, align 8
  %u1 = alloca %union._ZTS2un.un, align 4
  %u2 = alloca %union._ZTS2un.un, align 4
  %u3 = alloca %union._ZTS2un.un addrspace(4)*, align 8
  %ref.tmp3 = alloca %union._ZTS2un.un, align 4
  %agg-temp4 = alloca %union._ZTS2un.un, align 4
  %ca = alloca %class._ZTS1A.A, align 4
  %cb = alloca %class._ZTS1A.A, align 4
  %agg-temp5 = alloca %class._ZTS1A.A, align 4
  %ap = alloca i32 addrspace(4)*, align 8
  %bp = alloca i32 addrspace(4)*, align 8
  %0 = bitcast i32* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %0) #4
  store i32 123, i32* %a, align 4, !tbaa !9
  %1 = bitcast i32* %myA to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %1) #4
  store i32 321, i32* %myA, align 4, !tbaa !9
  %2 = bitcast i32* %b to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %2) #4
  %3 = load i32, i32* %a, align 4, !tbaa !9
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR]]
  %4 = call i32 @llvm.annotation.i32(i32 %3, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 35)
  store i32 %4, i32* %b, align 4, !tbaa !9
  %5 = bitcast i32* %myB to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #4
  %6 = load i32, i32* %myA, align 4, !tbaa !9
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR1]]
  %7 = call i32 @llvm.annotation.i32(i32 %6, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 39)
  store i32 %7, i32* %myB, align 4, !tbaa !9
  %8 = bitcast i32* %c to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #4
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR2]]
  %9 = call i32 @llvm.annotation.i32(i32 1073741824, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 43)
  %10 = bitcast i32 %9 to float
  %conv = fptosi float %10 to i32
  store i32 %conv, i32* %c, align 4, !tbaa !9
  %11 = bitcast i32* %d to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %11) #4
  %12 = load i32, i32* %b, align 4, !tbaa !9
  %add = add nsw i32 %12, 12
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR3]]
  %13 = call i32 @llvm.annotation.i32(i32 %add, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 48)
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR4]]
  %14 = call i32 @llvm.annotation.i32(i32 %13, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 48)
  store i32 %14, i32* %d, align 4, !tbaa !9
  %15 = bitcast i32* %e to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %15) #4
  %16 = load i32, i32* %a, align 4, !tbaa !9
  %17 = load i32, i32* %b, align 4, !tbaa !9
  %add1 = add nsw i32 %16, %17
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR5]]
  %18 = call i32 @llvm.annotation.i32(i32 %add1, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 54)
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR6]]
  %19 = call i32 @llvm.annotation.i32(i32 %18, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 54)
  store i32 %19, i32* %e, align 4, !tbaa !9
  %20 = bitcast i32* %f to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %20) #4
  %21 = load i32, i32* %a, align 4, !tbaa !9
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT32]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i32 @llvm.annotation.i32(i32 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR7]]
  %22 = call i32 @llvm.annotation.i32(i32 %21, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 62)
  store i32 %22, i32* %f, align 4, !tbaa !9
  %23 = bitcast %struct._ZTS2st.st* %i to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %23) #4
  %24 = bitcast %struct._ZTS2st.st* %i to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %24, i8* align 4 bitcast (%struct._ZTS2st.st* @__const._Z3foov.i to i8*), i64 8, i1 false)
  %25 = bitcast %struct._ZTS2st.st* %i2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %25) #4
  %26 = bitcast %struct._ZTS2st.st* %i2 to i8*
  %27 = bitcast %struct._ZTS2st.st* %i to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %26, i8* align 4 %27, i64 8, i1 false), !tbaa.struct !11
  %28 = bitcast %struct._ZTS2st.st* %ii to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %28) #4
  %29 = bitcast %struct._ZTS2st.st* %agg-temp to i8*
  %30 = bitcast %struct._ZTS2st.st* %i to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %29, i8* align 4 %30, i64 8, i1 false), !tbaa.struct !11
  %31 = bitcast %struct._ZTS2st.st* %agg-temp to i8*
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_PTR]]   {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i8* @llvm.ptr.annotation.p0i8(i8* %[[CAST1:[a-z0-9]+]], i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR8]]
  ; CHECK-LLVM-DAG: %[[CAST1]] = bitcast %struct._ZTS2st.st* %agg-temp to i8*
  %32 = call i8* @llvm.ptr.annotation.p0i8(i8* %31, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 69)
  %33 = bitcast i8* %32 to %struct._ZTS2st.st*
  %34 = bitcast %struct._ZTS2st.st* %ii to i8*
  %35 = bitcast %struct._ZTS2st.st* %33 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %34, i8* align 4 %35, i64 8, i1 false)
  %36 = bitcast %struct._ZTS2st.st* %iii to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %36) #4
  %37 = bitcast %struct._ZTS2st.st* %ref.tmp to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %37) #4
  %38 = bitcast %struct._ZTS2st.st* %agg-temp2 to i8*
  %39 = bitcast %struct._ZTS2st.st* %ii to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %38, i8* align 4 %39, i64 8, i1 false), !tbaa.struct !11
  %40 = bitcast %struct._ZTS2st.st* %agg-temp2 to i8*
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_PTR]]   {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i8* @llvm.ptr.annotation.p0i8(i8* %[[CAST2:[a-z0-9]+]], i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR9]]
  ; CHECK-LLVM-DAG: %[[CAST2]] = bitcast %struct._ZTS2st.st* %agg-temp2 to i8*
  %41 = call i8* @llvm.ptr.annotation.p0i8(i8* %40, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 80)
  %42 = bitcast i8* %41 to %struct._ZTS2st.st*
  %43 = bitcast %struct._ZTS2st.st* %ref.tmp to i8*
  %44 = bitcast %struct._ZTS2st.st* %42 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %43, i8* align 4 %44, i64 8, i1 false)
  %45 = bitcast %struct._ZTS2st.st* %iii to i8*
  %46 = bitcast %struct._ZTS2st.st* %ref.tmp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %45, i8* align 4 %46, i64 8, i1 false), !tbaa.struct !11
  %47 = bitcast %struct._ZTS2st.st* %ref.tmp to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %47) #4
  %48 = bitcast %struct._ZTS2st.st addrspace(4)** %iiii to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %48) #4
  %49 = ptrtoint %struct._ZTS2st.st* %iii to i64
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT64]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i64 @llvm.annotation.i64(i64 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR10]]
  %50 = call i64 @llvm.annotation.i64(i64 %49, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 94)
  %51 = inttoptr i64 %50 to %struct._ZTS2st.st*
  %52 = addrspacecast %struct._ZTS2st.st* %51 to %struct._ZTS2st.st addrspace(4)*
  store %struct._ZTS2st.st addrspace(4)* %52, %struct._ZTS2st.st addrspace(4)** %iiii, align 8, !tbaa !5
  %53 = bitcast %union._ZTS2un.un* %u1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %53) #4
  %54 = bitcast %union._ZTS2un.un* %u1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %54, i8* align 4 bitcast (%union._ZTS2un.un* @__const._Z3foov.u1 to i8*), i64 4, i1 false)
  %55 = bitcast %union._ZTS2un.un* %u2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %55) #4
  %56 = bitcast %union._ZTS2un.un addrspace(4)** %u3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %56) #4
  %57 = bitcast %union._ZTS2un.un* %ref.tmp3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %57) #4
  %58 = bitcast %union._ZTS2un.un* %agg-temp4 to i8*
  %59 = bitcast %union._ZTS2un.un* %u1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %58, i8* align 4 %59, i64 4, i1 false), !tbaa.struct !14
  %60 = bitcast %union._ZTS2un.un* %agg-temp4 to i8*
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_PTR]]   {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i8* @llvm.ptr.annotation.p0i8(i8* %[[CAST4:[a-z0-9]+]], i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR11]]
  ; CHECK-LLVM-DAG: %[[CAST4]] = bitcast %union._ZTS2un.un* %agg-temp4 to i8*
  %61 = call i8* @llvm.ptr.annotation.p0i8(i8* %60, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 103)
  %62 = bitcast i8* %61 to %union._ZTS2un.un*
  %63 = bitcast %union._ZTS2un.un* %ref.tmp3 to i8*
  %64 = bitcast %union._ZTS2un.un* %62 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %63, i8* align 4 %64, i64 8, i1 false)
  %65 = bitcast %union._ZTS2un.un* %u2 to i8*
  %66 = bitcast %union._ZTS2un.un* %ref.tmp3 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %65, i8* align 4 %66, i64 4, i1 false), !tbaa.struct !14
  %67 = bitcast %union._ZTS2un.un* %ref.tmp3 to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %67) #4
  %68 = ptrtoint %union._ZTS2un.un* %u2 to i64
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT64]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i64 @llvm.annotation.i64(i64 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR12]]
  %69 = call i64 @llvm.annotation.i64(i64 %68, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 117)
  %70 = inttoptr i64 %69 to %union._ZTS2un.un*
  %71 = addrspacecast %union._ZTS2un.un* %70 to %union._ZTS2un.un addrspace(4)*
  store %union._ZTS2un.un addrspace(4)* %71, %union._ZTS2un.un addrspace(4)** %u3, align 8, !tbaa !5
  %72 = bitcast %class._ZTS1A.A* %ca to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %72) #4
  %73 = addrspacecast %class._ZTS1A.A* %ca to %class._ZTS1A.A addrspace(4)*
  call spir_func void @_ZN1AC1Ei(%class._ZTS1A.A addrspace(4)* %73, i32 213)
  %74 = bitcast %class._ZTS1A.A* %cb to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %74) #4
  %75 = bitcast %class._ZTS1A.A* %agg-temp5 to i8*
  %76 = bitcast %class._ZTS1A.A* %ca to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %75, i8* align 4 %76, i64 4, i1 false), !tbaa.struct !16
  %77 = bitcast %class._ZTS1A.A* %agg-temp5 to i8*
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_PTR]]   {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i8* @llvm.ptr.annotation.p0i8(i8* %[[CAST5:[a-z0-9]+]], i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR13]]
  ; CHECK-LLVM-DAG: %[[CAST5]] = bitcast %class._ZTS1A.A* %agg-temp5 to i8*
  %78 = call i8* @llvm.ptr.annotation.p0i8(i8* %77, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 125)
  %79 = bitcast i8* %78 to %class._ZTS1A.A*
  %80 = bitcast %class._ZTS1A.A* %cb to i8*
  %81 = bitcast %class._ZTS1A.A* %79 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %80, i8* align 4 %81, i64 8, i1 false)
  %82 = bitcast i32 addrspace(4)** %ap to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %82) #4
  %83 = addrspacecast i32* %a to i32 addrspace(4)*
  store i32 addrspace(4)* %83, i32 addrspace(4)** %ap, align 8, !tbaa !5
  %84 = bitcast i32 addrspace(4)** %bp to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %84) #4
  %85 = load i32 addrspace(4)*, i32 addrspace(4)** %ap, align 8, !tbaa !5
  %86 = ptrtoint i32 addrspace(4)* %85 to i64
  ; CHECK-SPIRV: FPGARegINTEL [[TYPE_INT64]] {{[0-9]+}} {{[0-9]+}}{{ *$}}
  ; CHECK-LLVM-DAG: %{{[0-9]+}} = call i64 @llvm.annotation.i64(i64 {{[%a-z0-9]+}}, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @[[STR14]]
  %87 = call i64 @llvm.annotation.i64(i64 %86, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i32 0, i32 0), i32 137)
  %88 = inttoptr i64 %87 to i32 addrspace(4)*
  store i32 addrspace(4)* %88, i32 addrspace(4)** %bp, align 8, !tbaa !5
  %89 = bitcast i32 addrspace(4)** %bp to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %89) #4
  %90 = bitcast i32 addrspace(4)** %ap to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %90) #4
  %91 = bitcast %class._ZTS1A.A* %cb to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %91) #4
  %92 = bitcast %class._ZTS1A.A* %ca to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %92) #4
  %93 = bitcast %union._ZTS2un.un addrspace(4)** %u3 to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %93) #4
  %94 = bitcast %union._ZTS2un.un* %u2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %94) #4
  %95 = bitcast %union._ZTS2un.un* %u1 to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %95) #4
  %96 = bitcast %struct._ZTS2st.st addrspace(4)** %iiii to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %96) #4
  %97 = bitcast %struct._ZTS2st.st* %iii to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %97) #4
  %98 = bitcast %struct._ZTS2st.st* %ii to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %98) #4
  %99 = bitcast %struct._ZTS2st.st* %i2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %99) #4
  %100 = bitcast %struct._ZTS2st.st* %i to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %100) #4
  %101 = bitcast i32* %f to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %101) #4
  %102 = bitcast i32* %e to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %102) #4
  %103 = bitcast i32* %d to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %103) #4
  %104 = bitcast i32* %c to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %104) #4
  %105 = bitcast i32* %myB to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %105) #4
  %106 = bitcast i32* %b to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %106) #4
  %107 = bitcast i32* %myA to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %107) #4
  %108 = bitcast i32* %a to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %108) #4
  ret void
}

; Function Attrs: nounwind
declare i32 @llvm.annotation.i32(i32, i8*, i8*, i32) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #1

; Function Attrs: nounwind
declare i8* @llvm.ptr.annotation.p0i8(i8*, i8*, i8*, i32) #4

; Function Attrs: nounwind
declare i64 @llvm.annotation.i64(i64, i8*, i8*, i32) #4

; Function Attrs: nounwind
define linkonce_odr spir_func void @_ZN1AC1Ei(%class._ZTS1A.A addrspace(4)* %this, i32 %a) unnamed_addr #3 comdat align 2 {
entry:
  %this.addr = alloca %class._ZTS1A.A addrspace(4)*, align 8
  %a.addr = alloca i32, align 4
  store %class._ZTS1A.A addrspace(4)* %this, %class._ZTS1A.A addrspace(4)** %this.addr, align 8, !tbaa !5
  store i32 %a, i32* %a.addr, align 4, !tbaa !9
  %this1 = load %class._ZTS1A.A addrspace(4)*, %class._ZTS1A.A addrspace(4)** %this.addr, align 8
  %0 = load i32, i32* %a.addr, align 4, !tbaa !9
  call spir_func void @_ZN1AC2Ei(%class._ZTS1A.A addrspace(4)* %this1, i32 %0)
  ret void
}

; Function Attrs: nounwind
define linkonce_odr spir_func void @_ZN1AC2Ei(%class._ZTS1A.A addrspace(4)* %this, i32 %a) unnamed_addr #3 comdat align 2 {
entry:
  %this.addr = alloca %class._ZTS1A.A addrspace(4)*, align 8
  %a.addr = alloca i32, align 4
  store %class._ZTS1A.A addrspace(4)* %this, %class._ZTS1A.A addrspace(4)** %this.addr, align 8, !tbaa !5
  store i32 %a, i32* %a.addr, align 4, !tbaa !9
  %this1 = load %class._ZTS1A.A addrspace(4)*, %class._ZTS1A.A addrspace(4)** %this.addr, align 8
  %0 = load i32, i32* %a.addr, align 4, !tbaa !9
  %m_val = getelementptr inbounds %class._ZTS1A.A, %class._ZTS1A.A addrspace(4)* %this1, i32 0, i32 0
  store i32 %0, i32 addrspace(4)* %m_val, align 4, !tbaa !17
  ret void
}

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "uniform-work-group-size"="true" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { inlinehint nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0}
!opencl.spir.version = !{!1}
!spirv.Source = !{!2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, i32 2}
!2 = !{i32 4, i32 100000}
!3 = !{!"clang version 9.0.0"}
!4 = !{}
!5 = !{!6, !6, i64 0}
!6 = !{!"any pointer", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !7, i64 0}
!11 = !{i64 0, i64 4, !9, i64 4, i64 4, !12}
!12 = !{!13, !13, i64 0}
!13 = !{!"float", !7, i64 0}
!14 = !{i64 0, i64 4, !9, i64 0, i64 4, !15}
!15 = !{!7, !7, i64 0}
!16 = !{i64 0, i64 4, !9}
!17 = !{!18, !10, i64 0}
!18 = !{!"_ZTS1A", !10, i64 0}
