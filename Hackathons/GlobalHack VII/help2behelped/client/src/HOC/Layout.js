import React from 'react'
import { Nav } from '../blocks/Nav'
import styled from 'styled-components'
import '../overrides.css'


class Layout extends React.PureComponent {
  render() {
    return (
      <>
        <div className="container">{this.props.children}</div>
        <Nav />
      </>
    )
  }
}

export default Layout
