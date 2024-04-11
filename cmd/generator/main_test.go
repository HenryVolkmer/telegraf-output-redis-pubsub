package main

import (
    "testing"
    "time"
    "github.com/influxdata/line-protocol/v2/lineprotocol"
)

func TestTime(t *testing.T) {
    enc := lineprotocol.Encoder{}
    enc.StartLine("a_measurement")
    enc.AddField("temp",lineprotocol.MustNewValue(int64(10)))
    enc.EndLine(time.Now())

    // explicite from bytes to string and from string to bytes
    str := string(enc.Bytes())
    dec := lineprotocol.NewDecoderWithBytes([]byte(str))

    tests := map[string]lineprotocol.Precision {
        "nano": lineprotocol.Nanosecond,
        "micro": lineprotocol.Microsecond,
        "second": lineprotocol.Second,
    }

    for label,p := range tests {
        ti, err := dec.Time(p, time.Time{})
        if err != nil {
            panic(err)
        }
        if ti.IsZero() {
            t.Errorf("decoder.Time for precision %s should not be zero",label)
        }   
    }
}