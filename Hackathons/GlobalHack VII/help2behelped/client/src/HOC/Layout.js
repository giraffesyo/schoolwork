import React from 'react'
import { Nav } from '../blocks/Nav'

class Layout extends React.PureComponent {
  render() {
    return (
      <>
        {this.props.children}
        <Nav />
      </>
    )
  }
}

export default Layout
