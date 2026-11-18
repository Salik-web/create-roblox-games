# Localization & Accessibility

## Localization
- Roblox auto-translates in-experience text for many languages when "Automatic text
  capture" and "Use translated content" are enabled in Localization settings. Check
  results for important UI.
- For control: `LocalizationTable` entries (key + source + translations), fetch with
  `LocalizationService:GetTranslatorForPlayerAsync(player)` → `translator:FormatByKey`.
- Avoid text baked into images (can't translate). Keep strings short; leave room for
  ~30% longer text. Use numbers/icons where possible.
- Translate the game title/description for big markets (Spanish, Portuguese, Indonesian,
  etc.) in Creator Hub.

## Accessibility
- Settings: reduce camera shake/motion, reduce flashing lights, reduce jumpscares,
  subtitles for important audio, colour-blind-safe palette for gameplay-critical colours
  (add shapes/icons), text size option.
- Readable fonts, high contrast, no information by colour alone.
- Inputs: full support for touch, keyboard/mouse and gamepad; no fast mashing required
  for core progression; hold-to-interact alternatives.
- Clear audio cues paired with visual cues (deaf/hard-of-hearing players).
