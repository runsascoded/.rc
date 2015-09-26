
var args = process.argv.slice(2);

if (args.length != 1) {
  console.error("Usage: filter <expression>");
  process.exit(1);
}

var exp = args[0];

process.stdout.on('error', function( err ) {
  if (err.code == "EPIPE") {
    process.exit(0);
  }
});

var content = '';
process.stdin.resume();
process.stdin.on('data', function(buf) { content += buf.toString(); });
process.stdin.on('end', function() {
  content.split("\n").map(function(line) {
    var _ = parseFloat(line);
    if (isNaN(_)) {
      _ = line;
    }

    if (!!eval(exp)) {
      console.log(line);
    }
  });

});
