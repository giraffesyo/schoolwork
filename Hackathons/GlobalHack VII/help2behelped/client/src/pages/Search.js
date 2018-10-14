import React from 'react'
import Layout from '../HOC/Layout'

class Search extends React.PureComponent {
  render() {
    return (
      <Layout>
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

export { Search }
