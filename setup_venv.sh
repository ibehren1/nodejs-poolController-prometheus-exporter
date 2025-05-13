#!/usr/bin/env bash
# Copyright © 2025 Isaac Behrens. All rights reserved.

#!/usr/bin/env bash
# Copyright © 2025 Isaac Behrens. All rights reserved.

# Script should be run as user njspc-exporter.

export HOME=/opt/njspc-exporter

export HOME=/opt/njspc-exporter

cd /opt/njspc-exporter

# Create/activate venv
python3 -m venv njspc
source njspc/bin/activate

# Install toml
pip install toml

# Create requirements file and install remaining requirements
python3 -c 'import toml; c = toml.load("/opt/njspc-exporter/pyproject.toml"); print("\n".join(c["project"]["dependencies"]))' > /tmp/requirements.txt 
pip install -r /tmp/requirements.txt

# Deactivate venv
deactivate

exit 0