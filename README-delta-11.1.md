# Delta 11.1 — DNF5 install fix

Fedora 44 uses DNF5.

The previous package installer invoked:

```sh
dnf install -y -- package...
```

DNF5 rejects the `--` separator in that position.

The installer now calls:

```sh
dnf install -y package...
```

The package list is controlled by this repository, so no option separator is
required.
