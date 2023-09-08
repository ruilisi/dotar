#!/usr/bin/env zx

const content = argv._[0];
let { b, since = 200 } = argv
if (!b) {
	b = (await $`git branch --show-current`).stdout.trim()
}

$.verbose = false;

for (let i = 0; i < since; i++) {
  const { stdout, stderr } = await $`git show ${b}~${i} | grep ${content} || true`;
  if (stdout.length !== 0) {
    echo(`${b}~${i}\n${stdout}`);
  }
  if (stderr.length !== 0) {
    break;
  }
}
