const fs = require("fs");
const csv = require("csv-parser");
// const copy = require('copy-to-clipboard');

console.log("pofj");
const data = [];

const cleanData = () => {
  fs.createReadStream("vv-data-small.csv")
    .pipe(csv())
    .on("data", (row) => {
      data.push(row);
    })
    .on("end", () => {
      console.log("CSV file successfully processed");
      console.log(data);
      return data;
    });
};

// copy(cleanData());

console.log(cleanData());
// clipboardy.writeSync(`${cleanData()}`);
