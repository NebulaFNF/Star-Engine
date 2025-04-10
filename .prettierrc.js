/**
 * Configuration for JSON file formatting.
 */
module.exports = {
  // Line width before Prettier tries to add new lines.
  printWidth: 80,

  // Use double quotes.
  singleQuote: false,
  quoteProps: "preserve",
  parser: "json",

  bracketSpacing: false, // Spacing between brackets in object literals.
  trailingComma: "none", // No trailing commas.
  semi: false, // No semicolons at ends of statements.
};