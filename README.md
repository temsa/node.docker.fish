# node.docker.fish
Small, easy to understand, opinionated Fish configuration for easy development with Node &amp; Docker

Easily run the latest version of `node` ( or any other you may want, available from the docker registry ) for you project, by running it in a `Docker` container like if it was installed locally, sharing the local network as well.

# Prerequisites
- Already have `node` and `npm` installed on your system.
- A project directory, containing a `package.json` (not mandatory) and an executable js file, e.g. `index.js` (even an empty one is ok)
- `semver-node-cli` and `json` should be installed globally (or at least with the binaries available from your $PATH ) :
```
#> sudo npm i -g semver-node-cli json
```

# Installation
In your `fish` shell :
```
#> cd ~
#> mkdir -p .local/lib
#> cd ~/.local/lib
#> git clone https://github.com/temsa/node.docker.fish.git
```

Then add this to your `~/.config/fish/config.fish` file
```
source ~/.local/lib/node.docker.fish/init.fish
```

Finally do this too in the shell (or login again):
```
#> source ~/.local/lib/node.docker.fish/init.fish
```

# Commands
- `#> node.docker` : for running NodeJS
- `#> npm.docker` : for running NPM
- `#> es.docker` : for running Elasticsearch
- `#> rethinkdb.docker` : for running RethinkDB

# Usage

## First Time setup for a project
From your `fish` shell, go to the directory where you would like to use `node` and some other services (currently `Elasticsearch` and `RethinkDB` are supported, yet additions are very simple, and very welcome as PR) for development.

`node.docker.fish` will define and store the version of `node`/`npm` you will use for your project during the first run, then it will use the `cached version` ( stored in `.docker/node-version` ) all the time to provide some stability.

If you want to use the latest stable node version, or if you have already defined the `node` version in the directory `package.json`, simply run :

```
#> node.docker index.js
```

or even 

```
#> node.docker
```
If you want to run the node shell.

It should automagically download the needed docker layers from the Docker Registry, and run your `index.js` file (note that if your `index.js` has any module dependency, it will fail during execution, and given that you correctly put your dependencies in your `package.json`

If you want some little more control over the nodejs version used, you should instead run `node.docker` this way, for the first time, e.g for latest 4.x branch (please note that the executable js file is mandatory in this case, for now):
```
#> node.docker 4 index.js
```
For event more control, you may want to define better the version, like `4.3` :
```
#> node.docker 4.3 index.js
```
or
```
#> node.docker 4.3.2 index.js
```

# Run a database/storage/search engine etc.
Simply run the given supported database like this, from your project directory (it will run in the background) all ports are the default ones, and are available on `localhost`:

- For Elasticsearch `es.docker`, data will be stored in `.docker/es`
- For RethinkDB `rethinkdb.docker`, data will be stored in `.docker/rethinkdb`

# Troubleshoot / Reset
- if you want to reset `node.docker` to the "first time usage" state, and remove any data in your databases, simply delete the `.docker` directory from your project
- if you have trouble while loading your module dependencies, have previously installed your modules with another node version, or changed the version stored in `.docker/node-version`, you're likely to have some errors. In this case, you can delete the `node_modules` directory from your project, and simply do a `npm.docker i` which will reinstall everything according to your `package.json`




