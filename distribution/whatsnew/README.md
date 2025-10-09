# What's New Directory

This directory contains the release notes that will be displayed to users when they update the app in Google Play Store.

## File Format

Create files named `whatsnew-<locale>` where `<locale>` is the language code:

- `whatsnew-en-US` - English (United States)
- `whatsnew-es-ES` - Spanish (Spain)
- `whatsnew-fr-FR` - French (France)
- `whatsnew-de-DE` - German (Germany)
- `whatsnew-ja-JP` - Japanese (Japan)
- etc.

## Content Guidelines

- Maximum 500 characters per file
- Use plain text (no markdown)
- Keep it concise and user-friendly
- Focus on what's new or improved

## Example

```
whatsnew-en-US:
• Added medication reminder notifications
• Improved sync reliability
• Fixed crash on startup
• Performance improvements
```

## Default Behavior

If no `whatsnew-en-US` file is present, the deployment workflow will create one with a generic message:
"Bug fixes and performance improvements"

## Best Practices

1. Update this file before each release
2. Highlight the most important changes first
3. Keep the tone friendly and informative
4. Test that the content fits within 500 characters
