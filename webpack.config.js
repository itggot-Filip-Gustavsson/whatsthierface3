// webpack.config.js
const path = require('path');

module.exports = {
  entry: './src/index.ts',
  mode: 'development',
  output: {
    filename: '0',
    path: path.resolve(__dirname, 'dist/backend/priv/static')
  },
  resolve: {
      extensions: ['.ts', '.js', '.json']
  }
};