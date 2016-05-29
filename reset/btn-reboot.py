#!/usr/bin/env python2.7

# Import
from time import sleep
import subprocess
import RPi.GPIO as GPIO

# Variables
led_gpio=20
btn_gpio=16
reboot_time=1
halt_time=5
stop_time=10

GPIO.setmode(GPIO.BCM)
GPIO.setup(btn_gpio, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(led_gpio, GPIO.OUT)

def system_button(btn_gpio):
	press_time = 0
	i=0
	while True:
		if (GPIO.input(btn_gpio) == False): # Le bouton a ete presse
			press_time += 0.2
			if (press_time > stop_time):
				GPIO.output(led_gpio, GPIO.LOW)
			elif (press_time > halt_time): # Arret : clignotement rapide
				i += 1
				if (i%2 == 0):
					GPIO.output(led_gpio, GPIO.HIGH)
				else:
					GPIO.output(led_gpio, GPIO.LOW)					
			elif (press_time > reboot_time): # Reboot : clignotement lent
				i += 1
				if (i%3 == 0):
					GPIO.output(led_gpio, GPIO.LOW)
				else:
					GPIO.output(led_gpio, GPIO.HIGH)
		else: # Le  bouton est relache : on compte la duree
			GPIO.output(led_gpio, GPIO.HIGH)
			if (press_time > stop_time):
				print "Annulation reboot"	
			elif (press_time > halt_time):
				subprocess.call(['shutdown -h now "Arret du systeme par bouton GPIO" &'], shell=True)
			elif (press_time > reboot_time):
				subprocess.call(['shutdown -r now "Reboot du systeme par bouton GPIO" &'], shell=True)
			
			press_time = 0
			i=0
		# Attente de 0.2s pour reduire la charge CPU
		sleep(0.2)


# on met le bouton en ecoute par interruption, detection falling edge sur le canal choisi, et un debounce de 200 millisecondes
GPIO.add_event_detect(btn_gpio, GPIO.FALLING, callback=system_button, bouncetime=200)
GPIO.output(led_gpio, GPIO.HIGH)

try:
	while True:
		sleep(2)
except KeyboardInterrupt:
	GPIO.cleanup()

GPIO.cleanup()
