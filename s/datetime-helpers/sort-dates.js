
var moment = require('moment');

var args = process.argv.slice(2);

var dropNoDateLines = true;

process.stdout.on('error', function( err ) {
    if (err.code == "EPIPE") {
        process.exit(0);
    }
});

function parseDateFormat(str) {
  var m = str.match(/([0-9]{2,4})([/-])[0-9]{2}[/-][0-9]{2} [0-9]{2}:[0-9]{2}(:[0-9]{2})?/)
  if (m) {
    var yearFormat = m[1].split('').map(function() { return 'Y'; }).join('');
    var dateSep = m[2];
    var secondsFormatArray = m[3] ? ['ss'] : []
    var format = [yearFormat, 'MM', 'DD'].join(dateSep) + " " + ['HH', 'mm'].concat(secondsFormatArray).join(':')
    return format;
  }
}

var content = '';
process.stdin.resume();
process.stdin.on('data', function(buf) { content += buf.toString(); });
process.stdin.on('end', function() {

  var truthy = function(x) { return !!x; }

  content
        .split("\n")
        .filter(truthy)
        .map(function(line) {
          var format = parseDateFormat(line);
          if (!format) {
            if (dropNoDateLines) {
              return undefined;
            }
            throw new Error("Couldn't parse datetime: " + line);
          }
          var m = moment(line, format);
          var unix = parseInt(m.format('X'));
          return [unix, line];
        })
        .filter(truthy)
        .sort(function(p1, p2) {
          return p1[0] - p2[0];
        }).forEach(function(p) {
          console.log(p[1]);
        });
});

