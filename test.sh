echo "\n\nTesting ResizerRole......"
prove -I./ResizerRole/lib/ ./ResizerRole/t/

echo "\n\nTesting Catalyst-App......"
prove -I./ResizerRole/lib/ -I./Catalyst-App/lib/ ./Catalyst-App/t/
