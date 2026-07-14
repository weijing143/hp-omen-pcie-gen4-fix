# HP OMEN 16 PCIe Gen4 Crash Fix

> BIOS F.20 on HP OMEN 16 lacks manual PCIe Generation control, causing intermittent GPU link-loss hard freezes under Gen4. This repository documents the root cause analysis and provides a multi-layer defense solution.

## Quick Start

1. **Double-click** `PCIe_Gen3_Limit.reg` → import
2. **Restart** your computer
3. Verify with PowerShell:

```powershell
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" | Select-Object RMPcieLinkSpeed, RMLimitPcieGenTo
```

Both should read `3`.

## Files

| File | Purpose |
|------|---------|
| `hp-omen-pcie-gen4-crash-fix.md` | Full technical analysis & solution (Chinese) |
| `PCIe_Gen3_Limit.reg` | Registry hack to lock PCIe to Gen3 |
| `PCIe_Gen3_Unlimit.reg` | Revert to auto-negotiation (Gen4) |

## Hardware

- **Model**: HP OMEN 16-wf1142TX
- **CPU**: Intel i7-14650HX
- **GPU**: NVIDIA RTX 4060 Laptop
- **BIOS**: F.20 (2026-03-30)

## Disclaimer

**USE AT YOUR OWN RISK.** The registry modifications and configuration changes described in this repository are provided for educational and informational purposes only. Modifying the Windows registry can cause system instability, data loss, or hardware damage if applied incorrectly. The author assumes no responsibility or liability for any consequences resulting from the use of these materials.

This project is not affiliated with, endorsed by, or associated with HP Inc., NVIDIA Corporation, Intel Corporation, or Microsoft Corporation. All trademarks and registered trademarks are the property of their respective owners.

## License

[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) — Attribution-NonCommercial.

- **Allowed**: Share, copy, redistribute, adapt, remix for **non-commercial** purposes
- **Required**: Attribution to the original author
- **Prohibited**: Commercial use of any kind

Full license text: [LICENSE](LICENSE)
