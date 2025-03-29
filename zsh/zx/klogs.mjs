#!/usr/bin/env zx

$.shell = "/usr/local/bin/zsh";
$.prefix += "source ~/.yadr/zsh/k8s.zsh;";
$.verbose = true;

if (argv.h) {
  console.info(`Usage:
CMD [-h] [-i instance | -d deployment] [-n NAMESPACE] [--tail N] [-f]`);
  process.exit();
}
const { d, _, i, n = "default", tail = 100 } = argv;
if (i) {
  while (true) {
    await $`kubectl logs -f -n ${n} --tail ${tail} -l app.kubernetes.io/instance=${i} 2>&1 || true; sleep 2`;
  }
} else if (d) {
  await `kubectl logs -f deployment/${d} --all-containers=true --since=24h --pod-running-timeout=2s 2>&1`;
}
