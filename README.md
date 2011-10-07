# etmux

Simple utility for easily starting and joining [tmux] sessions.

`etmux` is short for "Easy tmux".  It was chosen because it had limited competition for tab completion.  In a default install of Ubuntu all you have to type is `et<TAB>`.

## Install

Put the `etmux` shell script in a folder in your path.  If that's not enough instruction, paste these lines into your terminal:

    export PATH=~/bin:$PATH
    mkdir ~/bin/
    mv etmux ~/bin/

## Usage

Simply call `etmux` to start a new session.

    etmux

Just like `tmux`, the default session is named `0`.  Unlike `tmux` if a session with a name `0` already exists, it will join that instead of creating a new session.  Thus preventing you from unknownlingly starting a bunch of sessions (like this author does).

If you want to call your session something else, just give `etmux` a
different name:

    etmux mySession

Again, if a session with the same name already exists, `etmux` will attach to that session.

If you are already in a `tmux` session when you call `etmux`, instead of nesting the sessions, `etmux` will switch you over to the new session.

## Predefined Sessions

Sometimes it is handy to have predefined sessions, with windows, panes and
commands chosen ahead of time (like is addressed by [Tmuxinator] or [Teamocil]).
Easy!  Just put a shell script in `~/.etmux-projects` that uses the `tmux` command line API to set up your session.

If you name your script `mySession` and it exists and is executable at `~/.etmux-projects/mySession` then you can run it with:

    etmux mySession

And as would be expected, if the session is already started, `etmux` will just join that session instead of rerunning the script and starting it again.

The smallest feature complete script I can think of:

    # change the default working directory for this session
    cd /path/to/project/root

    # start the session
    env TMUX= tmux new-session -d -t mySession

    # set up panes and windows
    tmux split-window -h -t mySession

    # actually join session
    if [ -z $TMUX ]; then
      tmux attach-session -t mySession
    else
      tmux switch-client -t mySession
    fi

The nice thing about writing your scripts like this is that they are regular old shell scripts and you could run them directly if you don't want to use `etmux` and they would work fine.  You can't do that with a `YAML` configuration file!

But if that is too much for you, because the starting and joining session code is done in every script, `etmux` will pass in the variables `$start` and `$join`  which will do that for you.  Also having to rewrite the session name so many times makes it a pain to change, so `etmux` will pass in the session name for you as `$session`.  Using those variables, our script looks like:

    # change the default working directory for tmux
    cd /path/to/project/root

    $start

    # set up panes and windows
    tmux split-window -h -t $session

    $join

Which is pretty simple.  

Sometimes all you want to do is just set the default working directory.  I have a lot of scripts that just look like this:

    cd /path/to/project/root && $start && $join

You may be thinking that this looks complicated, and that the configuration files of Tmuxinator or Teamocil might be easier.  And I mean nothing against either of those projects (they were the inspiration for this project after all), but if you're going to learn how to write configuration files for either of those, why don't you just instead learn the `tmux` API which, while it looks scary at first, is actually pretty straight-forward?  Either way you're still learning something new and this way you can use your new found skillz in `tmux` and if you decide you don't like this project you haven't wasted your time!

If you don't want to store your scripts in `~/.etmux-projects` you can set the `$ETMUX_PATH` environment variable to some other location:

    export ETMUX_PATH=/project/location/one:/project/location/two

## ZSH Command Line Completion

`emtux` comes with command line completion for ZSH.  To enable this you need to do three things

First, in your `.zshrc` file, specify a directory for custom completion scripts:

    fpath=(~/.zsh/completion $fpath)

Second, in your `.zshrc` file, after the previous line, enable completion:

    autoload -U compinit
    compinit

Third, put the `_etmux` completion script in the directory specified in the first step:

    mkdir -p ~/.zsh/completion
    mv zsh_completion/_etmux ~/zsh/completion

Now you can enjoy tab completion on all active sessions and specified `etmux` scripts.

Sessions that are currently active are suffixed with a `+`.

[tmux]: http://tmux.sourceforge.net/
[Tmuxinator]: https://github.com/aziz/tmuxinator
[Teamocil]: https://github.com/remiprev/teamocil

