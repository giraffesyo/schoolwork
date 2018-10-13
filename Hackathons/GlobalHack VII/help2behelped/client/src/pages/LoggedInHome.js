import React from 'react'
import { Nav } from '../blocks/Nav'
import { Shouts } from '../components/Shouts'




class LoggedInHome extends React.PureComponent {
  render() {
    return (
      <div>
        <Nav />
        <Shouts />
      </div>
    )
  }
}

export { LoggedInHome }
