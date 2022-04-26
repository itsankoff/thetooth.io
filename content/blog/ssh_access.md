---
title: "SSH access made easy 📟"
date: 2022-01-17T13:39:58+02:00
draft: false
tags: ["ssh", "access", "config"]
categories: ["tech", "infra", "devops"]
cover:
    image: "/images/ssh_config_cover.png"
---

If you are landing on this page you probably already know what SSH is and
how to use it through CLI. If not, take a quick look [here](https://en.wikipedia.org/wiki/Secure_Shell).
In general, SSH is the most common tool people use to connect to remote systems and servers.

Usually, in the beginning, a user starts with simple `ssh <user>@<host>` CLI usage.
With time, using more and more advanced options, the commands become lengthy and clumsy
resulting in a mess that is hard or impossible to remember.

Let's give you an example:  

```
# My SSH life begins here
ssh user@host
# :) - "That was easy"

# Then some person decides to enforce security through obscurity
ssh user@this.is.a.super.long.host.that.is.hard.to.remember.private.com
# ;) - "Eh mate, you can do better"

# Then the same person decides to change the default port
ssh -p 43571 user@this.is.a.super.long.host.that.is.hard.to.remember.private.com
# X) - "I am pretty good at numerology"

# That's not enough, so let's disable password auth and
# enforce public/private key authentication only
ssh -p 43571 -i /where/the/heck/is/my/private/key user@this.is.a.super.long.host.that.is.hard.to.remember.private.com
# :| - "Grr..."

# somebody from the infra team:
# "Mmm, the security team asked us to put everything in a private network
# and you will need an access the server through our jump server"
ssh -J jumbo@this.is.another.obscure.host.private.jump.com:62891 -i /where/the/heck/is/my/private/key -p 43571 user@this.is.a.super.long.host.that.is.hard.to.remember.private.com
# :@ - "Just shut up and teach me about the SSH config file!"
```

Remembering dictionary information nowadays should be considered a **crime**!
So what can you do to make yourself a proper citizen of the world?


## SSH config on the rescue
SSH utilities have a ton of options and configuration, so let's try to utilize
them and simplify our work! One of them is the **SSH config**. The SSH config is a
configurational file, usually stored at `~/.ssh/config` where you can configure
hosts and their access options that you use frequently and simplify the access
shown above to:

```
# access the 'this.is.a.super.long.host.that.is.hard.to.remember.private.com'
ssh test

# access the non-default-port (43571) on you-know-which-host
ssh ci

# access the production for f@ck sake!
ssh prod
```

### Setup
1. Check whether you have `~/.ssh/config` on your local setup. If the file does not exist, let's create it! *NOTE: `~`(tilda) means the home directory of the current user.*
2. Open the file with a text editor (`vim`, `emacs`, `VSCode`, *~~nano~~*, etc.)
3. Write down:
```
Host <alias>
    Hostname <[host|ip]>                        # mandatory
    Port <port>                                 # optional
    User <username>                             # optional | nice-to-have
    IdentityFile <path/to/identity_file>        # optional | nice-to-have
    ProxyJump <[host|ip]_of_jump_server>        # optional
```
4. Replace the mandatory placeholders and remove the unused ones
4. Save the file

Where:
* `Hostname <[host|ip]>` - the DNS host or IP address of the target server
* `Port <port>` - you can skip this if the target server runs SSH on the
    default `22` port. Otherwise, you will need to state it.
* `User <username>` - the name of the remote user on the target server
    you want to connect with. **NOTE**: Default is your local machine username `echo ${USER}`
* `IdentifyFile </path/to/identity_file>` - this is the path to the private key
    you use to connect to the target server. **NOTE**:
    Default is `~/.ssh/id_rsa` or an iteration of the files within `~/.ssh` directory
* `ProxyJump <[host|ip]_of_jump_server>` - if you want to connect to
    the target server using a
    [jump server](https://en.wikipedia.org/wiki/Jump_server),
    you should specify its DNS host or IP address here.

There is a ton of other options which you can explore
[here](https://linux.die.net/man/5/ssh_config)

### Usage and Access
```
# :) - My SSH life begins again
ssh test

# ;) - This time way easier
ssh ci

# X) So easy that I may run 'rm -rf /*' to spice it up a bit
ssh prod
```
If you have configured everything properly you should be connected to
the target server with a clean and easy-to-remember CLI. 🎊


### Troubleshooting
In case the setup does not work, there are a few things you can inspect:
1. ✏️ Make sure you saved `~/.ssh/config`
2. 🔎 Check for typos within the `~/.ssh/config`
3. ☎️ If using DNS records for hostname configuration, inspect whether
    your local setup can resolve them `nslookup <host>`
4. 🔌 If you are not sure whether the configured port is open you can
    always run `nc -G 1 <host|ip> <port>`, where `-G 1` is one second of timeout.
    If the operation times out, most probably the port is not open.
5. 🖨️ Check for network access to the target server `ping <host>`.
    *NOTE: Sometimes admins disable `ping`, so it may not work*.
    You can use `traceroute` or `nc` in that case.
6. 🔓 In case of `WARNING: UNPROTECTED PRIVATE KEY FILE!`
    run `chmod 0600 /path/to/private/key`

## Wrap-up
In the beginning, it may seem an overkill to maintain your SSH config file.
But with time and exposure to more servers you will eventually end up using
SSH config anyway.

In the end - What if you want to create another host for access. Just repeat
the steps above and enjoy your day! 🎉

---
PS: If you have a friend who struggles with SSH you can always share it with
the links down-below ⬇️

Best! 🦷
