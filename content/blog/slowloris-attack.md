---
title: "🦥 Slowloris Attack"
date: 2022-04-20T22:32:58+03:00
draft: false
tags: ["slowloris", "DoS", "DDoS", "security"]
categories: ["tech", "infra", "security"]
cover:
    image: "/images/slowloris.png"
---

Apart from being the cutest animal in the world 😍,
Slowloris is also a low-bandwidth **D**enial-**o**f-**S**ervice (DoS) attack
running on Application layer of the
[OSI model](https://en.wikipedia.org/wiki/OSI_model) (OSI Layer 7). The attack
allows the attacker to overwhelm a target HTTP server by exploiting the
internals of the [HTTP protocol](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol).

## How does a normal HTTP request-response work?
In a normal scenario the client opens a TCP connection after which it sends the
text information for the request. Each of the request's `lines` are terminated
by `\r\n` (so-called `CRLF` - carriage return line feed ⌨️) sequence.
The end of the request is signaled by `\r\n\r\n`.

Client (Alice) sends a HTTP `GET` request to a HTTP Server (Bob)
![HTTP GET](/images/http-get-bg-min.png)
The first line in the HTTP request is called `request line` holding information
about the HTTP request method `GET`, path `/` and query parameters
(`?key=value&hello=world`) as well as protocol version `HTTP/1.1`. Then the client
starts sending the request headers (`Host: example.com`, `User-Agent: ...`)
and so on. In the end the client sends `\r\n\r\n` to notify the server that
the request is done.

## How does a Slowloris attack works?
Slowloris attack works by utilizing partial HTTP requests. HTTP protocol works
as opening a client TCP connection to a target server and then sends the
HTTP request. The server usually waits until it receives the `\r\n\r\n` sequence
to process the request. Here comes the attack exploit. The attacker can send
multiple headers (thousands) to keep the connection open. By opening multiple
such connections and regularly sending partial information (such as headers)
the memory and sockets start building up on the server side. This way the client
can easily exhaust server's available resources (ports, sockets and memory).
Once the server's maximum connections has been exceeded, each new connection
won't be answered and denial-of-service will occur.
![HTTP Slowloris](/images/http-slowloris-min.png)

## Server configurations
Usually HTTP servers support configuration parameters like running
workers/threads, maximum open connections, timeouts and so on. The problem
comes when a server runs with the obsolete defaults configuration or it is
inherently exposed to such attack by its internal implementation.

### Apache server
The Apache server implementation is a thead-based implementation which is inherently
vulnerable to attacks like slowloris. The problem comes with that the OS defines
number of of maximum threads for each process. The numbers nowadays are pretty
big `cat /proc/sys/kernel/threads-max` but still if you don't have access to
kernel configuration that may be an issue. Another problem is memory footprint.
Each OS thread is associated with memory and also there are restrictions of
maximum Virtual Memory Areas (VMAs) per process `cat /proc/sys/vm/max_map_count`.
If the server does not have any additional protection through custom configuration
an attacker with very little bandwidth ([slowloris attack](https://github.com/itsankoff/slowloris))
can easily exhaust system's resources and create a denial-of-service scenario.

### Nginx server
Difference here is that the Nginx implementation relies on event based system
which saves the server from attacks such slowloris. But the problem may come
from having a Nginx server running its default configuration. Nowadays Nginx
comes with a default configuration that is pretty obsolete and it is usually
vulnerable to slowloris attack.

## Want to play with slowloris?
If you want to explore whether some of your deployments are vulnerable or
susceptible to slowloris attack, I've created a distributed Golang implementation.
The tools is able to run thousands of parallel slowloris connections against a target
server. You can download it and find more in the [🪣 repo](https://github.com/itsankoff/slowloris)

In the next article we will look at how to protect from such attacks.  
  
Best!
🦷
