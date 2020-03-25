#!/bin/bash

#https://www.cyberciti.biz/faq/howto-finding-files-by-date/

find ./ -iname "*.log" -mtime +60 -exec rm {} \;
