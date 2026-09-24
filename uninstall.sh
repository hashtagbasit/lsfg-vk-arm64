#!/bin/bash
# Removes what install.sh put in place. Use sudo + --system for a system install.
if [[ "${1:-}" == --system ]]; then
    rm -f /usr/lib/liblsfg-vk-arm64.so /usr/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation_arm64.json
else
    rm -f "$HOME/.local/lib/liblsfg-vk-arm64.so" "$HOME/.local/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation_arm64.json"
fi
echo removed
