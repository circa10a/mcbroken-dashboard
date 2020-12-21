package main

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	log "github.com/sirupsen/logrus"
)

// Mcbroken holds ice cream machine failure rates in all available cities
type McbrokenData struct {
	Cities []struct {
		CityName         string  `json:"city"`
		BrokenPercentage float64 `json:"broken"`
	} `json:"cities"`
	BrokenPercentage float64 `json:"broken"`
}

const (
	URL = "https://mcbroken.com/stats.json"
)

func fetchMcbrokenData() *McbrokenData {
	log.Info("Fetching mcbroken data...")
	client := &http.Client{Timeout: 10 * time.Second}

	req, err := http.NewRequest("GET", URL, nil)
	if err != nil {
		log.Error(err)
	}

	r, err := client.Do(req)
	if err != nil {
		log.Error(err)
	}
	defer r.Body.Close()

	// Unmarshal data
	brokenCities := &McbrokenData{}
	err = json.NewDecoder(r.Body).Decode(&brokenCities)
	if err != nil {
		log.Error(err)
	}
	log.Info("Fetched mcbroken data successfully...")
	log.Info()
	return brokenCities
}

var (
	mcbrokenCities = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "mcbroken",
		Help: "Percentage of broken mcdonald's ice cream machines",
	}, []string{"city"})
)

func recordMetrics() {
	go func() {
		for {
			data := fetchMcbrokenData()
			for _, mcbroken := range data.Cities {
				mcbrokenCities.With(prometheus.Labels{"city": mcbroken.CityName}).Set(mcbroken.BrokenPercentage)
			}
			mcbrokenCities.With(prometheus.Labels{"city": "all"}).Set(data.BrokenPercentage)
			time.Sleep(30 * time.Second)
		}
	}()
}

func main() {
	log.SetFormatter(&log.TextFormatter{
		TimestampFormat: "2006-01-02 15:04:05",
		FullTimestamp:   true,
	})
	recordMetrics()
	http.Handle("/metrics", promhttp.Handler())
	log.Fatal(http.ListenAndServe(":8080", nil))
}
