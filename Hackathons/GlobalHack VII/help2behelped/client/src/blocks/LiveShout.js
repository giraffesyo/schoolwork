import React from 'react'
import styled from 'styled-components'
import { gray, green, purple } from '../colors'
import { FaCaretUp } from 'react-icons/fa'

const Box = styled.div`
  background-color: ${gray};
  flex-basis: 1;
  border-radius: 25px;
  margin: 1rem;
  padding: 1rem;
  position: relative;
`

const Distance = styled.div`
  position: absolute;
  left: 1rem;
  top: 0.5rem;
  font-size: 0.75rem;
`
const Description = styled.div`
  font-size: 1rem;
  padding: 0.5rem 0;
  font-weight: 700;
  text-align: center;
  color: ${green};
`
const Purple = styled.span`
  color: ${purple};
`

class LiveShout extends React.PureComponent {
  render() {
    console.log(this.props)
    const { received, price, distance } = this.props
    return (
      <Box>
        <Distance>{distance} miles from you</Distance>
        <Description>
          Someone received {received} for{' '}
          <Purple>
            <FaCaretUp />
            {price} favor points
          </Purple>
        </Description>
      </Box>
    )
  }
}

export { LiveShout }
