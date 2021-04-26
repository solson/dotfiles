import fc from "https://cdn.skypack.dev/fast-check@2.14.0?dts";
import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.95.0/testing/asserts.ts";
import { zip } from "https://deno.land/x/fae@v1.0.0/zip.ts";
import { divmod, format_duration, once, polymod, todo } from "./lib.ts";

// TODO(solson): Is this the definition of divmod that I want?
Deno.test("divmod: basic", () => {
  assertEquals(divmod(25, 7), [3, 4]);
  assertEquals(divmod(-25, 7), [-3, -4]);
  assertEquals(divmod(25, -7), [-3, 4]);
  assertEquals(divmod(-25, -7), [3, -4]);
});

Deno.test("divmod: definition [prop]", () => {
  fc.assert(fc.property(fc.integer(), fc.integer(), (x, y) => {
    fc.pre(y !== 0);
    const [d, m] = divmod(x, y);
    assertEquals(d * y + m, x);
  }));
});

Deno.test("polymod: basic", () => {
  assertEquals(polymod(12345, [10, 10, 10, 10]), [5, 4, 3, 2, 1]);
  assertEquals(polymod(42, [2, 2, 2, 2, 2]), [0, 1, 0, 1, 0, 1]);
  assertEquals(polymod(123456789, [1000, 60, 60, 24]), [789, 36, 17, 10, 1]);
});

Deno.test("polymod: recombine [prop]", () => {
  fc.assert(
    fc.property(fc.integer(), fc.array(fc.integer()), (x, mods) => {
      fc.pre(!mods.includes(0));
      const parts = polymod(x, mods);
      assertEquals(parts.length, mods.length + 1);
      let whole = parts.pop()!;
      for (const [part, mod] of zip(parts, mods).reverse()) {
        whole *= mod;
        whole += part;
      }
      assertEquals(whole, x);
    }),
  );
});

Deno.test("format_duration: basic", () => {
  assertEquals(format_duration(0), "0s");
  assertEquals(format_duration(1234), "1.2s");
  assertEquals(format_duration(123456), "2m 3s");
  assertEquals(format_duration(12345678), "3h 25m 45s");
  assertEquals(format_duration(123456789), "1d 10h 17m 36s");
});

Deno.test("once: basic", () => {
  let counter = 0;
  const f = once(() => ++counter);
  assertEquals(f(), 1);
  assertEquals(f(), 1);
  assertEquals(counter, 1);
});

Deno.test("todo: basic", () => {
  assertThrows(() => todo());
  assertThrows(() => todo("test"));
});
