import { todo } from "../lib.ts";
import { assertSafeInt } from "./util.ts";
import { isSmallPrime, SMALL_PRIME_LIMIT } from "./small_primes.ts";

const VERY_SMALL_PRIME_LIMIT = 1000;

export function isPrimeStrongPseudo(n: number): boolean {
  assertSafeInt(n);
  todo();
}

export const isPrime = (() => {
  // TODO(solson): Store only odd primes in the table.
  const N = VERY_SMALL_PRIME_LIMIT;
  const primes = Array<boolean>(N + 1).fill(true);
  primes[0] = false;
  primes[1] = false;

  for (let i = 2; i <= N; i++) {
    if (!primes[i]) continue;
    for (let j = 2 * i; j <= N; j += i) {
      primes[j] = false;
    }
  }

  return function isPrime(n: number): boolean {
    assertSafeInt(n);
    n = Math.abs(n);
    return primes[n] ??
      (n < SMALL_PRIME_LIMIT ? isSmallPrime(n) : isPrimeStrongPseudo(n));
  };
})();
