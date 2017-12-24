'use strict';
var VERSION = require('./package.json').boaVersion;

var path = require('path');

module.exports =
  process.platform === 'darwin'
    ? path.join(__dirname, 'neo-one-boa-osx-v' + VERSION, 'neo-one-boa') :
  process.platform === 'linux'
    ? path.join(__dirname, 'neo-one-boa-linux-v' + VERSION, 'neo-one-boa') :
  process.platform === 'win32'
    ? path.join(__dirname, 'neo-one-boa-win-v' + VERSION, 'neo-one-boa.exe') :
  null;
