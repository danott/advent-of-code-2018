// cargo test

pub fn echo(value: i32) -> i32 {
  value
}

#[test]
fn test_echo() {
  assert_eq!(123, echo(123))
}