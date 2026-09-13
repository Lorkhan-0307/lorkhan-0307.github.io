const fs = require('fs');
const DIST_PATH = '_sass/dist';

fs.rmSync(DIST_PATH, { recursive: true, force: true });
fs.mkdirSync(DIST_PATH, { recursive: true });

module.exports = {
  content: ['_includes/**/*.html', '_layouts/**/*.html', '_javascript/**/*.js'],
  css: ['node_modules/bootstrap/dist/css/bootstrap.min.css'],
  keyframes: true,
  variables: true,
  output: `${DIST_PATH}/bootstrap.css`,
  // The `safelist` should be changed appropriately for future development
  safelist: {
    standard: [/^collaps/, /^w-/, 'shadow', 'border', 'kbd'],
    greedy: [/^col-/, /tooltip/]
  }
};
