#!/bin/bash
BBB_SERVER_URL="$(bbb-conf --secret | grep URL|  cut -d'/' -f3)"
HEAD_HTML="/usr/share/meteor/bundle/programs/web.browser/head.html"
HEAD_HTML_DEFAULT="/usr/share/meteor/bundle/programs/web.browser/head.html.default"
HEAD_HTML_LEGACY="/usr/share/meteor/bundle/programs/web.browser.legacy/head.html"
HEAD_HTML_LEGACY_DEFAULT="/usr/share/meteor/bundle/programs/web.browser.legacy/head.html.default"
BBB_WEBROOT="/var/www/bigbluebutton-default"
ROCKETCHAT_API_TOKEN="xvvyQ3vR4os5d_NELytNMTVDeSFAqpIR9ur8OKP-HoH"
ROCKETCHAT_USER_ID="CKQjkmNZK48LwTWbr"
ROCKETCHAT_URL="chat.higheredlab.com"

if [  ! -d "$BBB_WEBROOT/integrations" ];then
    mkdir -p "$BBB_WEBROOT/integrations"
fi


if [ -d "$BBB_WEBROOT/integrations" ];then
    wget -O "$BBB_WEBROOT/integrations/bbb-rocketchat.js" https://raw.githubusercontent.com/manishkatyan/bbb-rocket-chat/main/bbb-rocketchat.js
fi

echo "Updating rocketchat details"
sed -i "s/apiToken=apiToken/apiToken=\"$ROCKETCHAT_API_TOKEN\"/g" "$BBB_WEBROOT/integrations/bbb-jamboard.js"
sed -i "s/apiUserID=apiUserID/apiUserID=\"$ROCKETCHAT_USER_ID\"/g" "$BBB_WEBROOT/integrations/bbb-jamboard.js"
sed -i "s/rocketChatURL=rocketChatURL/rocketChatURL=\"$ROCKETCHAT_URL\"/g" "$BBB_WEBROOT/integrations/bbb-jamboard.js"

#Backup default files
if [ ! -f "$HEAD_HTML_DEFAULT" ];then
    echo "Creating a copy of $HEAD_HTML at $HEAD_HTML_DEFAULT"
    cp $HEAD_HTML $HEAD_HTML_DEFAULT
fi

if [ ! -f "$HEAD_HTML_LEGACY_DEFAULT" ];then
    echo "Creating a copy of $HEAD_HTML_LEGACY at $HEAD_HTML_LEGACY_DEFAULT"
    cp "$HEAD_HTML_LEGACY" "$HEAD_HTML_LEGACY_DEFAULT"
fi

#Add bbb-jamboard Integration
if grep -Fxq "<script src=\"https://$BBB_SERVER_URL/integrations/bbb-rocketchat.js\"></script>" $HEAD_HTML
then
   echo "Found Jamboard integration at $HEAD_HTML"
else
    echo "Installing bbb-jamboard at $HEAD_HTML"
    echo "">> $HEAD_HTML
    echo "<script src=\"https://$BBB_SERVER_URL/integrations/bbb-rocketchat.js\"></script>" >>  $HEAD_HTML
fi

if grep -Fxq "<script src=\"https://$BBB_SERVER_URL/integrations/bbb-rocketchat.js\"></script>" $HEAD_HTML_LEGACY
then
   echo "Found Jamboard integration at $HEAD_HTML_LEGACY"
else
    echo "Installing bbb-jamboard at $HEAD_HTML_LEGACY"
    echo "">> $HEAD_HTML_LEGACY
    echo "<script src=\"https://$BBB_SERVER_URL/integrations/bbb-rocketchat.js\"></script>" >>  $HEAD_HTML_LEGACY
fi


echo "==== Please restart your bigbluebutton server with: bbb-conf --restart ===="