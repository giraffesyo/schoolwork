import React from 'react'
import styled from 'styled-components'
import { gray, green } from '../colors'
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
  padding-top: 0.5rem;
  font-weight: 700;
  text-align: center;
  color: ${green};
`

class LiveShout extends React.PureComponent {
  render() {
    console.log(this.props)
    const { received, price, distance } = this.props
    return (
      <Box>
        <Distance>{distance} miles from you</Distance>
        <Description>
          Someone received {received} for <FaCaretUp /> {price} points
        </Description>
      </Box>
    )
  }
}

export { LiveShout }
