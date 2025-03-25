# Necrotools

A roster manager for the game Necromunda.

## Features

Necrotools will contain a comprehensive database of skills, weapons, war gear, and fighter stats, presented in such a way that building a gang should be both quick and easy.

At least initially, the ability to add new weapon, war gear, and fighter templates will be limited to admins but users should have the ability to add custom fighters to their own rosters.

In addition, Necrotools should have a quick and easy interface for managing a gang through a campaign, including the adding of gear from the Trading Post, the adding of XP and skills to fighters, and the dimunition of stats through injuries.

## Technology

Necrotools is a PHP-based REST backend that feeds a dynamic web frontend written in JavaScript.

Development is handled through the use of Docker. Simply check out the project, open the project directory in a terminal and run `docker compose up` to start a local instance.

Current environment targets are:
* PHP 8.2
* MySQL 8.3