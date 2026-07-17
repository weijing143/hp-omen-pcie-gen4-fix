# ============================================================
# PCIe AER 强制禁用 - 防止 WHEA 17 雪崩→卡死
# HP OMEN 16 / F.20 BIOS
# 以管理员身份运行，重启后生效
# ============================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " PCIe AER ForceDisable" -ForegroundColor Cyan
Write-Host " HP OMEN 16 - F.20 BIOS WHEA Mitigation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "[ERROR] 请以管理员身份运行此脚本" -ForegroundColor Red
    Write-Host "右键 PowerShell → 以管理员身份运行 → 再执行此脚本"
    exit 1
}

Write-Host "[1/3] 应用 pciexpress forcedisable..."
bcdedit /set pciexpress forcedisable

Write-Host ""
Write-Host "[2/3] 验证设置..."
$result = bcdedit /enum | Select-String -Pattern "pciexpress"
if ($result -match "ForceDisable") {
    Write-Host "  ✅ 设置成功: $($result.Line.Trim())" -ForegroundColor Green
} else {
    Write-Host "  ❌ 设置失败，请检查" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[3/3] 完成！" -ForegroundColor Green
Write-Host ""
Write-Host "请重启电脑使设置生效。" -ForegroundColor Yellow
Write-Host ""
Write-Host "--- 恢复命令（如需撤销）---" -ForegroundColor DarkGray
Write-Host "bcdedit /set pciexpress default" -ForegroundColor DarkGray
Write-Host "然后重启"
Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
