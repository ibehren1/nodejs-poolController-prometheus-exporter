# Copyright © 2025 Isaac Behrens. All rights reserved.

SHELL := /usr/bin/env bash -euo pipefail -c

install: create-user-group create-dir copy-files create-venv enable-service

create-dir:
	@echo "Create dir /opt/njspc-exporter."
	@mkdir -p /opt/njspc-exporter
	@chown njspc-exporter:njspc-exporter /opt/njspc-exporter
	@echo

create-venv:
	@echo "Creating Python virtual environment."
	@sudo -u njspc-exporter ./setup_venv.sh
	@echo

copy-files:
	@echo "Copy files..."
	@cp ./njspc-exporter.py /opt/njspc-exporter/njspc-exporter.py
	@chown njspc-exporter:njspc-exporter /opt/njspc-exporter/njspc-exporter.py
	@chmod 755 /opt/njspc-exporter/njspc-exporter.py

	@cp ./requirements.txt /opt/njspc-exporter/requirements.txt
	@chown njspc-exporter:njspc-exporter /opt/njspc-exporter/requirements.txt

	@cp ./njspc-exporter.service /etc/systemd/system/njspc-exporter.service
	@echo

create-user-group:
	@echo "Create njspc-exporter user and group."
	@groupadd njspc-exporter || true
	@useradd \
	 	-d /opt/nsjpc-exporter \
		-g njspc-exporter \
		-s /usr/bin/bash \
		njspc-exporter || true
	@echo

enable-service:
	@echo "Enabling service: njspc-exporter."
	@systemctl daemon-reload
	@systemctl enable njspc-exporter
	@systemctl start njspc-exporter
	@echo

status:
	@systemctl status njspc-exporter || true

uninstall:
	@echo "Removing njspc-exporter."
	@systemctl stop njspc-exporter 2>&1 > /dev/null || true
	@systemctl disable njspc-exporter 2>&1 > /dev/null || true
	@rm /etc/systemd/system/njspc-exporter.service 2>&1 > /dev/null || true
	@rm -rf /opt/njspc-exporter 2>&1 > /dev/null || true
	@userdel njspc-exporter 2>&1 > /dev/null || true
