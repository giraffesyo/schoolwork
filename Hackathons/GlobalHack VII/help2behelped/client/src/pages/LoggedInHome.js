import React from 'react'
import Layout from '../HOC/Layout'
import { Shouts } from '../components/Shouts'
import styled from 'styled-components'
import { Redirect } from 'react-router-dom'
import localForage from 'localforage'

const BigBottomMargin = styled.div`
  margin-bottom: 90px;
`
class LoggedInHome extends React.PureComponent {
  state = { loaded: false, loggedIn: false }
  async componentDidMount() {
    const user = await localForage.getItem('user')
    if (!!user) {
      this.setState({ loaded: true, loggedIn: true })
    } else {
      this.setState({ loaded: true, loggedIn: false })
    }
  }

  render() {
    const { loaded, loggedIn } = this.state
    return (
      <Layout>
        <BigBottomMargin>
          <Shouts />
        </BigBottomMargin>
        {loaded && !loggedIn && <Redirect to={'/'} />}
      </Layout>
    )
  }
}

export { LoggedInHome }
