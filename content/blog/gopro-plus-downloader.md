---
title: "⛓️‍💥 Breaking the 25 File Limit on GoPro Plus Cloud"
description: "Command line (CLI) and Dockerized tooling for downloading assets from GoPro (Plus) Cloud"
date: 2024-12-26
draft: false
tags: ["Python", "Docker", "GoPro"]
categories: ["tech", "tooling"]
cover:
    image: "/images/gopro-downloader-hero.webp"
---

## 🛠️ Why I Hacked GoPro Plus Cloud?

If you're a GoPro Plus user, you’ve probably felt the frustration of trying to download your media in bulk,
only to be stopped by the **25-file limit**. This arbitrary restriction makes it tedious 😤😡 to migrate
your content to other platforms like Google Drive, Dropbox, or your self-hosted NAS (e.g. Synology).

So I decided to build a solution that lets you bypass this limitation and take full control of your media.
Today, I’ll walk you through what the tool does, how you can use it,
and why this matters for anyone looking to break free ⛓️‍💥 from proprietary cloud ecosystems.

Let’s dive in! 🎉

---

## 🔧 What This Tool Can Do?

The [GoPro Cloud Downloader](https://github.com/itsankoff/gopro-plus) is a simple yet powerful Python-based solution that allows you to:

- ⬇️  **Download Your Entire GoPro Library in One Go**: Forget the 25-file restriction! Download hundreds (or thousands) of files from GoPro Plus without lifting a finger.
- 💸 **Migrate Your Media Anywhere**: Transfer your media seamlessly to platforms like Google Drive, Dropbox, or a self-hosted solution NAS (like Synology).
- ⚡ **Automate Bulk Downloads**: With this tool, you can script and schedule downloads to keep your offline backups up to date.
- 🐳 **Run it in Seconds with Docker**: No need to mess with Python code—just pull the Docker image and start downloading.

---

## 🐳 Why Docker?

For non-developers or anyone who doesn’t want to fiddle with code, I made this tool **Docker-friendly**. Using the [official Docker image](https://hub.docker.com/r/itsankoff/gopro), you can get started in no time:

1. **Pull the Docker Image**:
    ```bash
    docker pull itsankoff/gopro
    ```
2. Obtain your GoPro Plus Cloud credentials using the following [guide](https://github.com/itsankoff/gopro-plus?tab=readme-ov-file#environment-variables)
3. Run the Container:
    ```bash
    docker run -e AUTH_TOKEN=<gopro-auth-token> -e USER_ID=<gopro-user-id> -v </path/to/download>:/app/download itsankoff/gopro:latest
    ```

    or

    ```bash
    docker run \
    --name gopro-downloader
    -e AUTH_TOKEN='<AUTH_TOKEN>' \
    -e USER_ID='<USER_ID>' \
    -v </path/to/download>:/app/download \
    itsankoff/gopro:latest
    ```

4. Full reference of the parameters and environment variables can be found [here](https://github.com/itsankoff/gopro-plus?tab=readme-ov-file#usage-docker-environment)

## 🔍 How It Works?

This tool interacts with the undocumented GoPro Plus API, emulating how the GoPro app communicates with the cloud. It bypasses the limitations of their web UI and allows you to:

1. Authenticate via JWE: Log into your GoPro Plus account securely.
2. Retrieve Media Metadata: Get a list of all your files, regardless of batch size.
3. Download Files in Bulk: Specify the number of files or download them all at once.

With these features, you can effortlessly move your media to another storage solution or simply create an offline backup.

## 👩‍💻👨‍💻 For Developers

If you prefer working with the code directly, head over to the GitHub repository to clone and tweak the project to your liking.

### Install and Run Locally
1. Clone the repository:
```bash
git clone https://github.com/itsankoff/gopro-plus
```
2. Follow the README.md [local setup guide](https://github.com/itsankoff/gopro-plus?tab=readme-ov-file#prerequisites-local-environment)
3. Run: `./gopro` or `make` to explore the dev options

But again—why code when you can Docker? 🐳

## 🤔 Who Is This For?

This tool is perfect for:
* 🎥 Content Creators: Looking to offload large libraries to more affordable or flexible storage.
* 🛠️ Tech Enthusiasts: Interested in self-hosted solutions like Synology or a custom NAS.
* 🐼 Non-Coders: Want a quick, no-fuss way to manage GoPro Plus media using Docker.

## 🔗 Links and Resources
* GitHub Repository: [itsankoff/gopro-plus](https://github.com/itsankoff/gopro-plus)
* Docker Image: [itsankoff/gopro](https://hub.docker.com/r/itsankoff/gopro)

## 💪 Take Back Control

The 25-file limit shouldn’t dictate how you manage your own media. With the GoPro Plus API tool, you can break free from cloud restrictions and enjoy the freedom to store your files wherever you want.

Give it a try and let me know how it works for you! Drop your feedback in the comments or open an issue on GitHub. ✨

