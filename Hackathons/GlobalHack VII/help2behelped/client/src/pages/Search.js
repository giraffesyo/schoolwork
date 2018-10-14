import React from 'react'
import Layout from '../HOC/Layout'
import { SearchTopNav } from '../blocks/SearchTopNav'
import { Postings } from '../components/Postings'

class Search extends React.PureComponent {
  render() {
    return (
      <Layout TopNav={SearchTopNav}>
        <Postings />
      </Layout>
    )
  }
}

export { Search }
