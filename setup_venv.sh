#!/usr/bin/env bash
# Copyright © 2025 Isaac Behrens. All rights reserved.

# Script shoule be run as user njspc-exporter.

export HOME=/opt/njspc-exporter

cd /opt/njspc-exporter

# Create/activate venv
python3 -m venv njspc
source njspc/bin/activate

# Install requirements
pip install -r /opt/njspc-exporter/requirements.txt

# Deactivate venv
deactivate

exit 0