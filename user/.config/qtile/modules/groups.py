from libqtile.config import Group

groups = [Group(name=char, label=char.upper()) for char in "asdfuiop"]
