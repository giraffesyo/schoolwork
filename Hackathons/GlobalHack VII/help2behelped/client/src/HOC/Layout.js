import React from 'react'
import { Nav } from '../blocks/Nav'
import styled from 'styled-components'
import '../overrides.css'

class Layout extends React.PureComponent {
  render() {
    const { TopNav } = this.props

    const Wrapper = styled.div`
      margin: ${!!TopNav ? '100px 0' : '0'};
    `
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
