#!/usr/bin/env bash
# Copyright © 2025 Isaac Behrens. All rights reserved.

#!/usr/bin/env bash
# Copyright © 2025 Isaac Behrens. All rights reserved.

# Script should be run as user njspc-exporter.

export HOME=/opt/njspc-exporter

export HOME=/opt/njspc-exporter

cd /opt/njspc-exporter

# Create/activate venv
cd /opt/njspc-exporter

# Create/activate venv
python3 -m venv njspc || { echo "Failed to create virtual environment"; exit 1; }
source njspc/bin/activate || { echo "Failed to activate virtual environment"; exit 1; }

# Install toml
pip install toml || { echo "Failed to install toml"; exit 1; }

# Create requirements file and install remaining requirements
python3 -c 'import toml; c = toml.load("/opt/njspc-exporter/pyproject.toml"); print("
".join(c["project"]["dependencies"]))' > /tmp/requirements.txt || { echo "Failed to create requirements file"; exit 1; }
pip install -r /tmp/requirements.txt || { echo "Failed to install dependencies"; exit 1; }

# Deactivate venv
deactivate
source njspc/bin/activate

# Install toml
pip install toml

# Create requirements file and install remaining requirements
python3 -c 'import toml; c = toml.load("/opt/njspc-exporter/pyproject.toml"); print("\n".join(c["project"]["dependencies"]))' > /tmp/requirements.txt 
pip install -r /tmp/requirements.txt

# Deactivate venv
deactivate

exit 0