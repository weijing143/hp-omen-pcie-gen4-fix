@echo off
:: ============================================================
:: PCIe AER 强制禁用 - 防止 WHEA 17 雪崩→卡死
:: HP OMEN 16 / F.20 BIOS
:: 右键 → 以管理员身份运行，重启后生效
:: ============================================================

echo ========================================
echo  PCIe AER ForceDisable
echo  HP OMEN 16 - F.20 BIOS WHEA Mitigation
echo ========================================
echo.

echo [1/2] Applying pciexpress forcedisable...
bcdedit /set pciexpress forcedisable
if %errorlevel% neq 0 (
    echo [ERROR] 请以管理员身份运行此脚本
    echo 右键此文件 → 以管理员身份运行
    pause
    exit /b 1
)

echo.
echo [2/2] Verifying...
bcdedit /enum | findstr /C:"pciexpress"

echo.
echo ========================================
echo  Done! 请重启电脑使设置生效。
echo.
echo 恢复命令: bcdedit /set pciexpress default
echo ========================================
pause
