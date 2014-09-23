
S.source("/Users/ryan/s/slate/utils.js");

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

