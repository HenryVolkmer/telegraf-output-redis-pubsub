package main

import (
	"fmt"
	"math/rand"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/influxdata/line-protocol/v2/lineprotocol"
)

func main() {
    c := make(chan os.Signal, 1)
    signal.Notify(c, syscall.SIGHUP)
    if len(os.Args) == 2 {
        fmt.Println("PID",os.Getpid())        
    }
    metrics := map[string][]int{
        "Maschinen.PM1_Daten.Komponenten.Produkteinlauf.Temperatur.IST": {20,25},
        "Maschinen.PM1_Daten.Komponenten.Produkteinlauf.Massenstrom.IST": {230,240},
    }

    tags := map[string][]string{
        "Maschinen.PM1_Daten.Maschine.Auftragsdaten.Auftragsnummer": {"0","69930","69931"},
        "Maschinen.PM1_Daten.Maschine.Auftragsdaten.Artikelbezeichnung": {"0","Foobar1","Foobar2"},
        "Maschinen.PM1_Daten.Maschine.Auftragsdaten.Charge": {"0","FBA1","FBA2"},
        "Maschinen.PM1_Daten.Maschine.Auftragsdaten.Fertigungsschritt": {"0","60","70"},
    }

    tagCh := make(chan map[string]string)
    go func() {
        counter := 0
        for {
            buffer := make(map[string]string)
            for k, v := range tags {
                buffer[k] = v[counter%len(v)]
            }
            tagCh <- buffer
            counter++
            time.Sleep(20 * time.Second)
        }
    }()

    for {
        <-c
        select {
        case tags := <-tagCh:
            for k,v := range tags {
                enc := getEncoder()
                enc.AddField(k,lineprotocol.MustNewValue(v))
                enc.EndLine(time.Now())
                fmt.Printf("%s",enc.Bytes())
            }
        default:
            publishMetrics(metrics,10)
        }
        publishMetrics(metrics,10)
    }
}

func publishMetrics(metrics map[string][]int,cnt int) {
    for i := 0; i < cnt; i++ {
        for k,v := range metrics {
            min := int64(v[0])
            max := int64(v[1])
            value := rand.Int63n(max-min+1) + min
            enc := getEncoder()
            enc.AddField(k,lineprotocol.MustNewValue(value))
            enc.EndLine(time.Now())
            fmt.Printf("%s",enc.Bytes())
        }
    }
}

func getEncoder() lineprotocol.Encoder {
    enc := lineprotocol.Encoder{}
    enc.StartLine("generator_device2")
    enc.AddTag("machine_ID","550e8400-e29b-41d4-a716-446655440000")
    return enc
}