BOA_VERSION ?= $(shell node -p 'require("./package.json").boaVersion')
BOA_BINS = \
	neo-one-boa-osx-v$(BOA_VERSION)/neo-one-boa \
	neo-one-boa-linux-v$(BOA_VERSION)/neo-one-boa \
	neo-one-boa-win-v$(BOA_VERSION)/neo-one-boa.exe
PY = py
CLEAN_PYINSTALLER = rm -rf $(PY)/dist $(PY)/neo-one-boa.spec $(PY)/neo-one-boa.exe.spec $(PY)/__pycache__ $(PY)/build
PYINSTALLER = pipenv run pyinstaller compile.py -F --noconfirm --clean --osx-bundle-identifier io.neo-one.boa --additional-hooks-dir=.
TEST = \
	npm link && \
	neo-one-boa ./tests/neo-ico-template/ico_template.py ./ico_template.avm && \
	rm ./ico_template.avm && \
	npm unlink && \
	rm package-lock.json

.PHONY: all
all: clean build test

.PHONY: clean
clean:
	rm -rf neo-one-boa-*-v* SHASUM256.txt

.PHONY: test
test: $(BOA_BINS)
	shasum -c SHASUM256.txt
	node test.js

.PHONY: build
build: clean SHASUM256.txt

.PHONY: setup
setup:
	cd $(PY) && \
	pipenv install neo-boa==$(BOA_VERSION) && \
	pipenv install --dev

.PHONY: local
local: setup
	cd $(PY) && \
	$(PYINSTALLER) --name=neo-one-boa

# TODO: Possibly add the Universal CRT runtime.
# See http://pyinstaller.readthedocs.io/en/stable/usage.html#windows
.PHONY: local-windows
local-windows: setup
	cd $(PY) && \
	$(PYINSTALLER) --name=neo-one-boa.exe

.PHONY: local-test
local-test:
	$(TEST)

SHASUM256.txt: $(BOA_BINS)
	shasum -a 256 $^ > $@

neo-one-boa-osx-v%/neo-one-boa: local
	mkdir -p $(@D)
	mv $(PY)/dist/neo-one-boa $@
	$(CLEAN_PYINSTALLER)
	$(TEST)

neo-one-boa-linux-v%/neo-one-boa:
	eval $$(docker-machine env -unset) && docker run -v $$(pwd):/neo neo-one/build-linux:8.9.3 /bin/sh -c "cd neo && make local"
	mkdir -p $(@D)
	mv $(PY)/dist/neo-one-boa $@
	$(CLEAN_PYINSTALLER)
	eval $$(docker-machine env -unset) && docker run -v $$(pwd):/neo neo-one/test-linux:8.9.3 /bin/sh -c "cd neo && make local-test"

neo-one-boa-win-v%/neo-one-boa.exe:
	eval $$(docker-machine env 2016) && docker run -v C:$$(pwd):C:/neo neo-one/build-windowsservercore:ltsc2016 powershell -Command cd neo; make local-windows
	mkdir -p $(@D)
	mv $(PY)/dist/neo-one-boa.exe $@
	$(CLEAN_PYINSTALLER)
	eval $$(docker-machine env 2016) && docker run -v C:$$(pwd):C:/neo neo-one/test-windowsservercore:ltsc2016 powershell -Command cd neo; make local-test
