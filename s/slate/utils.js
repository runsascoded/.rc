
// Pretty Print
function pp(o) {
  for (x in o) {
    S.log("\t" + x +": " + o[x]);
  }
}


// Align windows on a 10x10 grid on the provided screen (defaults to current).
var M = 10;
var N = 10;
function grid() {
  var args = Array.prototype.slice.call(arguments);
  //S.log("got " + args.length + " args: " + args);
  var screen = null;
  if (args.length > 0 && typeof(args[0]) == "string") {
    screen = args[0];
    args = args.slice(1);
  }
  var x1 = 0;
  if (args.length > 0) {
    x1 = args[0];
    args = args.slice(1);
  }
  var x2 = N;
  if (args.length > 0) {
    x2 = args[0];
    args = args.slice(1);
  }
  var y1 = 0;
  if (args.length > 0) {
    y1 = args[0];
    args = args.slice(1);
  }
  var y2 = M;
  if (args.length > 0) {
    y2 = args[0];
    args = args.slice(1);
  }

  var moveHash = {
    x: "screenOriginX + "+x1+"*screenSizeX/"+N,
    width: "("+x2+" - "+x1+") * screenSizeX/"+N,
    y: "screenOriginY + "+y1+"*screenSizeY/"+M,
    height: "("+y2+" - "+y1+") * screenSizeY/"+M
  };
  if (screen) {
    moveHash['screen'] = screen;
  }

  return S.op("move", moveHash);
}

// Left-most n columns
function left(n) {
  return grid(0, n);
}

// Right-most n columns
function right(n) {
  return grid(N - n);
}
