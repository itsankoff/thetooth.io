---
title: "SSH access made easy 📟"
date: 2022-01-17T13:39:58+02:00
draft: false
---

If you are landing on this page you most probably already know what SSH is and
how to use it through CLI.  

If not, you can always read [here](https://en.wikipedia.org/wiki/Secure_Shell). 

Usually, at the beginning, people start with simple `ssh <user>@<host>` CLI usage.
With time, people start using more and more advanced options which results in
having messed-up commands that is hard or impossible to remember.

Let's give you an example:  

```
## SSH with custom non-default port
ssh <user>@<long_host> -p <custom_non_default_port>
# SSH with custom access file
ssh -i /path/to/another_access_file <another_user>@<another_long_host> -p <some_magical_non_default_port>
# SSH through Jump server
ssh -J <magical_host_to_jump_server> <target_host>
#.. and so on and so forth
```

Remembering dictionary information nowadays should be considered a **crime**! So
what you can do to make yourself a proper citizen of the world?


## SSH config on the rescue
SSH utility has a metaverse of option on it own, so let's try to utilize them
and simplify our work! One of them is the **SSH config**. The SSH config is a
configurational file, usually stored at `~/.ssh/config` where you can pre-configure
hosts and access configuration that you use frequently and simplify the access shown
above to:

```
# access with custom port
ssh test
# access with custom access file
ssh ci
# access through jump server
ssh prod
```

### Setup
1. Check whether you have `~/.ssh/config` on your local setup. If, let's create it!
2. Open the file with a text editor (`vim`, `VSCode`, ~~nano~~, etc...)
3. Write down:
```
Host test
    Hostname <[host|ip]>                        # mandatory
    Port <port>                                 # optional
    User <username>                             # optional | nice-to-have
    IdentityFile <path/to/identity_file>        # optional | nice-to-have
    ProxyJump <[host|ip]_of_jump_server>        # optional
```
4. Save the file

Where:
* `host|ip` - is the DNS host or IP address of the target server
* `port` - you can skip this if the target server runs SSH on default `22` port. Otherwise you will need to state it
* `username` - the name of the remote user on the target server you want to connect with. **NOTE**: Default is your local machine username
* `/path/to/identity_file` - this is the path to the private key you use to connect to the target server. **NOTE**: Default is `~/.ssh/id_rsa` or an iteration of the files within `~/.ssh` directory
* `host|ip_of_jump_server` - if you want to connect to a target server using a [jump server](https://en.wikipedia.org/wiki/Jump_server), you should specify its DNS host or IP address here.

There are a ton of other options which you can explore [here](https://linux.die.net/man/5/ssh_config)

### Usage and Access
Just run `ssh test`. If you have configured everything properly
you should be connected to the target server with a clean and easy-to-remember CLI.


### Troubleshooting
In case the setup does not work, there are a few things you can inspect:
1. 🙇 Make sure you saved `~/.ssh/config`
2. ✏️ Check for typos within the `~/.ssh/config`
3. ☎️ If using DNS records for hostname configuration, inspect whether your setup can resolve them `nslookup <host>`
4. 🔌 If you are not sure whether the configured port is open you can always run `nc -G 1 <host> <port>`, where `1` is one second of timeout. If the operation times out, most probably the port is not open.
5. 🖨️ Check for network access to the target server `ping <host>`. **NOTE**: Sometimes admins disable `ping`, so it may not work. You can use `traceroute` in that case.

## Wrap-up
At the beginning it may seem a burden to maintain your SSH config file. But with time
and exposure to more servers you will eventually end up using SSH config anyway.

At the end - What if you want to create another host for access. Just repeat the steps above
and enjoy your day! 🎉

---
PS: If you have a friend who is struggling with SSH you can always share it with
the links down-below ⬇️
