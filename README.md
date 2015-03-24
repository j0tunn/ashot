# ashot
OS X Application Screenshot utility

### Install
```bash
npm install ashot
```

### Use
```bash
ashot <application> <out.png>
```
```bash
ashot Calendar ./terminal.png
```

### Use as npm module
```js
var getScreenshot = require('ashot').getScreenshot;

getScreenshot('Calendar', function(error, img) {
   // img is Buffer
});
```
