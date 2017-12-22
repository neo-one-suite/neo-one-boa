'use strict';
var VERSION = require('./package.json').boaVersion;

var path = require('path');

module.exports =
  process.platform === 'darwin'
    ? path.join(__dirname, 'neo-one-boa-osx-v' + VERSION, 'neo-one-boa') :
  process.platform === 'linux' && process.arch === 'x64'
    ? path.join(__dirname, 'neo-one-boa-linux64-v' + VERSION, 'neo-one-boa') :
  process.platform === 'win32' &&  process.arch === 'x64'
    ? path.join(__dirname, 'neo-one-boa-win64-v' + VERSION, 'neo-one-boa.exe') :
  null;
