#usage: sh start_app.sh 9999

PORT=$1
: ${PORT:="9999"}
perl -I./ResizerRole/lib/ -I./Catalyst-App/lib/ ./Catalyst-App/script/resizer_server.pl -rdp $PORT

