#!/usr/bin/env python3
import configparser
import logging
import os
import re
import shutil
import time
from threading import Thread

import RPi.GPIO as GPIO
import smbus

logging.getLogger().setLevel(logging.INFO)
rev = GPIO.RPI_REVISION
if rev == 2 or rev == 3:
    bus = smbus.SMBus(1)
else:
    bus = smbus.SMBus(0)

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
SHUTDOWN_PIN=4
GPIO.setup(SHUTDOWN_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

CONFIG_FILE = "/etc/argon1_config.ini"
DEFAULT_CONFIG = {
    "fan": {
        "65": "100",
        "60": "80",
        "55": "60",
        "50": "40",
        "45": "20",
        "40": "0"
    },
    "power_button": {
        "shutdown_enabled": True,
        "reboot_enabled": True
    }
}


def shutdown_check():
    power_button_config = load_config(CONFIG_FILE).get("power_button")
    while True:
        pulsetime = 1
        GPIO.wait_for_edge(SHUTDOWN_PIN, GPIO.RISING)
        time.sleep(0.01)
        while GPIO.input(SHUTDOWN_PIN) == GPIO.HIGH:
            time.sleep(0.01)
            pulsetime += 1
        if pulsetime >=2 and pulsetime <=3:
            if power_button_config.get("reboot_enabled"):
                logging.warning("Rebooting...")
                os.system("reboot")
        elif pulsetime >=4 and pulsetime <=5:
            if power_button_config.get("shutdown_enabled"):
                logging.warning("Shuting down...")
                os.system("shutdown now -h")

def get_fanspeed(current_temp, temp_config):
    for k,v in temp_config.items():
        if current_temp >= float(k):
            return int(float(v))
    return 0

def load_config(file):
    if os.path.isfile(file):
        config = configparser.ConfigParser()
        config.read(file)
        return config
    else:
        logging.warning(f"Config file '{file}' not found. Using default config.")
        return DEFAULT_CONFIG
 
def temp_check():
    fanconfig = load_config(CONFIG_FILE).get("fan")
    address=0x1a
    prevblock=0
    current_temp = 0
    while True:
        if shutil.which("vcgencmd"):
            current_temp = float(re.findall(r'temp=([\d\.])', os.popen("vcgencmd measure_temp").readline())[0])
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as fp:
            current_temp = float(int(fp.readline())/1000)
        block = get_fanspeed(current_temp, fanconfig)
        if block < prevblock:
            time.sleep(30)
        prevblock = block
        try:
            logging.info(f"Setting fan speed to {block}% for temperature {current_temp:.0f}{chr(176)}C...")
            bus.write_byte(address, block)
        except IOError as e:
            logging.error(f"Error writing bytes to block.\n{str(e)}")
        time.sleep(30)

try:
    t1 = Thread(target = shutdown_check)
    t2 = Thread(target = temp_check)
    logging.info("Starting power button monitor thread...")
    t1.start()
    logging.info("Starting fan control thread...")
    t2.start()
except:
    t1.stop()
    t2.stop()
    GPIO.cleanup()
