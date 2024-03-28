package main

import (
	"os"
	"os/signal"
	"bufio"
	"syscall"
	"context"
	"github.com/redis/go-redis/v9"
)

var (
	redisConn string = "redis://localhost:6379/0?protocol=3"
	chanName string = "telegraf"
)

func main() {

	c := make(chan os.Signal, 1)
    signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)

	// channelname
	if len(os.Args) > 1 {
		chanName = os.Args[1]
	}
	// redis connection
	if len(os.Args) > 2 {
		redisConn = os.Args[2]
	}

	ctx := context.Background()
	opts, _ := redis.ParseURL(redisConn)
	rdb := redis.NewClient(opts)

	go func() {
		scanner := bufio.NewScanner(os.Stdin)
		for scanner.Scan() {
			line := scanner.Text()
			rdb.Publish(ctx, chanName, line)
		}

		if err := scanner.Err(); err != nil {
			panic(err)
		}
	}()

    <-c

	// Close the Redis client gracefully
	if err := rdb.Close(); err != nil {
		panic(err)
	}
}