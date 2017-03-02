#!/bin/bash
## --------------------------------------------------------------------------------------------------------------------

set -e

echo "Checking ask.sh is installed ..."
if [ ! $(which ask.sh) ]; then
    echo "Please put ask.sh into ~/bin (should already be in your path from ~/.profile):"
    echo ""
    echo "    mkdir ~/bin"
    echo "    wget -O ~/bin/ask.sh https://gist.githubusercontent.com/chilts/6b547307a6717d53e14f7403d58849dd/raw/ecead4db87ad4e7674efac5ab0e7a04845be642c/ask.sh"
    echo "    chmod +x ~/bin/ask.sh"
    echo ""
    exit 2
fi
echo

# General
TYNIO_PORT=`ask.sh tynio TYNIO_PORT 'Which local port should the server listen on :'`
TYNIO_NAKED_DOMAIN=`ask.sh tynio TYNIO_NAKED_DOMAIN 'What is the naked domain (e.g. localhost:1234 or tyn.io) :'`
TYNIO_BASE_URL=`ask.sh tynio TYNIO_BASE_URL 'What is the base URL (e.g. http://localhost:1234 or https://tyn.io) :'`

# Social Providers
TYNIO_TWITTER_CONSUMER_KEY=`ask.sh tynio TYNIO_TWITTER_CONSUMER_KEY 'Enter your Twitter Consumer Key :'`
TYNIO_TWITTER_CONSUMER_SECRET=`ask.sh tynio TYNIO_TWITTER_CONSUMER_SECRET 'Enter your Twitter Consumer Secret :'`
TYNIO_GPLUS_CLIENT_ID=`ask.sh tynio TYNIO_GPLUS_CLIENT_ID 'Enter your GPlus Client Id :'`
TYNIO_GPLUS_CLIENT_SECRET=`ask.sh tynio TYNIO_GPLUS_CLIENT_SECRET 'Enter your GPlus Client Secret :'`
TYNIO_GITHUB_CLIENT_ID=`ask.sh tynio TYNIO_GITHUB_CLIENT_ID 'Enter your GitHub Client Id :'`
TYNIO_GITHUB_CLIENT_SECRET=`ask.sh tynio TYNIO_GITHUB_CLIENT_SECRET 'Enter your GitHub Client Secret :'`

 # Sessions
TYNIO_SESSION_AUTH_KEY_V2=`ask.sh tynio TYNIO_SESSION_AUTH_KEY_V2 'Enter your SESSION_AUTH_KEY_V2 :'`
TYNIO_SESSION_ENC_KEY_V2=`ask.sh tynio TYNIO_SESSION_ENC_KEY_V2 'Enter your SESSION_ENC_KEY_V2 :'`
TYNIO_SESSION_AUTH_KEY_V1=`ask.sh tynio TYNIO_SESSION_AUTH_KEY_V1 'Enter your SESSION_AUTH_KEY_V1 :'`
TYNIO_SESSION_ENC_KEY_V1=`ask.sh tynio TYNIO_SESSION_ENC_KEY_V1 'Enter your SESSION_ENC_KEY_V1 :'`

echo "Building code ..."
gb build
echo

# copy the supervisor script into place
echo "Copying supervisor config ..."
m4 \
    -D __TYNIO_PORT__=$TYNIO_PORT \
    -D __TYNIO_NAKED_DOMAIN__=$TYNIO_NAKED_DOMAIN \
    -D __TYNIO_BASE_URL__=$TYNIO_BASE_URL \
    -D __TYNIO_TWITTER_CONSUMER_KEY__=$TYNIO_TWITTER_CONSUMER_KEY \
    -D __TYNIO_TWITTER_CONSUMER_SECRET__=$TYNIO_TWITTER_CONSUMER_SECRET \
    -D __TYNIO_GPLUS_CLIENT_ID__=$TYNIO_GPLUS_CLIENT_ID \
    -D __TYNIO_GPLUS_CLIENT_SECRET__=$TYNIO_GPLUS_CLIENT_SECRET \
    -D __TYNIO_GITHUB_CLIENT_ID__=$TYNIO_GITHUB_CLIENT_ID \
    -D __TYNIO_GITHUB_CLIENT_SECRET__=$TYNIO_GITHUB_CLIENT_SECRET \
    -D __TYNIO_SESSION_AUTH_KEY_V2__=$TYNIO_SESSION_AUTH_KEY_V2 \
    -D __TYNIO_SESSION_ENC_KEY_V2__=$TYNIO_SESSION_ENC_KEY_V2 \
    -D __TYNIO_SESSION_AUTH_KEY_V1__=$TYNIO_SESSION_AUTH_KEY_V1 \
    -D __TYNIO_SESSION_ENC_KEY_V1__=$TYNIO_SESSION_ENC_KEY_V1 \
    etc/supervisor/conf.d/io-tyn.conf.m4 | sudo tee /etc/supervisor/conf.d/io-tyn.conf
echo

# restart supervisor
echo "Restarting supervisor ..."
sudo systemctl restart supervisor.service
echo

# copy the caddy conf
echo "Copying Caddy config config ..."
m4 \
    -D __TYNIO_PORT__=$TYNIO_PORT \
    -D __TYNIO_NAKED_DOMAIN__=$TYNIO_NAKED_DOMAIN \
    -D __TYNIO_BASE_URL__=$TYNIO_BASE_URL \
    -D __TYNIO_TWITTER_CONSUMER_KEY__=$TYNIO_TWITTER_CONSUMER_KEY \
    -D __TYNIO_TWITTER_CONSUMER_SECRET__=$TYNIO_TWITTER_CONSUMER_SECRET \
    -D __TYNIO_GPLUS_CLIENT_ID__=$TYNIO_GPLUS_CLIENT_ID \
    -D __TYNIO_GPLUS_CLIENT_SECRET__=$TYNIO_GPLUS_CLIENT_SECRET \
    -D __TYNIO_GITHUB_CLIENT_ID__=$TYNIO_GITHUB_CLIENT_ID \
    -D __TYNIO_GITHUB_CLIENT_SECRET__=$TYNIO_GITHUB_CLIENT_SECRET \
    -D __TYNIO_SESSION_AUTH_KEY_V2__=$TYNIO_SESSION_AUTH_KEY_V2 \
    -D __TYNIO_SESSION_ENC_KEY_V2__=$TYNIO_SESSION_ENC_KEY_V2 \
    -D __TYNIO_SESSION_AUTH_KEY_V1__=$TYNIO_SESSION_AUTH_KEY_V1 \
    -D __TYNIO_SESSION_ENC_KEY_V1__=$TYNIO_SESSION_ENC_KEY_V1 \
    etc/caddy/vhosts/io.tynio.conf.m4 | sudo tee /etc/caddy/vhosts/io.tynio.conf
echo

# restarting Caddy
echo "Restarting caddy ..."
sudo systemctl restart caddy.service
echo

## --------------------------------------------------------------------------------------------------------------------
