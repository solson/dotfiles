import { assertEquals } from "https://deno.land/std/testing/asserts.ts";
import { divmod, polymod, format_duration } from "./lib.ts";

Deno.test({
  name: "divmod",
  fn(): void {
    assertEquals(divmod(25, 7), [3, 4]);
  },
});

Deno.test({
  name: "polymod",
  fn(): void {
    assertEquals(polymod(12345, [10, 10, 10, 10]), [5, 4, 3, 2, 1]);
    assertEquals(polymod(42, [2, 2, 2, 2, 2]), [0, 1, 0, 1, 0, 1]);
    assertEquals(polymod(123456789, [1000, 60, 60, 24]), [789, 36, 17, 10, 1]);
  },
});

Deno.test({
  name: "format_duration",
  fn(): void {
    assertEquals(format_duration(123456789), "1d 10h 17m 36s");
  },
});
