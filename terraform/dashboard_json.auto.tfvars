gcp_dashboard_json = <<-EOF
{
  "category": "CUSTOM",
  "displayName": "(Custom Dashboard) - URL Shortener - IDmeHireMe",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 3,
        "widget": {
          "title": "Container Memory Utilization [50TH PERCENTILE]",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_PERCENTILE_50"
                    },
                    "filter": "metric.type=\"run.googleapis.com/container/memory/utilizations\" resource.type=\"cloud_run_revision\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 6,
        "yPos": 0
      },
      {
        "height": 3,
        "widget": {
          "title": "Total latency [50TH PERCENTILE]",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_PERCENTILE_50"
                    },
                    "filter": "metric.type=\"loadbalancing.googleapis.com/https/total_latencies\" resource.type=\"https_lb_rule\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 6,
        "yPos": 6
      },
      {
        "height": 3,
        "widget": {
          "title": "Container CPU Utilization [50TH PERCENTILE]",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_PERCENTILE_50"
                    },
                    "filter": "metric.type=\"run.googleapis.com/container/cpu/utilizations\" resource.type=\"cloud_run_revision\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 6,
        "yPos": 3
      },
      {
        "height": 2,
        "widget": {
          "scorecard": {
            "gaugeView": {
              "lowerBound": 0,
              "upperBound": 1000
            },
            "thresholds": [
              {
                "color": "RED",
                "direction": "ABOVE",
                "label": "",
                "value": 900
              },
              {
                "color": "YELLOW",
                "direction": "BELOW",
                "label": "",
                "value": 2
              }
            ],
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_PERCENTILE_99",
                  "groupByFields": [],
                  "perSeriesAligner": "ALIGN_MAX"
                },
                "filter": "metric.type=\"run.googleapis.com/container/instance_count\" resource.type=\"cloud_run_revision\""
              }
            }
          },
          "title": "Container Instance Count"
        },
        "width": 3,
        "xPos": 0,
        "yPos": 0
      },
      {
        "height": 2,
        "widget": {
          "scorecard": {
            "gaugeView": {
              "lowerBound": 0,
              "upperBound": 1
            },
            "thresholds": [],
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_NONE",
                  "perSeriesAligner": "ALIGN_RATE"
                },
                "filter": "metric.type=\"loadbalancing.googleapis.com/https/backend_request_count\" resource.type=\"https_lb_rule\"",
                "secondaryAggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_PERCENTILE_99",
                  "groupByFields": [],
                  "perSeriesAligner": "ALIGN_MAX"
                }
              }
            }
          },
          "title": "Backend Request Count [99TH PERCENTILE]"
        },
        "width": 3,
        "xPos": 3,
        "yPos": 0
      },
      {
        "height": 3,
        "widget": {
          "title": "Check passed [COUNT TRUE]",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_COUNT_TRUE"
                    },
                    "filter": "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 3,
        "xPos": 0,
        "yPos": 2
      }
    ]
  }
}
EOF
