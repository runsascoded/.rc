
var m = require("moment");

console.log(process.argv);

var firstPaycheck = m("2014-07-04");

function getStartEnd() {
  if (process.argv.length == 4) {
    return process.argv.slice(2).map(function(s) { return m(s.replace(/\//g, '-')); });
  }
  if (process.argv.length == 3) {
    return [ firstPaycheck, m(process.argv[2].replace(/\//g, '-')) ];
  }
  return [ firstPaycheck, m("2015-01-01") ];
}

var bounds = getStartEnd();
var start = bounds[0];
var end = bounds[1];

var count = 0;

monthBuckets = {}
for (var cur = firstPaycheck; cur < end; cur = cur.add(2, "weeks")) {
  if (cur >= start) {
    count += 1;
    var key = cur.format("YYYY-MM");
    if (!(key in monthBuckets)) {
      monthBuckets[key] = 0;
    }
    monthBuckets[key] += 1;

    var starStr = "";
    if (monthBuckets[key] > 2) {
      starStr = " *";
    }

    console.log(cur.format("ddd MM/DD/YYYY") + starStr);
  }
}

console.log(count);
