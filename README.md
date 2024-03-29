# etmux

Simple utility for easily starting and joining [tmux] sessions.

`etmux` is short for "Easy tmux".  It was chosen because it had limited
competition for tab completion: In a default install of Ubuntu all you have to
type is `et<TAB>`.

## Install

Put the `etmux` shell script in a folder in your path.

## Usage

Simply call `etmux` to start a new session.

    etmux

By default `etmux` will name the session after the current directory. If a session
with that name already exists, it will join that instead of creating a new
one.  This prevents you from unknownlingly starting a bunch of sessions
(like this author does).

If you want to call your session something else, just give `etmux` a different name:

    etmux mySession

Again, if a session with the same name already exists, `etmux` will attach to
that session.

If you are already in a `tmux` session when you call `etmux`, instead of nesting
the sessions, `etmux` will switch you over to the new session.

To see all the options try:

    etmux --help

## Predefined Sessions

`etmux` can open predefined sessions.  Just set the `$ETMUX_PATH` environment
variable to a directory or two that contains your projects:

    export ETMUX_PATH=/path/to/sessions/one:/path/to/sessions/two

And then you can give the name of a project to etmux...

    etmux proj1

This will start a tmux session in the directory for that project.

Sometimes it is handy to go one step further and have predefined sessions, complete
with windows, panes and commands chosen ahead of time.  Easy! Just put a shell script
one of the directories specified with the `ETMUX_PATH` env variable, or put a
`.etmux.sh` in a specific directory, found above and `etmux` will run it when
starting your session.

And as would be expected, if the session is already started, `etmux` will just
join that session instead of starting it again and rerunning your script.

The smallest feature complete script I can think of:

    # change the default working directory for this session
    cd /path/to/session/root

    # start this new session, even if we're already in a session
    env TMUX= tmux new-session -d -t mySession

    # set up panes and windows for the new session
    tmux split-window -h -t mySession

    # join our new session
    if [ -z $TMUX ]; then
      # if we aren't in a session, then attach to the new one
      tmux attach-session -t mySession
    else
      # if we are in a session, then switch this client over to the new one
      tmux switch-client -t mySession
    fi

The nice thing about writing your scripts like this is that they are regular old
shell scripts and you could run them directly if you ever decide you don't want
to use `etmux`.

However, `etmux` can make writing these scripts easier. Because the starting and
joining session code is done in every script, `etmux` makes two custom commands
available to your script: `start` and `join`. These commands do the respective
parts from the above example. Also having to rewrite the session name so many
times makes it a pain to change, so `etmux` will pass in the session name for you
as `$session`.  Using those `etmux` shortcuts, our script looks like:

    # change the default working directory for tmux
    cd /path/to/session/root

    start

    # set up panes and windows
    tmux split-window -h -t $session

    join

Which is pretty simple.

Sometimes all you want to do is just set the default working directory. I have a
lot of scripts that just look like this:

    cd /path/to/session/root && start && join

You may be thinking that all this looks complicated, and that the configuration
files of Tmuxinator or Teamocil might be easier.  And I mean nothing against
either of those projects (they were the inspiration for this project after all),
but if you're going to learn how to write configuration files for either of
those, why don't you just instead learn the `tmux` API which, while it looks
scary at first, is actually pretty straight-forward?  Either way you're still
learning something new and this way you can use your new found skillz in `tmux`
itself. And if you decide you don't like this project you haven't wasted your
time.

## ZSH Command Line Completion

`emtux` comes with command line completion for ZSH.  To enable this you need to
do three things

First, in your `.zshrc` file, specify a directory for custom completion scripts:

    fpath=(~/.zsh/completion $fpath)

Second, in your `.zshrc` file, after the previous line, enable completion:

    autoload -U compinit
    compinit

Third, put the `_etmux` completion script in the directory specified in the
first step:

    mkdir -p ~/.zsh/completion
    mv zsh_completion/_etmux ~/zsh/completion

Now you can enjoy tab completion on all active sessions and specified
`etmux` scripts.

Sessions that are currently active are suffixed with a `+`.

[tmux]: http://tmux.sourceforge.net/
[Tmuxinator]: https://github.com/aziz/tmuxinator
[Teamocil]: https://github.com/remiprev/teamocil

