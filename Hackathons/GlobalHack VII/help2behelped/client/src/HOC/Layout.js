import React from 'react'
import { Nav } from '../blocks/Nav'
import styled from 'styled-components'
import '../overrides.css'

const Wrapper = styled.div`
  margin: 100px 0;
`

class Layout extends React.PureComponent {
  render() {
    const { TopNav } = this.props
    return (
      <>
        {!!TopNav && <TopNav />}
        <Wrapper className="container">{this.props.children}</Wrapper>
        <Nav />
      </>
    )
  }
}

export default Layout
