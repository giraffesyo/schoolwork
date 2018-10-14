import React from 'react'
import postings from '../data/postings'
import { Posting } from '../blocks/Posting'

class Postings extends React.PureComponent {
  render() {
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
