#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

###########################################################
## Output the command lines, or not
###########################################################
ifeq ($(strip $(SHOW_COMMANDS)),)
hide := @
else
hide :=
endif

MACHINE ?= foundationos-qemux86-64

TOP := $(abspath .)
OUT := $(abspath $(TOP)/out/$(MACHINE))

FOUNDATIONOS_DOCKER_BUILDER_IMAGE := foundationos-builder
FOUNDATIONOS_DOCKER_EMULATOR_IMAGE := foundationos-emulator
FOUNDATIONOS_DOCKER_IMAGE_VERSION ?= latest
FOUNDATIONOS_DOCKER_BUILDER_IMAGE_ID := $(shell docker images -q $(FOUNDATIONOS_DOCKER_BUILDER_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION))
FOUNDATIONOS_DOCKER_EMULATOR_IMAGE_ID := $(shell docker images -q $(FOUNDATIONOS_DOCKER_EMULATOR_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION))
FOUNDATIONOS_CONF_DIR ?= $(TOP)/platform/yocto/meta-foundationos/conf
IMAGE ?= foundationos-console-image

build-foundationos-docker-image:
ifeq ($(FOUNDATIONOS_DOCKER_BUILDER_IMAGE_ID),)
	cd $(TOP)/build/docker/builder && docker build -t $(FOUNDATIONOS_DOCKER_BUILDER_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION) .
endif

build-foundationos-emu-docker-image:
ifeq ($(FOUNDATIONOS_DOCKER_EMULATOR_IMAGE_ID),)
	cd $(TOP)/build/docker/emulator && docker build -t $(FOUNDATIONOS_DOCKER_EMULATOR_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION) .G
endif

$(OUT):
	$(hide) mkdir -p $@

foundationos: build-foundationos-docker-image $(OUT)
	$(hide) bash $(TOP)/build/docker/builder/run.sh \
					--rm \
					-v $(TOP):$(TOP) \
					-e FOUNDATIONOS_ROOT=$(TOP) \
				 	-e FOUNDATIONOS_OUT=$(OUT) \
					-e FOUNDATIONOS_CONF_DIR=$(FOUNDATIONOS_CONF_DIR) \
					-e MACHINE=$(MACHINE) \
					-e FOUNDATIONOS_IMAGE=$(IMAGE) \
					$(FOUNDATIONOS_DOCKER_BUILDER_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION)

foundationos-emu : foundationos build-foundationos-emu-docker-image
	$(hide) bash $(TOP)/build/docker/emulator/run.sh \
					--rm \
					-v $(TOP):$(TOP) \
					-e FOUNDATIONOS_ROOT=$(TOP) \
				 	-e FOUNDATIONOS_OUT=$(OUT) \
					-e FOUNDATIONOS_CONF_DIR=$(FOUNDATIONOS_CONF_DIR) \
					-e MACHINE=$(MACHINE) \
					-e FOUNDATIONOS_IMAGE=$(IMAGE) \
					$(FOUNDATIONOS_DOCKER_EMULATOR_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION)
clean:
	$(hide) rm -fr $(OUT)
	$(hide) docker rmi $(FOUNDATIONOS_DOCKER_BUILDER_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION)
	$(hide) docker rmi  $(FOUNDATIONOS_DOCKER_EMULATOR_IMAGE):$(FOUNDATIONOS_DOCKER_IMAGE_VERSION)

.PHONY:foundationos
all:foundationos
