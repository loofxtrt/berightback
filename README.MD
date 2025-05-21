# berightback
copiador de arquivos e diretórios

## setup
- criar um .sh no diretório raiz do projeto, ex: `targets.sh`  
- nesse .sh, escrever uma lista nesse formato, com o nome de todos os arrays começando com target_:  
```
target_dotlocal_dotconfig=(
    "$HOME/.config/godot"
    "$HOME/.config/blender"
    "$HOME/.config/audacity"
)

target_dotlocal_share=(
    "$HOME/.local/share/fonts"
    "$HOME/.local/share/flatpak"
    "$HOME/.local/share/applications"
)

target_root_dirs=(
    "/opt"
)
```
- alterar a linha 40 do `berightback.sh` pra importar as variáveis do arquivo novo criado caso o nome dele seja diferente de `targets.sh`  
- e opcionalmente alterar o if da linha 45 caso o prefixo do nome das variáveis não seja target_

## run
`./berightback.sh` no terminal da raiz do projeto