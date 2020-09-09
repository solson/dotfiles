// TODO(solson): This file is mostly a list of snippets from libraries that:
//    1) work out of the box on Deno
//    2) have good TypeScript definitions
//    3) are generally of adequate quality
// They should likely be moved to a more organized format.

// import * as lib from "./lib.ts";
// import { assert } from "https://deno.land/std@0.68.0/testing/asserts.ts";
// const p = console.log;
// function sleep(ms: number) {
//   return new Promise((resolve) => setTimeout(resolve, ms));
// }
// export type AssertEqual<T, Expected> =
//   T extends Expected
//   ? (Expected extends T ? true : never)
//   : never;

// import xs from 'https://cdn.skypack.dev/xstream@^11.12.0?dts';
// const stream = xs.periodic(100)
//   .filter(i => i % 2 === 1)
//   .drop(3)
//   .map(i => i * i)
//   .endWhen(xs.periodic(2000).take(1))
// stream.addListener({
//   next: i => console.log(i),
//   error: err => console.error(err),
//   complete: () => console.log('completed'),
// })

// import { assert, enums, object, number, string, array, StructType } from "https://cdn.skypack.dev/superstruct@^0.10.11?dts";
// const Article = object({
//   id: number(),
//   title: string(),
//   tags: array(enums(['news', 'features'])),
//   author: object({
//     id: number(),
//   }),
// })
// type Article = StructType<typeof Article>;
// const data: unknown = {
//   id: 34,
//   title: 'Hello World',
//   tags: ['news', 'features'],
//   author: {
//     id: 1,
//   },
// }
// assert(data, Article);
// const data_typed: Article = data;
// console.log(data_typed.title);

// import yargs from 'https://deno.land/x/yargs/deno.ts'
// import { Arguments, YargsType } from 'https://deno.land/x/yargs/types.ts'
// yargs()
//   .command('download <files...>', 'download a list of files', (yargs: YargsType) => {
//     return yargs.positional('files', {
//       describe: 'a list of files to do something with'
//     })
//   }, (argv: Arguments) => {
//     console.info(argv)
//   })
//   .strictCommands()
//   .demandCommand(1)
//   .parse(Deno.args)

// import ProgressBar from "https://deno.land/x/progressbar@v0.2.0/progressbar.ts";
// import {
//   percentageWidget,
//   amountWidget,
// } from "https://deno.land/x/progressbar@v0.2.0/widgets.ts";
// const widgets = [percentageWidget, amountWidget];
// const pb = new ProgressBar({ total: 200, widgets });
// for (let i = 0; i < pb.total; i++) {
//   await pb.update(i);
//   await sleep(5);
// }
// await pb.finish();

// import { format_duration } from "./lib.ts";
// import { cac } from "https://cdn.skypack.dev/cac@^6.6.1?dts";
// const cli = cac("util");
// cli
//   .command("fmt-duration <ms>", "Pretty-print a duration given in milliseconds")
//   .action((ms) => console.log(format_duration(ms)));
// cli.help();
// cli.parse();

// import { SmtpClient } from "https://deno.land/x/smtp@v0.5.1/mod.ts";
// const client = new SmtpClient();
// await client.connectTLS({
//   hostname: "smtp.fastmail.com",
//   port: 465,
//   username: "scott@solson.me",
//   password: "[redacted]",
// });
// await client.send({
//   from: "deno-scratch <notify@solson.me>",
//   to: "Scott Olson <scott@solson.me>",
//   subject: "The thing completed successfully.",
//   content: "This is an automated message.",
// });
// await client.close();

// import { YouTube } from "https://deno.land/x/youtube@v0.3.0/mod.ts";

// NOTE(solson): No libreadline, no validation failure messages.
// import Ask from "https://deno.land/x/ask@1.0.5/mod.ts";
// const ask = new Ask(); // global options are also supported! (see below)
// const answers = await ask.prompt([
//   { name: "name", type: "input", message: "Name:" },
//   { name: "age", type: "number", message: "Age:" },
// ]);
// console.log(answers);

// NOTE(solson): Broken. Try after https://github.com/deno-postgres/deno-postgres/issues/169.
// import {
//   DataTypes,
//   Database,
//   Model,
// } from "https://deno.land/x/denodb@v1.0.8/mod.ts";
// // const db = new Database('sqlite3', { filepath: "/music/beets.db" });
// const db = new Database(
//   { dialect: "sqlite3", debug: true },
//   { filepath: "/music/beets.db" },
// );

// import { Evt } from "https://deno.land/x/evt@v1.8.9/mod.ts";
// const evtText = new Evt<string>();
// const evtTime = new Evt<number>();
// evtText.attach(console.log);
// evtTime.attachOnce(console.log);
// evtText.post("hi!");
// evtTime.post(123);
// evtTime.post(1234);

// import { DB } from "https://deno.land/x/sqlite@v2.3.0/mod.ts";
// const db = new DB("/music/beets.db");
// const q = "SELECT albumartist, album, year FROM albums LIMIT 5;";
// for (const row of db.query(q)) {
//   console.log(row);
// }
// db.close();

// import * as tty from "https://deno.land/x/tty@0.1.0/mod.ts";
// let i = 0;
// setInterval(() => {
//   tty.clearScreenSync();
//   tty.goHomeSync();
//   console.log(i++);
// }, 50);

// import * as emoji from "https://deno.land/x/emoji@0.1.1/mod.ts";
// console.log(emoji.get("coffee"));
// console.log(emoji.get(":fast_forward:"));
// console.log(emoji.alias(emoji.get("coffee")));
// console.log(emoji.emojify("I :heart: :coffee:!"));
// console.log(emoji.unemojify("I ❤️ 🍕"));
// console.log(emoji.random());
// console.log(emoji.strip("⚠️ 〰️ 〰️ low disk space"));
// console.log(emoji.replace("⚠️ 〰️ 〰️ low disk space", (emoji) => `${emoji.emoji}:`));
