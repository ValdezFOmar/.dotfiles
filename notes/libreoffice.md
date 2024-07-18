# LibreOffice Programming in Python

## Resources

Information about the LibreOffice python API and tips for development.

- [APSO][apso]: Extension for managing python scripts and running an interactive shell from within LibreOffice.
- [Import `uno` from system python](https://bbs.archlinux.org/viewtopic.php?id=145384)
- [LibreOffice Extensions](https://wiki.documentfoundation.org/Extensions)
- [Developing LibreOffice Extensions](https://wiki.documentfoundation.org/Development/Extension_Development)
- [Template for creating extensions](https://github.com/allotropia/libreoffice-python-starter)
- [Python Macros Tutorial](http://christopher5106.github.io/office/2015/12/06/openoffice-libreoffice-automate-your-office-tasks-with-python-macros.html)
- Example macros can be found at `/usr/lib/libreoffice/share/Scripts/python`

Example repositories of various LibreOffice extensions.

- [APSO source code](https://gitlab.com/jmzambon/apso)
- [`factur-x-libreoffice-extension`](https://github.com/akretion/factur-x-libreoffice-extension)
- [`libreoffice-code-highlighter`](https://github.com/jmzambon/libreoffice-code-highlighter)


## Access through the interactive python shell

To access the LibreOffice python API from the system python executable,
append `/usr/lib/libreoffice/program/` (this is where the modules/so files
for the python API are stored) to `PYTHONPATH`.

```sh
PYTHONPATH=/usr/lib/libreoffice/program/ python
```

Alternatively use the console provided by the APSO extension. Go to
*Tool > Macros > Organize python scripts*, select the
*MyMacros > apso.oxt > tools > console* and hit **Execute** to run it.

## Including external modules

External modules should be placed under the `pythonpath/` directory
alongside the main python script, given the following structure:

```
.
├── pythonpath/
│   ├── module_a/
│   └── module_b/
└── main.py
```

[apso]: https://extensions.libreoffice.org/en/extensions/show/apso-alternative-script-organizer-for-python
