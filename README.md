# NixOS Tweaks for Lenovo ThinkPad T14 Gen 5 AMD

This repository contains the code related to [my blog post](https://blog.bootkit.dev/post/nix-extravaganza-thinkpad-t14-gen5-amd).
For more information, read the blog post [here](https://blog.bootkit.dev/post/nix-extravaganza-thinkpad-t14-gen5-amd).

It contains two hacks that 'fix' some issues. I personally use this as part of my [snowfall-lib](https://snowfall.org/reference/lib/) configuration.
This is my relevant part of my folder structure of my flake:
```bash
~/flake $ tree -L 5 --charset ascii
.
|-- flake.lock
|-- flake.nix
|-- modules
|   `-- nixos
|       `-- services
|           |-- t14-hibernate
|           |   `-- default.nix
|           `-- t14-micmuteled
|               `-- default.nix
`-- systems
    `-- x86_64-linux
```

In my system configuration I use the following to activate and configure the tweaks' services:

```nix
{pkgs, ...} : {
  config = {
    services.t14-hibernate.enable = true;
    services.t14-micmuteled = {
      enable = true;
      userId = 1337;
    };
  };
}
```