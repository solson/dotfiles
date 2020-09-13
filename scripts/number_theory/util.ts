export function assertSafeInt(n: number): void {
  if (!Number.isSafeInteger(n)) {
    throw new RangeError(
      `${n} is not a safe integer (see 'Number.isSafeInteger')`,
    );
  }
}
