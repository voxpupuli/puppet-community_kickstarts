#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with community_kickstarts](#setup)
    * [What community_kickstarts affects](#what-community_kickstarts-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with community_kickstarts](#beginning-with-community_kickstarts)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A collection of kickstart templates from the VoxPupuli community. Each type can be used as is to build a puppet-ready VM, or customized with minimal knowledge of kickstart syntax.

## Usage

Choose one of the available base types. Add the definition without any options for a puppet-ready kickstart file with sane defaults located at the specified location.

    community_kickstarts::centos7{'/var/www/html/centos7.ks':}

You may also override the default parameters. The options may vary between types, please review each option for the parameter list. You may wish to change the default password:

    community_kickstarts::centos7{'/var/www/html/centos7.ks:
      rootpw => '--plaintext p4ssW0rd',
    }

All types have the `required_packages` parameter, allowing you to customize what is and is not installed on the new VM. You can override the default list by providing an array to the parameter. Add an `@` before package group names and a `-` before packages or groups you wish to be removed. Remember that all packages being added must exist or the kickstart effort will fail.

    community_kickstarts::centos7{'/var/www/html/centos7.ks:
      required_packages => [
        '@core',
        '@file-print-server-environment',
        'git',
        '-man',
        '-gcc',
      ],
    }

## Available types

# **centos7**: Minimal install of CentOS7 from the CentOS Mirrors.

## How It Works

The kickstart generation is done with [danzilio/kickstart](https://github.com/danzilio/puppet-kickstart/). Please review it's documentation for more details.
