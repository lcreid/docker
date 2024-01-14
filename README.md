# Notes for Using Docker in Ruby Development

[These are notes mostly for myself.]

These are notes about how to use Docker for developing Ruby. I've found it best to consider three scenarios:

* Run some ad-hoc pure Ruby, e.g. no scripts or files from your local file system, no need to install distribution packages, no need to persist changes to the image.
* Develop and test a pure Ruby application (no Rails or other framework).
* Develop and test Rails. This has various sub-scenarios depending on the database you use, whether you want to run tests through a browser, whether you need Redis, or whether you want any other containers to manage other parts of the application's infrastructure.

There's nothing here about production use of Docker for Ruby.

## Quickly Try Ad-Hoc Pure Ruby

To run Ruby container really quickly, when you just want to run some Ruby CLI Ruby in a specific version. Among other things, you don't need to access the local file system from the container, create any files, install any gems, or install any additional operating system packages:

```bash
docker run -it ruby:3.2-alpine3.18
```

Or to run it as the local user (if you plan to create files, for example), and access files from the local directory:

```bash
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -it ruby:3.2-alpine3.18
```

Replace `3.2` by the version of Ruby you want. See the Docker Hub for tags available (https://hub.docker.com/_/ruby). Replace `alpine3.18` by the version of Alpine you want to use. Or use another distribution, like Debian `bullseye`. Alpine will be the smallest if you're doing really simple Ruby testing. bullseye has more of the tools you'll likely need if you're starting a longer-term project.

### Installing Packages

It looks like the answer to installing packages is to run the container as root. But then we lose the package when we log out to go back to being a local user. Or we have to save the image and run the image instead of straight from the official image.

Another solution was to give your image a root password. This is getting us into `Dockerfile` territory.

## Ruby Application

For this I build and run an image from a `Dockerfile`. It's possible there is a single-line `docker run` command that would do what's needed, but it would be so complicated that no one would remember it anyway. Copying and pasting the command is just as much a nuisance as copying and pasting a `Dockerfile`, and the `Dockerfile` method is probably less error prone.

The advantage is that you can build one image locally that you can use any time you need a container for Ruby development.

### Dockerfile

Here's the `Dockerfile` (from the `ruby-app` directory):

```dockerfile
ARG RUBY_VERSION=3.2
ARG DISTRO=bullseye

FROM ruby:$RUBY_VERSION-$DISTRO

RUN mkdir -p /app
ENV HOME /app
WORKDIR /app

ENV GEM_HOME $HOME/vendor/bundle
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH ./bin:$GEM_HOME/bin:$PATH
RUN (echo 'docker'; echo 'docker') | passwd root

# This Dockerfile inherits the CMD from the Ruby image, which is `irb`.
```

To build the image:

```bash
docker build --build-arg "RUBY_VERSION=3.2" --build-arg "DISTRO=bullseye" --tag lenchoreyes/jade:ruby-app-3.2-bullseye .
```

Replace `.` by whatever context or `Dockerfile` location is needed. Replace the value of the `--tag` argument by the name you want to attach to the image. While not necessary, it may be convenient to do as done above, naming the image with the ruby version and distribution it was built with.

To run the image:

```bash
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -it lenchoreyes/jade:ruby-app-3.2-bullseye
```

Note that if your host computer is running Ubuntu and yours is the only user account on the computer, you can most likely shorten the above to:

```bash
docker run --volume "$PWD:/app" --user $UID:$UID -it lenchoreyes/jade:ruby-app-3.2-bullseye
```

The above short-cut won't work for scripts that you want to run for anyone on any machine. For that, use the longer form with the funky `grep` and `cut`.

If I'm going to run something that serves requests from another host or otherwise needs to respond on a port, I have to specify the port forwarding on the command line. For a typical Rails application that listens on port 3000 by default:

```bash
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -p 3000:3000 -it lenchoreyes/jade:ruby-app-3.2-bullseye
```

### `.gitignore`

The above leaves me with some history files and whatnot in the project directory that I didn't want to check in to `git`. So I added some lines to `.gitignore`:

```conf
# or .local/share/pry/pry_history if you need to be more exact
.local/
.irb_history
.byebug_history
# For Debian images with Bash
.bash_history
# For Alpine images
.ash_history

vendor/bundle
```

* Give the container a root password. (`sudo` isn't installed in the Debian container, so giving everyone `sudo` is more of a pain.) (Alpine's `su` isn't setuid, so it doesn't want to work, even with a password. bullseye's is `-rwsr-xr-x` and Alpine's is `-rwxrwxrwx`.)
* Set the `HOME` environment variable to `/app`.
* Make sure Bundler and `gem` install to persisted locations.
* A persistent place to put gems.
* A persistent place to put history files for `pry` and `irb`.
* Bundler is in the default Ruby image (at least from 2.7 on, maybe before), but the version may not be what you want (TBC).
* The ability to install the distro's packages. It seems nice not to have to create a `Dockerfile` just to build what you need to try something.
* Run as local user on Linux. This complicates the desire to be able to install packages, since installing packages requires root privileges.

## Rails

For Rails, you also want:

* The database client code and application.
* `nodejs` and `yarn`, unless you're building an API-only application, probably newer versions of those than you get with the Debian distro.
* A persistent place to put history for the database console app.
* git (TBC). IIRC, there is some part of the Rails create that uses git. The bullseye Ruby images (Debian) come with git.
* Expose at least port 3000 to the host.

Rails brings with it potential requirements for many other things, most of which get into `docker compose` territory:

* You can run sqlite locally, but most other databases will require a container for the database.
* A container for Redis if you need it.
* Containers to drive system testing (I do Capybara via Selenium).

### Creating a New Rails Image

In `rails-app/Dockerfile`:

```bash
docker build --build-arg "REPOSITORY=lenchoreyes/jade" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=3.2" --build-arg "DISTRO=bullseye" --tag lenchoreyes/jade:rails-app-3.2-bullseye .
```

The above assumes that you created the Ruby application image above, with the image name and tags `lenchoreyes/jade:ruby-app-3.2-bullseye`.

### Create a New Rails Image with Sqlite

In `rails-app-sqlite/Dockerfile`:

```bash
docker build --build-arg "REPOSITORY=lenchoreyes/jade" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=3.2" --build-arg "DISTRO=bullseye" --tag lenchoreyes/jade:rails-app-3.2-sqlite-bullseye .
```

To run it:

```bash
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -p 3000:3000 -it lenchoreyes/jade:rails-app-3.2-sqlite-bullseye /bin/bash
```

### Creating a New Rails Project

One of the things I really liked about the Vagrant boxes I used to build for Rails, was the ability to spin up a new instance of a box with Rails already installed, and create a new Rails project.

With Docker images and containers it's a little more complicated. If we add the Rails version to the container, we have yet another combination of versions to keep track of.

```bash
```

### Creating a New API-Only Rails Project

I've run an API-only Rails new with just a Ruby application container built from the `Dockerfile` in the `ruby-app` directory.

I either create the Rails project in two steps like this:

```bash
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -it lenchoreyes/jade:ruby-app-3.2-bullseye /bin/bash
gem install rails
rails new new-project
exit
cd new-project
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -p 3000:3000 -it lenchoreyes/jade:ruby-app-3.2-bullseye
```

or in one step:

```bash
mkdir new-project
cd new-project
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -p 3000:3000 -it lenchoreyes/jade:ruby-3.2-bullseye
gem install rails
rails new .
```

IIRC, some files or directories get a funny name when you do the "one step" version.

### Creating a Rails Project with Postgres, Bootstrap, `esbuild`, and Selenium

Here's the outline of what we're going to do:

1. Make a directory for the new project.
1. Copy a couple of files for Docker Compose into the directory.
1. Run a shell _with Docker Compose_ to create the Rails project.
1. Set-up the database configuration so you can connect to Postgres.
1. Fix `Procfile.dev` so you can reach your application from outside the container.
1. Run the app to see the default Rails welcome page.

```bash
mkdir <project>
cd <project>
wget -O docker-compose.yml https://github.com/lcreid/docker/raw/main/rails-app-postgres/docker-compose.with-selenium.yml
# The following line is only for Linux without Docker Desktop:
wget -O docker-compose.override.yml https://github.com/lcreid/docker/raw/main/Linux/docker-compose.override.yml
docker compose up &
docker compose exec -it shell /bin/bash
gem install rails
rails new -d postgresql -j esbuild -c bootstrap --skip-docker --skip-action-mailbox --skip-action-cable --skip-active-storage .
```

Edit `config/database.yml` to add the following to the default:

```yaml
username: pg
password: pg
host: postgres
```

Now set up the database:

```bash
bin/setup
```

Edit `Procfile.dev` and change the line that starts with `web` to the following:

```procfile
web: bin/rails server -p 3000 -b 0.0.0.0
```

The app is ready to start. In another terminal:

```bash
docker compose exec shell bin/dev
```

Browse to `localhost:3000` and you should see the default Rails welcome page.

### Creating a Rails Project with Mariadb (MySQL), Bootstrap, `esbuild`, and Selenium

Here's the outline of what we're going to do:

1. Make a directory for the new project.
1. Copy a couple of files for Docker Compose into the directory.
1. Run a shell _with Docker Compose_ to create the Rails project.
1. Set-up the database configuration so you can connect to Postgres.
1. Fix `Procfile.dev` so you can reach your application from outside the container.
1. Run the app to see the default Rails welcome page.

```bash
mkdir <project>
cd <project>
wget -O docker-compose.yml https://github.com/lcreid/docker/raw/main/rails-app-mariadb/docker-compose.with-selenium.yml
# The following line is only for Linux without Docker Desktop:
wget -O docker-compose.override.yml https://github.com/lcreid/docker/raw/main/Linux/docker-compose.override.yml
docker compose up &
docker compose exec -it shell /bin/bash
gem install rails
rails new -d mysql -j esbuild -c bootstrap --skip-docker --skip-action-mailbox --skip-action-cable --skip-active-storage .
```

Edit `config/database.yml` to add the following to the default:

```yaml
username: maria
password: maria
host: mariadb
```

Now set up the database:

```bash
bin/setup
```

Edit `Procfile.dev` and change the line that starts with `web` to the following:

```procfile
web: bin/rails server -p 3000 -b 0.0.0.0
```

The app is ready to start. In another terminal:

```bash
docker compose exec shell bin/dev
```

Browse to `localhost:3000` and you should see the default Rails welcome page.

### Creating a Rails Project with Sqllite, Bootstrap, `esbuild`, and Selenium

Here's the outline of what we're going to do:

1. Make a directory for the new project.
1. Copy a couple of files for Docker Compose into the directory.
1. Run a shell _with Docker Compose_ to create the Rails project and get it set up.
1. Fix `Procfile.dev` so you can reach your application from outside the container.
1. Run the app to see the default Rails welcome page.

```bash
mkdir <project>
cd <project>
wget -O docker-compose.yml https://github.com/lcreid/docker/raw/main/rails-app-sqlite/docker-compose.with-selenium.yml
# The following line is only for Linux without Docker Desktop:
wget -O docker-compose.override.yml https://github.com/lcreid/docker/raw/main/Linux/docker-compose.override.yml
docker compose up &
docker compose exec -it shell /bin/bash
gem install rails
rails new -j esbuild -c bootstrap --skip-docker --skip-action-mailbox --skip-action-cable --skip-active-storage .
```

Edit `Procfile.dev` and change the line that starts with `web` to the following:

```procfile
web: bin/rails server -p 3000 -b 0.0.0.0
```

The app is ready to start. In another terminal:

```bash
docker compose exec shell bin/dev
```

Browse to `localhost:3000` and you should see the default Rails welcome page.

### Restarting

If you're running `shell` in one window and the server in another, you can restart the server with:

```bash
bin/rails restart
```

### Bootstrap

* Put the meta line in the application layout, for responsiveness and ???: `<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">` TBC I THINK THIS WAS ALREADY THERE.
* Some Bootstrap features require JavaScript, and aren't enabled by default due to performance considerations (tooltips, toasters).

## Irritating Stuff

* The `tmp/pids/server.pid` file lives on after the container stops running in many cases, so you have to manually delete it all the time.
* Any volume for which the file or directory doesn't exist on the host, will be created by Docker before the `docker-compose.override.yml` takes effect, meaning they get created as `root`.

## Notes from Research

```bash
docker run --volume="$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -it `basename $PWD`-image
```

The above runs in `/`, and therefore can't write `.irb_history`, and is pretty useless for running scripts. `pry` also looks to write `.local`, specifically `.local/share/pry/pry_history`.

```bash
docker run --volume="$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -it ruby:3.2-bullseye
```

Both Alpine and Debian do this at the end of their `Dockerfile`s (at least for Ruby 3.2):

```dockerfile
# don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$PATH
# adjust permissions of a few directories for running "gem install" as an arbitrary user
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

CMD [ "irb" ]
```

It looks like they let you install gems, but they won't persist from run to run. Docker does have a commit command that you can use to persist changes into a new container (https://docs.docker.com/engine/reference/commandline/commit/).

This command saves changes and the new environment. You can also make other configuration changes. See the documentation linked just above:

```bash
docker commit --change "ENV DEBUG=true" c3f279d17e0a  svendowideit/testimage:version3
```

`.bundle` is sort of a default place for bundler to install gems. When `--deployment`, puts in `vendor/bundle`.

`BUNDLE_PATH` overrides `GEM_HOME` and `GEM_PATH`.
