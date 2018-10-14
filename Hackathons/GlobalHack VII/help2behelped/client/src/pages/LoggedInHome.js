import React from 'react'
import Layout from '../HOC/Layout'
import { Shouts } from '../components/Shouts'

class LoggedInHome extends React.PureComponent {
  render() {
    return (
      <Layout>
        <Shouts />
      </Layout>
    )
  }
}

export { LoggedInHome }
