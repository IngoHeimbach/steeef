# steeef-modified

![Screenshot](https://github.com/IngoHeimbach/steeef/blob/master/steeef-modified.png)

Zsh steeef theme as a standalone repository. The purpose behind this repo is avoid having a
dependency on oh-my-zsh when using the steeef theme. Zsh plugin managers such as Antibody can use
the theme without having to use oh-my-zsh. Credits to the original theme authors.

Modified to my liking.

# Usage
Example usage with Antibody:

    source <(antibody init)
    antibody bundle IngoHeimbach/steeef

# Changes from the original steeef
- Removed the checks in the preexec and chpwd hooks to see if the current command is a git or vcs
  command. Instead always update the prompt.
- Prompt is more compact.
- Changed colors. User and hostname are white to be unobtrusive. The other colors are changed to my liking.
- Fixed vcs information for unstaged files. Previously, the unstaged files indicator was only shown if unstaged
  files were present in the current working directory. Now, the whole repository is considered.
- The error code of the last command is shown if it failed.
- Added an indicator for normal mode (vi key bindings).

# Credits
- Stephen Price
- Steve Losh
- Henrique Vicente
