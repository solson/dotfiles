#!/usr/bin/env -S deno run
import * as colors from "https://deno.land/std@0.95.0/fmt/colors.ts";

const text = "text";

function print(s: string): void {
  Deno.stdout.writeSync(new TextEncoder().encode(s));
}

type Formatter = (s: string) => string;

type FormatGroup = {
  name: string;
  fmts: Formatter[];
};

const fgs: FormatGroup = {
  name: "plain",
  fmts: [
    (s) => s,
    colors.black,
    colors.red,
    colors.green,
    colors.yellow,
    colors.blue,
    colors.magenta,
    colors.cyan,
    colors.white,
  ],
};

const brightFgs: FormatGroup = {
  name: "bright",
  fmts: [
    (s) => s,
    colors.brightBlack,
    colors.brightRed,
    colors.brightGreen,
    colors.brightYellow,
    colors.brightBlue,
    colors.brightMagenta,
    colors.brightCyan,
    colors.brightWhite,
  ],
};

const boldFgs: FormatGroup = {
  name: "bold",
  fmts: fgs.fmts.map((f) => (s) => colors.bold(f(s))),
};

const dimBoldFgs: FormatGroup = {
  name: "dim bold",
  fmts: boldFgs.fmts.map((f) => (s) => colors.dim(f(s))),
};

const bgs: FormatGroup = {
  name: "plain",
  fmts: [
    colors.bgBlack,
    colors.bgRed,
    colors.bgGreen,
    colors.bgYellow,
    colors.bgBlue,
    colors.bgMagenta,
    colors.bgCyan,
    colors.bgWhite,
  ],
};

const brightBgs: FormatGroup = {
  name: "bright",
  fmts: [
    colors.bgBrightBlack,
    colors.bgBrightRed,
    colors.bgBrightGreen,
    colors.bgBrightYellow,
    colors.bgBrightBlue,
    colors.bgBrightMagenta,
    colors.bgBrightCyan,
    colors.bgBrightWhite,
  ],
};

if (import.meta.main) {
  for (const bgGroup of [bgs, brightBgs]) {
    for (const fgGroup of [fgs, dimBoldFgs, brightFgs, boldFgs]) {
      print(`${fgGroup.name} fg + ${bgGroup.name} bg\n`);
      for (const fg of fgGroup.fmts) {
        print(" ");
        print(fg(text));
        for (const bg of bgGroup.fmts) {
          print(" ");
          print(bg(fg(` ${text} `)));
        }
        print("\n");
      }
      print("\n");
    }
  }
  print(colors.reset(""));
}
