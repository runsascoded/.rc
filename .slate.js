
S.source("/Users/ryan/s/slate/screen.js");
S.source("/Users/ryan/s/slate/utils.js");

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
