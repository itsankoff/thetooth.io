---
title: "[PARTIAL] Slowloris Attack 🦥 "
date: 2022-04-20T22:32:58+03:00
draft: false
tags: ["slowloris", "DoS", "DDoS", "security"]
categories: ["tech", "infra", "security"]
cover:
    image: "/images/slowloris.png"
---

# Slowloris Attack

Slowloris is an application layer **D**enial-**o**f-**S**ervice (DoS) attack
running on Application layer of the [OSI model](https://en.wikipedia.org/wiki/OSI_model) (OSI Layer 7).
The attack allows the attacker to overwhelm a target HTTP server by exploiting
the internals of the [HTTP protocol](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol).

## How normal HTTP request-response works?
In normal scenario the client opens a TCP connection after which it sends the
text information for the request. Each of the request `lines` are terminated
by `\r\n` sequence. The end of the request is signaled by `\r\n\r\n`.

Client (Alice) sends an HTTP `GET` request to a HTTP Server (Bob)
![HTTP GET](/images/http-get-bg-min.png)
The first line in the HTTP request is called `request line` holding information
about the HTTP request method `GET`, path `/` and query parameters as well as
protocol version `HTTP/1.1`. Then the client starts sending the request
headers - `Host: example.com`, `User-Agent: ...` and so on. In the end the
client sends `\r\n\r\n` to notify the server that the request is done.

## How does a Slowloris attack works?
Slowloris attack works by utilizing partial HTTP requests. HTTP protocol works
as opening a client TCP connection to a target server and then sends the
HTTP request. The server usually waits until it receives the `\r\n\r\n` sequence
to process the request. Here comes the attack exploit. The attacker can send
multiple headers (thousands) to keep the connection open. By opening multiple
such connections and regularly sending partial information (such as headers)
the memory and sockets start building up on the server side. This way the client
can easily exhaust server's available resources (ports, sockets and memory).
![HTTP Slowloris](/images/http-slowloris-min.png)


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
