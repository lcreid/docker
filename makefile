REPOSITORY = lenchoreyes/jade
RUBY_VERSION = 3.2
DISTRO = bullseye

.PHONY: ruby-app rails-app
.PHONY: rails-app-3.0-postgres-bullseye
.PHONY: rails-app-3.1-postgres-bullseye
.PHONY: rails-app-3.2-postgres-bullseye
.PHONY: rails-app-3.1-postgres-bookworm
.PHONY: rails-app-3.2-postgres-bookworm
.PHONY: rails-app-3.0-sqlite-bullseye
.PHONY: rails-app-3.1-sqlite-bullseye
.PHONY: rails-app-3.2-sqlite-bullseye
.PHONY: rails-app-3.1-sqlite-bookworm
.PHONY: rails-app-3.2-sqlite-bookworm

ALL = \
	rails-app-3.1-postgres-bullseye \
	rails-app-3.0-postgres-bullseye \
	rails-app-3.2-postgres-bullseye \
	rails-app-3.1-postgres-bookworm \
	rails-app-3.2-postgres-bookworm \
	rails-app-3.0-sqlite-bullseye \
	rails-app-3.1-sqlite-bullseye \
	rails-app-3.2-sqlite-bullseye \
	rails-app-3.1-sqlite-bookworm \
	rails-app-3.2-sqlite-bookworm

rails-app-3.0-postgres-bullseye: RUBY_VERSION = 3.0
rails-app-3.0-postgres-bullseye: DISTRO = bullseye
rails-app-3.0-postgres-bullseye: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "PG_VERSION=$(PG_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-postgres-$(DISTRO) rails-app-postgres

rails-app-3.1-postgres-bullseye: RUBY_VERSION = 3.1
rails-app-3.1-postgres-bullseye: DISTRO = bullseye
rails-app-3.1-postgres-bullseye: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "PG_VERSION=$(PG_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-postgres-$(DISTRO) rails-app-postgres

rails-app-3.2-postgres-bullseye: RUBY_VERSION = 3.2
rails-app-3.2-postgres-bullseye: DISTRO = bullseye
rails-app-3.2-postgres-bullseye: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "PG_VERSION=$(PG_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-postgres-$(DISTRO) rails-app-postgres

rails-app-3.1-postgres-bookworm: RUBY_VERSION = 3.1
rails-app-3.1-postgres-bookworm: DISTRO = bookworm
rails-app-3.1-postgres-bookworm: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "PG_VERSION=$(PG_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-postgres-$(DISTRO) rails-app-postgres

rails-app-3.2-postgres-bookworm: RUBY_VERSION = 3.2
rails-app-3.2-postgres-bookworm: DISTRO = bookworm
rails-app-3.2-postgres-bookworm: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "PG_VERSION=$(PG_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-postgres-$(DISTRO) rails-app-postgres

rails-app-3.0-sqlite-bullseye: RUBY_VERSION = 3.0
rails-app-3.0-sqlite-bullseye: DISTRO = bullseye
rails-app-3.0-sqlite-bullseye: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-sqlite-$(DISTRO) rails-app-sqlite

rails-app-3.1-sqlite-bullseye: RUBY_VERSION = 3.1
rails-app-3.1-sqlite-bullseye: DISTRO = bullseye
rails-app-3.1-sqlite-bullseye: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-sqlite-$(DISTRO) rails-app-sqlite

rails-app-3.2-sqlite-bullseye: RUBY_VERSION = 3.2
rails-app-3.2-sqlite-bullseye: DISTRO = bullseye
rails-app-3.2-sqlite-bullseye: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-sqlite-$(DISTRO) rails-app-sqlite

rails-app-3.1-sqlite-bookworm: RUBY_VERSION = 3.1
rails-app-3.1-sqlite-bookworm: DISTRO = bookworm
rails-app-3.1-sqlite-bookworm: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-sqlite-$(DISTRO) rails-app-sqlite

rails-app-3.2-sqlite-bookworm: RUBY_VERSION = 3.2
rails-app-3.2-sqlite-bookworm: DISTRO = bookworm
rails-app-3.2-sqlite-bookworm: rails-app
	docker build --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):ruby-app-$(RUBY_VERSION)-$(DISTRO) ruby-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=ruby-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-$(DISTRO) rails-app
	docker build --build-arg "REPOSITORY=$(REPOSITORY)" --build-arg "IMAGE=rails-app" --build-arg "RUBY_VERSION=$(RUBY_VERSION)" --build-arg "DISTRO=$(DISTRO)" --tag $(REPOSITORY):rails-app-$(RUBY_VERSION)-sqlite-$(DISTRO) rails-app-sqlite

push: $(ALL)

$(ALL):
	docker push $(REPOSITORY):$@
