#!/bin/bash
echo {\"text\":\" "HOSTNAME: " > /tmp/slack.data.txt
hostname >> /tmp/slack.data.txt
echo "\\n\\n" >> /tmp/slack.data.txt
echo "User: " >> /tmp/slack.data.txt
cat /home/pi/.user_name >> /tmp/slack.data.txt
echo "\\n\\n" >> /tmp/slack.data.txt
ifconfig eth0 >> /tmp/slack.data.txt
echo "\\n\\n" >> /tmp/slack.data.txt
ifconfig wlan0 >> /tmp/slack.data.txt
echo \"}    >> /tmp/slack.data.txt
curl -X POST -H 'Content-type: application/json' --data @/tmp/slack.data.txt \
		https://hooks.slack.com/services/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 \
          &&  echo slack message sent ||  echo error sending slack msg

