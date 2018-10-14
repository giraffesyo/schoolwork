import React from 'react'
import Layout from '../HOC/Layout'
import { ProfileTopNav } from '../blocks/ProfileTopNav'

class Offer extends React.PureComponent {
  render() {
    return (
      <Layout TopNav={ProfileTopNav}>
        <div className="container">
          <div className="row">
            <div className="col">
              <h1>Hello world</h1>
            </div>
          </div>
          <div className="row">
            <div className="col">
              <h2>this is html...</h2>
            </div>
          </div>
        </div>
      </Layout>
    )
  }
}

export { Offer }
