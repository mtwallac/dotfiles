## Setup

As per https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/.

Don't forget to update any submodules: `git submodule update --init --recursive`.

Create a `.gitconfig.local` to put your Git credentials (and any other settings):

```
[user]
  name = Michael Wallace
  email = yourgithub@email.com
```
