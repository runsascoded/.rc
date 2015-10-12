#!/usr/bin/env node

var GoogleSpreadsheets = require("google-spreadsheets");

var key = process.argv[2];
var range = process.argv[3];

GoogleSpreadsheets.cells(
      {
        key: key,
        worksheet: 0,
        range: range
      },
      function(err, cells) {
        console.log("cells:", err, cells);
      }
);
