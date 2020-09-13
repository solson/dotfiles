import { assertEquals } from "https://deno.land/std@0.68.0/testing/asserts.ts";
import { assertSafeInt } from "./util.ts";
import { divmod, once, todo } from "../lib.ts";

// Each group represents 60 numbers but is represented by 16 bits. See `non235`.
const NUM_GROUPS = 17000;

/** `isSmallPrime` returns false for any number larger than this. */
export const SMALL_PRIME_LIMIT = 60 * NUM_GROUPS - 1;

// A 16-bit value with all bits set.
const ALL_ONES = 0xFFFF;

// The moduli mod 60 that 2, 3 and 5 do not divide.
//
// Note that there are exactly 16 of these moduli, so they fit in a u16.
// That is, a single u16 can represent a block of 60 numbers.
const non235 = [1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 53, 59];
assertEquals(non235.length, 16);

// A map from numbers in `non235` to their index in `num235`.
const non235Indexes = new Map<number, number>();
for (const [i, n] of non235.entries()) {
  non235Indexes.set(n, i);
}

type BitIndex = {
  group: number;
  bit: number | undefined;
};

function bitIndex(n: number): BitIndex {
  const [group, numInGroup] = divmod(n, 60);
  const bit = non235Indexes.get(numInGroup);
  return { group, bit };
}

function clearBit(primes: Uint16Array, n: number): void {
  const { group, bit } = bitIndex(n);
  if (bit === undefined) return;
  primes[group] &= ALL_ONES ^ (1 << bit);
}

function getBitInner(primes: Uint16Array, group: number, bit: number): boolean {
  return (primes[group] & (1 << bit)) !== 0;
}

function getBit(primes: Uint16Array, i: number): boolean {
  const { group, bit } = bitIndex(i);
  if (bit === undefined) return false;
  return getBitInner(primes, group, bit);
}

function clearComposites(primes: Uint16Array, n: number): void {
  // `n` is prime, so we mark `k*n` as composite for all `k > 1`. However, 2*n,
  // 3*n, 4*n, 5*n, 6*n, etc are not in our table, so we only mark the multiples
  // that are not divisible by 2, 3, or 5.
  outer:
  for (let i = 0;; i++) {
    const base = i * 60 * n;
    for (const d of non235) {
      const m = base + d * n;
      if (n === m) continue;
      if (m > SMALL_PRIME_LIMIT) break outer;
      clearBit(primes, m);
    }
  }
}

// `primes` holds `16 * NUM_GROUPS` bits each representing a number not
// congruent to 2, 3, or 5.
const primes: () => Uint16Array = once(() => {
  // Initialize to all ones (every number marked as prime).
  const primes = new Uint16Array(NUM_GROUPS).fill(0xFFFF);

  // 1 is not prime.
  clearBit(primes, 1);

  outer:
  for (let group = 0;; group++) {
    for (const numInGroup of non235) {
      const n = group * 60 + numInGroup;
      if (n * n > SMALL_PRIME_LIMIT) break outer;
      const bit = non235Indexes.get(numInGroup);
      if (bit === undefined) continue;
      if (getBitInner(primes, group, bit)) {
        clearComposites(primes, n);
      }
    }
  }

  return primes;
});

export function isSmallPrime(n: number): boolean {
  assertSafeInt(n);
  return n === 2 || n === 3 || n === 5 || getBit(primes(), n);
}
