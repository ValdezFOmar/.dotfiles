# WiFi Connection

## Using iwctl (Live boot)

Type `iwctl` and the interactive prompt should start:

```console
$ iwctl
[iwd]#
```

> [!TIP]
> To see all available commands, type: `[iwd]# help`

List all available WiFi devices:

```console
[iwd]# device list
```

Initiate a scan for networks:

```console
[iwd]# station [device] scan
```

To list all the networks:

```console
[iwd]# station [device] get-networks
```

Connect to a network:

```console
[iwd]# station [device] connect [SSID]
```


## Using NetworkManager

List nearby Wi-Fi networks:

```sh
nmcli device wifi list
```

Connect to a Wi-Fi network:

```sh
nmcli device wifi connect [SSID] password [password]
```
