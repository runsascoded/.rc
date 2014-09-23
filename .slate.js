
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

// Screen class: wrap {grid,left,right} for a given screen ID.
var Screen = function(id) {
  this.id = id;
  this.grid = function() {
    return grid.apply(this, [this.id].concat(Array.prototype.slice.call(arguments)));
  };

  this.left = function(n) {
    return this.grid(0, n);
  };

  this.right = function(n) {
    return this.grid(N - n);
  };
};

var laptop = new Screen('1440x900');
var apple = new Screen('2560x1440');

var office2Monitors = S.layout("office-2monitors", {
  "Google Chrome": {
    operations: [ apple.grid(1, 7) ]
    ,repeat:true
  },
  "iTerm": {
    operations: [ apple.left(5) ]
    ,repeat:true
  },
  "IntelliJ IDEA": {
    operations: [ apple.right(6) ]
    ,repeat:true
  },
  "GitX": {
    operations: [ apple.right(5) ]
    ,repeat:true
  },
  "HipChat": {
    operations: [ laptop.grid() ]
    ,repeat:true
  }
});
S.default([ laptop.id, apple.id ], office2Monitors);

var laptop1Monitor = S.layout("laptop-1monitor", {
  "Google Chrome": {
    operations: [ laptop.left(7) ]
    ,repeat:true
  },
  "iTerm": {
    operations: [ laptop.left(6) ]
    ,repeat:true
  },
  "IntelliJ IDEA": {
    operations: [ laptop.right(7) ]
    ,repeat:true
  },
  "GitX": {
    operations: [ laptop.right(6) ]
    ,repeat:true
  },
  "HipChat": {
    operations: [ laptop.right(6) ]
    ,repeat:true
  }
});
S.default([ laptop.id ], laptop1Monitor);


var bindings = {
  "m:ctrl;cmd": S.op("layout", { name: office2Monitors })
  ,"n:ctrl;cmd": S.op("layout", { name: laptop1Monitor })
  ,"0:alt": grid()
  ,"d:alt": function() { S.source("/Users/ryan/.slate.js"); }
};
for (var n = 1; n < 10; ++n) {
  bindings[n + ":alt"] = left(n);
  bindings[n + ":alt;shift"] = right(n);
}

S.bindAll(bindings);
