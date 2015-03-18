# Anagram solver as a service

The service is currently implemented as a primitive rest api.
Example query: `http://example.com:1525/anagram/master%20of%20the%20universe`

## Required packages

These packages are not on hackage, but are necessary for building. Install them
in a local sandbox with `cabal sandbox add-source /path/to/requisite`.

* [rest-service](https://github.com/jotrk/rest-service)
* [anagram-solver](https://github.com/jotrk/anagram-solver)
