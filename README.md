# Ubuntu 24.04 Development Image

This Docker image is based on the official Ubuntu 24.04 LTS image and provides a comprehensive, lightweight development environment. It is specifically created for building and deploying WordPress plugins and themes by Code Soup and is used as part of the Ziploy GitHub Action workflow.

## Features

-   **Base Image:** Ubuntu 24.04 LTS (linux/amd64)
-   **Installed Software:**
    -   **curl:** 8.5.0
    -   **wget:** 1.21.4
    -   **git:** 2.43.0
    -   **Python:** 3.12.3 (with pip)
    -   **PHP:** 8.3.6 (CLI, XML, cURL)
    -   **Composer:** 2.8.6
    -   **yarn:** 1.22.22
    -   **Node.js:** v20.18.3

## Package Installation & Configuration

Software packages are installed in non-interactive mode using apt, and additional tools such as Composer, Node.js, and Yarn are installed from their official sources. This setup provides a streamlined and lightweight environment with all necessary tools available in their specified versions.

## GitHub Action Integration

This image is optimized to work with the [Ziploy GitHub Action](https://github.com/code-soup/ziploy-github-action), enabling seamless creation of [Ziploy WordPress plugin](https://www.ziploy.com) and automated deployment of your WordPress plugins and themes to any hosting environment.
To find out more, visit [ziploy.com](https://www.ziploy.com)

## Building the Docker Image

To build the image, navigate to the directory containing your Dockerfile and run:

```bash
docker build --platform=linux/amd64 -t codesoup/beetroot:latest .
```

## Running the Container

Once the image is built, run a container with the following command:

```bash
docker run --platform=linux/amd64 -it codesoup/beetroot:latest /bin/sh
```

## GitHub Workflow Example

Below is an example GitHub Actions workflow that uses this Docker image. This workflow builds and deploys a WordPress plugin/theme when changes are pushed to the `release` branch.

```yaml
name: Build and Deploy WordPress Plugin/Theme

on:
    push:
        branches:
            - release

jobs:
    build-deploy:
        runs-on: ubuntu-latest
        container:
            image: codesoup/beetroot:latest

        steps:
            - name: Checkout Repository
              uses: actions/checkout@v4

            - name: Install Dependencies
              run: |
                  composer install --no-dev --prefer-dist
                  yarn install

            - name: Build Assets
              run: |
                  yarn build:prod

            - name: Run Tests
              run: |
                  php -v
                  python --version

            - name: Deploy the code
              id: deploy_code
              uses: code-soup/ziploy-github-action@0.0.1
              with:
                  ziploy-ssh-key: ${{ secrets.MY_SSH_KEY_PRIVATE }}
                  ziploy-working-directory: "wp-content/themes/my-theme-to-deploy"
```

## Notes

-   This image is built for the `linux/amd64` architecture.
-   Intended for building and deploying WordPress plugins and themes for Code Soup.
-   Modify or extend the Dockerfile if additional packages or configuration changes are required.
-   Adjust the Node.js installation command if a different version is needed.
