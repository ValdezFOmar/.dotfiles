#!/usr/bin/python

import subprocess


class Entry:
    def __init__(self, text: str, icon: str, action: list[str]):
        self.text = text
        self.icon = icon
        self.action = action


def main() -> int:
    entries = (
        Entry('Lock Screen', icon='system-lock-screen', action=['loginctl', 'lock-session']),
        Entry('Suspend', icon='system-suspend', action=['systemctl', 'suspend']),
        Entry('Logout', icon='system-log-out', action=['loginctl', 'terminate-user']),
        Entry('Reboot', icon='system-reboot', action=['systemctl', 'reboot']),
        Entry('Shutdown', icon='system-shutdown', action=['systemctl', 'poweroff']),
        Entry('Hibernate', icon='system-suspend-hibernate', action=['systemctl', 'hibernate']),
    )

    stdin = '\n'.join(f'{entry.text}\0icon\x1f{entry.icon}' for entry in entries)
    proc = subprocess.run(
        ('fuzzel', '--dmenu', '--index', '--hide-prompt'),
        encoding='utf-8',
        input=stdin,
        stdout=subprocess.PIPE,
        check=False,
    )
    if proc.returncode != 0:
        return proc.returncode

    index = int(proc.stdout)
    if index < 0:
        return proc.returncode
    if index >= len(entries):
        return 1

    proc = subprocess.run(entries[index].action, check=False)
    return proc.returncode


if __name__ == '__main__':
    raise SystemExit(main())
