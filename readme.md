# dark_dot_cave

A simple and modular dotfiles setup using [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

1. Clone the repository into the home directory:
   ```sh
   git clone https://github.com/yourusername/dark_dot_cave.git ~/dark_dot_cave
   ```

2. Change into the repository directory:
   ```sh
   cd ~/dark_dot_cave
   ```

3. Use Stow to symlink configurations:
   ```sh
   stow data-storage
   ```
   This applies the `data-storage` configuration, which is used for Podman pods.

## Example Usage

To apply the `data-storage` configuration:
```sh
stow data-storage
```

To remove symlinks:
```sh
stow -D data-storage
```

## Adding New Configurations

1. Place the configuration files inside a new folder in `dark_dot_cave`.
2. Ensure the folder structure matches the expected locations relative to `$HOME`.
3. Use `stow folder_name` to apply the configuration.

## Updating Dotfiles

After making changes to the dotfiles, commit and push them:
```sh
git add .
git commit -m "Updated configurations"
git push
```

## Notes
- Ensure Stow is installed (`sudo apt install stow` or `sudo pacman -S stow`).
- Run `stow -n folder_name` for a dry run before applying changes.

## License
[Unlicense](LICENSE)

