import React from 'react'
import shouts from '../data/shouts'
import { LiveShout } from '../blocks/LiveShout'

class Shouts extends React.PureComponent {
  render() {
    const Mapped = shouts.map(({ received, price, distance }, index) => (
      <LiveShout
        distance={distance}
        price={price}
        received={received}
        key={'liveshout-' + index}
      />
    ))
    return Mapped
  }
}

export { Shouts }
