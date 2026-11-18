# UI / UX

## Theme system
- Define a `Theme` in `Shared/Config` (or `Shared/Theme`): fonts (one display font,
  one body font via `Font.new`/`FontFace`), colours (bg, panel, primary, accent,
  success, danger, text), corner radius, stroke, padding, sounds.
- Every UI element built through helper functions reading Theme → consistent look,
  restyle a whole game by editing one table.

## Structure
- ScreenGuis: `HUD` (always), `Menus` (shop, inventory, settings, quests),
  `Popups` (notifications, rewards), `Overlay` (fades, death screen, cutscene bars).
- `ResetOnSpawn = false` for persistent UI. `IgnoreGuiInset` deliberately.
  Use `ZIndexBehavior = Sibling` and `DisplayOrder` for stacking.
- One UIController manages open/close (only one menu at a time), back/escape handling,
  gamepad selection (`GuiService.SelectedObject`).

## Mobile-first layout
- Scale-based sizes (`UDim2.fromScale`), `UIAspectRatioConstraint` on panels,
  `UISizeConstraint` min/max, `UIScale` adjusted by viewport size for small screens.
- Touch targets ≥ 44 px effective; HUD buttons on screen edges away from the
  thumbstick (bottom-left) and jump button (bottom-right).
- Respect safe areas/notches (`ScreenInsets`/`SafeAreaCompatibility`) and top-bar
  (`GuiService:GetGuiInset()`).
- Test with Studio Device Emulator: small phone, large phone, tablet, 1080p, 4K,
  console (10-foot UI). Use `screen_capture` during playtest to verify.
- Text: `TextScaled` + `UITextSizeConstraint` (MaxTextSize) or fixed sizes per breakpoint.
  Never tiny text. Add `UIStroke` on text over busy backgrounds.

## Feel
- Open/close animations (TweenService on Size/Position/Transparency, 0.15–0.3 s,
  Back/Quad easing), button hover/press scale (1.05 / 0.95), click sound, shine on
  important buttons, number count-up on rewards, confetti/particles for big rewards
  (UI particles via image animation or Viewport).
- Notifications queue (toast, top-centre), never overlapping.

## Essential screens
HUD (currency, objective, health/stamina, buttons: Shop, Inventory, Quests, Settings),
Shop (tabs: Featured, Skins, Passes, Currency; item preview; owned/equip state),
Inventory/Equip, Daily Rewards (calendar), Quests, Settings (audio, graphics, controls,
reduce scares/flashes), Death/Results, Tutorial hints, Loading screen, Codes.

## Previews
- `ViewportFrame` + `WorldModel` with a cloned model and a rotating camera for item
  and skin previews (client side). Light it (ViewportFrame Ambient/LightColor).

## Accessibility & clarity
- Colour + icon + text for states (not colour alone). High contrast.
- Input prompts adapt to device (`UserInputService.PreferredInput` /
  `LastInputType`): show tap icons on touch, key letters on keyboard, button glyphs on
  gamepad.
- Settings to reduce camera shake, flashing and jumpscares.

## Images
- Icons: generate in-Studio scenes + `screen_capture`, or upload originals with
  `upload_image`. Keep a consistent icon style (same outline, angle, background).
- Use 9-slice (`ScaleType.Slice`) for panels.
