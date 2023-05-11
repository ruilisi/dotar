#!/usr/bin/env zx

$.shell = "/usr/local/bin/zsh";
$.prefix += "source ~/.yadr/zsh/k8s.zsh;";
$.verbose = false;

if (argv.h) {
  console.info(`Usage:
CMD [-h] [-i instance] [-f file]`);
  process.exit();
}
const { f, i } = argv;
const pods = (
  await $`kubectl get pods -l app.kubernetes.io/instance=${i} -o custom-columns=":metadata.name"`
).stdout
  .trim()
  .split(/\s+/);
$.verbose = true;
const threads = pods.map((pod) => {
  $`kubectl exec -it ${pod} -- tail -f ${f}`;
});
await Promise.all(threads);
