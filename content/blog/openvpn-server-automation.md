---
title: "🚀 Automating OpenVPN Server Setup with Ansible"
date: 2024-12-23T17:40:46+01:00
description: "Part 2: Simplifying OpenVPN server setup using Ansible for automation enthusiasts. Follow this guide to deploy your VPN in minutes!"
draft: true
categories: ["tech", "infra", "security", "devops", "vpn"]
tags: ["Ansible", "Automation", "VPN", "EasyRSA", "Security", "Linux"]
cover:
    image: "/images/openvpn-automation-hero.webp"
---

## ✨ Introduction

Welcome to **Part 2** of the OpenVPN server series! 🎉 If you’ve gone through the [manual setup guide](https://thetooth.io/blog/openvpn-server-setup/), you know that setting up an OpenVPN server manually can be a bit tedious. 🤔

But what if you could automate the entire process? 💡 This guide introduces an **Ansible playbook** that takes care of everything—from installing dependencies to configuring the OpenVPN server and generating client certificates.

---

## 🛠 Prerequisites

Before diving in, ensure you have the following ready:

1. 🖥 A **Ubuntu 20.04LTS 22.04LTS or 24.04LTS** server
    (it should work for older versions or other Ubuntu flavor 🤞).
2. 🔑 SSH access to the server.
3. ⚙️ Ansible installed on your local machine.

---

## 🔄 Why Automate?

While the manual approach teaches you the nitty-gritty of OpenVPN, automation brings the following perks:

- 🕒 **Time-saving**: Get up and running in minutes.
- 📜 **Repeatability**: Easily redeploy or migrate your server.
- 📦 **Manageability**: Scale with minimal effort.

---

## 🚀 Getting Started with the Ansible Playbook

Here’s how you can automate the OpenVPN setup process:

### 1️⃣ Clone the Repository

First, clone the repository containing the playbook:

```bash
git clone https://github.com/itsankoff/ansible
cd ansible/ansible
```

### 2️⃣ Prepare Your Inventory

Update your inventory file (hosts) to specify the target server:

```ini
# VPN hosts
[vpn]
# targer_server_IP  | target_server_user    | sudo_enabled          | ssh_private_key_for_access
<server_IP>         ansible_user=<user>     ansible_become=true     ansible_ssh_private_key_file=<path/to/ssh/key>
```

Replace `<server_IP>`, `<user>`. Depending on your access to the server either
provide path to the SSH private key file in `ansible_ssh_private_key_file` or
delete it if you use SSH with password access (strongly discouraged)

### 3️⃣ Configure Variables

Add the users you want to generate VPN configurations for in `group_vars/openvpn.yml`:

```yaml
openvpn_users:
  - name: "janedoe"
    state: "active"
  - name: "johndoe"
    state: "revoked"
```

If the `state` is active, the user will have generated certificate and `<user>.ovpn` configuration.  
In case you want to stop access to the VPN for some users, use `state` revoked and rerun the VPN playbook.


### 4️⃣ Run the Playbook

Run the Ansible playbook to set up the OpenVPN server:

```bash
# from ansible/ansible directory execute
./deploy.sh live openvpn
```

Grab a coffee ☕ while Ansible takes care of everything.


## 🧾 What the Playbook Does

The playbook performs the following steps:
1. Install dependencies: Installs OpenVPN, EasyRSA, and other prerequisites.
2. Configure EasyRSA: Sets up the public key infrastructure (PKI).
3. Generate certificates: Builds the server and client certificates.
4. Set up networking: Configures IP forwarding and iptables rules.
5. Deploy server configuration: Creates the OpenVPN server configuration.
6. Start OpenVPN: Enables and starts the OpenVPN service.


## 🎉 Generating Client Configurations

**The ready OVPN configurations will bee stored in two places:**
1. On the target server in `/etc/openvpn/client-configs` dir.
2. On the local machine into `ansible/ansible/files/<user>.ovpn` NOTE: ovpn files are gitignored for safety.

## 🛠 Customization and Details

If you need slightly different setup of the server you can check all of the control variables in `ansible/ansible/group_vars/openvpn.yml`
but here a quick reference guide for the most important ones and their default values:

| Variable  | Description  | Default Value   |
| :-------- | :----------- | :-------------: |
| `openvpn_port` | Port for OpenVPN server | `1194` |
| `openvpn_proto` | Protocol (UDP/TCP) | `udp` |
| `openvpn_network` | Subnet for VPN clients | `10.8.0.0` |
| `openvpn_users` | List of users and their states (active) | `N/A` |
| `ca_common_name` | Common Name for the Certificate Authority | `OpenVPN Server` |
| `easyrsa_dir` | Directory for EasyRSA setup | `/etc/openvpn/easy-rsa` |


## 🐞 Troubleshooting

**Problem: No internet on the client**

**1. Ensure `iptables` rules are correctly applied.**

```bash
# Run on the VPN server
ip route
```

*Expected output should look like this:*
```text
default via <server_ip> dev eth0
10.8.0.0/24 dev tun0 proto kernel scope link src 10.8.0.1
```

**2. Check that `sysctl` enables IP forwarding:**

Run on the VPN server

```bash
sudo sysctl net.ipv4.ip_forward
```

*Expected output should look like this:*

```text
net.ipv4.ip_forward=1
```

**3. Monitor Packet Flow**

Client to VPN server traffic
```bash
sudo tcpdump -i tun0
```

VPN server to public internet traffic
```bash
sudo tcpdump -i eth0
```

Connect to the VPN server with the client configuration and run `ping google.com` on the client terminal or open Google in the browser.

* If the `tcpdump` for `tun0` does not produce logs, then the problem is between client and the VPN service
    * Inspect the client config for `proto` (`udp` or `tcp`. it **must match** the server configuration)
    * Inspect the client config for `remote` (it **must match** server IP)
    * Inspect the client config for `port` (it **must match** server IP. Make sure the port is open on the server `telnet <server_ip> <port>`)
* If the `tcpdump` for `eth0` does not produce logs, then the problem is either in kernel ip forwarding configuration or within firewall rules (`iptables` or `ufw`) Inspect:

```bash
iptables -t nat -L POSTROUTING -v
```

* The result should look like this:

```text
MASQUERADE  all  --  10.8.0.0/24  anywhere
```

* Add Explicit Forwarding Rules:

```bash
sudo iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
```

* Reinforce NAT Rules for OpenVPN
Ensure the MASQUERADE rule for tun0 traffic is correct:

```bash
sudo iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
```
> Note: Using -I ensures the rule is inserted at the top of the chain, taking precedence over
any other rules.

If you are interested in more in-depth knowledge around networking and firewalls, check the following articles:
- [Networking 101](/networking-101)
- [Linux Network Tooling](/network-tooling)
- [Linux Firewalls](/linux-firewalls)
- [Linux Modern Firewalls](/linux-modern-firewalls)

## 🌟 Conclusion

With this automated setup, you can focus on what matters—using your VPN! 🎉
If you have any feedback or issues, feel free to reach out or open an issue on [GitHub](https://github.com/itsankoff/ansible).
Happy automating! 🚀
