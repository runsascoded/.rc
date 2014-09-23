
var laptop = new Screen('1440x900');
var apple = new Screen('2560x1440');

var bindings = {};

// Alt-d: reload this Slate config.
bindings["d:alt"] = function() { S.source("/Users/ryan/.slate.js"); };


// {Alt+N, Alt+Shift+N}: {left,right}-most N columns
for (var n = 1; n < 10; ++n) {
  bindings[n + ":alt"] = left(n);
  bindings[n + ":alt;shift"] = right(n);
}
// Alt+0: full screen
bindings["0:alt"] = grid();


// Organize windows on laptop + apple-monitor.
var office2Monitors = S.layout("office-2monitors", {
  "Google Chrome": apple.grid(1, 7),
  "iTerm": apple.left(5),
  "IntelliJ IDEA": apple.right(6),
  "GitX": apple.right(5),
  "HipChat": laptop.grid()
});
S.default([ laptop.id, apple.id ], office2Monitors);
bindings["m:ctrl;cmd"] = S.op("layout", { name: office2Monitors });

// Organize windows on laptop.
var laptop1Monitor = S.layout("laptop-1monitor", {
  "Google Chrome": laptop.left(7),
  "iTerm": laptop.left(6),
  "IntelliJ IDEA": laptop.right(7),
  "GitX": laptop.right(6),
  "HipChat": laptop.right(6)
});
S.default([ laptop.id ], laptop1Monitor);
bindings["l:ctrl;cmd"] = S.op("layout", { name: laptop1Monitor });


// Bind all hotkeys.
S.bindAll(bindings);
