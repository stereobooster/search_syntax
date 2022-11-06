import { readFileSync, writeFileSync } from "node:fs";

const { algorithms } = JSON.parse(readFileSync("./graph.json"));

const typeToColor = {
  CoC: "lightpink",
  A: "lightblue",
  BP: "lavender",
  PSM: "olivedrab1",
};

const byDate = {};
algorithms.forEach((algorithm) => {
  algorithm.id = `"${algorithm.id}"`;
  algorithm.relationship = algorithm.relationship.map((x) => `"${x}"`);
  byDate[algorithm.date] = byDate[algorithm.date] || [];
  byDate[algorithm.date].push(algorithm.id);
});

const dates = Object.keys(byDate)
  .sort()
  .filter((x) => x != "null")
  .map((x) => parseInt(x, 10));
dates.unshift("start");

const dot = `
digraph algorithms {
    size="7,8";
    node [fontsize=24, shape=plaintext];

    ${dates.join(` -> `)};

    node [fontsize=20, shape=box, style=filled];
${dates
  .map(
    (date) =>
      `    { rank=same; ${date} ${byDate[date === "start" ? "null" : date].join(
        " "
      )}; }`
  )
  .join("\n")}


${algorithms
  .map((x) => `    ${x.id} [color=${typeToColor[x.type]}, label="${x.name}"];`)
  .join("\n")}

${algorithms
  .map((x) => x.relationship.map((y) => `    ${y} -> ${x.id};`).join("\n"))
  .join("\n")}
}`;

writeFileSync("./graph.dot", dot);
