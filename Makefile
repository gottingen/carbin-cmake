
.PHONY: test build cache-build install package help clean carbin carbin-clean .pre_build .clean-build
.DEFAULT_GOAL := help

build_folder = build
current_folder = $(shell pwd)
build_path = $(current_folder)/$(build_folder)
#platform_version := $(shell uname -r| awk -F 'el' '{printf("el%d", substr($2,1,1))}')
build_type = Release

test: .pre_build ## Run tests
	@echo "start testing ..."
	@cd $(build_path); \
    		make test;

build: .pre_build ## Build abel build_type=[Debug|Release|ReleaseWithDebugInfo]
	@cd $(build_path); \
	make -j

cache-build: ## Run build on build stack, not clean the old build
	@cd $(build_path); \
	make -j

install: .pre_build ## Install abel
	@echo "install abel now ..."
	@cd $(build_path); \
	make -j install

package: .pre_build ## Generate package
	@echo "generate package for abel"
	@cd $(build_path); \
	make -j package

clean: ## Clean build
	@echo "clean build.."
	@rm -r $(build_path)

carbin: ## Run carbin install
	@echo "start to isntall dependencies"
	@carbin install
	@echo "dependencies have been installed to carbin"

carbin-clean: ## Run clean up dependencies
	@echo "start to isntall dependencies"
	@carbin clean -y

.pre_build: .clean-build
	@echo "start build type check"
	@ cd $(build_path); \
	cmake .. -DCMAKE_BUILD_TYPE=$(build_type);

.clean-build: carbin
	@echo "clean building env ..."
	@if test -d $(build_path); then \
  		rm -rf $(build_path); \
  		fi
	@mkdir $(build_path)

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
