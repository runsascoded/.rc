
var moment = require('moment');

var args = process.argv.slice(2);

if (args.length != 1) {
  console.error("Usage: add-date <datetime interval>");
  process.exit(1);
}

var arg = args[0];
var intervalNum = parseInt(arg.substr(0, arg.length - 1));
var intervalScale = arg[arg.length - 1];

process.stdout.on('error', function( err ) {
    if (err.code == "EPIPE") {
        process.exit(0);
    }
});

var content = '';
process.stdin.resume();
process.stdin.on('data', function(buf) { content += buf.toString(); });
process.stdin.on('end', function() {

  var lines = content.split("\n");   // split the lines
  lines.map(function(line) {
    if (!line.trim()) return;
    var m = moment(line, 'YYYY-MM-DD HH:mm');
    console.log(m.add(intervalNum, intervalScale).format(m._f));
  });
});

