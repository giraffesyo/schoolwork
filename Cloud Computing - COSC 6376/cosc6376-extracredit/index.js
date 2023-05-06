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
    //delete the minion from the table
    await database.table('Minion').deleteRows([minion.MinionId])
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

const DEFAULT_MINIONS = [
  {
    MinionId: '1',
    Name: 'Bob',
    Email: 'bob@hardworking.com',
  },
  {
    MinionId: '2',
    Name: 'Kevin',
    Email: 'kevin@slacking.com',
  },
  {
    MinionId: '3',
    Name: 'Stuart',
    Email: 'stu@aol.com',
  },
]
// reset function clears the Minion table and inserts 3 minions
const reset = async (req, res) => {
  const queryDelete = {
    sql: 'DELETE FROM Minion where true',
  }

  try {
    await database.runTransaction(async (err, transaction) => {
      await transaction.runUpdate(queryDelete)
      const promises = DEFAULT_MINIONS.map(minion => {
        const queryInsert = {
          sql: `INSERT INTO Minion (MinionId, Name, Email) VALUES (@MinionId, @Name, @Email)`,
          params: minion,
        }
        return transaction.runUpdate(queryInsert)
      })
      await Promise.all(promises)
      await transaction.commit()
    })
  } catch (error) {
    return res.status(500).json({ error: true, message: 'Error resetting' })
  }
  return res.status(200).json({ error: false, message: 'Minions reset' })
}

const app = express()

app.use(express.json())

app.post('/summon', summon)

app.get('/', get_minions)

app.post('/reset', reset)

exports.minions = app
