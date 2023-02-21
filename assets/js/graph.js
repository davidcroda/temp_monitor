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
            parser: (date) => {
              return moment(date).subtract(5, 'hours')
            }
          }
        }
      }
    }
  })
}
loadGraph()