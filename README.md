# neo-one-boa

> Binary wrapper for [neo-boa](https://github.com/cityofzion/neo-boa) - Python compiler for the NEO Virtual Machine

OS X, Linux (64-bit) and Windows binaries are currently provided.


## CLI

```
$ npm install --global neo-one-boa
```

or

```
$ yarn global add neo-one-boa
```

```
$ neo-one-boa sc.py sc.avm
```


## API

```
$ npm install --save neo-one-boa
```

```js
const execFile = require('child_process').execFile;
const boa = require('neo-one-boa');

execFile(boa, ['sc.py', 'sc.avm'], (err, stdout) => {
	console.log(stdout);
});
```


## License

neo-one-boa is MIT-licensed.
