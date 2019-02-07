# selfkey-payments

This project comprehend smart contract implementations for the different payment systems to be used
in SelfKey.

_Note: current implementation status is for Proof of Concept only._

## Overview

## Development

The smart contracts are being implemented in Solidity `0.5.0`.

### Prerequisites

* [NodeJS](htps://nodejs.org): v9.5.0   (Check with command `node -v`)
* [truffle](http://truffleframework.com/): v5.0.2.  (Check using `truffle version`).
* [Ganache](https://truffleframework.com/ganache): v6.2.5   (Check: `ganache-cli --version`)

### Initialization

    npm install

### Testing

#### Standalone

In order to test, open a new terminal window and run a test Ethereum client such as `ganache-cli`.
Other Ethereum clients work, as long as they are running on the default port: `8545`.

Ganache can be installed by running the following command:

    npm install -g ganache-cli
    ganache-cli

Once running, execute tests:

    npm test

or with code coverage

    npm run test:cov

#### From within Truffle

Run the `truffle` development environment

    truffle develop

then from the prompt you can run

    compile
    migrate
    test

as well as other Truffle commands. See [truffleframework.com](http://truffleframework.com) for more.

### Linting

The project provides linting for solidity files. To run:

* `npm run lint:sol`

## Contributing

Please see the [contributing notes](CONTRIBUTING.md).
