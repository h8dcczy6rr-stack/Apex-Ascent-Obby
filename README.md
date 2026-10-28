# Apex Ascent - Roblox Obstacle Course

A fun but **not easy** multi-stage Roblox obby with:

- Checkpoints
- Permanent leaderboard (Wins + Highest Stage)
- Moving platforms
- Kill bricks
- Ready for multiple stages
- Extra obstacle scripts included

---

## Quick Setup in Roblox Studio

### 1. Create the folders in Workspace

```
Workspace
├─ Checkpoints          ← Parts named "1", "2", "3"... (Anchored)
├─ KillBricks           ← Any deadly parts (lava, spikes, etc.)
├─ MovingPlatforms      ← Platforms that slide
└─ Finish               ← One Part at the very end of the course
```

### 2. Add the main script

1. In **ServerScriptService**, create a new **Script**
2. Name it `MainObby`
3. Paste the code from `ServerScriptService/MainObby.lua`

### 3. (Optional) Extra obstacles

Copy the scripts from the `ExtraObstacles` folder into ServerScriptService if you want disappearing platforms, spinning platforms, jump pads, etc.

---

## How the systems work

| Feature              | How it works                                      |
|----------------------|---------------------------------------------------|
| **Checkpoints**      | Touch a part named `1`, `2`, `3`... to save progress |
| **Stage**            | Current checkpoint number (shown in leaderboard)  |
| **Wins**             | Increases every time you touch the Finish part    |
| **Leaderboard**      | Saves permanently using DataStores                |
| **Moving Platforms** | Use Attributes `Offset` (Vector3) and `Time` (number) |

---

## Recommended Stage Layout

| Stage | Checkpoints | Difficulty Ideas                          |
|-------|-------------|--------------------------------------------|
| 1     | 1–5         | Big platforms, easy jumps                  |
| 2     | 6–12        | Moving platforms + some kill bricks        |
| 3     | 13–20       | Disappearing platforms + tighter timing    |
| 4     | 21–28       | Spinning + fast movers                     |
| 5     | 29–Finish   | Mix of everything (hard)                   |

---

## Tips for making it fun but hard

- Make platforms smaller as stages progress
- Add timing challenges (moving + disappearing together)
- Use transparent kill bricks under thin platforms
- Give players a short safe zone after each checkpoint
- Test the jumps yourself — if it feels slightly unfair, it’s usually perfect for an obby

---

Made for you by Grok • Enjoy building!
