const url = "https://channels.nixos.org/nixos-unstable/packages.json.br";
const watchedPackages = ["babashka", "deno", "keepassxc", "neovim", "firefox"];

const { packages } = await fetch(url).then((r) => r.json());

for (const p of watchedPackages) {
  console.log("%s: %s", p, packages[p].version);
}
