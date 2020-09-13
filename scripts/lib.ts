export function divmod(x: number, y: number): [number, number] {
  return [Math.trunc(x / y), x % y];
}

// Inspired by https://docs.raku.org/routine/polymod.
export function polymod(x: number, mods: number[]): number[] {
  let more = x;
  let remainders: number[] = [];
  for (const mod of mods) {
    const rem = more % mod;
    remainders.push(rem);
    more -= rem;
    more /= mod;
  }
  remainders.push(more);
  return remainders;
}

export function format_duration(total_ms: number): string {
  const [ms, s, m, h, d] = polymod(total_ms, [1000, 60, 60, 24]);
  const ms_hundreds = Math.round(ms / 100);

  if (d > 0) {
    return `${d}d ${h}h ${m}m ${s}s`;
  } else if (h > 0) {
    return `${h}h ${m}m ${s}s`;
  } else if (m > 0) {
    return `${m}m ${s}s`;
  } else if (ms_hundreds > 0) {
    return `${s}.${ms_hundreds}s`;
  } else {
    return `${s}s`;
  }
}

/**
 * Indicates unfinished code.
 *
 * This can be useful if you are prototyping and are just looking to have your
 * code typecheck.
 */
export function todo(msg?: string): never {
  const err = new Error(
    msg === undefined ? "not yet implemented" : `not yet implemented: ${msg}`,
  );
  // Capture a stack trace from where `todo` was called instead of at the above
  // `Error` constructor.
  Error.captureStackTrace(err, todo);
  throw err;
}

export function once<T>(f: () => T): () => T {
  let cached: T | undefined;
  return () => cached ?? (cached = f());
}
