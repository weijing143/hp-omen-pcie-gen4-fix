# HP OMEN 16 PCIe Gen4 Crash Fix

> BIOS F.20 on HP OMEN 16 lacks manual PCIe Generation control, causing intermittent GPU link-loss hard freezes under Gen4. This repository documents the root cause analysis and provides a **six-layer defense** solution.

## Quick Start

### Core Fix: PCIe Gen3 Lock + AER Silence

1. **Double-click** `PCIe_Gen3_Limit.reg` → import
2. **Run as Admin** → `PCIe_AER_ForceDisable.bat`
3. **Restart** your computer

### Verify

```powershell
# Check Gen3 lock
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" | Select-Object RMPcieLinkSpeed, RMLimitPcieGenTo
# Both should read 3

# Check AER status
bcdedit /enum | findstr pciexpress
# Should show: pciexpress              ForceDisable
```

## Files

| File | Purpose |
|------|---------|
| `hp-omen-pcie-gen4-crash-fix.md` | Full technical analysis & six-layer defense solution (Chinese) |
| `2026-07-17-deep-dive.md` | 🆕 Deep-dive into F.20 BIOS root cause & AER WHEA 17 snowball effect |
| `PCIe_Gen3_Limit.reg` | Registry hack: lock PCIe to Gen3 |
| `PCIe_Gen3_Unlimit.reg` | Revert to auto-negotiation (Gen4) |
| `PCIe_AER_ForceDisable.bat` | 🆕 One-click: disable PCIe AER error reporting |
| `PCIe_AER_ForceDisable.ps1` | 🆕 PowerShell version with verification |

## The Six-Layer Defense

| # | Layer | Configuration | Purpose |
|---|-------|--------------|---------|
| 1 | Driver | NVIDIA Studio 576.49 (locked) | Prevent TDR driver bugs |
| 2 | PCIe Speed | Registry-locked Gen3 | Prevent Gen4 signal loss → GPU disconnection |
| 3 | Power | Balanced + ASPM off | Reduce heat, prevent link state transitions |
| 4 | CPU Clock Cap | P-core 4300 / E-core 3500 MHz | Reduce CPU heat → stabilize PCB |
| 5 | CPU Undervolt | OMEN Gaming Hub -0.1V | Further temperature reduction |
| 6 | **AER Silence** | **`bcdedit pciexpress forcedisable`** | 🆕 **Block WHEA 17 flood → prevent DPC storm** |

## What Changed (2026-07-17 Update)

The F.20 BIOS "security update" actually bundles Intel ME firmware changes that:
- Made PCIe AER error reporting **aggressively verbose** (previously silent)
- Modified iGPU/dGPU switching logic (causing freeze → fixed by disabling iGPU in BIOS)
- Caused WHEA Event 17 to accumulate from 0/month → 186/month → DPC storm → system freeze

The 6th defense line (`bcdedit pciexpress forcedisable`) bypasses the aggressive AER policy by reverting Windows to legacy PCIe behavior at the kernel level. Unlike the registry Gen3 lock, **this survives Windows Update**.

See `2026-07-17-deep-dive.md` for the full investigation timeline and WHEA statistics.

## WHEA 17 Trend (March – July 2026)

```
Mar:   0
Apr:   0    ← Clean (old F.20)
May:   0
─── F.20 Rev.A update (5/14) ───
Jun: 183   ← Explosion (avg 6/day)
Jul: 186   ← 17 days already exceeded full June (avg 11/day)
```

## Hardware

- **Model**: HP OMEN 16-wf1142TX
- **CPU**: Intel i7-14650HX
- **GPU**: NVIDIA RTX 4060 Laptop
- **BIOS**: F.20 Rev.A (2026-05-14)
- **OS**: Windows 11 Build 26200

## Disclaimer

**USE AT YOUR OWN RISK.** The registry modifications, bcdedit changes, and configuration adjustments described in this repository are provided for educational and informational purposes only. Modifying the Windows registry or boot configuration can cause system instability, data loss, or hardware damage if applied incorrectly. The author assumes no responsibility or liability for any consequences resulting from the use of these materials.

This project is not affiliated with, endorsed by, or associated with HP Inc., NVIDIA Corporation, Intel Corporation, or Microsoft Corporation. All trademarks and registered trademarks are the property of their respective owners.

## License

[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) — Attribution-NonCommercial.

- **Allowed**: Share, copy, redistribute, adapt, remix for **non-commercial** purposes
- **Required**: Attribution to the original author
- **Prohibited**: Commercial use of any kind

Full license text: [LICENSE](LICENSE)
