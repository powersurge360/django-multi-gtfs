.PHONY: clean-pyc clean-build docs

help:
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "clean - remove all artifacts"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "testall - run tests on every Python version with tox"
	@echo "coverage - check code coverage quickly with the default Python"
	@echo "qa - run quick quality assurance (pre-checkin)"
	@echo "qa-all - run full quality assurance (pre-release)"
	@echo "docs - generate Sphinx HTML documentation, including API docs"
	@echo "release - package and upload a release"
	@echo "sdist - package"

clean: clean-build clean-pyc

qa: lint coverage

qa-all: qa docs sdist test-all

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

lint:
	flake8 --exclude='.tox' .

test:
	python run_tests.py

test-all:
	tox

coverage:
	coverage erase
	./run_tests.py --with-coverage --cover-tests
	coverage html
	open htmlcov/index.html

docs:
	rm -f docs/multigtfs.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ multigtfs
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	open docs/_build/html/index.html

release: clean
	python setup.py sdist upload
	python setup.py bdist_wheel upload

sdist: clean
	python setup.py sdist
	ls -l dist
	check-manifest
	pyroma dist/`ls -t dist | head -n1`; if [ $$? -ne 1 ]; then exit 1; fi