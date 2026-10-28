# Apex Ascent - Roblox Obstacle Course

**One single script** that gives you a complete fun-but-hard multi-stage obby.

### Features included
- Checkpoints + Stage tracking
- Permanent leaderboard (Wins + Highest Stage) with DataStores
- Moving platforms
- Disappearing platforms
- Spinning platforms
- Jump pads / launchers
- Falling platforms
- Kill bricks
- Finish line that awards Wins and resets progress

---

## Setup (very easy)

1. Open Roblox Studio
2. In **ServerScriptService** create a new **Script** and name it `MainObby`
3. Delete the default code and paste everything from  
   `ServerScriptService/MainObby.lua`
4. Create these folders/parts in **Workspace**:

```
Workspace
├─ Checkpoints            (Parts named "1", "2", "3"...)
├─ KillBricks
├─ MovingPlatforms
├─ DisappearingPlatforms
├─ SpinningPlatforms
├─ JumpPads
├─ FallingPlatforms
└─ Finish                 (one Part at the end)
```

That's it. The script automatically detects everything.

---

## Optional Attributes (customize difficulty)

| Folder                 | Attribute     | Default     | Meaning                          |
|------------------------|---------------|-------------|----------------------------------|
| MovingPlatforms        | Offset        | 0,0,20      | How far it moves                 |
| MovingPlatforms        | Time          | 3           | Seconds for one way              |
| DisappearingPlatforms  | Delay         | 1.2         | Time before it disappears        |
| DisappearingPlatforms  | RespawnTime   | 3           | Time until it comes back         |
| SpinningPlatforms      | Speed         | 60          | Degrees per second               |
| SpinningPlatforms      | Axis          | Y           | X / Y / Z                        |
| JumpPads               | Power         | 80          | Upward launch strength           |
| FallingPlatforms       | Delay         | 0.8         | Time before it falls             |
| FallingPlatforms       | RespawnTime   | 4           | Time until it resets             |

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

Enjoy building your obby!
