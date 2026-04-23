#!/bin/bash

# Check if project name is provided
if [ -z "$1" ]; then
    echo "❌ Error: Please provide a project name."
    echo "Usage: bash setup_project.sh project_name"
    exit 1
fi

PROJECT_NAME=$1
SRC_DIR="src/$PROJECT_NAME"

echo "🚀 Starting setup for $PROJECT_NAME..."

# 1. Create Directory Structure
mkdir -p "$SRC_DIR"
mkdir -p tests
mkdir -p docs/_static
mkdir -p docs/_templates

# 2. Create initial Python files
touch "$SRC_DIR/__init__.py"
cat <<EOF > "$SRC_DIR/solvers.py"
def solve_problem(data):
    """
    Example solver docstring.

    Args:
        data (list): Input constraints.

    Returns:
        list: The solution found.
    """
    return []
EOF

# 3. Create pyproject.toml
cat <<EOF > pyproject.toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
version = "0.1.0"
description = "Backtracking optimization solvers."
requires-python = ">=3.8"
dependencies = []

[project.optional-dependencies]
test = ["pytest"]
docs = ["sphinx", "sphinx-rtd-theme"]
EOF

# 4. Populate docs/conf.py
cat <<EOF > docs/conf.py
import os
import sys
sys.path.insert(0, os.path.abspath('../src'))

project = '$PROJECT_NAME'
copyright = '2026, Student Team'
author = 'Students'
release = '0.1.0'

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinx.ext.viewcode',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
EOF

# 5. Populate docs/index.rst
cat <<EOF > docs/index.rst
$PROJECT_NAME
$(printf '=%.0s' $(seq 1 ${#PROJECT_NAME}))

.. toctree::
   :maxdepth: 2
   :caption: Contents:

API Reference
-------------

.. automodule:: $PROJECT_NAME.solvers
   :members:
   :undoc-members:
   :show-inheritance:
EOF

# 6. CREATE THE MISSING MAKEFILE
cat <<'EOF' > docs/Makefile
# Minimal makefile for Sphinx documentation
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
EOF

# 7. Create README and .gitignore
echo "# $PROJECT_NAME" > README.md
cat <<EOF > .gitignore
__pycache__/
*.py[cod]
.pytest_cache/
docs/_build/
dist/
build/
*.egg-info/
EOF

# 8. Install Environment
echo "📦 Installing package and dev tools..."
pip install -e ".[test,docs]"

echo "✅ Success! Project $PROJECT_NAME is ready."
echo "Commands:"
echo "  pytest"
echo "  cd docs && make html"