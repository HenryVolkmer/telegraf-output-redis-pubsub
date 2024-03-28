redispubsub-output and generator-input
======================================

## with telegraf

1. `make build`
2. copy/modify `telegraf.conf.dist` and make it a telegraf config
3. start container `make up`
4. run telegraf


## without telegraf

1. `make build`
2. start container `make up`
3. run `/tmp/input_plugin true` (true: echo PID on startup)
4. kill -SIGHUP <pid>