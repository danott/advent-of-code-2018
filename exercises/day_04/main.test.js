const fs = require("fs");

// yarn test
const TEST_INPUT = `
[2018-11-01 00:00] Guard #10 begins shift
[2018-11-01 00:05] falls asleep
[2018-11-01 00:25] wakes up
[2018-11-01 00:30] falls asleep
[2018-11-01 00:55] wakes up
[2018-11-01 23:58] Guard #99 begins shift
[2018-11-02 00:40] falls asleep
[2018-11-02 00:50] wakes up
[2018-11-03 00:05] Guard #10 begins shift
[2018-11-03 00:24] falls asleep
[2018-11-03 00:29] wakes up
[2018-11-04 00:02] Guard #99 begins shift
[2018-11-04 00:36] falls asleep
[2018-11-04 00:46] wakes up
[2018-11-05 00:03] Guard #99 begins shift
[2018-11-05 00:45] falls asleep
[2018-11-05 00:55] wakes up
`;

const REAL_INPUT = fs.readFileSync("input.txt", "utf8");

test("sleepiestGuard", () => {
  expect(sleepiestGuard(TEST_INPUT)).toBe(10);
});

test("sleepiestMinuteForGuard", () => {
  expect(sleepiestMinuteForGuard(TEST_INPUT, 10)).toBe(24);
});

test("star 1 example", () => {
  expect(star1(TEST_INPUT)).toBe(240);
});

test("find star 1", () => {
  expect(star1(REAL_INPUT)).toBe(131469);
});

test("sleepiestMinuteForAnyGuard", () => {
  expect(sleepiestMinuteForAnyGuard(TEST_INPUT)).toEqual([99, 45]);
});

test("star 2 example", () => {
  expect(star2(TEST_INPUT)).toBe(4455);
});

test("find star 2", () => {
  expect(star2(REAL_INPUT)).toBe(96951);
});

function star1(input) {
  let guard = sleepiestGuard(input);
  let minute = sleepiestMinuteForGuard(input, guard);
  return guard * minute;
}

function star2(input) {
  const [guard, minute] = sleepiestMinuteForAnyGuard(input);
  return guard * minute;
}

function parseInstruction(line) {
  let [date, time, action, guard] = line
    .replace("[", "")
    .replace("]", "")
    .replace("#", "")
    .split(" ");
  guard = parseInt(guard, 10) || null;
  date = new Date(`${date}T${time}:00.000Z`);

  switch (action) {
    case "Guard":
      action = "change";
      break;
    case "wakes":
      action = "wake";
      break;
    case "falls":
      action = "sleep";
      break;
    default:
      throw "wat";
  }

  return {
    date,
    action,
    guard
  };
}

function parseInstructions(input) {
  return input
    .trim()
    .split("\n")
    .sort()
    .map(parseInstruction);
}

function buildSleepData(input) {
  let instructions = parseInstructions(input);
  let data = {};
  let guard = null;

  while (instructions.length > 0) {
    let instruction = instructions.shift();
    if (instruction.action === "change") {
      guard = instruction.guard;
      continue;
    } else if (instruction.action === "sleep") {
      let until = instructions.shift().date;
      for (
        let currentMinute = instruction.date;
        currentMinute < until;
        currentMinute = new Date(currentMinute.getTime() + 60000)
      ) {
        let minute = currentMinute.getMinutes();
        let key = `${guard}-${minute}`;
        data[key] = (data[key] || 0) + 1;
      }
    }
  }
  return data;
}

function sleepiestGuard(input) {
  let sleepData = buildSleepData(input);
  sleepData = Object.keys(sleepData).reduce((map, key) => {
    let guard = key.split("-")[0];
    map[guard] = (map[guard] || 0) + sleepData[key];
    return map;
  }, {});
  let guard = getKeyForLargestValue(sleepData);
  return parseInt(guard, 10);
}

function sleepiestMinuteForGuard(input, guard) {
  let sleepData = buildSleepData(input);
  sleepData = Object.keys(sleepData).reduce((map, key) => {
    if (key.startsWith(`${guard}-`)) map[key] = sleepData[key];
    return map;
  }, {});
  let key = getKeyForLargestValue(sleepData);
  let minute = key.split("-")[1];
  return parseInt(minute, 10);
}

function sleepiestMinuteForAnyGuard(input) {
  let sleepData = buildSleepData(input);
  let key = getKeyForLargestValue(sleepData);
  return key.split("-").map(i => parseInt(i, 10));
}

function getKeyForLargestValue(map) {
  let sortedKeys = Object.keys(map).sort((left, right) =>
    map[left] > map[right] ? -1 : +1
  );
  return sortedKeys[0];
}
