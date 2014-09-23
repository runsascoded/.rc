
// Screen class: wrap {grid,left,right} for a given screen ID.
var Screen = function(id) {
  this.id = id;

  function wrapAppParams(operation) {
    return {
      operations: [ operation ],
      repeat: true
    };
  };

  this.grid = function() {
    return wrapAppParams(grid.apply(this, [this.id].concat(Array.prototype.slice.call(arguments))));
  };

  this.left = function(n) {
    return this.grid(0, n);
  };

  this.right = function(n) {
    return this.grid(N - n);
  };

};

