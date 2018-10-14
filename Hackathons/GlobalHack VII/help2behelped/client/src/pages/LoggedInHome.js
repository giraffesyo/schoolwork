import React from 'react'
import Layout from '../HOC/Layout'
import { Shouts } from '../components/Shouts'
import styled from 'styled-components'

const BigBottomMargin = styled.div`
  margin-bottom: 90px;
`
class LoggedInHome extends React.PureComponent {
  render() {
    return (
      <Layout>
        <BigBottomMargin>

          <Shouts />
        </BigBottomMargin>
      </Layout>
    )
  }
}

export { LoggedInHome }
