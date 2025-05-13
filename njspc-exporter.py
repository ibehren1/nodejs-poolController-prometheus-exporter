#!/usr/bin/env python3
# Copyright © 2025 Isaac Behrens. All rights reserved.

import json
import time
import urllib3
from os import path
from prometheus_client.core import (
    GaugeMetricFamily,
    REGISTRY,
    CounterMetricFamily,
)
from prometheus_client import start_http_server

# Constants
from prometheus_client import start_http_server

# Constants
port = 9101  # Port number for the Prometheus HTTP server
collection_frequency = 15  # Time interval (in seconds) between data collections
njspc_url = "http://localhost:4200"  # URL of the njspc service for fetching pool data


class RandomNumberCollector(object):
collection_frequency = 15
njspc_url = "http://localhost:4200"


njspc_url = "http://localhost:4200"


class PoolMetricsCollector(object):
    def __init__(self):
        pass
    def __init__(self):
        pass

    def collect(self):

        # Call njspc for state of all resources
# Call njspc for state of all resources
        http = urllib3.PoolManager()
        try:
            r = http.request("GET", f"{njspc_url}/state/all")
            data = json.loads(r.data)
        except urllib3.exceptions.HTTPError as e:
            print(f"HTTP request failed: {e}")
            return
        except json.JSONDecodeError as e:
            print(f"JSON parsing failed: {e}")
            return

        # Set short vars for values we care about
        pool_ph = data["chemControllers"][0]["ph"]["probe"]["level"]
        r = http.request("GET", f"{njspc_url}/state/all")
        data = json.loads(r.data)

        # Set short vars for values we care about
        pool_ph = data["chemControllers"][0]["ph"]["probe"]["level"]
        pool_dosed_acid = data["chemControllers"][0]["ph"]["dailyVolumeDosed"]
        pool_orp = data["chemControllers"][0]["orp"]["probe"]["level"]
        pool_alk = data["chemControllers"][0]["alkalinity"]
        pool_ch = data["chemControllers"][0]["calciumHardness"]
        pool_lsi = data["chemControllers"][0]["lsi"]
        pool_temp = data["chemControllers"][0]["ph"]["probe"]["temperature"]
        pump_rpm = data["pumps"][0]["rpm"]
        pump_watts = data["pumps"][0]["watts"]
        pump_flow = data["pumps"][0]["flow"]

        # Create Prometheus metrics for the values
        ph = GaugeMetricFamily("pH", "pH value", labels=["ph"])
        ph.add_metric(["ph"], pool_ph)
        yield ph

        dosed_acid = GaugeMetricFamily(
            "dosed_acid", "Dosed Acid (ml)", labels=["dosed_acid"]
        )
        dosed_acid.add_metric(["dosed_acid"], pool_dosed_acid)
        yield dosed_acid

        orp = GaugeMetricFamily("ORP", "ORP value", labels=["orp"])
        orp.add_metric(["orp"], pool_orp)
        yield orp

        alk = GaugeMetricFamily("ALK", "ALK value", labels=["alk"])
        alk.add_metric(["alk"], pool_alk)
        yield alk

        ch = GaugeMetricFamily("CH", "CH value", labels=["ch"])
        ch.add_metric(["ch"], pool_ch)
        yield ch

        lsi = GaugeMetricFamily("LSI", "LSI value", labels=["lsi"])
        lsi.add_metric(["lsi"], pool_lsi)
        yield lsi

        rpm = GaugeMetricFamily("RPM", "RPM value", labels=["rpm"])
        rpm.add_metric(["rpm"], pump_rpm)
        yield rpm

        temp = GaugeMetricFamily("Temp", "Temp (F)", labels=["temp"])
        temp.add_metric(["temp"], pool_temp)
        yield temp

        gpm = GaugeMetricFamily("GPM", "GPM value", labels=["gpm"])
        gpm.add_metric(["gpm"], pump_flow)
        yield gpm

        watts = GaugeMetricFamily("WATTS", "WATTS value", labels=["watts"])
        watts.add_metric(["watts"], pump_watts)
        yield watts


if __name__ == "__main__":
    start_http_server(port)
    REGISTRY.register(RandomNumberCollector())

    while True:
        time.sleep(collection_frequency)
