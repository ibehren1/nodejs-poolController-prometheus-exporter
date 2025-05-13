#!/usr/bin/env bash
# Copyright © 2025 Isaac Behrens. All rights reserved.

# Script should be run as user njspc-exporter.

export HOME=/opt/njspc-exporter

cd /opt/njspc-exporter

# Create/activate venv
python3 -m venv njspc || { echo "Failed to create virtual environment"; exit 1; }
source njspc/bin/activate || { echo "Failed to activate virtual environment"; exit 1; }

# Install toml
pip install toml || { echo "Failed to install toml"; exit 1; }

# Create requirements file and install remaining requirements
python3 <<EOF
import toml
config = toml.load("/opt/njspc-exporter/pyproject.toml")
with open("/tmp/requirements.txt", "w") as f:
    f.write("
".join(config["project"]["dependencies"]))
EOF

pip install -r /tmp/requirements.txt || { echo "Failed to install requirements"; exit 1; }

# Deactivate venv
deactivate

exit 0
