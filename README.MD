# berightback
copiador de arquivos e diretórios

## setup
- criar um .sh, ex: `targets.sh`  
- nesse .sh, escrever uma lista nesse formato:  
```
dotlocal_dotconfig=(
    "$HOME/.config/godot"
    "$HOME/.config/blender"
    "$HOME/.config/audacity"
)

dotlocal_share=(
    "$HOME/.local/share/fonts"
    "$HOME/.local/share/flatpak"
    "$HOME/.local/share/applications"
)

root_dirs=(
    "/opt"
)
```