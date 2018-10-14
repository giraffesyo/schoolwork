import React from 'react'
import styled from 'styled-components'
import { green } from '../colors'
import Color from 'color'

const Box = styled.div`
  border-radius: 5px;
  width: 25px;
  height: 15px;
  display: inline-block;
  margin: 0.25rem;

  border: 1px solid
    ${Color(green)
      .darken(0.3)
      .string()};
`

const FilledGreenBox = styled(Box)`
  background-color: ${green};
`

class Checkbox extends React.PureComponent {
  render() {
    const { checked, onClick, name } = this.props
    return checked ? (
      <FilledGreenBox name={name} onClick={onClick} />
    ) : (
      <Box name={name} onClick={onClick} />
    )
  }
}
export { Checkbox }
