#pragma once

#include <stdint.h>

static inline __attribute((always_inline)) uint32_t volatile_load_uint32_t(const volatile uint32_t * _Nonnull source) {
    return *((const volatile uint32_t * _Nonnull) source);
}

static inline __attribute((always_inline)) void volatile_store_uint32_t(volatile uint32_t * _Nonnull destination, uint32_t value) {
    *((volatile uint32_t * _Nonnull) destination) = value;
}

static inline __attribute((always_inline)) void nop() {
    asm volatile("nop");
}
