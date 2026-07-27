Canonical intro/outro/caption spec for Halo social videos. Use these exact values and files for every new video — do not re-derive, re-extract, or approximate from an old video again. If a value needs to change, change it here first, then every future render inherits it.

## Files in this folder
- `outro-logo-mark.png` — the paw+halo mark, extracted directly from the actually-posted `angel-message-FINAL.mp4` outro frame (not the App Store screenshot asset, not the app's own AppLogo.imageset — those are close but not pixel-identical, and caused a visible colour mismatch once already). Transparent background. Use this file for every outro card.
- `outro-card-template-reference.png` — a full 1920x1080... (1080x1920) rendered reference card, for visual comparison only. Don't crop assets out of this one — use `outro-logo-mark.png` directly.

## Canvas
1080 x 1920 (9:16), background `#FDFAF6` (also written as rgb(253,250,246) — matches CSS `--bg`).

## Outro card layout (all y-values are pixel positions on the 1080x1920 canvas)
- Logo (`outro-logo-mark.png`): height 278px, width auto (preserve aspect), horizontally centered, top edge at y=477.
- "Halo" wordmark: font `CormorantGaramond-LightItalic.ttf`, size 190px, color `#C9897A` (rose), vertically centered at y=1046 (band 978–1114).
- Tagline (varies per post — e.g. "Launching soon", "Coming to you this week", "here for every year"): font `CormorantGaramond-Italic.ttf`, size 92px, color `#3A3230` (dark), vertically centered at y=1301 (band 1248–1354).
- URL "myhaloapp.co.uk": font `CormorantGaramond-Italic.ttf`, size 62px, color `#CBBAA6` (light), vertically centered at y=1437 (band 1399–1474).
- Fonts live at `/Users/mrsharding/Documents/Code/Halo/Halo/Fonts/`.

## Caption pill (burned-in on-screen captions during clips)
- Background: rose-l, `#E8C4BB`.
- Text: white, Arial Bold, 54px, centered, 2 lines max.
- Rounded rect, radius 26px, padding 46px horizontal / 34px vertical around the text block.
- Vertical position: pill center at y=1353 on the 1080x1920 canvas (≈70% down) — this exact position was chosen deliberately to fix a real TikTok bug (captions lower than this overlapped TikTok's own username/caption/sound UI). Do not move it lower.
- Caption on-screen duration: hold for the clip's full "clear" window (i.e. from just after it finishes crossfading in, to just before it starts crossfading out) minus ~0.2–0.3s buffer on each side, not a fixed short duration — a caption that's only visible for ~1.5–2s reads as too fast, aim for 3s+ where the clip length allows it.

## Process, every time
1. Copy `outro-logo-mark.png` and the font files above verbatim. Never regenerate the logo from a different source file, even if it looks close.
2. Build the outro card and caption pills as flat PNGs at these exact values before touching ffmpeg.
3. Only the tagline text and the caption copy should change between posts — nothing else in the layout, fonts, sizes, or colors.
4. If a genuine redesign is wanted, update this file's values first (with Jehane's sign-off), then every future post automatically matches — don't let one post quietly drift from the last.
