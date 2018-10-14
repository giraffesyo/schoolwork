import React from 'react'
import { Posting } from '../blocks/Posting'
import firebase from '../firebase'

class Postings extends React.PureComponent {
  state = {
    offers: {}
  }

  async componentDidMount() {
    //get raw offers
    const ref = await firebase
      .database()
      .ref('offers')
      .once('value')
    const offers = ref.val()
    this.setState({ offers })
  }
  render() {
    const { offers } = this.state
    let postings = []
    for (let key in offers) {
      let post = offers[key]
      postings.push(
        <Posting
          message={post.description}
          user={post.user}
          skill={post.task}
          key={post.user+post.task}
        />
      )
    }
    return postings
  }
}

export { Postings }

// OLD VERSIOn

/*

import React from 'react'
import postings from '../data/postings'
import { Posting } from '../blocks/Posting'
import firebase from '../firebase'

class Postings extends React.PureComponent {

  async componentDidMount() {
    //get raw offers
     const ref = await firebase
     .database()
     .ref('offers')
     .once('value')
   const offers = ref.val()
   this.setState({ offers })
  }
  render() {
    let postings = []
    const Mapped = postings.map(({ user, action, skill, message }, index) => (
      <Posting
        user={user}
        action={action}
        skill={skill}
        message={message}
        key={'posting-' + index}
      />
    ))
    return Mapped
  }
}

export { Postings }

*/
