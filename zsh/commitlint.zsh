commitlint_init() {
  yarn add husky @commitlint/{config-conventional,cli} -D
  echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
  yarn husky init
  echo 'yarn commitlint --edit $1' > .husky/commit-msg
}
