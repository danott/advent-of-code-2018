# 🎄 Advent of Code 2018 🎄

For [Advent of Code](https://adventofcode.com) 2018, I want to try my hand at some different languages.
The minimum viable testing scaffold is setup for each language in the `scaffolds` directory.
To scaffold a day, use the `scaffold` command.

```
scaffold # Uses today's date, and random language
scaffold 23 # Uses the 23rd, with a random language
scaffold 23 # Fails because the day has already been scaffolded
scaffold 23 javascript --force # Deletes the existing scaffold, and changes it to javascript
```

The exercies live in the `exercies` folder, after they've been scaffolded.

This might be a terrible idea that has me looking at lots of language docs. 😬
