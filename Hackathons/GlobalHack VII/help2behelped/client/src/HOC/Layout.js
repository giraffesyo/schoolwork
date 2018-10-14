import React from 'react'
import { Nav } from '../blocks/Nav'
import styled from 'styled-components'
import '../overrides.css'

const Translate = styled.div`
  margin-right: 1rem;
  img { 
    display: none;
  }
  text-align: right;
  & > div {
    color: transparent;
  }
  & > div > :not(:nth-child(1)) {
    display: none !important;
    content: '';
  }
`

class Layout extends React.PureComponent {
  render() {
    return (
      <>
        <Translate id="google_translate_element" />
        {this.props.children}
        <Nav />
      </>
    )
  }
}

export default Layout
