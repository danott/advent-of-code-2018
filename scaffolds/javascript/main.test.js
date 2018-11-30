// yarn test

test("echo", () => {
  expect(echo(123)).toBe(123);
});

function echo(value) {
  return value;
}
