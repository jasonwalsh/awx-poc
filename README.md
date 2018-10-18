[![Build Status](https://img.shields.io/travis/com/jasonwalsh/awx-poc.svg?style=flat-square)](https://travis-ci.com/jasonwalsh/awx-poc)

> A repository for getting started with [Ansible AWX](https://github.com/ansible/awx)

## Contents

- [Ansible AWX](#ansible-awx)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Local](#local)
  - [Production](#production)
- [Troubleshooting](#troubleshooting)
- [Testing](#testing)
- [Continuous Integration](#continuous-integration)
- [License](#license)

## Ansible AWX

> An open source community project, sponsored by Red Hat, that enables users to control their Ansible project use in IT environments better.

## Requirements

This project requires the following software:

- [Vagrant](https://www.vagrantup.com/)
- [Packer](https://packer.io/)
- [Terraform](https://www.terraform.io/)
- [VirtualBox](https://www.virtualbox.org/) (if using Vagrant)

## Usage

This project intends to provide strategies for deploying Ansible AWX. The following sections define how to configure and deploy Ansible AWX in either a local environment or a production environment.

### Local

The root of this repository contains a [Vagrantfile](https://www.vagrantup.com/docs/vagrantfile/) which creates a virtual machine using [Vagrant](https://www.vagrantup.com/) developed by HashiCorp. Currently, the Vagrant box only supports installing Ansible AWX using the Ubuntu 16.04 (Xenial Xerus) operating system.

To deploy a local Ansible AWX server, invoke the following command:

    $ vagrant up

If the command exits with a zero status code, then an Ansible AWX is running and can be accessed in a web browser by visiting http://localhost:8080/#/login.

**Note:** If the web page returns an `ERR_EMPTY_RESPONSE` message, please be patient, as the service may still be starting. If the service fails to start, please refer to the [troubleshooting](#troubleshooting) section.

After rendering the web page, authenticate by using `admin` for the username and `password` for the password.

| <img src="https://user-images.githubusercontent.com/2184329/47095511-6d90c200-d1fb-11e8-9e24-c6d72378e463.png"> | <img src="https://user-images.githubusercontent.com/2184329/47095512-6d90c200-d1fb-11e8-9f6c-7e02a947ba5a.png"> |
|:---------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------:|
| Figure 1 Login Page                                                                                             | Figure 2 Dashboard Page                                                                                         |

### Production

The production environment uses a combination of [Packer](https://packer.io/) and [Terraform](https://www.terraform.io/), both developed by HashiCorp.

<p align="center">
    <img src="docs/cloudcraft.svg">
</p>

## Troubleshooting

> The problem with troubleshooting is that trouble shoots back - Unknown Author

If the `awx` service fails to start, then checking the logs may yield some useful information. The `awx` service is a `systemd` managed service, and its logs are queryable using `journalctl`.

If using Vagrant, connect to the virtual machine using SSH:

    $ vagrant ssh

Once connected to the virtual machine, invoke the following commands:

> To check the status of the `awx` service:

    $ sudo systemctl status awx

> To check the logs of the awx service:

    $ sudo journalctl -xeu awx

## Testing

This project uses Ansible [Molecule](https://molecule.readthedocs.io/en/latest/) to test the `awx` role. Testing the `awx` role requires the following dependencies:

- [molecule](https://pypi.org/project/molecule/)
- [docker](https://pypi.org/project/docker/)

After installing the required pip dependencies, visit the [awx](provisioning/roles/awx) directory and invoke the following command:

    $ molecule test

## Continuous Integration

This project uses [Travis CI](https://travis-ci.com/) for testing. The [.travis.yml](.travis.yml) file contains scripts executed per build.

## License

MIT &copy; [Jason Walsh](https://github.com/jasonwalsh)
