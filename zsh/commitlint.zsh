commitlint_init() {
  yarn add husky @commitlint/{config-conventional,cli} -D -W
  echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
  yarn husky install
  yarn husky add .husky/commit-msg 'yarn commitlint --edit $1'
}
