# flowhub-runtime-registry-example

[noflo-ui](https://github.com/noflo/noflo-ui), and the hosted version [Flowhub](http://app.flowhub.io)
uses a 'registry' of runtimes in order to remember runtimes a user has, across different machines and browsers.

The runtime registry is a simple HTTP RESTful service which can
`list existing runtimes`, `register a new runtime` and `modify an existing runtime`.
This here is an open source example of how to implement such a service.

## Installing

   npm install

## Running

    npm start

## Customizing

See [./src/app.coffee](./src/app.coffee)
