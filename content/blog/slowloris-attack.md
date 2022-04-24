---
title: "[PARTIAL] Slowloris Attack 🦥 "
date: 2022-04-20T22:32:58+03:00
draft: false
tags: ["slowloris", "DoS", "DDoS", "security"]
categories: ["tech", "infra", "devops"]
cover:
    image: "/images/slowloris.png"
---

# Slowloris Attack

Slowloris is an application layer **D**enial-**o**f-**S**ervice (DoS) attack
running on Application layer of the [OSI model](https://en.wikipedia.org/wiki/OSI_model) (OSI Layer 7).
The attack allows the attacker to overwhelm a target HTTP server by exploiting
the internal of the [HTTP protocol](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol).


## How does a Slowloris attack works?
Slowloris attack works by utilizing partial HTTP requests. HTTP protocol works
as opening client TCP connection to a target server and then sends the HTTP request.
The first line in the HTTP request is called `request line` holding information
about the HTTP request method, path and query parameters as well as protocol version.
Then the client starts sending the request headers. Here comes the attack exploit.
Usually the server waits for the client to send the whole request (request line,
headers and body) to process it. The attacker can send multiple headers (thousands)
to keep the connection open. By opening multiple such connections and regularly
sending partial information (such as headers) the server memory and sockets start
build-up. This way the client can easily exhaust server available ports and sockets.


## Server configurations
Usually servers supports configuration of parameters like running workers,
maximum open connections, timeouts and so on. The problem comes when a server
runs defaults parameters or it is inherently exposed to such attack by its
internal implementation.

### Apache server
Apache server implementation is a thead-based implementation which is inherently
vulnerable to attacks like slowloris. Let's see why:

### Nginx server
Difference here is that nginx implementation relies on event based system
which saves the server from attacks such slowloris. But the problem may come
from having nginx running its default configuration. Nowadays nginx comes
with default configuration that is pretty obsolete and it is usually vulnerable
to slowloris attack.
