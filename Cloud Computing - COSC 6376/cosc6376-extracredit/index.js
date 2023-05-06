const { Spanner } = require('@google-cloud/spanner')
const express = require('express')

const spanner = new Spanner()
const instance = spanner.instance('cosc6376')
const database = instance.database('cosc6376')
const summon = async (req, res) => {
  const query = {
    sql: 'SELECT * FROM Minion LIMIT 1',
  }

  try {
    const [rows] = await database.run(query)
    if (rows.length === 0) {
      return res.status(404).json({ error: 'No minions available' })
    }

    const minion = rows[0].toJSON()
    const response = {
      minion_id: minion.MinionId,
      minion_name: minion.Name,
      minion_email: minion.Email || 'N/A',
    }

    return res.status(200).json(response)
  } catch (error) {
    return res
      .status(500)
      .json({ error: true, message: 'Error querying Cloud Spanner' })
  }
}

const get_minions = async (req, res) => {
  const query = {
    sql: 'SELECT * FROM Minion',
  }

  try {
    const [rows] = await database.run(query)
    const minions = rows.map(row => {
      const minion = row.toJSON()
      return {
        minion_id: minion.MinionId,
        minion_name: minion.Name,
        minion_email: minion.Email || 'N/A',
      }
    })

    return res.status(200).json(minions)
  } catch (error) {
    return es.status(500).json({ error: 'Error querying Cloud Spanner' })
  }
}

const app = express()

app.use(express.json())

app.post('/summon', summon)

app.get('/minions', get_minions)

exports.minions = app
