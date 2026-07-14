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

## License

CC BY 4.0 — see [hp-omen-pcie-gen4-crash-fix.md](hp-omen-pcie-gen4-crash-fix.md) for full details.
