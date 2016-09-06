#!/usr/bin/env node

var fs = require('fs');

function print(str) {
  try {
    console.log(JSON.stringify(JSON.parse(str), null, 4));
  } catch(e) {
    var lines = str.split("\n");
    lines.forEach((line) => {
      if (!line) return;
      console.log(JSON.stringify(JSON.parse(line), null, 4));
    });
  }
}

if (process.argv.length > 2) {
  process.argv.slice(2).forEach((file) => {
    print(fs.readFileSync(file));
  });
} else {
  var stdin = '';
  process.stdin.on('readable', function() {
    var chunk = process.stdin.read();
    if (chunk != null) {
      stdin += chunk;
    }
  });

  process.stdin.on('error', function( err ) {
    if (err.code == "EPIPE") {
      process.exit(0);
    }
  });

  process.stdin.on('end', function() {
    print(stdin);
  });
}
