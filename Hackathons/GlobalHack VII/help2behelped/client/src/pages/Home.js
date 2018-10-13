import React from 'react'
import localForage from 'localforage'

import { Link } from 'react-router-dom'

class Home extends React.PureComponent {
  render() {
    return (
      <div>
        <Link to="/home">Click here to login</Link>
      </div>
    )
  }
}

export { Home }
