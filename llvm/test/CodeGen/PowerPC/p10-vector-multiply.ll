; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s

; This test case aims to test the vector multiply instructions on Power10.

define <2 x i64> @test_vmulld(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test_vmulld:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmulld v2, v3, v2
; CHECK-NEXT:    blr
entry:
  %mul = mul <2 x i64> %b, %a
  ret <2 x i64> %mul
}
