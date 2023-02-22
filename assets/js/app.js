// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"


import { Chart } from "chart.js/auto"
import annotationPlugin from "chartjs-plugin-annotation"
import "chartjs-adapter-date-fns"

Chart.register(annotationPlugin)

async function loadGraph() {
  const ctx = document.getElementById("myChart")

  const resp = await fetch("/api/temperatures")
  const data = await resp.json()
  let temps = data.data.map((d) => d.temperature)
  let dates = data.data.map((d) => d.inserted_at)

  new Chart(ctx, {
    type: "line",
    data: {
      datasets: [{
        label: "Freezer Temp",
        data: temps
      }],
      labels: dates,
    },
    options: {
      scales: {
        x: {
          type: 'time',
          time: {
            unit: 'minute',
          },
          suggestedMax: new Date()
        },
        y: {
          min: -10,
          suggestedMax: 32
        }
      },
      plugins: {
        annotation: {
          annotations: {
            threshold: {
              type: "line",
              yMin: 5,
              yMax: 5,
              borderColor: "rgb(255, 99, 132)",
              borderWidth: 3
            }
          }
        }
      }
    }
  })
}
document.addEventListener("DOMContentLoaded", loadGraph)