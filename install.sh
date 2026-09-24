#!/bin/bash
# Installs the ARM64 lsfg-vk layer next to the decky-lsfg-vk plugin's x86 one.
#   ./install.sh            for the current user
#   sudo ./install.sh --system   system-wide (/usr/lib + /usr/share)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
LIB_SRC="$HERE/liblsfg-vk-arm64.so"
[[ -f "$LIB_SRC" ]] || { echo "liblsfg-vk-arm64.so not found next to this script"; exit 1; }
[[ "$(uname -m)" == aarch64 ]] || echo "warning: this isn't an aarch64 system"

if [[ "${1:-}" == --system ]]; then
    LIB=/usr/lib/liblsfg-vk-arm64.so
    JSON_DIR=/usr/share/vulkan/implicit_layer.d
else
    LIB="$HOME/.local/lib/liblsfg-vk-arm64.so"
    JSON_DIR="$HOME/.local/share/vulkan/implicit_layer.d"
fi

mkdir -p "$(dirname "$LIB")" "$JSON_DIR"
install -m755 "$LIB_SRC" "$LIB"
cat > "$JSON_DIR/VkLayer_LS_frame_generation_arm64.json" <<JSON
{
  "file_format_version": "1.0.0",
  "layer": {
    "name": "VK_LAYER_LS_frame_generation_arm64",
    "type": "GLOBAL",
    "api_version": "1.4.313",
    "library_path": "$LIB",
    "implementation_version": "1",
    "description": "Lossless Scaling frame generation (aarch64)",
    "functions": {
      "vkGetInstanceProcAddr": "layer_vkGetInstanceProcAddr",
      "vkGetDeviceProcAddr": "layer_vkGetDeviceProcAddr"
    },
    "enable_environment": { "LSFG_PROCESS": "decky-lsfg-vk" },
    "disable_environment": { "DISABLE_LSFG": "1" }
  }
}
JSON
echo "installed $LIB"
echo "manifest  $JSON_DIR/VkLayer_LS_frame_generation_arm64.json"
