#!/usr/bin/python


import json
import os
import re
import subprocess
from typing import NamedTuple, Self, TypedDict

SCRIPT_NAME = os.path.basename(__file__)


class Event(TypedDict):
    index: int
    event: str
    on: str


class SinkState(NamedTuple):
    volume: int
    muted: bool

    _VOLUME_PATTERN = re.compile(r'\d+\.\d+')

    @classmethod
    def get(cls) -> Self:
        output = subprocess.run(
            ['/usr/bin/wpctl', 'get-volume', '@DEFAULT_SINK@'],
            capture_output=True,
            encoding='utf-8',
        ).stdout.strip()

        match = cls._VOLUME_PATTERN.search(output)
        volume = int(float(match[0]) * 100) if match else 0
        muted = output.endswith('[MUTED]')

        return cls(volume, muted)


def send_notification(summary: str, body: str):
    try:
        subprocess.run(
            [
                '/usr/bin/notify-send',
                f'--app-name={SCRIPT_NAME}',
                '--hint=string:x-dunst-stack-tag:volume_indicator_notification',
                summary,
                body,
            ]
        )
    except Exception:
        pass


def display_indicator(state: SinkState):
    if state.muted:
        icon = 'notification-audio-volume-muted'
    elif state.volume < 30:
        icon = 'notification-audio-volume-low'
    elif state.volume < 70:
        icon = 'notification-audio-volume-medium'
    else:
        icon = 'notification-audio-volume-high'

    subprocess.run(
        [
            '/usr/bin/notify-send',
            f'--app-name={SCRIPT_NAME}',
            '--urgency=low',
            f'--icon={icon}',
            '--hint=string:x-dunst-stack-tag:volume_indicator',
            f'--hint=int:value:{state.volume}',
            f'{state.volume}%',
        ],
        capture_output=True,
    )


def main() -> int:
    prev_state = SinkState.get()

    with subprocess.Popen(
        ['/usr/bin/pactl', '--format=json', 'subscribe'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    ) as process:
        assert process.stdout and process.stderr

        while line := process.stdout.readline():
            try:
                event: Event = json.loads(line)
                if event['event'] != 'change' or event['on'] != 'sink':
                    continue
                state = SinkState.get()
                # Some 'change' events don't actually represent a change in volume or mute state.
                # This is really notorious with Firefox.
                if state == prev_state:
                    continue
                display_indicator(state)
                prev_state = state
            except Exception as e:  # prevent exceptions from terminating the process
                send_notification('Error while trying to display volume', f'<tt>{e}</tt>')

    if process.returncode not in (0, 130):
        send_notification(
            f'"{process.args}" terminated with code {process.returncode}',
            process.stderr.read().decode('utf-8', errors='replace'),
        )
    return process.returncode


if __name__ == '__main__':
    raise SystemExit(main())
